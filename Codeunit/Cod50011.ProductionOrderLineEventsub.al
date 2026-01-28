codeunit 50011 "Production Order Line Eventsub"
{
    [EventSubscriber(ObjectType::Table, Database::"Prod. Order Line", OnValidateItemNoOnBeforeCheckReservations, '', false, false)]
    local procedure "Prod. Order Line_OnValidateItemNoOnBeforeCheckReservations"(var ProdOrderLine: Record "Prod. Order Line"; xProdOrderLine: Record "Prod. Order Line"; CurrentFieldNo: Integer; var IsHandled: Boolean)
    begin
        ProdOrderLineReserve.VerifyChange(ProdOrderLine, xProdOrderLine);
        ProdOrderLine.TestField("Finished Quantity", 0);
        ProdOrderLine.CalcFields("Reserved Quantity");
        ProdOrderLine.TestField("Reserved Quantity", 0);
        ProdOrderWarehouseMgt.ProdOrderLineVerifyChange(ProdOrderLine, xProdOrderLine);

        if (ProdOrderLine."Item No." <> xProdOrderLine."Item No.") and (ProdOrderLine."Line No." <> 0) then begin
            ProdOrderLine.DeleteRelations();
            ProdOrderLine."Variant Code" := '';
        end;
        if ProdOrderLine."Item No." = '' then
            ProdOrderLine.Init()
        else begin
            ProdOrder.Get(ProdOrderLine.Status, ProdOrderLine."Prod. Order No.");
            ProdOrderLine."Starting Date" := ProdOrder."Starting Date";
            ProdOrderLine."Starting Time" := ProdOrder."Starting Time";
            ProdOrderLine."Ending Date" := ProdOrder."Ending Date";
            ProdOrderLine."Ending Time" := ProdOrder."Ending Time";
            ProdOrderLine."Due Date" := ProdOrder."Due Date";
            ProdOrderLine."Location Code" := ProdOrder."Location Code";
            ProdOrderLine."Bin Code" := ProdOrder."Bin Code";

            Item.Get(ProdOrderLine."Item No.");
            Item.TestField(Blocked, false);
            Item.TestField("Inventory Posting Group");
            ProdOrderLine."Inventory Posting Group" := Item."Inventory Posting Group";

            ProdOrderLine.Description := Item.Description;
            ProdOrderLine."Description 2" := Item."Description 2";
            ProdOrderLine."Production BOM No." := Item."Production BOM No.";
            ProdOrderLine."Routing No." := Item."Routing No.";

            ProdOrderLine."Scrap %" := Item."Scrap %";
            ProdOrderLine."Unit Cost" := Item."Unit Cost";
            ProdOrderLine."Indirect Cost %" := Item."Indirect Cost %";
            ProdOrderLine."Overhead Rate" := Item."Overhead Rate";

            if ProdOrderLine."Item No." <> xProdOrderLine."Item No." then begin
                ProdOrderLine.Validate("Production BOM No.", Item."Production BOM No.");
                ProdOrderLine.Validate("Routing No.", Item."Routing No.");
                ProdOrderLine.Validate("Unit of Measure Code", Item."Base Unit of Measure");
            end else
                if ProdOrderLine."Routing No." <> xProdOrderLine."Routing No." then
                    ProdOrderLine.Validate("Routing No.", Item."Routing No.");

            if ProdOrder."Source Type" = ProdOrder."Source Type"::Family then
                ProdOrderLine."Routing Reference No." := 0
            else
                if ProdOrderLine."Line No." = 0 then
                    ProdOrderLine."Routing Reference No." := -10000
                else
                    ProdOrderLine."Routing Reference No." := ProdOrderLine."Line No.";

            if ProdOrderLine."Bin Code" = '' then
                GetDefaultBin(ProdOrderLine, xProdOrderLine);
        end;
        if ProdOrderLine."Item No." <> xProdOrderLine."Item No." then
            ProdOrderLine.Validate(Quantity);
        ProdOrderLine.GetUpdateFromSKU();

        ProdOrderLine.CreateDimFromDefaultDim();

        IsHandled := true;
    end;

    local procedure GetDefaultBin(ProdOrderLine: Record "Prod. Order Line"; xProdOrderLine: Record "Prod. Order Line")
    var
        WMSManagement: Codeunit "WMS Management";
    begin
        if (ProdOrderLine.Quantity * xProdOrderLine.Quantity > 0) and
           (ProdOrderLine."Item No." = xProdOrderLine."Item No.") and
           (ProdOrderLine."Location Code" = xProdOrderLine."Location Code") and
           (ProdOrderLine."Variant Code" = xProdOrderLine."Variant Code") and
           (ProdOrderLine."Routing No." = xProdOrderLine."Routing No.")
        then
            exit;

        ProdOrderLine."Bin Code" := '';
        if (ProdOrderLine."Location Code" <> '') and (ProdOrderLine."Item No." <> '') then begin
            ProdOrderLine."Bin Code" :=
                ProdOrderWarehouseMgt.GetLastOperationFromBinCode(
                    ProdOrderLine."Routing No.", ProdOrderLine."Routing Version Code", ProdOrderLine."Location Code", false, Enum::"Flushing Method"::Manual);
            Location.Get(ProdOrderLine."Location Code");
            if ProdOrderLine."Bin Code" = '' then
                ProdOrderLine."Bin Code" := Location."From-Production Bin Code";
            if (ProdOrderLine."Bin Code" = '') and Location."Bin Mandatory" and not Location."Directed Put-away and Pick" then
                WMSManagement.GetDefaultBin(ProdOrderLine."Item No.", ProdOrderLine."Variant Code", ProdOrderLine."Location Code", ProdOrderLine."Bin Code");
        end;
        ProdOrderLine.Validate("Bin Code");
    end;





    var
        Item: Record Item;
        ProdOrder: Record "Production Order";
        Location: Record Location;
        ProdOrderLineReserve: Codeunit "Prod. Order Line-Reserve";
        ProdOrderWarehouseMgt: Codeunit "Prod. Order Warehouse Mgt.";
        DimMgt: Codeunit DimensionManagement;

}
