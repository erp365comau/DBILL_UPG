codeunit 50004 "Sales Line EventSub"
{
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnBeforeValidateReturnReasonCode, '', false, false)]
    local procedure "Sales Line_OnBeforeValidateReturnReasonCode"(var SalesLine: Record "Sales Line"; CallingFieldNo: Integer; var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnValidateQuantityOnBeforeSalesLineVerifyChange, '', false, false)]
    local procedure "Sales Line_OnValidateQuantityOnBeforeSalesLineVerifyChange"(var SalesLine: Record "Sales Line"; StatusCheckSuspended: Boolean; var IsHandled: Boolean)
    begin
        SalesLine."Qty. to Asm. to Order (Base)" := CalcBaseQty(SalesLine, SalesLine."Qty. to Assemble to Order", SalesLine.FieldCaption("Qty. to Assemble to Order"), SalesLine.FieldCaption("Qty. to Asm. to Order (Base)"));
        if SalesLine."Qty. to Asm. to Order (Base)" <> 0 then begin
            SalesLine.TestField("Drop Shipment", false);
            SalesLine.TestField("Special Order", false);
            if SalesLine."Qty. to Asm. to Order (Base)" < 0 then
                SalesLine.FieldError("Qty. to Assemble to Order", StrSubstNo(Text009, SalesLine.FieldCaption("Quantity (Base)"), SalesLine."Quantity (Base)"));
            SalesLine.TestField("Appl.-to Item Entry", 0);

            case SalesLine."Document Type" of
                SalesLine."Document Type"::"Blanket Order",
             SalesLine."Document Type"::Quote:
                    if (SalesLine."Quantity (Base)" = 0) or (SalesLine."Qty. to Asm. to Order (Base)" <= 0) or SalesLineReserve.ReservEntryExist(SalesLine) then
                        SalesLine.TestField("Qty. to Asm. to Order (Base)", 0)
                    else
                        if SalesLine."Quantity (Base)" <> SalesLine."Qty. to Asm. to Order (Base)" then
                            SalesLine.FieldError("Qty. to Assemble to Order", StrSubstNo(Text031, 0, SalesLine."Quantity (Base)"));
                SalesLine."Document Type"::Order:
                    ;
                else begin

                    SalesLine.TestField("Qty. to Asm. to Order (Base)", 0);
                end;
            end;
        end;

        SalesLine.CheckItemAvailable(SalesLine.FieldNo("Qty. to Assemble to Order"));
        SalesLine.GetDefaultBin();

        SalesLine.AutoAsmToOrder();

        IsHandled := true;
    end;

    procedure CalcBaseQty(SalesLine: Record "Sales Line"; Qty: Decimal; FromFieldName: Text; ToFieldName: Text): Decimal
    begin
        exit(UOMMgt.CalcBaseQty(
            SalesLine."No.", SalesLine."Variant Code", SalesLine."Unit of Measure Code", Qty, SalesLine."Qty. per Unit of Measure", SalesLine."Qty. Rounding Precision (Base)", SalesLine.FieldCaption("Qty. Rounding Precision"), FromFieldName, ToFieldName));
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnBeforeInitQtyToShip, '', false, false)]
    local procedure "Sales Line_OnBeforeInitQtyToShip"(var SalesLine: Record "Sales Line"; FieldNo: Integer; var IsHandled: Boolean)
    begin
        SalesLine."Qty. to Ship" := SalesLine."Outstanding Quantity";
        SalesLine."Qty. to Ship (Base)" := SalesLine."Outstanding Qty. (Base)";

        SalesLine.CheckServItemCreation();
        SalesLine.InitQtyToInvoice();

        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnBeforeInitQtyToReceive, '', false, false)]
    local procedure "Sales Line_OnBeforeInitQtyToReceive"(var SalesLine: Record "Sales Line"; FieldNo: Integer; var IsHandled: Boolean)
    begin
        SalesLine."Return Qty. to Receive" := SalesLine."Outstanding Quantity";
        SalesLine."Return Qty. to Receive (Base)" := SalesLine."Outstanding Qty. (Base)";

        SalesLine.InitQtyToInvoice();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnUpdatePricesIncludingVATAmountsOnAfterCalculateNormalVAT, '', false, false)]
    local procedure "Sales Line_OnUpdatePricesIncludingVATAmountsOnAfterCalculateNormalVAT"(var SalesLine: Record "Sales Line"; var Currency: Record Currency)
    var
        SalesHeader: Record "Sales Header";
        TotalLineAmount: Decimal;
        TotalAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        TotalInvDiscAmount: Decimal;
    begin
        SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.");
        SalesLine."Amount Including VAT" := TotalLineAmount + SalesLine."Line Amount" - Round((TotalAmount + SalesLine.Amount) * (SalesHeader."VAT Base Discount %" / 100) * (SalesLine."VAT %" / 100),
                                Currency."Amount Rounding Precision", Currency.VATRoundingDirection()) - TotalAmountInclVAT - TotalInvDiscAmount
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnShowItemChargeAssgntOnBeforeCalcItemCharge, '', false, false)]
    local procedure "Sales Line_OnShowItemChargeAssgntOnBeforeCalcItemCharge"(var SalesLine: Record "Sales Line"; var ItemChargeAssgntLineAmt: Decimal; Currency: Record Currency; var IsHandled: Boolean; var ItemChargeAssgntSales: Record "Item Charge Assignment (Sales)")
    begin
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnBeforeUpdateVATOnLines, '', false, false)]
    local procedure "Sales Line_OnBeforeUpdateVATOnLines"(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; var VATAmountLine: Record "VAT Amount Line"; var IsHandled: Boolean; QtyType: Integer; var LineWasModified: Boolean; xSalesLine: Record "Sales Line"; CurrentFieldNo: Integer; var PrepaymentLineAmountEntered: Boolean)
    var
        TempVATAmountLineRemainder: Record "VAT Amount Line" temporary;
        Currency: Record Currency;
        AddCurrency: Record Currency;
        NewAmount: Decimal;
        NewAmountIncludingVAT: Decimal;
        NewVATBaseAmount: Decimal;
        VATAmount: Decimal;
        VATDifference: Decimal;
        InvDiscAmount: Decimal;
        LineAmountToInvoice: Decimal;
        NewAmountACY: Decimal;
        NewAmountIncludingVATACY: Decimal;
        NewVATBaseAmountACY: Decimal;
        VATAmountACY: Decimal;
        VATDifferenceACY: Decimal;
        LineAmountToInvoiceDiscounted: Decimal;
        DeferralAmount: Decimal;
        CurrencyFactor: Decimal;
    begin
        GLSetup.Get();
        if QtyType = 3 then
            exit;

        Currency.Initialize(SalesHeader."Currency Code");

        TempVATAmountLineRemainder.DeleteAll();

        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SetLoadFieldsForInvDiscoundCalculation(SalesLine);
        SalesLine.LockTable();
        if SalesLine.FindSet() then
            repeat
                if not SalesLine.ZeroAmountLine(QtyType) then begin
                    DeferralAmount := SalesLine.GetDeferralAmount();
                    FindVATAmountLine(SalesLine, VATAmountLine);
                    if VATAmountLine.Modified then begin
                        if not FindVATAmountLine(SalesLine, TempVATAmountLineRemainder) then begin
                            TempVATAmountLineRemainder := VATAmountLine;
                            TempVATAmountLineRemainder.Init();
                            TempVATAmountLineRemainder.Insert();
                        end;

                        if QtyType = 1 then
                            LineAmountToInvoice := SalesLine."Line Amount"
                        else
                            LineAmountToInvoice :=
                              Round(SalesLine."Line Amount" * SalesLine."Qty. to Invoice" / SalesLine.Quantity, Currency."Amount Rounding Precision");

                        if SalesLine."Allow Invoice Disc." then begin
                            if VATAmountLine."Inv. Disc. Base Amount" = 0 then
                                InvDiscAmount := 0
                            else begin
                                LineAmountToInvoiceDiscounted :=
                                  VATAmountLine."Invoice Discount Amount" * LineAmountToInvoice /
                                  VATAmountLine."Inv. Disc. Base Amount";
                                TempVATAmountLineRemainder."Invoice Discount Amount" :=
                                  TempVATAmountLineRemainder."Invoice Discount Amount" + LineAmountToInvoiceDiscounted;
                                InvDiscAmount :=
                                  Round(
                                    TempVATAmountLineRemainder."Invoice Discount Amount", Currency."Amount Rounding Precision");
                                LineAmountToInvoiceDiscounted := ROUND(LineAmountToInvoiceDiscounted, Currency."Amount Rounding Precision");
                                IF (InvDiscAmount < 0) AND (LineAmountToInvoiceDiscounted = 0) THEN
                                    InvDiscAmount := 0;
                                TempVATAmountLineRemainder."Invoice Discount Amount" :=
                                  TempVATAmountLineRemainder."Invoice Discount Amount" - InvDiscAmount;
                            end;
                            if QtyType = 1 then begin
                                SalesLine."Inv. Discount Amount" := InvDiscAmount;
                                SalesLine.CalcInvDiscToInvoice();
                                if SalesLine."Inv. Disc. Amount to Invoice" <> 0 then
                                    if SalesLine.GetFullGST() then
                                        SalesLine.UpdateAmounts();
                            end else
                                SalesLine."Inv. Disc. Amount to Invoice" := InvDiscAmount;
                        end else
                            InvDiscAmount := 0;

                        if QtyType = 1 then begin
                            if SalesHeader."Prices Including VAT" then begin
                                if (VATAmountLine.CalcLineAmount() = 0) or (SalesLine."Line Amount" = 0) then begin
                                    VATAmount := 0;
                                    NewAmountIncludingVAT := 0;
                                end else begin
                                    VATAmount :=
                                      TempVATAmountLineRemainder."VAT Amount" +
                                      VATAmountLine."VAT Amount" * SalesLine.CalcLineAmount() / VATAmountLine.CalcLineAmount();
                                    NewAmountIncludingVAT :=
                                      TempVATAmountLineRemainder."Amount Including VAT" +
                                      VATAmountLine."Amount Including VAT" * SalesLine.CalcLineAmount() / VATAmountLine.CalcLineAmount();
                                end;
                                NewAmount :=
                                  Round(NewAmountIncludingVAT, Currency."Amount Rounding Precision") -
                                  Round(VATAmount, Currency."Amount Rounding Precision");
                                NewVATBaseAmount :=
                                  Round(
                                    NewAmount * (1 - SalesHeader."VAT Base Discount %" / 100), Currency."Amount Rounding Precision");
                            end else begin
                                if SalesLine."VAT Calculation Type" = SalesLine."VAT Calculation Type"::"Full VAT" then begin
                                    VATAmount := SalesLine.CalcLineAmount();
                                    if (GLSetup."Additional Reporting Currency" <> '') and
                                        (SalesHeader."Currency Code" = GLSetup."Additional Reporting Currency") then
                                        VATAmountACY := TempVATAmountLineRemainder."VAT Amount (ACY)" +
                                          Round(VATAmount, Currency."Amount Rounding Precision")
                                    else
                                        VATAmountACY :=
                                          TempVATAmountLineRemainder."VAT Amount (ACY)" +
                                          Round(
                                            CurrExchRate.ExchangeAmtLCYToFCY(
                                              SalesLine.GetDate(), GLSetup."Additional Reporting Currency",
                                              Round(
                                                CurrExchRate.ExchangeAmtFCYToLCY(
                                                  SalesLine.GetDate(), SalesHeader."Currency Code", VATAmount,
                                                  SalesHeader."Currency Factor"), Currency."Amount Rounding Precision"), CurrencyFactor),
                                            AddCurrency."Amount Rounding Precision");
                                    NewAmount := 0;
                                    NewAmountACY := 0;
                                    NewVATBaseAmount := 0;
                                    NewVATBaseAmountACY := 0;
                                end else begin
                                    NewAmount := SalesLine.CalcLineAmount();
                                    NewAmountACY := SalesLine."Amount (ACY)";
                                    NewVATBaseAmount :=
                                      Round(
                                        NewAmount * (1 - SalesHeader."VAT Base Discount %" / 100), Currency."Amount Rounding Precision");
                                    NewVATBaseAmountACY :=
                                        Round(
                                            NewAmountACY * (1 - SalesHeader."VAT Base Discount %" / 100), Currency."Amount Rounding Precision");
                                    if VATAmountLine."VAT Base" = 0 then
                                        VATAmount := 0
                                    else
                                        VATAmount :=
                                          TempVATAmountLineRemainder."VAT Amount" +
                                          VATAmountLine."VAT Amount" * NewAmount / VATAmountLine."VAT Base";
                                end;
                                NewAmountIncludingVAT := NewAmount + Round(VATAmount, Currency."Amount Rounding Precision");
                                if VATAmountLine."VAT Base (ACY)" = 0 then
                                    VATAmountACY := 0
                                else
                                    VATAmountACY :=
                                      TempVATAmountLineRemainder."VAT Amount (ACY)" +
                                      VATAmountLine."VAT Amount (ACY)" * NewAmountACY / VATAmountLine."VAT Base (ACY)";
                                NewAmountIncludingVATACY := NewAmountACY + Round(VATAmountACY, Currency."Amount Rounding Precision");
                            end;
                        end else begin
                            if VATAmountLine.CalcLineAmount() = 0 then
                                SalesLine."VAT Difference" := 0
                            else begin
                                VATDifference :=
                                  TempVATAmountLineRemainder."VAT Difference" +
                                  VATAmountLine."VAT Difference" * (LineAmountToInvoice - InvDiscAmount) / VATAmountLine.CalcLineAmount();
                                VATDifferenceACY :=
                                    TempVATAmountLineRemainder."VAT Difference (ACY)" +
                                    VATAmountLine."VAT Difference (ACY)" * (LineAmountToInvoice - InvDiscAmount) / VATAmountLine.CalcLineAmount();
                            end;
                            if LineAmountToInvoice = 0 then
                                SalesLine."VAT Difference" := 0
                            else begin
                                SalesLine."VAT Difference" := Round(VATDifference, Currency."Amount Rounding Precision");
                                SalesLine."VAT Difference (ACY)" := Round(VATDifferenceACY, Currency."Amount Rounding Precision");
                            end;
                        end;

                        if QtyType = 1 then begin
                            SalesLine.UpdateBaseAmounts(NewAmount, Round(NewAmountIncludingVAT, Currency."Amount Rounding Precision"), NewVATBaseAmount);
                            SalesLine."Amount Including VAT (ACY)" := Round(NewAmountIncludingVATACY, Currency."Amount Rounding Precision");
                            SalesLine."VAT Base (ACY)" := NewVATBaseAmountACY;
                            SalesLine."Amount (ACY)" := NewAmountACY;
                        end;
                        SalesLine.InitOutstanding();
                        if SalesLine.Type = SalesLine.Type::"Charge (Item)" then
                            SalesLine.UpdateItemChargeAssgnt();
                        SalesLine.Modify();
                        LineWasModified := true;

                        if (SalesLine."Deferral Code" <> '') and (DeferralAmount <> SalesLine.GetDeferralAmount()) then
                            SalesLine.UpdateDeferralAmounts();

                        TempVATAmountLineRemainder."Amount Including VAT" :=
                          NewAmountIncludingVAT - Round(NewAmountIncludingVAT, Currency."Amount Rounding Precision");
                        TempVATAmountLineRemainder."VAT Amount" := VATAmount - NewAmountIncludingVAT + NewAmount;
                        TempVATAmountLineRemainder."VAT Difference" := VATDifference - SalesLine."VAT Difference";
                        TempVATAmountLineRemainder."Amount Including VAT (ACY)" :=
                            NewAmountIncludingVATACY - Round(NewAmountIncludingVATACY, Currency."Amount Rounding Precision");
                        TempVATAmountLineRemainder."VAT Amount (ACY)" := VATAmountACY - NewAmountIncludingVATACY + NewAmountACY;
                        TempVATAmountLineRemainder."VAT Difference (ACY)" := VATDifferenceACY - SalesLine."VAT Difference (ACY)";
                        TempVATAmountLineRemainder.Modify();
                    end;
                end;
            until SalesLine.Next() = 0;
        VATAmountLine.Reset();
        SalesLine.SetLoadFields();
        IsHandled := true;
    end;

    local procedure SetLoadFieldsForInvDiscoundCalculation(var SalesLine: Record "Sales Line")
    begin
        SalesLine.SetLoadFields(
            "Document Type", "Document No.", Type, "No.", "Shipment No.", "Return Receipt No.", "Deferral Code",
            Quantity, "Quantity (Base)", "Qty. to Invoice", "Qty. to Invoice (Base)", "Qty. Shipped Not Invoiced", "Qty. Shipped Not Invd. (Base)", "Ret. Qty. Rcd. Not Invd.(Base)", "Return Qty. Received (Base)",
            "Return Qty. Rcd. Not Invd.", "Qty. to Ship", "Qty. to Ship (Base)", "Return Qty. to Receive", "Return Qty. to Receive (Base)", "Return Qty. Received", "Outstanding Quantity", "Outstanding Qty. (Base)",
            "Quantity Invoiced", "Qty. Invoiced (Base)", "Quantity Shipped", "Qty. Shipped (Base)", "Qty. per Unit of Measure", "Reserved Quantity",
            "Unit Price", "Amount Including VAT", Amount, "Line Amount", "Inv. Discount Amount", "Inv. Disc. Amount to Invoice", "VAT Difference", "VAT Base Amount",
            "Outstanding Amount", "Outstanding Amount (LCY)", "Shipped Not Invoiced", "Shipped Not Invoiced (LCY)", "Return Rcd. Not Invd.", "Return Rcd. Not Invd. (LCY)",
            "System-Created Entry", "VAT Identifier", "VAT Calculation Type", "Tax Group Code", "VAT %", "Allow Invoice Disc.", "Prepayment Line", "Completely Shipped", Planned);
    end;

    local procedure FindVATAmountLine(var SalesLine: Record "Sales Line"; var VATAmountLine: Record "VAT Amount Line" temporary): Boolean
    begin
        VATAmountLine.Reset();
        VATAmountLine.SetRange("VAT Identifier", SalesLine."VAT Identifier");
        VATAmountLine.SetRange("VAT Calculation Type", SalesLine."VAT Calculation Type");
        VATAmountLine.SetRange("Tax Group Code", SalesLine."Tax Group Code");
        VATAmountLine.SetRange("Use Tax", false);
        VATAmountLine.SetRange(Positive, SalesLine."Line Amount" >= 0);
        VATAmountLine.SetRange("Full GST on Prepayment", SalesLine.GetFullGST());
        exit(VATAmountLine.FindFirst());
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnBeforeUpdatePrePaymentAmounts, '', false, false)]
    local procedure "Sales Line_OnBeforeUpdatePrePaymentAmounts"(var SalesLine: Record "Sales Line"; var IsHandled: Boolean)
    var
        ShipmentLine: Record "Sales Shipment Line";
        SalesOrderLine: Record "Sales Line";
        SalesOrderHeader: Record "Sales Header";
    begin
        if Currency.get(SalesLine."Currency Code") then;
        if not ShipmentLine.Get(SalesLine."Shipment No.", SalesLine."Shipment Line No.") then begin
            SalesLine."Prepmt Amt to Deduct" := 0;
            SalesLine."Prepmt VAT Diff. to Deduct" := 0;
        end else
            if SalesOrderLine.Get(SalesOrderLine."Document Type"::Order, ShipmentLine."Order No.", ShipmentLine."Order Line No.") then begin
                if (SalesLine."Prepayment %" = 100) and (SalesLine.Quantity <> SalesOrderLine.Quantity - SalesOrderLine."Quantity Invoiced") and (SalesOrderLine."Inv. Discount Amount" = 0) then
                    SalesLine."Prepmt Amt to Deduct" := SalesLine."Line Amount"
                else
                    SalesLine."Prepmt Amt to Deduct" :=
                      Round((SalesOrderLine."Prepmt. Amt. Inv." - SalesOrderLine."Prepmt Amt Deducted") *
                        SalesLine.Quantity / (SalesOrderLine.Quantity - SalesOrderLine."Quantity Invoiced"), Currency."Amount Rounding Precision");
                SalesLine."Prepmt VAT Diff. to Deduct" := SalesLine."Prepayment VAT Difference" - SalesLine."Prepmt VAT Diff. Deducted";
                SalesOrderHeader.Get(SalesOrderHeader."Document Type"::Order, SalesOrderLine."Document No.");
            end else begin
                SalesLine."Prepmt Amt to Deduct" := 0;
                SalesLine."Prepmt VAT Diff. to Deduct" := 0;
            end;

        SalesHeader.get(SalesLine."Document Type", SalesLine."Document No.");
        SalesHeader.TestField("Prices Including VAT", SalesOrderHeader."Prices Including VAT");
        if SalesHeader."Prices Including VAT" then begin
            SalesLine."Prepmt. Amt. Incl. VAT" := SalesLine."Prepmt Amt to Deduct";
            SalesLine."Prepayment Amount" :=
              Round(
                SalesLine."Prepmt Amt to Deduct" / (1 + (SalesLine."Prepayment VAT %" / 100)),
                Currency."Amount Rounding Precision");
        end else begin
            SalesLine."Prepmt. Amt. Incl. VAT" :=
              Round(
                SalesLine."Prepmt Amt to Deduct" * (1 + (SalesLine."Prepayment VAT %" / 100)),
                Currency."Amount Rounding Precision");
            SalesLine."Prepayment Amount" := SalesLine."Prepmt Amt to Deduct";
        end;
        SalesLine."Prepmt. Line Amount" := SalesLine."Prepmt Amt to Deduct";
        SalesLine."Prepmt. Amt. Inv." := SalesLine."Prepmt. Line Amount";
        SalesLine."Prepmt. VAT Base Amt." := SalesLine."Prepayment Amount";
        SalesLine."Prepmt. Amount Inv. Incl. VAT" := SalesLine."Prepmt. Amt. Incl. VAT";
        SalesLine."Prepmt Amt Deducted" := 0;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnBeforeUpdatePrepmtAmounts, '', false, false)]
    local procedure "Sales Line_OnBeforeUpdatePrepmtAmounts"(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header"; var IsHandled: Boolean; xSalesLine: Record "Sales Line"; FieldNo: Integer)
    var
        OutstandingAmountExclTax: Decimal;
        ShouldCalcPrepmtLineAmount: Boolean;
    begin
        if (SalesLine.Quantity <> 0) and (SalesLine."Outstanding Quantity" = 0) and (SalesLine."Qty. Shipped Not Invoiced" = 0) then
            if SalesHeader."Document Type" <> SalesHeader."Document Type"::Invoice then
                exit;

        if SalesHeader."Document Type" <> SalesHeader."Document Type"::Invoice then begin
            OutstandingAmountExclTax := SalesLine.CalculateOutstandingAmountExclTax();
            SalesLine."Prepayment VAT Difference" := 0;
            ShouldCalcPrepmtLineAmount := (not PrePaymentLineAmountEntered) and (not CalculateFullGST(SalesLine, SalesLine."Prepmt. Line Amount"));
            if ShouldCalcPrepmtLineAmount then begin
                IsHandled := false;
                if not IsHandled then begin
                    SalesLine."Prepmt. Line Amount" := Round((OutstandingAmountExclTax) * SalesLine."Prepayment %" / 100, Currency."Amount Rounding Precision");
                    SalesLine."Prepmt. Line Amount" := SalesLine."Prepmt. Line Amount" + SalesLine."Prepmt Amt Deducted";
                end;
            end;
            PrePaymentLineAmountEntered := false;
        end;
    end;

    local procedure CalculateFullGST(SalesLine: Record "Sales Line"; var PrepmtLineAmount: Decimal): Boolean
    var
        BaseAmount: Decimal;
    begin
        GLSetup.Get();
        if not GLSetup.CheckFullGSTonPrepayment(SalesLine."VAT Bus. Posting Group", SalesLine."VAT Prod. Posting Group") then
            exit(false);

        SalesLine.UpdateVATAmounts();
        if SalesLine."Prepayment %" <> 0 then begin
            if SalesHeader."Prices Including VAT" then
                BaseAmount := SalesLine.Amount
            else
                BaseAmount := SalesLine."Line Amount";
            PrepmtLineAmount :=
              Round(BaseAmount * SalesLine."Prepayment %" / 100, Currency."Amount Rounding Precision") +
              FullGSTAmount(SalesLine);
        end else
            PrepmtLineAmount := 0;
        exit(true);
    end;

    local procedure FullGSTAmount(SalesLine: Record "Sales Line"): Decimal
    begin
        SalesHeader.get(SalesLine."Document Type", SalesLine."Document No.");
        if SalesHeader."Prices Including VAT" then
            exit(SalesLine."Amount Including VAT" - SalesLine.Amount - SalesLine."Inv. Discount Amount");
        exit(0);
    end;


    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnAfterValidateLocationCode, '', false, false)]
    local procedure "Sales Line_OnAfterValidateLocationCode"(var SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line")
    begin
        CheckWMS(SalesLine);
    end;



    LOCAL procedure CheckWMS(SalesLine: Record "Sales Line")
    var
        DialogText: Text;
    begin
        DialogText := Text035;
        IF SalesLine."Quantity (Base)" <> 0 THEN
            CASE SalesLine."Document Type" OF
                SalesLine."Document Type"::Invoice:
                    IF SalesLine."Shipment No." = '' THEN
                        IF Location.GET(SalesLine."Location Code") AND Location."Directed Put-away and Pick" THEN BEGIN
                            DialogText += Location.GetRequirementText(Location.FIELDNO("Require Shipment"));
                            ERROR(Text016, DialogText, SalesLine.FIELDCAPTION("Line No."), SalesLine."Line No.");
                        END;
                SalesLine."Document Type"::"Credit Memo":
                    IF SalesLine."Return Receipt No." = '' THEN
                        IF Location.GET(SalesLine."Location Code") AND Location."Directed Put-away and Pick" THEN BEGIN
                            DialogText += Location.GetRequirementText(Location.FIELDNO("Require Receive"));
                            ERROR(Text016, DialogText, SalesLine.FIELDCAPTION("Line No."), SalesLine."Line No.");
                        END;
            END;
    end;

    var

        InvtSetup: Record "Inventory Setup";
        Location: Record Location;
        GLSetup: Record "General Ledger Setup";
        CurrExchRate: Record "Currency Exchange Rate";
        Currency: Record Currency;
        SalesHeader: Record "Sales Header";
        SalesWarehouseMgt: Codeunit "Sales Warehouse Mgt.";
        SalesLineReserve: Codeunit "Sales Line-Reserve";
        UOMMgt: Codeunit "Unit of Measure Management";
        PrePaymentLineAmountEntered: Boolean;
        Text009: Label 'must be 0 when %1 is %2';
        Text016: Label '%1 is required for %2 = %3.';
        Text031: Label 'You must either specify %1 or %2.';
        Text035: Label 'Warehouse';

}
