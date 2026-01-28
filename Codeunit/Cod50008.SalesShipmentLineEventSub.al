codeunit 50008 "Sales Shipment Line EventSub"
{
    [EventSubscriber(ObjectType::Table, Database::"Sales Shipment Line", OnAfterClearSalesLineValues, '', false, false)]
    local procedure "Sales Shipment Line_OnAfterClearSalesLineValues"(var SalesShipmentLine: Record "Sales Shipment Line"; var SalesLine: Record "Sales Line")
    begin
        SalesLine."Prepmt. Amt. Inv." := 0;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Shipment Line", OnBeforeCodeInsertInvLineFromShptLine, '', false, false)]
    local procedure "Sales Shipment Line_OnBeforeCodeInsertInvLineFromShptLine"(var SalesShipmentLine: Record "Sales Shipment Line"; var SalesLine: Record "Sales Line"; var IsHandled: Boolean)
    var
        SalesInvHeader: Record "Sales Header";
        SalesOrderHeader: Record "Sales Header";
        SalesOrderLine: Record "Sales Line";
        TempSalesLine: Record "Sales Line" temporary;
        TransferOldExtLines: Codeunit "Transfer Old Ext. Text Lines";
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        TranslationHelper: Codeunit "Translation Helper";
        PrepaymentMgt: Codeunit "Prepayment Mgt.";
        ExtTextLine: Boolean;
        NextLineNo: Integer;
    begin

        SalesShipmentLine.SetRange("Document No.", SalesShipmentLine."Document No.");

        TempSalesLine := SalesLine;
        if SalesLine.Find('+') then
            NextLineNo := SalesLine."Line No." + 10000
        else
            NextLineNo := 10000;


        if not IsHandled then
            if SalesInvHeader."No." <> TempSalesLine."Document No." then
                SalesInvHeader.Get(TempSalesLine."Document Type", TempSalesLine."Document No.");

        if SalesLine."Shipment No." <> SalesShipmentLine."Document No." then begin

            SalesLine.Init();
            SalesLine."Line No." := NextLineNo;
            SalesLine."Document Type" := TempSalesLine."Document Type";
            SalesLine."Document No." := TempSalesLine."Document No.";
            TranslationHelper.SetGlobalLanguageByCode(SalesInvHeader."Language Code");
            SalesLine.Description := StrSubstNo(Text000, SalesShipmentLine."Document No.");
            TranslationHelper.RestoreGlobalLanguage();
            if not IsHandled then begin
                SalesLine.Insert();
                NextLineNo := NextLineNo + 10000;
            end;
        end;

        TransferOldExtLines.ClearLineNumbers();

        repeat
            ExtTextLine := (SalesShipmentLine.Type = SalesShipmentLine.Type::" ") and (SalesShipmentLine."Attached to Line No." <> 0) and (SalesShipmentLine.Quantity = 0);
            if ExtTextLine then
                TransferOldExtLines.GetNewLineNumber(SalesShipmentLine."Attached to Line No.")
            else
                SalesShipmentLine."Attached to Line No." := 0;

            if (SalesShipmentLine.Type <> SalesShipmentLine.Type::" ") and SalesOrderLine.Get(SalesOrderLine."Document Type"::Order, SalesShipmentLine."Order No.", SalesShipmentLine."Order Line No.")
            then begin
                if (SalesOrderHeader."Document Type" <> SalesOrderLine."Document Type"::Order) or
                   (SalesOrderHeader."No." <> SalesOrderLine."Document No.")
                then
                    SalesOrderHeader.Get(SalesOrderLine."Document Type"::Order, SalesShipmentLine."Order No.");

                PrepaymentMgt.TestSalesOrderLineForGetShptLines(SalesOrderLine);
                InitCurrency(SalesShipmentLine."Currency Code");

                if SalesInvHeader."Prices Including VAT" then begin
                    if not SalesOrderHeader."Prices Including VAT" then
                        SalesOrderLine."Unit Price" :=
                          Round(
                            SalesOrderLine."Unit Price" * (1 + SalesOrderLine."VAT %" / 100),
                            Currency."Unit-Amount Rounding Precision");
                end else
                    if SalesOrderHeader."Prices Including VAT" then
                        SalesOrderLine."Unit Price" :=
                          Round(
                            SalesOrderLine."Unit Price" / (1 + SalesOrderLine."VAT %" / 100),
                            Currency."Unit-Amount Rounding Precision");
            end else begin
                SalesOrderHeader.Init();
                if ExtTextLine or (SalesShipmentLine.Type = SalesShipmentLine.Type::" ") then begin
                    SalesOrderLine.Init();
                    SalesOrderLine."Line No." := SalesShipmentLine."Order Line No.";
                    SalesOrderLine.Description := SalesShipmentLine.Description;
                    SalesOrderLine."Description 2" := SalesShipmentLine."Description 2";
                end else
                    Error(Text001);
            end;

            SalesLine := SalesOrderLine;
            SalesLine."Line No." := NextLineNo;
            SalesLine."Document Type" := TempSalesLine."Document Type";
            SalesLine."Document No." := TempSalesLine."Document No.";
            SalesLine."Variant Code" := SalesShipmentLine."Variant Code";
            SalesLine."Location Code" := SalesShipmentLine."Location Code";
            SalesLine."Drop Shipment" := SalesShipmentLine."Drop Shipment";
            SalesLine."Shipment No." := SalesShipmentLine."Document No.";
            SalesLine."Shipment Line No." := SalesShipmentLine."Line No.";
            SalesShipmentLine.ClearSalesLineValues(SalesLine);
            if not ExtTextLine and (SalesLine.Type <> SalesLine.Type::" ") then begin
                IsHandled := false;
                if SalesLine."Deferral Code" <> '' then
                    SalesLine.Validate("Deferral Code");
                if not IsHandled then
                    SalesLine.Validate(Quantity, SalesShipmentLine.Quantity - SalesShipmentLine."Quantity Invoiced");
                SalesShipmentLine.CalcBaseQuantities(SalesLine, SalesShipmentLine."Quantity (Base)" / SalesShipmentLine.Quantity);

                SalesLine.Validate("Unit Price", SalesOrderLine."Unit Price");
                SalesLine."Allow Line Disc." := SalesOrderLine."Allow Line Disc.";
                SalesLine."Allow Invoice Disc." := SalesOrderLine."Allow Invoice Disc.";
                SalesLine."Line Discount Amount" :=
                  Round(
                    SalesOrderLine."Line Discount Amount" * SalesLine.Quantity / SalesOrderLine.Quantity,
                    Currency."Amount Rounding Precision");
                SalesLine."Line Discount %" := SalesOrderLine."Line Discount %";
                SalesLine.UpdatePrePaymentAmounts();

                if SalesOrderLine.Quantity = 0 then
                    SalesLine.Validate("Inv. Discount Amount", 0)
                else begin
                    if not SalesLine."Allow Invoice Disc." then
                        if SalesLine."VAT Calculation Type" <> SalesLine."VAT Calculation Type"::"Full VAT" then
                            SalesLine."Allow Invoice Disc." := SalesOrderLine."Allow Invoice Disc.";
                    if SalesLine."Allow Invoice Disc." then
                        SalesLine.Validate(
                          "Inv. Discount Amount",
                          Round(
                            SalesOrderLine."Inv. Discount Amount" * SalesLine.Quantity / SalesOrderLine.Quantity,
                            Currency."Amount Rounding Precision"));
                    SalesLine.VALIDATE("Prepmt. Amt. Inv.", SalesOrderLine."Prepmt. Amt. Inv.");
                end;
            end;

            SalesLine."Attached to Line No." :=
              TransferOldExtLines.TransferExtendedText(
                SalesOrderLine."Line No.",
                NextLineNo,
                SalesShipmentLine."Attached to Line No.");
            SalesLine."Shortcut Dimension 1 Code" := SalesShipmentLine."Shortcut Dimension 1 Code";
            SalesLine."Shortcut Dimension 2 Code" := SalesShipmentLine."Shortcut Dimension 2 Code";
            SalesLine."Dimension Set ID" := SalesShipmentLine."Dimension Set ID";
            IsHandled := false;
            if not IsHandled then
                SalesLine.Insert();

            ItemTrackingMgt.CopyHandledItemTrkgToInvLine(SalesOrderLine, SalesLine);

            NextLineNo := NextLineNo + 10000;
            if SalesShipmentLine."Attached to Line No." = 0 then begin
                SalesShipmentLine.SetRange("Attached to Line No.", SalesShipmentLine."Line No.");
                SalesShipmentLine.SetRange(Type, SalesShipmentLine.Type::" ");
            end;
        until (SalesShipmentLine.Next() = 0) or (SalesShipmentLine."Attached to Line No." = 0);
        IsHandled := false;
        if not IsHandled then
            if SalesOrderHeader.Get(SalesOrderHeader."Document Type"::Order, SalesShipmentLine."Order No.") then
                if not SalesOrderHeader."Get Shipment Used" then begin
                    SalesOrderHeader."Get Shipment Used" := true;
                    SalesOrderHeader.Modify();
                end;

        IsHandled := true;
    end;

    local procedure InitCurrency(CurrencyCode: Code[10])
    begin
        if (Currency.Code = CurrencyCode) and CurrencyRead then
            exit;

        if CurrencyCode <> '' then
            Currency.Get(CurrencyCode)
        else
            Currency.InitRoundingPrecision();
        CurrencyRead := true;
    end;

    var
        CurrencyRead: Boolean;
        Currency: Record Currency;
        Text000: Label 'Shipment No. %1:';
        Text001: Label 'The program cannot find this Sales line.';
}
