codeunit 50007 "Item Journal Line EventSub"
{
    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", OnBeforeValidateAppliesToEntry, '', false, false)]
    local procedure "Item Journal Line_OnBeforeValidateAppliesToEntry"(var ItemJournalLine: Record "Item Journal Line"; CurrentFieldNo: Integer; var IsHandled: Boolean)
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        ItemTrackingLines: Page "Item Tracking Lines";
        ShowTrackingExistsError: Boolean;
        ShouldCheckItemLedgEntryFieldsForOutput: Boolean;
    begin
        if ItemJournalLine."Applies-to Entry" <> 0 then begin
            ItemLedgEntry.Get(ItemJournalLine."Applies-to Entry");

            if ItemJournalLine."Value Entry Type" = ItemJournalLine."Value Entry Type"::Revaluation then begin
                if ItemJournalLine."Inventory Value Per" <> ItemJournalLine."Inventory Value Per"::" " then
                    Error(Text006, ItemJournalLine.FieldCaption("Applies-to Entry"));

                if ItemJournalLine."Inventory Value Per" = ItemJournalLine."Inventory Value Per"::" " then begin
                    Item.Get(ItemJournalLine."Item No.");
                    IF Item."Costing Method" = Item."Costing Method"::Average THEN
                        Error(RevaluationPerEntryNotAllowedErr);
                end;

                InitRevalJnlLine(ItemJournalLine, ItemLedgEntry);
                ItemLedgEntry.TestField(Positive, true);
            end else begin
                ItemJournalLine.TestField(Quantity);
                if ItemJournalLine.Signed(ItemJournalLine.Quantity) * ItemLedgEntry.Quantity > 0 then begin
                    if ItemJournalLine.Quantity > 0 then
                        ItemJournalLine.FieldError(Quantity, Text030);
                    if ItemJournalLine.Quantity < 0 then
                        ItemJournalLine.FieldError(Quantity, Text029);
                end;
                ShowTrackingExistsError := ItemLedgEntry.TrackingExists();
                if ShowTrackingExistsError then
                    Error(Text033, ItemJournalLine.FieldCaption("Applies-to Entry"), ItemTrackingLines.Caption);

                if not ItemLedgEntry.Open then
                    Message(Text032, ItemJournalLine."Applies-to Entry");

                ShouldCheckItemLedgEntryFieldsForOutput := ItemJournalLine."Entry Type" = ItemJournalLine."Entry Type"::Output;
                if ShouldCheckItemLedgEntryFieldsForOutput then begin
                    ItemLedgEntry.TestField("Order Type", ItemJournalLine."Order Type"::Production);
                    ItemLedgEntry.TestField("Order No.", ItemJournalLine."Order No.");
                    ItemLedgEntry.TestField("Order Line No.", ItemJournalLine."Order Line No.");
                    ItemLedgEntry.TestField("Entry Type", ItemJournalLine."Entry Type");
                end;
            end;

            ItemJournalLine."Location Code" := ItemLedgEntry."Location Code";
            ItemJournalLine."Variant Code" := ItemLedgEntry."Variant Code";
        end else
            if ItemJournalLine."Value Entry Type" = ItemJournalLine."Value Entry Type"::Revaluation then begin
                ItemJournalLine.Validate("Unit Amount", 0);
                ItemJournalLine.Validate(Quantity, 0);
                ItemJournalLine."Inventory Value (Calculated)" := 0;
                ItemJournalLine."Inventory Value (Revalued)" := 0;
                ItemJournalLine."Location Code" := '';
                ItemJournalLine."Variant Code" := '';
                ItemJournalLine."Bin Code" := '';
            end;

        IsHandled := true;
    end;

    local procedure RevaluationPerEntryAllowed(ItemNo: Code[20]) Result: Boolean
    var
        ValueEntry: Record "Value Entry";
        Item: Record Item;
    begin
        Item.get(ItemNo);
        if Item."Costing Method" <> Item."Costing Method"::Average then
            exit(true);

        ValueEntry.SetRange("Item No.", ItemNo);
        ValueEntry.SetRange("Entry Type", ValueEntry."Entry Type"::Revaluation);
        ValueEntry.SetRange("Partial Revaluation", true);
        exit(ValueEntry.IsEmpty);
    end;

    local procedure InitRevalJnlLine(ItemJournalLine: Record "Item Journal Line"; ItemLedgEntry2: Record "Item Ledger Entry")
    var
        ItemApplnEntry: Record "Item Application Entry";
        ValueEntry: Record "Value Entry";
        CostAmtActual: Decimal;
        IsHandled: Boolean;
    begin

        if ItemJournalLine."Value Entry Type" <> ItemJournalLine."Value Entry Type"::Revaluation then
            exit;

        ItemLedgEntry2.TestField("Item No.", ItemJournalLine."Item No.");
        ItemLedgEntry2.TestField("Completely Invoiced", true);
        ItemLedgEntry2.TestField(Positive, true);
        ItemApplnEntry.CheckAppliedFromEntryToAdjust(ItemLedgEntry2."Entry No.");

        ItemJournalLine.Validate("Entry Type", ItemLedgEntry2."Entry Type");
        ItemJournalLine."Posting Date" := ItemLedgEntry2."Posting Date";
        ItemJournalLine.Validate("Unit Amount", 0);
        ItemJournalLine.Validate(Quantity, ItemLedgEntry2."Invoiced Quantity");

        ValueEntry.Reset();
        ValueEntry.SetCurrentKey("Item Ledger Entry No.", "Entry Type");
        ValueEntry.SetRange("Item Ledger Entry No.", ItemLedgEntry2."Entry No.");
        ValueEntry.SetFilter("Entry Type", '<>%1', ValueEntry."Entry Type"::Rounding);
        ValueEntry.Find('-');
        repeat
            if not (ValueEntry."Expected Cost" or ValueEntry."Partial Revaluation") then
                CostAmtActual := CostAmtActual + ValueEntry."Cost Amount (Actual)";
        until ValueEntry.Next() = 0;

        ItemJournalLine.Validate("Inventory Value (Calculated)", CostAmtActual);
        ItemJournalLine.Validate("Inventory Value (Revalued)", CostAmtActual);

        ItemJournalLine."Location Code" := ItemLedgEntry2."Location Code";
        ItemJournalLine."Variant Code" := ItemLedgEntry2."Variant Code";
        ItemJournalLine."Applies-to Entry" := ItemLedgEntry2."Entry No.";
        ItemJournalLine.CopyDim(ItemLedgEntry2."Dimension Set ID");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", OnSelectItemEntryOnSetFilters, '', false, false)]
    local procedure "Item Journal Line_OnSelectItemEntryOnSetFilters"(var ItemJournalLine: Record "Item Journal Line"; var ItemLedgerEntry: Record "Item Ledger Entry"; CurrentFieldNo: Integer; var IsHandled: Boolean)
    begin
        ItemLedgerEntry.SETRANGE(Correction, FALSE);
    end;

    /* [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", OnBeforeFindUnitCost, '', false, false)]
    local procedure "Item Journal Line_OnBeforeFindUnitCost"(var ItemJournalLine: Record "Item Journal Line"; var UnitCost: Decimal; var IsHandled: Boolean)
    var
        SKU: Record "Stockkeeping Unit";
        InventorySetup: Record "Inventory Setup";
    begin

        InventorySetup.Get();
        if InventorySetup."Average Cost Calc. Type" = InventorySetup."Average Cost Calc. Type"::Item then
            UnitCost := Item."Unit Cost"
        else
            if ItemJournalLine.GetSKU() then
                UnitCost := SKU."Unit Cost"
            else
                UnitCost := Item."Unit Cost";

        IsHandled := true;
    end; */

    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", OnBeforeLookupItemNo, '', false, false)]
    local procedure "Item Journal Line_OnBeforeLookupItemNo"(var ItemJournalLine: Record "Item Journal Line"; var IsHandled: Boolean)
    var
        ProdOrderLine2: Record "Prod. Order Line";
        ItemList: Page "Item List";
        ProdOrderLineList: Page "Prod. Order Line List";
    begin
        IF ItemJournalLine."Entry Type" = ItemJournalLine."Entry Type"::Output THEN BEGIN
            SetFilterProdOrderLine(ItemJournalLine);
            ProdOrderLine2.Status := ProdOrderLine2.Status::Released;
            ProdOrderLine2."Prod. Order No." := ItemJournalLine."Order No.";
            ProdOrderLine2."Line No." := ItemJournalLine."Order Line No.";
            ProdOrderLine2."Item No." := ItemJournalLine."Item No.";

            ProdOrderLineList.LOOKUPMODE(TRUE);
            ProdOrderLineList.SETTABLEVIEW(ProdOrderLine);
            ProdOrderLineList.SETRECORD(ProdOrderLine2);

            IF ProdOrderLineList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                ProdOrderLineList.GETRECORD(ProdOrderLine);
                ItemJournalLine.VALIDATE("Item No.", ProdOrderLine."Item No.");
            END;
        END ELSE BEGIN
            ItemList.LOOKUPMODE := TRUE;
            IF ItemList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                ItemList.GETRECORD(Item);
                ItemJournalLine.VALIDATE("Item No.", Item."No.");
            END;
        END;

        IsHandled := true;
    end;

    procedure SetFilterProdOrderLine(ItemJournalLine: Record "Item Journal Line")
    begin
        ProdOrderLine.RESET;
        ProdOrderLine.SETCURRENTKEY(Status, "Prod. Order No.", "Item No.");
        ProdOrderLine.SETRANGE(Status, ProdOrderLine.Status::Released);
        ProdOrderLine.SETRANGE("Prod. Order No.", ItemJournalLine."Order No.");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", OnBeforeRevaluationPerEntryAllowed, '', false, false)]
    local procedure "Item Journal Line_OnBeforeRevaluationPerEntryAllowed"(ItemJournalLine: Record "Item Journal Line"; ItemNo: Code[20]; var Result: Boolean; var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;


    var
        ProdOrderLine: Record "Prod. Order Line";
        Item: Record Item;
        Text006: Label 'You must not enter %1 in a revaluation sum line.';
        Text029: Label 'must be positive';
        Text030: Label 'must be negative';
        Text032: Label 'When posting, the entry %1 will be opened first.';
        Text033: Label 'If the item carries serial, lot or package numbers, then you must use the %1 field in the %2 window.';
        RevaluationPerEntryNotAllowedErr: Label 'This item has already been revalued with the Calculate Inventory Value function, so you cannot use the Applies-to Entry field as that may change the valuation.';
}
