codeunit 50018 "Create Prod. Order Lines Event"
{
    procedure CheckStructure(Status: Option; ProdOrderNo: Code[20]; Direction: Option Forward,Backward; MultiLevel: Boolean)
    begin
        ProdOrder.Get(Status, ProdOrderNo);
        ProdOrderLine.SetRange(Status, Status);
        ProdOrderLine.SetRange("Prod. Order No.", ProdOrderNo);
        if ProdOrderLine.Find('+') then
            NextProdOrderLineNo := ProdOrderLine."Line No." + 10000
        else
            NextProdOrderLineNo := 10000;

        CheckMultiLevelStructure(Direction, MultiLevel);
    end;

    local procedure CheckMultiLevelStructure(Direction: Option Forward,Backward; MultiLevel: Boolean)
    var
        MultiLevelStructureCreated: Boolean;
        IsHandled: Boolean;
    begin

        ProdOrderComp.SetCurrentKey(Status, "Prod. Order No.", "Prod. Order Line No.", "Item Low-Level Code");
        ProdOrderComp.SetRange(Status, ProdOrder.Status);
        ProdOrderComp.SetRange("Prod. Order No.", ProdOrder."No.");
        ProdOrderComp.SetFilter("Item No.", '<>%1', '');
        if ProdOrderComp.FindSet(true) then
            repeat
                if ProdOrderComp."Planning Level Code" = 0 then
                    if ShouldIncreasePlanningLevel(ProdOrderComp) then begin
                        ProdOrderComp."Planning Level Code" := 1;
                        ProdOrderComp.Modify(true);
                    end;
                if ProdOrderComp."Planning Level Code" > 0 then
                    MultiLevelStructureCreated :=
                      MultiLevelStructureCreated or
                      CheckMakeOrderLine(ProdOrderComp, ProdOrderLine, Direction, MultiLevel);
            until ProdOrderComp.Next() = 0;
        if MultiLevelStructureCreated then
            CreateProdOrderLines.ReserveMultiLevelStructure(ProdOrderComp);
    end;

    local procedure ShouldIncreasePlanningLevel(ProdOrderComp: Record "Prod. Order Component") IncreasePlanningLevel: Boolean
    var
        Item: Record Item;
        StockkeepingUnit: Record "Stockkeeping Unit";
    begin
        if StockkeepingUnit.Get(ProdOrderComp."Location Code", ProdOrderComp."Item No.", ProdOrderComp."Variant Code") then
            IncreasePlanningLevel :=
              (StockkeepingUnit."Manufacturing Policy" = StockkeepingUnit."Manufacturing Policy"::"Make-to-Order") and
              (StockkeepingUnit."Replenishment System" = StockkeepingUnit."Replenishment System"::"Prod. Order")
        else begin
            Item.Get(ProdOrderComp."Item No.");
            IncreasePlanningLevel :=
              (Item."Manufacturing Policy" = Item."Manufacturing Policy"::"Make-to-Order") and Item.IsMfgItem();
        end;
    end;

    procedure CheckMakeOrderLine(var ProdOrderComp: Record "Prod. Order Component"; var ProdOrderLine: Record "Prod. Order Line"; Direction: Option Forward,Backward; MultiLevel: Boolean): Boolean
    var
        Item: Record Item;
        ParentItem: Record Item;
        ParentSKU: Record "Stockkeeping Unit";
        SKU: Record "Stockkeeping Unit";
        ProdOrderLine2: Record "Prod. Order Line";
        MakeProdOrder: Boolean;
        Inserted: Boolean;
    begin
        ProdOrderLine2.Get(ProdOrderComp.Status, ProdOrderComp."Prod. Order No.", ProdOrderComp."Prod. Order Line No.");
        if ParentSKU.Get(ProdOrderLine2."Location Code", ProdOrderLine2."Item No.", ProdOrderLine2."Variant Code") then
            MakeProdOrder := ParentSKU."Manufacturing Policy" = ParentSKU."Manufacturing Policy"::"Make-to-Order"
        else begin
            ParentItem.Get(ProdOrderLine2."Item No.");
            MakeProdOrder := ParentItem."Manufacturing Policy" = ParentItem."Manufacturing Policy"::"Make-to-Order";
        end;

        if not MakeProdOrder then
            exit(false);

        Item.Get(ProdOrderComp."Item No.");

        if SKU.Get(ProdOrderComp."Location Code", ProdOrderComp."Item No.", ProdOrderComp."Variant Code") then
            MakeProdOrder :=
              (SKU."Replenishment System" = SKU."Replenishment System"::"Prod. Order") and
              (SKU."Manufacturing Policy" = SKU."Manufacturing Policy"::"Make-to-Order")
        else
            MakeProdOrder :=
              (Item."Replenishment System" = Item."Replenishment System"::"Prod. Order") and
              (Item."Manufacturing Policy" = Item."Manufacturing Policy"::"Make-to-Order");

        if not MakeProdOrder then
            exit(false);

        CreateProdOrderLines.InitProdOrderLine(ProdOrderComp."Item No.", ProdOrderComp."Variant Code", ProdOrderComp."Location Code");
        ProdOrderLine.Validate("Unit of Measure Code", ProdOrderComp."Unit of Measure Code");
        ProdOrderLine."Qty. per Unit of Measure" := ProdOrderComp."Qty. per Unit of Measure";
        ProdOrderLine."Bin Code" := ProdOrderComp."Bin Code";
        ProdOrderLine.Description := ProdOrderComp.Description;
        ProdOrderLine."Description 2" := Item."Description 2";
        ProdOrderComp.CalcFields("Reserved Quantity");
        ProdOrderLine.Validate(Quantity, ProdOrderComp."Expected Quantity" - ProdOrderComp."Reserved Quantity");
        if ProdOrderLine."Quantity (Base)" = 0 then
            exit(false);
        ProdOrderLine."Planning Level Code" := ProdOrderComp."Planning Level Code";
        ProdOrderLine."Due Date" := ProdOrderComp."Due Date";
        ProdOrderLine."Ending Date" := ProdOrderComp."Due Date";
        ProdOrderLine."Ending Time" := ProdOrderComp."Due Time";
        ProdOrderLine.UpdateDatetime();
        // this InsertNew is responsible for controlling if same POLine is added up or new POLine is created
        InsertNew := InsertNew and (ProdOrderComp."Planning Level Code" > 1);

        Inserted := CreateProdOrderLines.InsertProdOrderLine();
        if MultiLevel then begin
            if Inserted then
                Calculate(ProdOrderLine, Direction::Backward, true, true, true)
            else begin
                Recalculate(ProdOrderLine, Direction::Backward);
                if ProdOrderLine."Line No." < ProdOrderComp."Prod. Order Line No." then
                    UpdateProdOrderLine(ProdOrderLine, Direction);
            end;
        end else
            exit(false);
        ProdOrderComp."Supplied-by Line No." := ProdOrderLine."Line No.";
        ProdOrderComp.Modify();
        exit(true);
    end;

    procedure Calculate(ProdOrderLine2: Record "Prod. Order Line"; Direction: Option Forward,Backward; CalcRouting: Boolean; CalcComponents: Boolean; DeleteRelations: Boolean): Boolean
    var
        CapLedgEntry: Record "Capacity Ledger Entry";
        ItemLedgEntry: Record "Item Ledger Entry";
        ProdOrderRoutingLine3: Record "Prod. Order Routing Line";
        ProdOrderRoutingLine4: Record "Prod. Order Routing Line";
        RoutingHeader: Record "Routing Header";
        ProdOrderRoutingLine: Record "Prod. Order Routing Line";
        ErrorOccured: Boolean;
        IsHandled: Boolean;
        ShouldCheckIfEntriesExist: Boolean;
        SkipCalcComponents: Boolean;
    begin
        ProdOrderLine := ProdOrderLine2;

        ShouldCheckIfEntriesExist := ProdOrderLine.Status = ProdOrderLine.Status::Released;
        if ShouldCheckIfEntriesExist then begin
            ItemLedgEntry.SetCurrentKey("Order Type", "Order No.");
            ItemLedgEntry.SetRange("Order Type", ItemLedgEntry."Order Type"::Production);
            ItemLedgEntry.SetRange("Order No.", ProdOrderLine."Prod. Order No.");
            if not ItemLedgEntry.IsEmpty() then
                Error(
                  Text001,
                  ProdOrderLine.Status, ProdOrderLine.TableCaption(), ProdOrderLine."Prod. Order No.",
                  ItemLedgEntry.TableCaption());

            CapLedgEntry.SetCurrentKey("Order Type", "Order No.");
            CapLedgEntry.SetRange("Order Type", CapLedgEntry."Order Type"::Production);
            CapLedgEntry.SetRange("Order No.", ProdOrderLine."Prod. Order No.");
            if not CapLedgEntry.IsEmpty() then
                Error(
                  Text001,
                  ProdOrderLine.Status, ProdOrderLine.TableCaption(), ProdOrderLine."Prod. Order No.",
                  CapLedgEntry.TableCaption());
        end;

        CheckProdOrderLineQuantity(ProdOrderLine);
        if Direction = Direction::Backward then
            ProdOrderLine.TestField("Ending Date")
        else
            ProdOrderLine.TestField("Starting Date");

        if DeleteRelations then
            ProdOrderLine.DeleteRelations();

        if CalcRouting then begin
            TransferRouting();
            if not CalcComponents then begin // components will not be calculated later- update bin code
                ProdOrderRoutingLine.SetRange(Status, ProdOrderLine.Status);
                ProdOrderRoutingLine.SetRange("Prod. Order No.", ProdOrderLine."Prod. Order No.");
                ProdOrderRoutingLine.SetRange("Routing Reference No.", ProdOrderLine."Routing Reference No.");
                ProdOrderRoutingLine.SetRange("Routing No.", ProdOrderLine."Routing No.");
                if not ProdOrderRouteMgt.UpdateComponentsBin(ProdOrderRoutingLine, true) then
                    ErrorOccured := true;
            end;
        end else
            if RoutingHeader.Get(ProdOrderLine2."Routing No.") or (ProdOrderLine2."Routing No." = '') then
                if RoutingHeader.Type <> RoutingHeader.Type::Parallel then begin
                    ProdOrderRoutingLine3.SetRange(Status, ProdOrderLine2.Status);
                    ProdOrderRoutingLine3.SetRange("Prod. Order No.", ProdOrderLine2."Prod. Order No.");
                    ProdOrderRoutingLine3.SetRange("Routing Reference No.", ProdOrderLine2."Routing Reference No.");
                    ProdOrderRoutingLine3.SetRange("Routing No.", ProdOrderLine2."Routing No.");
                    ProdOrderRoutingLine3.SetFilter("Routing Status", '<>%1', ProdOrderRoutingLine3."Routing Status"::Finished);
                    ProdOrderRoutingLine4.CopyFilters(ProdOrderRoutingLine3);
                    if ProdOrderRoutingLine3.Find('-') then
                        repeat
                            if ProdOrderRoutingLine3."Next Operation No." <> '' then begin
                                ProdOrderRoutingLine4.SetRange("Operation No.", ProdOrderRoutingLine3."Next Operation No.");
                                if ProdOrderRoutingLine4.IsEmpty() then begin
                                    Error(OperationCannotFollowErr, ProdOrderRoutingLine3."Next Operation No.");
                                end;
                            end;
                            if ProdOrderRoutingLine3."Previous Operation No." <> '' then begin
                                ProdOrderRoutingLine4.SetRange("Operation No.", ProdOrderRoutingLine3."Previous Operation No.");
                                if ProdOrderRoutingLine4.IsEmpty() then begin
                                    Error(OperationCannotPrecedeErr, ProdOrderRoutingLine3."Previous Operation No.");
                                end;
                            end;
                        until ProdOrderRoutingLine3.Next() = 0;
                end;

        SkipCalcComponents := false;
        if CalcComponents and not SkipCalcComponents then
            if ProdOrderLine."Production BOM No." <> '' then begin
                Item.Get(ProdOrderLine."Item No.");
                GetPlanningParameters.AtSKU(
                  SKU,
                  ProdOrderLine."Item No.",
                  ProdOrderLine."Variant Code",
                  ProdOrderLine."Location Code");

                CalculateLeadTime(ProdOrderLine, Direction);

                if not CalcProdOrder.TransferBOM(
                     ProdOrderLine."Production BOM No.",
                     1,
                     ProdOrderLine."Qty. per Unit of Measure",
                     UOMMgt.GetQtyPerUnitOfMeasure(
                       Item,
                       VersionMgt.GetBOMUnitOfMeasure(
                         ProdOrderLine."Production BOM No.",
                         ProdOrderLine."Production BOM Version Code")))
                then
                    ErrorOccured := true;
            end;
        Recalculate(ProdOrderLine, Direction, CalcRouting, CalcComponents);

        exit(not ErrorOccured);
    end;

    local procedure CheckProdOrderLineQuantity(var ProdOrderLineToCheck: Record "Prod. Order Line")
    var
        IsHandled: Boolean;
    begin
        ProdOrderLineToCheck.TestField(Quantity);
    end;

    local procedure TransferRouting()
    var
        RoutingHeader: Record "Routing Header";
        RoutingLine: Record "Routing Line";
        ProdOrderRoutingLine: Record "Prod. Order Routing Line";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        if IsHandled then
            exit;

        if ProdOrderLine."Routing No." = '' then
            exit;

        RoutingHeader.Get(ProdOrderLine."Routing No.");

        ProdOrderRoutingLine.SetRange(Status, ProdOrderLine.Status);
        ProdOrderRoutingLine.SetRange("Prod. Order No.", ProdOrderLine."Prod. Order No.");
        ProdOrderRoutingLine.SetRange("Routing Reference No.", ProdOrderLine."Routing Reference No.");
        ProdOrderRoutingLine.SetRange("Routing No.", ProdOrderLine."Routing No.");
        if not ProdOrderRoutingLine.IsEmpty() then
            exit;

        RoutingLine.SetRange("Routing No.", ProdOrderLine."Routing No.");
        RoutingLine.SetRange("Version Code", ProdOrderLine."Routing Version Code");
        if RoutingLine.Find('-') then
            repeat
                ProcessRoutingLine(RoutingLine, ProdOrderRoutingLine);
            until RoutingLine.Next() = 0;
    end;

    local procedure ProcessRoutingLine(var RoutingLine: Record "Routing Line"; var ProdOrderRoutingLine: Record "Prod. Order Routing Line")
    var
        IsHandled: Boolean;
    begin
        RoutingLine.TestField(Recalculate, false);
        CalcProdOrder.InitProdOrderRoutingLine(ProdOrderRoutingLine, RoutingLine);
        CalcProdOrder.TransferTaskInfo(ProdOrderRoutingLine, ProdOrderLine."Routing Version Code");
    end;

    local procedure CalculateLeadTime(ProdOrderLine2: Record "Prod. Order Line"; Direction: Option Forward,Backward)
    var
        LeadTime: Code[20];
    begin
        ProdOrderLine := ProdOrderLine2;

        LeadTimeMgt.SetManualScheduling(ProdOrderLine2."Manual Scheduling");
        LeadTime :=
          LeadTimeMgt.ManufacturingLeadTime(
            ProdOrderLine."Item No.", ProdOrderLine."Location Code", ProdOrderLine."Variant Code");

        if Direction = Direction::Forward then
            // Ending Date calculated forward from Starting Date
            ProdOrderLine."Ending Date" :=
            LeadTimeMgt.GetPlannedEndingDate(
              ProdOrderLine."Item No.", ProdOrderLine."Location Code", ProdOrderLine."Variant Code", '',
              LeadTime, "Requisition Ref. Order Type"::"Prod. Order", ProdOrderLine."Starting Date")
        else
            // Starting Date calculated backward from Ending Date
            ProdOrderLine."Starting Date" :=
            LeadTimeMgt.GetPlannedStartingDate(
              ProdOrderLine."Item No.", ProdOrderLine."Location Code", ProdOrderLine."Variant Code", '',
              LeadTime, "Requisition Ref. Order Type"::"Prod. Order", ProdOrderLine."Ending Date");

        CalculateProdOrderDates(ProdOrderLine);

        ProdOrderLine2 := ProdOrderLine;
    end;

    procedure Recalculate(var ProdOrderLine2: Record "Prod. Order Line"; Direction: Option Forward,Backward)
    begin
        ProdOrderLine := ProdOrderLine2;
        ProdOrderLine.BlockDynamicTracking(Blocked);

        CalculateRouting(Direction);
        CalcProdOrder.CalculateComponents();
        ProdOrderLine2 := ProdOrderLine;
    end;

    local procedure UpdateProdOrderLine(var ProdOrderLine: Record "Prod. Order Line"; Direction: Option Forward,Backward)
    var
        ProdOrderLine3: Record "Prod. Order Line";
        ProdOrderComp3: Record "Prod. Order Component";
    begin
        ProdOrderComp3.SetRange(Status, ProdOrderLine.Status);
        ProdOrderComp3.SetRange("Prod. Order No.", ProdOrderLine."Prod. Order No.");
        ProdOrderComp3.SetRange("Prod. Order Line No.", ProdOrderLine."Line No.");
        if ProdOrderComp3.FindSet() then
            repeat
                ProdOrderLine3.CopyFilters(ProdOrderLine);
                ProdOrderLine3.SetRange("Item No.", ProdOrderComp3."Item No.");
                ProdOrderLine3.SetRange("Variant Code", ProdOrderComp3."Variant Code");
                if ProdOrderLine3.FindFirst() then begin
                    ProdOrderComp3.CalcFields("Reserved Quantity");
                    TempOldProdOrderComp.Get(ProdOrderComp3.Status, ProdOrderComp3."Prod. Order No.",
                      ProdOrderComp3."Prod. Order Line No.", ProdOrderComp3."Line No.");
                    ProdOrderLine3.Validate(Quantity,
                      ProdOrderLine3.Quantity - TempOldProdOrderComp."Expected Quantity" +
                      ProdOrderComp3."Expected Quantity" - ProdOrderComp3."Reserved Quantity");
                    if ProdOrderLine3."Planning Level Code" < ProdOrderComp3."Planning Level Code" then
                        ProdOrderLine3."Planning Level Code" := ProdOrderComp3."Planning Level Code";
                    AdjustDateAndTime(ProdOrderLine3, ProdOrderComp3."Due Date", ProdOrderComp3."Due Date", ProdOrderComp3."Due Time");
                    UpdateCompPlanningLevel(ProdOrderLine3);
                    Recalculate(ProdOrderLine3, Direction::Backward);
                    ProdOrderLine3.Modify();
                end;
            until ProdOrderComp3.Next() = 0;
        TempOldProdOrderComp.DeleteAll();
    end;

    local procedure CalculateRouting(Direction: Option Forward,Backward)
    var
        ProdOrderRoutingLine: Record "Prod. Order Routing Line";
        IsHandled: Boolean;
    begin
        if ProdOrderRouteMgt.NeedsCalculation(
             ProdOrderLine.Status,
             ProdOrderLine."Prod. Order No.",
             ProdOrderLine."Routing Reference No.",
             ProdOrderLine."Routing No.")
        then
            ProdOrderRouteMgt.Calculate(ProdOrderLine);

        if Direction = Direction::Forward then
            ProdOrderRoutingLine.SetCurrentKey(Status, "Prod. Order No.", "Routing Reference No.", "Routing No.",
              "Sequence No. (Forward)")
        else
            ProdOrderRoutingLine.SetCurrentKey(Status, "Prod. Order No.", "Routing Reference No.", "Routing No.",
              "Sequence No. (Backward)");

        ProdOrderRoutingLine.SetRange(Status, ProdOrderLine.Status);
        ProdOrderRoutingLine.SetRange("Prod. Order No.", ProdOrderLine."Prod. Order No.");
        ProdOrderRoutingLine.SetRange("Routing Reference No.", ProdOrderLine."Routing Reference No.");
        ProdOrderRoutingLine.SetRange("Routing No.", ProdOrderLine."Routing No.");
        ProdOrderRoutingLine.SetFilter("Routing Status", '<>%1', ProdOrderRoutingLine."Routing Status"::Finished);
        if not ProdOrderRoutingLine.FindFirst() then begin
            CalculateLeadTime(ProdOrderLine, Direction);
            exit;
        end;

        if Direction = Direction::Forward then begin
            ProdOrderRoutingLine."Starting Date" := ProdOrderLine."Starting Date";
            ProdOrderRoutingLine."Starting Time" := ProdOrderLine."Starting Time";
        end else begin
            ProdOrderRoutingLine."Ending Date" := ProdOrderLine."Ending Date";
            ProdOrderRoutingLine."Ending Time" := ProdOrderLine."Ending Time";
        end;
        ProdOrderRoutingLine.UpdateDatetime();
        CalcProdOrder.CalculateRoutingFromActual(ProdOrderRoutingLine, Direction, false);

        CalculateProdOrderDates(ProdOrderLine);
    end;

    procedure CalculateProdOrderDates(var ProdOrderLine: Record "Prod. Order Line")
    var
        ProdOrderRoutingLine: Record "Prod. Order Routing Line";
        NewDueDate: Date;
    begin

        ProdOrder.Get(ProdOrderLine.Status, ProdOrderLine."Prod. Order No.");

        ProdOrderRoutingLine.SetRange(Status, ProdOrderLine.Status);
        ProdOrderRoutingLine.SetRange("Prod. Order No.", ProdOrderLine."Prod. Order No.");
        ProdOrderRoutingLine.SetRange("Routing No.", ProdOrderLine."Routing No.");
        if ProdOrder."Source Type" <> ProdOrder."Source Type"::Family then
            ProdOrderRoutingLine.SetRange("Routing Reference No.", ProdOrderLine."Line No.")
        else
            ProdOrderRoutingLine.SetRange("Routing Reference No.", 0);
        ProdOrderRoutingLine.SetFilter("Routing Status", '<>%1', ProdOrderRoutingLine."Routing Status"::Finished);
        ProdOrderRoutingLine.SetFilter("Next Operation No.", '%1', '');

        if ProdOrderRoutingLine.FindFirst() then begin
            ProdOrderLine."Ending Date" := ProdOrderRoutingLine."Ending Date";
            ProdOrderLine."Ending Time" := ProdOrderRoutingLine."Ending Time";
        end;

        ProdOrderRoutingLine.SetRange("Next Operation No.");
        ProdOrderRoutingLine.SetFilter("Previous Operation No.", '%1', '');

        if ProdOrderRoutingLine.FindFirst() then begin
            ProdOrderLine."Starting Date" := ProdOrderRoutingLine."Starting Date";
            ProdOrderLine."Starting Time" := ProdOrderRoutingLine."Starting Time";
        end;

        LeadTimeMgt.SetManualScheduling(ProdOrderLine."Manual Scheduling");

        if ProdOrderLine."Planning Level Code" = 0 then
            NewDueDate :=
              LeadTimeMgt.GetPlannedDueDate(
                ProdOrderLine."Item No.", ProdOrderLine."Location Code", ProdOrderLine."Variant Code",
                ProdOrderLine."Ending Date", '', "Requisition Ref. Order Type"::"Prod. Order")
        else
            NewDueDate := ProdOrderLine."Ending Date";

        if (NewDueDate > ProdOrderLine."Due Date") then
            if ProdOrderLine.ConfirmUpdateDueDateAndEndingDate(ProdOrderLine.FieldCaption("Due Date"), NewDueDate) then
                ProdOrderLine."Due Date" := NewDueDate;


        ProdOrderLine.UpdateDatetime();
        ProdOrderLine.Modify();

        if not ProdOrderModify then begin
            ProdOrder.Validate("Manual Scheduling", ProdOrderLine."Manual Scheduling");
            ProdOrder.AdjustStartEndingDate();
            ProdOrder.Modify();
        end;
    end;

    procedure BlockDynamicTracking(SetBlock: Boolean)
    begin
        Blocked := SetBlock;
    end;

    local procedure Recalculate(var ProdOrderLine: Record "Prod. Order Line"; Direction: Option; CalcRouting: Boolean; CalcComponents: Boolean)
    begin
        Recalculate(ProdOrderLine, Direction);
    end;

    local procedure AdjustDateAndTime(var ProdOrderLine3: Record "Prod. Order Line"; DueDate: Date; EndingDate: Date; EndingTime: Time)
    begin
        if ProdOrderLine3."Due Date" > DueDate then
            ProdOrderLine3."Due Date" := DueDate;

        if ProdOrderLine3."Ending Date" > EndingDate then begin
            ProdOrderLine3."Ending Date" := EndingDate;
            ProdOrderLine3."Ending Time" := EndingTime;
        end else
            if (ProdOrderLine3."Ending Date" = EndingDate) and
               (ProdOrderLine3."Ending Time" > EndingTime)
            then
                ProdOrderLine3."Ending Time" := EndingTime;
        ProdOrderLine3.UpdateDatetime();
    end;

    local procedure UpdateCompPlanningLevel(ProdOrderLine3: Record "Prod. Order Line")
    var
        ProdOrderComp3: Record "Prod. Order Component";
    begin
        // update planning level code of component
        ProdOrderComp3.SetRange(Status, ProdOrderLine3.Status);
        ProdOrderComp3.SetRange("Prod. Order No.", ProdOrderLine3."Prod. Order No.");
        ProdOrderComp3.SetRange("Prod. Order Line No.", ProdOrderLine3."Line No.");
        ProdOrderComp3.SetFilter("Planning Level Code", '>0');
        if ProdOrderComp3.FindSet(true) then
            repeat
                ProdOrderComp3."Planning Level Code" := ProdOrderLine3."Planning Level Code" + 1;
                ProdOrderComp3.Modify();
            until ProdOrderComp3.Next() = 0;
    end;

    var
        Item: Record Item;
        ProdOrder: Record "Production Order";
        ProdOrderLine: Record "Prod. Order Line";
        ProdOrderComp: Record "Prod. Order Component";
        SKU: Record "Stockkeeping Unit";
        TempOldProdOrderComp: Record "Prod. Order Component" temporary;
        CreateProdOrderLines: Codeunit "Create Prod. Order Lines";
        CalcProdOrder: Codeunit "Calculate Prod. Order";
        ProdOrderRouteMgt: Codeunit "Prod. Order Route Management";
        GetPlanningParameters: Codeunit "Planning-Get Parameters";
        LeadTimeMgt: Codeunit "Lead-Time Management";
        UOMMgt: Codeunit "Unit of Measure Management";
        VersionMgt: Codeunit VersionManagement;
        NextProdOrderLineNo: Integer;
        InsertNew: Boolean;
        Blocked: Boolean;
        ProdOrderModify: Boolean;
        Text001: Label '%1 %2 %3 can not be calculated, if at least one %4 has been posted.';
        OperationCannotFollowErr: Label 'Operation No. %1 cannot follow another operation in the routing of this Prod. Order Line.', Comment = '%1 = Operation No.';
        OperationCannotPrecedeErr: Label 'Operation No. %1 cannot precede another operation in the routing of this Prod. Order Line.', Comment = '%1 = Operation No.';
}
