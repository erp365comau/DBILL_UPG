codeunit 50013 "Sales Post EventSub"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnBeforeSalesInvHeaderInsert, '', false, false)]
    local procedure "Sales-Post_OnBeforeSalesInvHeaderInsert"(var SalesInvHeader: Record "Sales Invoice Header"; var SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; var IsHandled: Boolean; WhseShip: Boolean; WhseShptHeader: Record "Warehouse Shipment Header"; InvtPickPutaway: Boolean)
    begin
        SalesInvHeader."Promised Delivery Date" := SalesHeader."Promised Delivery Date";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnInsertShipmentLineOnAfterInitQuantityFields, '', false, false)]
    local procedure "Sales-Post_OnInsertShipmentLineOnAfterInitQuantityFields"(var SalesLine: Record "Sales Line"; var xSalesLine: Record "Sales Line"; var SalesShptLine: Record "Sales Shipment Line")
    begin
        IF SalesLine."Qty. to Ship" <> SalesLine.Quantity THEN
            SalesShptLine."Outstanding Quantity" := SalesLine."Outstanding Quantity" - SalesLine."Qty. to Ship";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnBeforeCheckCertificateOfSupplyStatus, '', false, false)]
    local procedure "Sales-Post_OnBeforeCheckCertificateOfSupplyStatus"(SalesShipmentHeader: Record "Sales Shipment Header"; SalesShipmentLine: Record "Sales Shipment Line"; var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Invoice Line", OnAfterInitFromSalesLine, '', false, false)]
    local procedure "Sales Invoice Line_OnAfterInitFromSalesLine"(var SalesInvLine: Record "Sales Invoice Line"; SalesInvHeader: Record "Sales Invoice Header"; SalesLine: Record "Sales Line")
    begin
        IF SalesLine."Qty. to Invoice" <> SalesLine.Quantity THEN
            SalesInvLine."Outstanding Quantity" := SalesLine."Outstanding Quantity" - SalesLine."Qty. to Invoice";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnAfterInitAssocItemJnlLine, '', false, false)]
    local procedure "Sales-Post_OnAfterInitAssocItemJnlLine"(var ItemJournalLine: Record "Item Journal Line"; PurchaseHeader: Record "Purchase Header"; PurchaseLine: Record "Purchase Line"; SalesHeader: Record "Sales Header"; SalesLine: Record "Sales Line"; QtyToBeShipped: Decimal; QtyToBeShippedBase: Decimal)
    begin
        ItemJournalLine.Amount := PurchaseLine."Line Amount"
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnBeforeCheckHeaderShippingAdvice, '', false, false)]
    local procedure "Sales-Post_OnBeforeCheckHeaderShippingAdvice"(SalesHeader: Record "Sales Header"; WhseShip: Boolean; var IsHandled: Boolean)
    begin
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnBeforeUpdateBlanketOrderLine, '', false, false)]
    local procedure "Sales-Post_OnBeforeUpdateBlanketOrderLine"(SalesLine: Record "Sales Line"; Ship: Boolean; Receive: Boolean; Invoice: Boolean; var IsHandled: Boolean)
    var
        BlanketOrderSalesLine: Record "Sales Line";
        xBlanketOrderSalesLine: Record "Sales Line";
        ModifyLine: Boolean;
        Sign: Decimal;
    begin
        if (SalesLine."Blanket Order No." <> '') and (SalesLine."Blanket Order Line No." <> 0) and
        ((Ship and (SalesLine."Qty. to Ship" <> 0)) or
         (Receive and (SalesLine."Return Qty. to Receive" <> 0)) or
         (Invoice and (SalesLine."Qty. to Invoice" <> 0)))
     then
            if BlanketOrderSalesLine.Get(
                 BlanketOrderSalesLine."Document Type"::"Blanket Order", SalesLine."Blanket Order No.",
                 SalesLine."Blanket Order Line No.")
            then begin
                BlanketOrderSalesLine.TestField(Type, SalesLine.Type);
                BlanketOrderSalesLine.TestField("No.", SalesLine."No.");

                BlanketOrderSalesLine.TestField("Sell-to Customer No.", SalesLine."Sell-to Customer No.");

                ModifyLine := false;
                case SalesLine."Document Type" of
                    SalesLine."Document Type"::Order,
                  SalesLine."Document Type"::Invoice:
                        Sign := 1;
                    SalesLine."Document Type"::"Return Order",
                  SalesLine."Document Type"::"Credit Memo":
                        Sign := -1;
                end;
                if Ship and (SalesLine."Shipment No." = '') then begin

                    if BlanketOrderSalesLine."Qty. per Unit of Measure" = SalesLine."Qty. per Unit of Measure" then
                        BlanketOrderSalesLine."Quantity Shipped" += Sign * SalesLine."Qty. to Ship"
                    else
                        BlanketOrderSalesLine."Quantity Shipped" +=
                          Sign *
                          Round(
                            (SalesLine."Qty. per Unit of Measure" /
                             BlanketOrderSalesLine."Qty. per Unit of Measure") * SalesLine."Qty. to Ship",
                            UOMMgt.QtyRndPrecision());
                    BlanketOrderSalesLine."Qty. Shipped (Base)" += Sign * SalesLine."Qty. to Ship (Base)";
                    ModifyLine := true;
                end;
                if Receive and (SalesLine."Return Receipt No." = '') then begin
                    if BlanketOrderSalesLine."Qty. per Unit of Measure" =
                       SalesLine."Qty. per Unit of Measure"
                    then
                        BlanketOrderSalesLine."Quantity Shipped" += Sign * SalesLine."Return Qty. to Receive"
                    else
                        BlanketOrderSalesLine."Quantity Shipped" +=
                          Sign *
                          Round(
                            (SalesLine."Qty. per Unit of Measure" /
                             BlanketOrderSalesLine."Qty. per Unit of Measure") * SalesLine."Return Qty. to Receive",
                            UOMMgt.QtyRndPrecision());
                    BlanketOrderSalesLine."Qty. Shipped (Base)" += Sign * SalesLine."Return Qty. to Receive (Base)";
                    ModifyLine := true;
                end;
                if Invoice then begin
                    if BlanketOrderSalesLine."Qty. per Unit of Measure" =
                       SalesLine."Qty. per Unit of Measure"
                    then
                        BlanketOrderSalesLine."Quantity Invoiced" += Sign * SalesLine."Qty. to Invoice"
                    else
                        BlanketOrderSalesLine."Quantity Invoiced" +=
                          Sign *
                          Round(
                            (SalesLine."Qty. per Unit of Measure" /
                             BlanketOrderSalesLine."Qty. per Unit of Measure") * SalesLine."Qty. to Invoice",
                            UOMMgt.QtyRndPrecision());
                    BlanketOrderSalesLine."Qty. Invoiced (Base)" += Sign * SalesLine."Qty. to Invoice (Base)";
                    ModifyLine := true;
                end;

                if ModifyLine then begin
                    BlanketOrderSalesLine.InitOutstanding();


                    if (BlanketOrderSalesLine.Quantity * BlanketOrderSalesLine."Quantity Shipped" < 0) or
                       (Abs(BlanketOrderSalesLine.Quantity) < Abs(BlanketOrderSalesLine."Quantity Shipped"))
                    then
                        BlanketOrderSalesLine.FieldError(
                          "Quantity Shipped", StrSubstNo(BlanketOrderQuantityGreaterThanErr, BlanketOrderSalesLine.FieldCaption(Quantity)));
                    if (BlanketOrderSalesLine."Quantity (Base)" * BlanketOrderSalesLine."Qty. Shipped (Base)" < 0) or
                       (Abs(BlanketOrderSalesLine."Quantity (Base)") < Abs(BlanketOrderSalesLine."Qty. Shipped (Base)"))
                    then
                        BlanketOrderSalesLine.FieldError(
                          "Qty. Shipped (Base)",
                          StrSubstNo(BlanketOrderQuantityGreaterThanErr, BlanketOrderSalesLine.FieldCaption("Quantity (Base)")));
                    BlanketOrderSalesLine.CalcFields("Reserved Qty. (Base)");
                    if Abs(BlanketOrderSalesLine."Outstanding Qty. (Base)") < Abs(BlanketOrderSalesLine."Reserved Qty. (Base)") then
                        BlanketOrderSalesLine.FieldError(
                          "Reserved Qty. (Base)", BlanketOrderQuantityReducedErr);
                end;

                BlanketOrderSalesLine."Qty. to Invoice" :=
                    BlanketOrderSalesLine.Quantity - BlanketOrderSalesLine."Quantity Invoiced";
                if (SalesLine.Quantity = SalesLine."Quantity Shipped") or (SalesLine."Quantity Shipped" = 0) then
                    BlanketOrderSalesLine."Qty. to Ship" :=
                        BlanketOrderSalesLine.Quantity - BlanketOrderSalesLine."Quantity Shipped";
                BlanketOrderSalesLine."Qty. to Invoice (Base)" :=
                    BlanketOrderSalesLine."Quantity (Base)" - BlanketOrderSalesLine."Qty. Invoiced (Base)";
                if (SalesLine."Quantity (Base)" = SalesLine."Qty. Shipped (Base)") or (SalesLine."Qty. Shipped (Base)" = 0) then
                    BlanketOrderSalesLine."Qty. to Ship (Base)" :=
                        BlanketOrderSalesLine."Quantity (Base)" - BlanketOrderSalesLine."Qty. Shipped (Base)";

                BlanketOrderSalesLine.Modify();
            end;
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnBeforeAdjustPrepmtAmountLCY, '', false, false)]
    local procedure "Sales-Post_OnBeforeAdjustPrepmtAmountLCY"(SalesHeader: Record "Sales Header"; var PrepmtSalesLine: Record "Sales Line"; var IsHandled: Boolean)
    VAR
        SalesLine: Record "Sales Line";
        SalesInvoiceLine: Record "Sales Line";
        TempSalesLineShipmentBuffer: Record "Sales Line" temporary;
        DeductionFactor: Decimal;
        PrepmtVATPart: Decimal;
        PrepmtVATAmtRemainder: Decimal;
        TotalRoundingAmount: array[2] of Decimal;
        TotalPrepmtAmount: array[2] of Decimal;
        FinalInvoice: Boolean;
        PricesInclVATRoundingAmount: array[2] of Decimal;
        CurrentLineFinalInvoice: Boolean;
    begin
        if PrepmtSalesLine."Prepayment Line" then begin
            PrepmtVATPart :=
              (PrepmtSalesLine."Amount Including VAT" - PrepmtSalesLine.Amount) / PrepmtSalesLine."Unit Price";

            TempPrepmtDeductLCYSalesLine.Reset();
            TempPrepmtDeductLCYSalesLine.SetRange("Attached to Line No.", PrepmtSalesLine."Line No.");
            if TempPrepmtDeductLCYSalesLine.FindSet(true) then begin
                FinalInvoice := true;
                repeat
                    SalesLine := TempPrepmtDeductLCYSalesLine;
                    SalesLine.Find();

                    if TempPrepmtDeductLCYSalesLine."Document Type" = TempPrepmtDeductLCYSalesLine."Document Type"::Invoice then begin
                        SalesInvoiceLine := SalesLine;
                        GetSalesOrderLine(SalesLine, SalesInvoiceLine);
                        SalesLine."Qty. to Invoice" := SalesInvoiceLine."Qty. to Invoice";

                        TempSalesLineShipmentBuffer := SalesLine;
                        if TempSalesLineShipmentBuffer.Find() then begin
                            TempSalesLineShipmentBuffer."Qty. to Invoice" += TempPrepmtDeductLCYSalesLine."Qty. to Invoice";
                            TempSalesLineShipmentBuffer.Modify();
                        end else begin
                            TempSalesLineShipmentBuffer.Quantity := TempPrepmtDeductLCYSalesLine.Quantity;
                            TempSalesLineShipmentBuffer."Qty. to Invoice" := TempPrepmtDeductLCYSalesLine."Qty. to Invoice";
                            TempSalesLineShipmentBuffer.Insert();
                        end;
                        CurrentLineFinalInvoice := TempSalesLineShipmentBuffer.IsFinalInvoice();
                    end else begin
                        CurrentLineFinalInvoice := TempPrepmtDeductLCYSalesLine.IsFinalInvoice();
                        FinalInvoice := FinalInvoice and CurrentLineFinalInvoice;
                    end;

                    if SalesLine."Qty. to Invoice" <> TempPrepmtDeductLCYSalesLine."Qty. to Invoice" then
                        SalesLine."Prepmt Amt to Deduct" := CalcPrepmtAmtToDeduct(SalesLine, SalesHeader.Ship);
                    DeductionFactor :=
                      SalesLine."Prepmt Amt to Deduct" /
                      (SalesLine."Prepmt. Amt. Inv." - SalesLine."Prepmt Amt Deducted");

                    TempPrepmtDeductLCYSalesLine."Prepmt. VAT Amount Inv. (LCY)" :=
                      CalcRoundedAmount(SalesLine."Prepmt Amt to Deduct" * PrepmtVATPart, PrepmtVATAmtRemainder);
                    if (TempPrepmtDeductLCYSalesLine."Prepayment %" <> 100) or CurrentLineFinalInvoice or (TempPrepmtDeductLCYSalesLine."Currency Code" <> '') then
                        CalcPrepmtRoundingAmounts(TempPrepmtDeductLCYSalesLine, SalesLine, DeductionFactor, TotalRoundingAmount);
                    TempPrepmtDeductLCYSalesLine.Modify();

                    if TempPrepmtDeductLCYSalesLine."VAT Calculation Type" <> TempPrepmtDeductLCYSalesLine."VAT Calculation Type"::"Full VAT" then
                        TotalPrepmtAmount[1] += TempPrepmtDeductLCYSalesLine."Prepmt. Amount Inv. (LCY)";
                    TotalPrepmtAmount[2] += TempPrepmtDeductLCYSalesLine."Prepmt. VAT Amount Inv. (LCY)";
                until TempPrepmtDeductLCYSalesLine.Next() = 0;
            end;

            if FinalInvoice then
                if TempSalesLineShipmentBuffer.FindSet() then
                    repeat
                        if not TempSalesLineShipmentBuffer.IsFinalInvoice() then
                            FinalInvoice := false;
                    until not FinalInvoice or (TempSalesLineShipmentBuffer.Next() = 0);

            if SalesHeader."Document Type" <> SalesHeader."Document Type"::"Credit Memo" then
                UpdatePrepmtSalesLineWithRounding(PrepmtSalesLine, TotalRoundingAmount, TotalPrepmtAmount, FinalInvoice);
        end;
        IsHandled := true;
    end;

    local procedure GetSalesOrderLine(var SalesOrderLine: Record "Sales Line"; SalesLine: Record "Sales Line")
    var
        SalesShptLine: Record "Sales Shipment Line";
    begin
        SalesShptLine.Get(SalesLine."Shipment No.", SalesLine."Shipment Line No.");
        SalesOrderLine.Get(
          SalesOrderLine."Document Type"::Order,
          SalesShptLine."Order No.", SalesShptLine."Order Line No.");
        SalesOrderLine."Prepmt Amt to Deduct" := SalesLine."Prepmt Amt to Deduct";
    end;

    local procedure CalcPrepmtAmtToDeduct(SalesLine: Record "Sales Line"; Ship: Boolean): Decimal
    begin
        SalesLine."Qty. to Invoice" := GetQtyToInvoice(SalesLine, Ship);
        SalesLine.CalcPrepaymentToDeduct();
        exit(SalesLine."Prepmt Amt to Deduct");
    end;

    local procedure CalcRoundedAmount(Amount: Decimal; var Remainder: Decimal): Decimal
    var
        AmountRnded: Decimal;
    begin
        GLSetup.GET();
        Amount := Amount + Remainder;
        AmountRnded := Round(Amount, GLSetup."Amount Rounding Precision");
        Remainder := Amount - AmountRnded;
        exit(AmountRnded);
    end;

    local procedure GetQtyToInvoice(SalesLine: Record "Sales Line"; Ship: Boolean): Decimal
    var
        AllowedQtyToInvoice: Decimal;
    begin
        AllowedQtyToInvoice := SalesLine."Qty. Shipped Not Invoiced";
        if Ship then
            AllowedQtyToInvoice := AllowedQtyToInvoice + SalesLine."Qty. to Ship";
        if SalesLine."Qty. to Invoice" > AllowedQtyToInvoice then
            exit(AllowedQtyToInvoice);
        exit(SalesLine."Qty. to Invoice");
    end;

    local procedure CalcPrepmtRoundingAmounts(var PrepmtSalesLineBuf: Record "Sales Line"; SalesLine: Record "Sales Line"; DeductionFactor: Decimal; var TotalRoundingAmount: array[2] of Decimal)
    var
        RoundingAmount: array[2] of Decimal;
    begin
        if PrepmtSalesLineBuf."VAT Calculation Type" <> PrepmtSalesLineBuf."VAT Calculation Type"::"Full VAT" then begin
            RoundingAmount[1] :=
              PrepmtSalesLineBuf."Prepmt. Amount Inv. (LCY)" - Round(DeductionFactor * SalesLine."Prepmt. Amount Inv. (LCY)");
            PrepmtSalesLineBuf."Prepmt. Amount Inv. (LCY)" := PrepmtSalesLineBuf."Prepmt. Amount Inv. (LCY)" - RoundingAmount[1];
            TotalRoundingAmount[1] += RoundingAmount[1];
        end;
        RoundingAmount[2] :=
          PrepmtSalesLineBuf."Prepmt. VAT Amount Inv. (LCY)" - Round(DeductionFactor * SalesLine."Prepmt. VAT Amount Inv. (LCY)");
        PrepmtSalesLineBuf."Prepmt. VAT Amount Inv. (LCY)" := PrepmtSalesLineBuf."Prepmt. VAT Amount Inv. (LCY)" - RoundingAmount[2];
        TotalRoundingAmount[2] += RoundingAmount[2];
    end;

    procedure UpdatePrepmtSalesLineWithRounding(var PrepmtSalesLine: Record "Sales Line"; TotalRoundingAmount: array[2] of Decimal; TotalPrepmtAmount: array[2] of Decimal; FinalInvoice: Boolean)
    var
        NewAmountIncludingVAT: Decimal;
        Prepmt100PctVATRoundingAmt: Decimal;
        AmountRoundingPrecision: Decimal;
        Currency: Record Currency;
    begin
        Currency.get(PrepmtSalesLine."Currency Code");
        NewAmountIncludingVAT := TotalPrepmtAmount[1] + TotalPrepmtAmount[2] + TotalRoundingAmount[1] + TotalRoundingAmount[2];
        if PrepmtSalesLine."Prepayment %" = 100 then
            TotalRoundingAmount[1] += PrepmtSalesLine."Amount Including VAT" - NewAmountIncludingVAT;

        AmountRoundingPrecision :=
          GetAmountRoundingPrecisionInLCY(PrepmtSalesLine."Document Type", PrepmtSalesLine."Document No.", PrepmtSalesLine."Currency Code");

        if (Abs(TotalRoundingAmount[1]) <= AmountRoundingPrecision) and
           (Abs(TotalRoundingAmount[2]) <= AmountRoundingPrecision) and
           (PrepmtSalesLine."Prepayment %" = 100)
        then begin
            Prepmt100PctVATRoundingAmt := TotalRoundingAmount[1];
            TotalRoundingAmount[1] := 0;
        end;

        PrepmtSalesLine."Prepmt. Amount Inv. (LCY)" := TotalRoundingAmount[1];
        PrepmtSalesLine.Amount := TotalPrepmtAmount[1] + TotalRoundingAmount[1];

        if ((TotalRoundingAmount[2] <> 0) or FinalInvoice) and (TotalRoundingAmount[1] = 0) then begin
            if (PrepmtSalesLine."Prepayment %" = 100) and (PrepmtSalesLine."Prepmt. Amount Inv. (LCY)" = 0) then
                Prepmt100PctVATRoundingAmt += TotalRoundingAmount[2];
            if (PrepmtSalesLine."Prepayment %" = 100) or FinalInvoice then
                TotalRoundingAmount[2] := 0;
        end;

        PrepmtSalesLine."Prepmt. VAT Amount Inv. (LCY)" := TotalRoundingAmount[2] + Prepmt100PctVATRoundingAmt;
        NewAmountIncludingVAT := PrepmtSalesLine.Amount + TotalPrepmtAmount[2] + TotalRoundingAmount[2];

        Increment(
          TotalSalesLineLCY."Amount Including VAT",
          PrepmtSalesLine."Amount Including VAT" - NewAmountIncludingVAT - Prepmt100PctVATRoundingAmt);
        if PrepmtSalesLine."Currency Code" = '' then
            TotalSalesLine."Amount Including VAT" := TotalSalesLineLCY."Amount Including VAT";
        PrepmtSalesLine."Amount Including VAT" := NewAmountIncludingVAT;

        if FinalInvoice and (TotalSalesLine.Amount = 0) and (TotalSalesLine."Amount Including VAT" <> 0) and
           (Abs(TotalSalesLine."Amount Including VAT") <= Currency."Amount Rounding Precision")
        then begin
            PrepmtSalesLine."Amount Including VAT" += TotalSalesLineLCY."Amount Including VAT";
            TotalSalesLine."Amount Including VAT" := 0;
            TotalSalesLineLCY."Amount Including VAT" := 0;
        end;
    end;

    local procedure GetAmountRoundingPrecisionInLCY(DocType: Enum "Sales Document Type"; DocNo: Code[20]; CurrencyCode: Code[10]) AmountRoundingPrecision: Decimal
    var
        SalesHeader: Record "Sales Header";
        Currency: Record Currency;
    begin

        if CurrencyCode = '' then begin
            Currency.GET(CurrencyCode);
            exit(GLSetup."Amount Rounding Precision");
        end;
        SalesHeader.Get(DocType, DocNo);
        AmountRoundingPrecision := Currency."Amount Rounding Precision" / SalesHeader."Currency Factor";
        if AmountRoundingPrecision < GLSetup."Amount Rounding Precision" then
            exit(GLSetup."Amount Rounding Precision");
        exit(AmountRoundingPrecision);
    end;

    local procedure Increment(var Number: Decimal; Number2: Decimal)
    begin
        Number := Number + Number2;
    end;

    var
        SalesSetup: Record "Sales & Receivables Setup";
        TempPrepmtDeductLCYSalesLine: Record "Sales Line" temporary;
        GLSetup: Record "General Ledger Setup";
        TotalSalesLineLCY: Record "Sales Line";
        TotalSalesLine: Record "Sales Line";
        UOMMgt: Codeunit "Unit of Measure Management";
        AsmPost: Codeunit "Assembly-Post";
        SalesLineReserve: Codeunit "Sales Line-Reserve";
        SalesPost: Codeunit "Sales-Post";
        BlanketOrderQuantityGreaterThanErr: Label 'in the associated blanket order must not be greater than %1', Comment = '%1 = Quantity';
        BlanketOrderQuantityReducedErr: Label 'in the associated blanket order must not be reduced';

}
