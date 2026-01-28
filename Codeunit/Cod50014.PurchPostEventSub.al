codeunit 50014 "Purch.-Post EventSub"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnBeforeCheckExternalDocumentNumber, '', false, false)]
    local procedure "Purch.-Post_OnBeforeCheckExternalDocumentNumber"(VendorLedgerEntry: Record "Vendor Ledger Entry"; PurchaseHeader: Record "Purchase Header"; var Handled: Boolean; DocType: Option; ExtDocNo: Text[35]; SrcCode: Code[10]; GenJnlLineDocType: Enum "Gen. Journal Document Type"; GenJnlLineDocNo: Code[20]; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; var TotalPurchLine: Record "Purchase Line"; var TotalPurchLineLCY: Record "Purchase Line")
    begin
        VendorLedgerEntry.Reset();
        VendorLedgerEntry.SetCurrentKey("External Document No.");
        VendorLedgerEntry.SetRange("Document Type", GenJnlLineDocType);
        VendorLedgerEntry.SetRange("External Document No.", ExtDocNo);
        VendorLedgerEntry.SetRange("Vendor No.", PurchaseHeader."Pay-to Vendor No.");
        if VendorLedgerEntry.FindFirst() then
            Error(
              PurchaseAlreadyExistsErr, VendorLedgerEntry."Document Type", ExtDocNo);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnPostItemChargePerSalesShptOnBeforeTestJobNo, '', false, false)]
    local procedure "Purch.-Post_OnPostItemChargePerSalesShptOnBeforeTestJobNo"(SalesShipmentLine: Record "Sales Shipment Line"; var IsHandled: Boolean; var PurchaseLine: Record "Purchase Line")
    var
        TempItemLedgEntry: Record "Item Ledger Entry" temporary;
        PurchPost: Codeunit "Purch.-Post";
        Sign: Decimal;
        DistributeCharge: Boolean;
    begin
        SalesShipmentLine.TestField("Job No.", '');

        IF SalesShipmentLine."Quantity (Base)" < 0 THEN
            Sign := -1
        ELSE
            Sign := 1;

        if SalesShipmentLine."Item Shpt. Entry No." <> 0 then
            DistributeCharge :=
              CostCalcMgt.SplitItemLedgerEntriesExist(
                TempItemLedgEntry, -SalesShipmentLine."Quantity (Base)", SalesShipmentLine."Item Shpt. Entry No.")
        else begin
            DistributeCharge := true;
            ItemTrackingMgt.CollectItemEntryRelation(TempItemLedgEntry,
              DATABASE::"Sales Shipment Line", 0, SalesShipmentLine."Document No.",
              '', 0, SalesShipmentLine."Line No.", SalesShipmentLine."Quantity (Base)");
        end;

        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnAfterInitAssocItemJnlLine, '', false, false)]
    local procedure "Purch.-Post_OnAfterInitAssocItemJnlLine"(var ItemJournalLine: Record "Item Journal Line"; SalesHeader: Record "Sales Header"; SalesLine: Record "Sales Line"; PurchaseHeader: Record "Purchase Header"; QtyToBeShipped: Decimal)
    begin
        ItemJournalLine.Amount := SalesLine."Line Amount";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnBeforeAdjustPrepmtAmountLCY, '', false, false)]
    local procedure "Purch.-Post_OnBeforeAdjustPrepmtAmountLCY"(PurchaseHeader: Record "Purchase Header"; var PrepmtPurchaseLine: Record "Purchase Line"; var IsHandled: Boolean)
    var
        PurchLine: Record "Purchase Line";
        PurchInvoiceLine: Record "Purchase Line";
        TempPurchaseLineReceiptBuffer: Record "Purchase Line" temporary;
        DeductionFactor: Decimal;
        PrepmtVATPart: Decimal;
        PrepmtVATAmtRemainder: Decimal;
        TotalRoundingAmount: array[2] of Decimal;
        TotalPrepmtAmount: array[2] of Decimal;
        FinalInvoice: Boolean;
        PricesInclVATRoundingAmount: array[2] of Decimal;
        CurrentLineFinalInvoice: Boolean;
    begin
        if PrepmtPurchaseLine."Prepayment Line" then begin
            PrepmtVATPart :=
              (PrepmtPurchaseLine."Amount Including VAT" - PrepmtPurchaseLine.Amount) / PrepmtPurchaseLine."Direct Unit Cost";

            TempPrepmtDeductLCYPurchLine.Reset();
            TempPrepmtDeductLCYPurchLine.SetRange("Attached to Line No.", PrepmtPurchaseLine."Line No.");
            if TempPrepmtDeductLCYPurchLine.FindSet(true) then begin
                FinalInvoice := true;
                repeat
                    PurchLine := TempPrepmtDeductLCYPurchLine;
                    PurchLine.Find();

                    if TempPrepmtDeductLCYPurchLine."Document Type" = TempPrepmtDeductLCYPurchLine."Document Type"::Invoice then begin
                        PurchInvoiceLine := PurchLine;
                        GetPurchOrderLine(PurchLine, PurchInvoiceLine);
                        PurchLine."Qty. to Invoice" := PurchInvoiceLine."Qty. to Invoice";

                        TempPurchaseLineReceiptBuffer := PurchLine;
                        if TempPurchaseLineReceiptBuffer.Find() then begin
                            TempPurchaseLineReceiptBuffer."Qty. to Invoice" += TempPrepmtDeductLCYPurchLine."Qty. to Invoice";
                            TempPurchaseLineReceiptBuffer.Modify();
                        end else begin
                            TempPurchaseLineReceiptBuffer.Quantity := TempPrepmtDeductLCYPurchLine.Quantity;
                            TempPurchaseLineReceiptBuffer."Qty. to Invoice" := TempPrepmtDeductLCYPurchLine."Qty. to Invoice";
                            TempPurchaseLineReceiptBuffer.Insert();
                        end;
                        CurrentLineFinalInvoice := TempPurchaseLineReceiptBuffer.IsFinalInvoice();
                    end else begin
                        CurrentLineFinalInvoice := TempPrepmtDeductLCYPurchLine.IsFinalInvoice();
                        FinalInvoice := FinalInvoice and CurrentLineFinalInvoice;
                    end;

                    if PurchLine."Qty. to Invoice" <> TempPrepmtDeductLCYPurchLine."Qty. to Invoice" then
                        PurchLine."Prepmt Amt to Deduct" := CalcPrepmtAmtToDeduct(PurchLine, PurchaseHeader.Receive);
                    DeductionFactor :=
                      PurchLine."Prepmt Amt to Deduct" /
                      (PurchLine."Prepmt. Amt. Inv." - PurchLine."Prepmt Amt Deducted");

                    TempPrepmtDeductLCYPurchLine."Prepmt. VAT Amount Inv. (LCY)" :=
                      -CalcRoundedAmount(PurchLine."Prepmt Amt to Deduct" * PrepmtVATPart, PrepmtVATAmtRemainder);
                    if (TempPrepmtDeductLCYPurchLine."Prepayment %" <> 100) or CurrentLineFinalInvoice or (TempPrepmtDeductLCYPurchLine."Currency Code" <> '') then
                        CalcPrepmtRoundingAmounts(TempPrepmtDeductLCYPurchLine, PurchLine, DeductionFactor, TotalRoundingAmount);
                    TempPrepmtDeductLCYPurchLine.Modify();

                    if PurchaseHeader."Prices Including VAT" then
                        if ((TempPrepmtDeductLCYPurchLine."Prepayment %" <> 100) or CurrentLineFinalInvoice) and (DeductionFactor = 1) then begin
                            PricesInclVATRoundingAmount[1] := TotalRoundingAmount[1];
                            PricesInclVATRoundingAmount[2] := TotalRoundingAmount[2];
                        end;

                    if TempPrepmtDeductLCYPurchLine."VAT Calculation Type" <> TempPrepmtDeductLCYPurchLine."VAT Calculation Type"::"Full VAT" then
                        TotalPrepmtAmount[1] += TempPrepmtDeductLCYPurchLine."Prepmt. Amount Inv. (LCY)";
                    TotalPrepmtAmount[2] += TempPrepmtDeductLCYPurchLine."Prepmt. VAT Amount Inv. (LCY)";
                until TempPrepmtDeductLCYPurchLine.Next() = 0;
            end;

            if FinalInvoice then
                if TempPurchaseLineReceiptBuffer.FindSet() then
                    repeat
                        if not TempPurchaseLineReceiptBuffer.IsFinalInvoice() then
                            FinalInvoice := false;
                    until not FinalInvoice or (TempPurchaseLineReceiptBuffer.Next() = 0);

            UpdatePrepmtPurchLineWithRounding(PrepmtPurchaseLine, TotalRoundingAmount, TotalPrepmtAmount, FinalInvoice);
        end;

        IsHandled := true;
    end;

    local procedure GetPurchOrderLine(var PurchOrderLine: Record "Purchase Line"; PurchLine: Record "Purchase Line")
    var
        PurchRcptLine: Record "Purch. Rcpt. Line";
    begin
        PurchRcptLine.Get(PurchLine."Receipt No.", PurchLine."Receipt Line No.");
        PurchOrderLine.Get(
          PurchOrderLine."Document Type"::Order,
          PurchRcptLine."Order No.", PurchRcptLine."Order Line No.");
        PurchOrderLine."Prepmt Amt to Deduct" := PurchLine."Prepmt Amt to Deduct";
    end;

    local procedure CalcPrepmtAmtToDeduct(PurchLine: Record "Purchase Line"; Receive: Boolean): Decimal
    begin
        PurchLine."Qty. to Invoice" := GetQtyToInvoice(PurchLine, Receive);
        PurchLine.CalcPrepaymentToDeduct();
        exit(PurchLine."Prepmt Amt to Deduct");
    end;

    local procedure GetQtyToInvoice(PurchLine: Record "Purchase Line"; Receive: Boolean): Decimal
    var
        AllowedQtyToInvoice: Decimal;
    begin
        AllowedQtyToInvoice := PurchLine."Qty. Rcd. Not Invoiced";
        if Receive then
            AllowedQtyToInvoice := AllowedQtyToInvoice + PurchLine."Qty. to Receive";
        if PurchLine."Qty. to Invoice" > AllowedQtyToInvoice then
            exit(AllowedQtyToInvoice);
        exit(PurchLine."Qty. to Invoice");
    end;

    local procedure CalcRoundedAmount(Amount: Decimal; var Remainder: Decimal): Decimal
    var
        AmountRnded: Decimal;
        GLSetup: Record "General Ledger Setup";
    begin
        GLSetup.Get();
        Amount := Amount + Remainder;
        AmountRnded := Round(Amount, GLSetup."Amount Rounding Precision");
        Remainder := Amount - AmountRnded;
        exit(AmountRnded);
    end;

    local procedure CalcPrepmtRoundingAmounts(var PrepmtPurchLineBuf: Record "Purchase Line"; PurchLine: Record "Purchase Line"; DeductionFactor: Decimal; var TotalRoundingAmount: array[2] of Decimal)
    var
        RoundingAmount: array[2] of Decimal;
    begin
        if PrepmtPurchLineBuf."VAT Calculation Type" <> PrepmtPurchLineBuf."VAT Calculation Type"::"Full VAT" then begin
            RoundingAmount[1] :=
              PrepmtPurchLineBuf."Prepmt. Amount Inv. (LCY)" - Round(DeductionFactor * PurchLine."Prepmt. Amount Inv. (LCY)");
            PrepmtPurchLineBuf."Prepmt. Amount Inv. (LCY)" := PrepmtPurchLineBuf."Prepmt. Amount Inv. (LCY)" - RoundingAmount[1];
            TotalRoundingAmount[1] += RoundingAmount[1];
        end;
        RoundingAmount[2] :=
          PrepmtPurchLineBuf."Prepmt. VAT Amount Inv. (LCY)" - Round(DeductionFactor * PurchLine."Prepmt. VAT Amount Inv. (LCY)");
        PrepmtPurchLineBuf."Prepmt. VAT Amount Inv. (LCY)" := PrepmtPurchLineBuf."Prepmt. VAT Amount Inv. (LCY)" - RoundingAmount[2];
        TotalRoundingAmount[2] += RoundingAmount[2];
    end;

    local procedure UpdatePrepmtPurchLineWithRounding(var PrepmtPurchLine: Record "Purchase Line"; TotalRoundingAmount: array[2] of Decimal; TotalPrepmtAmount: array[2] of Decimal; FinalInvoice: Boolean)
    var
        NewAmountIncludingVAT: Decimal;
        Prepmt100PctVATRoundingAmt: Decimal;
        AmountRoundingPrecision: Decimal;
        Currency: Record Currency;
    begin
        Currency.get(PrepmtPurchLine."Currency Code");
        NewAmountIncludingVAT := TotalPrepmtAmount[1] + TotalPrepmtAmount[2] + TotalRoundingAmount[1] + TotalRoundingAmount[2];
        if PrepmtPurchLine."Prepayment %" = 100 then
            TotalRoundingAmount[1] -= PrepmtPurchLine."Amount Including VAT" + NewAmountIncludingVAT;

        AmountRoundingPrecision :=
          GetAmountRoundingPrecisionInLCY(PrepmtPurchLine."Document Type", PrepmtPurchLine."Document No.", PrepmtPurchLine."Currency Code");

        if (Abs(TotalRoundingAmount[1]) <= AmountRoundingPrecision) and
           (Abs(TotalRoundingAmount[2]) <= AmountRoundingPrecision) and
           (PrepmtPurchLine."Prepayment %" = 100)
        then begin
            Prepmt100PctVATRoundingAmt := TotalRoundingAmount[1];
            TotalRoundingAmount[1] := 0;
        end;

        PrepmtPurchLine."Prepmt. Amount Inv. (LCY)" := -TotalRoundingAmount[1];
        PrepmtPurchLine.Amount := -(TotalPrepmtAmount[1] + TotalRoundingAmount[1]);

        if ((TotalRoundingAmount[2] <> 0) or FinalInvoice) and (TotalRoundingAmount[1] = 0) then begin
            if (PrepmtPurchLine."Prepayment %" = 100) and (PrepmtPurchLine."Prepmt. Amount Inv. (LCY)" = 0) then
                Prepmt100PctVATRoundingAmt += TotalRoundingAmount[2];
            if (PrepmtPurchLine."Prepayment %" = 100) or FinalInvoice then
                TotalRoundingAmount[2] := 0;
        end;

        PrepmtPurchLine."Prepmt. VAT Amount Inv. (LCY)" := -(TotalRoundingAmount[2] + Prepmt100PctVATRoundingAmt);
        NewAmountIncludingVAT := PrepmtPurchLine.Amount - (TotalPrepmtAmount[2] + TotalRoundingAmount[2]);

        Increment(
          TotalPurchLineLCY."Amount Including VAT",
          -(PrepmtPurchLine."Amount Including VAT" - NewAmountIncludingVAT + Prepmt100PctVATRoundingAmt));
        if PrepmtPurchLine."Currency Code" = '' then
            TotalPurchLine."Amount Including VAT" := TotalPurchLineLCY."Amount Including VAT";
        PrepmtPurchLine."Amount Including VAT" := NewAmountIncludingVAT;

        if FinalInvoice and (TotalPurchLine.Amount = 0) and (TotalPurchLine."Amount Including VAT" <> 0) and
           (Abs(TotalPurchLine."Amount Including VAT") <= Currency."Amount Rounding Precision")
        then begin
            PrepmtPurchLine."Amount Including VAT" -= TotalPurchLineLCY."Amount Including VAT";
            TotalPurchLine."Amount Including VAT" := 0;
            TotalPurchLineLCY."Amount Including VAT" := 0;
        end;
    end;

    local procedure GetAmountRoundingPrecisionInLCY(DocType: Enum "Purchase Document Type"; DocNo: Code[20]; CurrencyCode: Code[10]) AmountRoundingPrecision: Decimal
    var
        PurchHeader: Record "Purchase Header";
        GLSetup: Record "General Ledger Setup";
        Currency: Record Currency;
    begin
        GLSetup.Get();
        if CurrencyCode = '' then
            exit(GLSetup."Amount Rounding Precision");
        PurchHeader.Get(DocType, DocNo);
        AmountRoundingPrecision := Currency."Amount Rounding Precision" / PurchHeader."Currency Factor";
        if AmountRoundingPrecision < GLSetup."Amount Rounding Precision" then
            exit(GLSetup."Amount Rounding Precision");
    end;

    local procedure Increment(var Number: Decimal; Number2: Decimal)
    begin
        Number := Number + Number2;
    end;

    var
        TempPrepmtDeductLCYPurchLine: Record "Purchase Line" temporary;
        TotalPurchLineLCY: Record "Purchase Line";
        TotalPurchLine: Record "Purchase Line";
        CostCalcMgt: Codeunit "Cost Calculation Management";
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        PurchaseAlreadyExistsErr: Label 'Purchase %1 %2 already exists for this vendor.', Comment = '%1 = Document Type, %2 = Document No.';


}
