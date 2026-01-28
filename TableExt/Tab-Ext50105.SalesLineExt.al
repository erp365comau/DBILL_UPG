tableextension 50105 SalesLineExt extends "Sales Line"
{
    fields
    {
        field(50001; "Unit Price 2"; Decimal)
        {
            Editable = false;
            trigger OnValidate()
            var
                SalesLine: Record "Sales Line";
                SalesHeader: Record "Sales Header";
                PriceChanged: Boolean;
            begin
                SalesLine.Reset();
                SalesLine.SetRange("Document Type", Rec."Document Type");
                SalesLine.SetRange("Document No.", Rec."Document No.");
                Message('SalesLine Count: %1', SalesLine.Count());
                PriceChanged := false;

                if SalesLine.FindSet() then
                    repeat
                        if SalesLine."Unit Price" < SalesLine."Unit Price 2" then begin
                            PriceChanged := true;
                            exit;
                        end;
                    until SalesLine.Next() = 0;
                Message('Price Changed: %1', PriceChanged);
                if SalesHeader.Get(Rec."Document Type", Rec."Document No.") then begin
                    SalesHeader."Unit Price Changed" := PriceChanged;
                    SalesHeader.Modify();
                end;
            end;
        }
        field(50002; "Ordered Qty."; Decimal)
        {
        }
        field(50300; "VMS Label"; Text[200])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("VAT Posting Setup"."VMS Label" WHERE("VAT Prod. Posting Group" = FIELD("VAT Prod. Posting Group"),
                                                                       "VAT Bus. Posting Group" = FIELD("VAT Bus. Posting Group")));
        }
        field(50301; "VMS Label Description"; Text[200])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("VAT Posting Setup"."VMS Label Description" WHERE("VAT Prod. Posting Group" = FIELD("VAT Prod. Posting Group"),
                                                                                    "VAT Bus. Posting Group" = FIELD("VAT Bus. Posting Group")));
        }
        field(50302; "Price Changed"; Boolean)
        {
        }
        modify("Unit Price")
        {
            trigger OnAfterValidate()
            var
                SalesLine: Record "Sales Line";
                SalesHeader: Record "Sales Header";
                PriceChanged: Boolean;
            begin
                SalesLine.Reset();
                SalesLine.SetRange("Document Type", Rec."Document Type");
                SalesLine.SetRange("Document No.", Rec."Document No.");
                PriceChanged := false;

                if SalesLine.FindSet() then
                    repeat
                        if SalesLine."Unit Price" < SalesLine."Unit Price 2" then begin
                            PriceChanged := true;
                            break;
                        end;
                    until SalesLine.Next() = 0;

                if SalesHeader.Get(Rec."Document Type", Rec."Document No.") then begin
                    if SalesHeader."Unit Price Changed" <> PriceChanged then begin
                        SalesHeader."Unit Price Changed" := PriceChanged;
                        SalesHeader.Modify();
                    end;
                end;
            end;
        }
        modify(Quantity)
        {
            trigger OnAfterValidate()
            begin
                IF (xRec.Quantity = 0) AND (Quantity <> 0) THEN
                    Rec."Ordered Qty." := Quantity;
            end;
        }
        modify("Return Reason Code")
        {
            trigger OnAfterValidate()
            begin

                IF "Return Reason Code" = '' THEN
                    UpdateUnitPrice(FIELDNO("Return Reason Code"));

                IF ReturnReason.GET("Return Reason Code") THEN BEGIN
                    IF ReturnReason."Default Location Code" <> '' THEN
                        VALIDATE("Location Code", ReturnReason."Default Location Code");
                    IF ReturnReason."Inventory Value Zero" THEN BEGIN
                        VALIDATE("Unit Cost (LCY)", 0);
                        VALIDATE("Unit Price", 0);
                    END ELSE
                        IF "Unit Price" = 0 THEN
                            UpdateUnitPrice(FIELDNO("Return Reason Code"));
                END;
            end;
        }
        modify("Appl.-to Item Entry")
        {
            trigger OnAfterValidate()
            var
                ItemLedgEntry: Record "Item Ledger Entry";
            begin
                IF "Appl.-to Item Entry" <> 0 THEN BEGIN
                    ItemLedgEntry.GET("Appl.-to Item Entry");
                    VALIDATE("Unit Cost (LCY)", CalcUnitCost2(ItemLedgEntry));
                end;
            end;
        }
        modify("Appl.-from Item Entry")
        {
            trigger OnAfterValidate()
            var
                ItemLedgEntry: Record "Item Ledger Entry";
            begin
                IF "Appl.-from Item Entry" <> 0 THEN BEGIN
                    CheckApplFromItemLedgEntry(ItemLedgEntry);
                    VALIDATE("Unit Cost (LCY)", CalcUnitCost2(ItemLedgEntry));
                END;
            end;
        }
    }
    LOCAL procedure CalcUnitCost2(ItemLedgEntry: Record "Item Ledger Entry"): Decimal
    var
        ValueEntry: Record "Value Entry";
        UnitCost: Decimal;
    begin
        WITH ValueEntry DO BEGIN
            SETCURRENTKEY("Item Ledger Entry No.");
            SETRANGE("Item Ledger Entry No.", ItemLedgEntry."Entry No.");
            CALCSUMS("Cost Amount (Actual)", "Cost Amount (Expected)");
            UnitCost :=
              ("Cost Amount (Expected)" + "Cost Amount (Actual)") / ItemLedgEntry.Quantity;
        END;

        EXIT(ABS(UnitCost * "Qty. per Unit of Measure"));
    end;

    LOCAL procedure CheckApplFromItemLedgEntry(VAR ItemLedgEntry: Record "Item Ledger Entry")
    var
        ItemTrackingLines: Page "Item Tracking Lines";
        QtyNotReturned: Decimal;
        QtyReturned: Decimal;
    begin
        IF "Appl.-from Item Entry" = 0 THEN
            EXIT;

        IF "Shipment No." <> '' THEN
            EXIT;

        TESTFIELD(Type, Type::Item);
        TESTFIELD(Quantity);
        IF "Document Type" IN ["Document Type"::"Return Order", "Document Type"::"Credit Memo"] THEN BEGIN
            IF Quantity < 0 THEN
                FIELDERROR(Quantity, Text029);
        END ELSE BEGIN
            IF Quantity > 0 THEN
                FIELDERROR(Quantity, Text030);
        END;

        ItemLedgEntry.GET("Appl.-from Item Entry");
        ItemLedgEntry.TESTFIELD(Positive, FALSE);
        ItemLedgEntry.TESTFIELD("Item No.", "No.");
        ItemLedgEntry.TESTFIELD("Variant Code", "Variant Code");
        IF (ItemLedgEntry."Lot No." <> '') OR (ItemLedgEntry."Serial No." <> '') THEN
            ERROR(Text040, ItemTrackingLines.CAPTION, FIELDCAPTION("Appl.-from Item Entry"));

        IF ABS("Quantity (Base)") > -ItemLedgEntry.Quantity THEN
            ERROR(
              Text046,
              -ItemLedgEntry.Quantity, ItemLedgEntry.FIELDCAPTION("Document No."),
              ItemLedgEntry."Document No.");

        IF "Document Type" IN ["Document Type"::"Return Order", "Document Type"::"Credit Memo"] THEN
            IF ABS("Outstanding Qty. (Base)") > -ItemLedgEntry."Shipped Qty. Not Returned" THEN BEGIN
                QtyNotReturned := ItemLedgEntry."Shipped Qty. Not Returned";
                QtyReturned := ItemLedgEntry.Quantity - ItemLedgEntry."Shipped Qty. Not Returned";
                IF "Qty. per Unit of Measure" <> 0 THEN BEGIN
                    QtyNotReturned :=
                      ROUND(ItemLedgEntry."Shipped Qty. Not Returned" / "Qty. per Unit of Measure", 0.00001);
                    QtyReturned :=
                      ROUND(
                        (ItemLedgEntry.Quantity - ItemLedgEntry."Shipped Qty. Not Returned") /
                        "Qty. per Unit of Measure", 0.00001);
                END;
                ERROR(
                  Text039,
                  -QtyReturned, ItemLedgEntry.FIELDCAPTION("Document No."),
                  ItemLedgEntry."Document No.", -QtyNotReturned);
            END;
    end;

    procedure SetStyle() Styletxt: Text[30]
    begin
        IF "Document Type" = "Document Type"::Order THEN BEGIN
            IF "Unit Price" <> "Unit Price 2" THEN
                EXIT('Attention')
            ELSE
                EXIT('')
            //IF "Closed at Date" > "Due Date" THEN
        END ELSE
            EXIT('');
    end;

    var
        ReturnReason: Record "Return Reason";
        TotalUnitPrice: Decimal;
        TotalUnitPrice2: Decimal;
        UnitPriceChanged: Boolean;
        Text029: Label 'must be positive';
        Text030: Label 'must be negative';
        Text039: Label '%1 units for %2 %3 have already been returned. Therefore, only %4 units can be returned.';
        Text040: Label 'You must use form %1 to enter %2, if item tracking is used.';
        Text046: Label 'You cannot return more than the %1 units that you have shipped for %2 %3.';
}