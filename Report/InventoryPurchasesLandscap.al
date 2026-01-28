report 50052 "Inventory - Purchases Landscap"
{
    // Austral Sugeevan 13/11/2014 >>> Designed this Report same as Kelly Inventory Purchase Costing Report
    // Austral Sugeevan 18/11/2015 >>> Removed Storage column and added Unit Price Column and Unit Price Mods
    // Austral Sugeevan 19/11/2015 >>> Removed Warranty column and added Cost Per Unit Column and Cost Per Unit Mods
    // Austral Sugeevan 09/12/2015 >>> Redesined this Report on Total Shipment Cost Issue
    DefaultLayout = RDLC;
    RDLCLayout = 'Report/InventoryPurchasesLandscap.rdl';
    ApplicationArea = all;
    Caption = 'Inventory - Purchases Costing';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Item; Item)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "No. 2", "Search Description", "Inventory Posting Group";
            column(PeriodText__; STRSUBSTNO(Text000, PeriodText))
            {
            }
            column(COMPANYNAME__; COMPANYNAME)
            {
            }
            column(Today__; FORMAT(TODAY, 0, 4))
            {
            }
            column(USERID__; USERID)
            {
            }
            column(ItemFilter__; STRSUBSTNO('%1: %2', Item.TABLECAPTION, ItemFilter))
            {
            }
            column(ItemLedgerEntryFilter__; STRSUBSTNO('%1: %2', "Value Entry".TABLECAPTION, ItemLedgEntryFilter))
            {
            }
            column(Item_No__; "No.")
            {
            }
            dataitem("Item Ledger Entry"; "Item Ledger Entry")
            {
                DataItemLink = "Item No." = FIELD("No.");
                DataItemTableView = SORTING("Item No.", "Posting Date")
                                    WHERE("Entry Type" = CONST(Purchase));
                RequestFilterFields = "Document No.", "External Document No.";
                column(ItemNo_ItemLedgerEntry; "Item No.")
                {
                }
                column(PostingDate_ItemLedgerEntry; "Posting Date")
                {
                }
                column(InvoicedQuantity_ItemLedgerEntry; "Invoiced Quantity")
                {
                }
                column(ItemLedgerEntry_EntryNo__; "Entry No.")
                {
                }
                column(Item_Description__; Item.Description)
                {
                } /* column(Item_Description__; Item."Location Filter")
                {
                } */
                dataitem("Value Entry"; "Value Entry")
                {
                    DataItemLink = "Item Ledger Entry No." = FIELD("Entry No.");
                    DataItemTableView = SORTING("Source Type", "Source No.", "Item No.", "Item Charge No.")
                                        WHERE("Source Type" = CONST(Vendor),
                                              "Expected Cost" = CONST(false));
                    RequestFilterFields = "Posting Date", "Source No.", "Source Posting Group";
                    column(TotShipment__; TotShipment)
                    {
                    }
                    column(TotStandard__; TotStandard)
                    {
                    }
                    column(DecTotalShpment__; DecTotalShpment)
                    {
                    }
                    column(DecTotalStandard__; DecTotalStandard)
                    {
                    }
                    column(Expec_Cost__; "Expected Cost")
                    {
                    }
                    column(UnitPrice__; UnitPrice)
                    {
                    }
                    column(CostPerUnit_ValueEntry__; ValueEntry."Cost per Unit")
                    {
                    }
                    column(TotdecDuty__; TotdecDuty)
                    {
                    }
                    column(TotdecFreight__; TotdecFreight)
                    {
                    }
                    column(TotdecCUSTOMS__; TotdecCUSTOMS)
                    {
                    }
                    column(TotdecTotal__; TotdecTotal)
                    {
                    }
                    column(TotdecArtwork__; TotdecArtwork)
                    {
                    }
                    column(TotdecQA__; TotdecQA)
                    {
                    }
                    column(GrandTotdecTotal__; GrandTotdecTotal)
                    {
                    }
                    column(GrandTotdecFreight__; GrandTotdecFreight)
                    {
                    }
                    column(GrandTotdecDuty__; GrandTotdecDuty)
                    {
                    }
                    column(GrandTotdecCUSTOMS__; GrandTotdecCUSTOMS)
                    {
                    }
                    column(GrandTotdecArtwork__; GrandTotdecArtwork)
                    {
                    }
                    column(GrandTotdecQA__; GrandTotdecQA)
                    {
                    }
                    column(InvoicedQty__; InvoicedQty)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        ValueEntryCount += 1;

                        IF ISSERVICETIER THEN
                            IF NOT Vend.GET("Source No.") THEN
                                CLEAR(Vend);

                        IF ("Item Charge No." = '') THEN BEGIN
                            IF RecPostedInvoice.GET("Document No.") THEN BEGIN
                                decExRate := RecPostedInvoice."Currency Factor";
                                cCurrCode := RecPostedInvoice."Currency Code";
                            END;
                        END;

                        CASE "Item Charge No." OF
                            'DUTY':
                                BEGIN
                                    decDuty += "Cost Amount (Actual)";
                                    TotdecDuty += "Cost Amount (Actual)";
                                END;
                            'FREIGHT-IN':
                                BEGIN
                                    decFreight += "Cost Amount (Actual)";
                                    TotdecFreight += "Cost Amount (Actual)";
                                END;
                            'CLEARING':
                                BEGIN
                                    decCUSTOMS += "Cost Amount (Actual)";
                                    TotdecCUSTOMS += "Cost Amount (Actual)";
                                END;
                            'FREIGHT-INT':
                                BEGIN
                                    decArtwork += "Cost Amount (Actual)";
                                    TotdecArtwork += "Cost Amount (Actual)";
                                END;
                            'PACKAGING':
                                BEGIN
                                    decQA += "Cost Amount (Actual)";
                                    TotdecQA += "Cost Amount (Actual)";
                                END;
                            'WARRANTY':
                                BEGIN
                                    decWarranty += "Cost Amount (Actual)";
                                    TotdecWarranty += "Cost Amount (Actual)";
                                END;
                            'STORAGE':
                                BEGIN
                                    decStor += "Cost Amount (Actual)";
                                    TotdecStor += "Cost Amount (Actual)";
                                END;
                            '':
                                IF "Cost Amount (Actual)" > 0 THEN
                                    IF Item."Costing Method" = Item."Costing Method"::Standard THEN BEGIN
                                        IF "Value Entry"."Entry Type" = "Value Entry"."Entry Type"::"Direct Cost" THEN BEGIN
                                            decTotal += "Cost Amount (Actual)";
                                            TotdecTotal += "Cost Amount (Actual)";
                                        END;
                                    END ELSE BEGIN
                                        decTotal += "Cost Amount (Actual)";
                                        TotdecTotal += "Cost Amount (Actual)";
                                    END;
                        END;

                        IF ValueEntryCount = COUNT THEN BEGIN
                            DecTotalShpment += decTotal + decDuty + decFreight + decCUSTOMS + decArtwork + decWarranty + decQA + decStor;
                            TotShipment += decTotal + decDuty + decFreight + decCUSTOMS + decArtwork + decWarranty + decQA + decStor;
                            //Austral Sugeevan 18/11/2015 >>>
                            IF InvoicedQty <> 0 THEN
                                UnitPrice := DecTotalShpment / InvoicedQty;
                            //Austral Sugeevan 18/11/2015 <<<
                            IF RVItem.GET("Item Ledger Entry"."Item No.") THEN
                                IF RVItem."Costing Method" = RVItem."Costing Method"::Standard THEN BEGIN
                                    DecTotalStandard += InvoicedQty * RVItem."Unit Cost";
                                    TotStandard += InvoicedQty * RVItem."Unit Cost";
                                END ELSE
                                    IF RVItem."Costing Method" = RVItem."Costing Method"::Average THEN BEGIN
                                        CLEAR(QTY);
                                        CLEAR(CostAmount);
                                        ILE.RESET;
                                        ILE.SETFILTER(ILE."Posting Date", '%1..%2', 0D, "Item Ledger Entry"."Posting Date");
                                        ILE.SETRANGE(ILE."Item No.", "Item Ledger Entry"."Item No.");
                                        IF ILE.FIND('-') THEN
                                            REPEAT
                                                ILE.CALCFIELDS("Cost Amount (Actual)");

                                                QTY += ILE.Quantity;
                                                CostAmount += ILE."Cost Amount (Actual)";
                                            UNTIL ILE.NEXT = 0;
                                        IF (QTY <> 0) THEN BEGIN
                                            DecTotalStandard += (CostAmount / QTY) * InvoicedQty;
                                            TotStandard += (CostAmount / QTY) * InvoicedQty;
                                        END;
                                    END;
                            GrandTotdecTotal += decTotal;
                            GrandTotdecDuty += decDuty;
                            GrandTotdecFreight += decFreight;
                            GrandTotdecCUSTOMS += decCUSTOMS;
                            GrandTotdecArtwork += decArtwork;
                            GrandTotdecQA += decQA;
                            ValueEntryCount := 0;
                        END;
                    end;

                    trigger OnPreDataItem()
                    var
                        ItemLedEntry: Record "Item Ledger Entry";
                    begin
                        CLEAR(decDuty);
                        CLEAR(decFreight);
                        CLEAR(decCUSTOMS);
                        CLEAR(decTotal);
                        CLEAR(decArtwork);
                        CLEAR(decQA);
                        CLEAR(decWarranty);
                        CLEAR(decStor);

                        //Austral Sugeevan 19/11/2015 >>>
                        CLEAR(ValueEntry);
                        ItemLedEntry.SETCURRENTKEY("Item No.", "Posting Date");
                        ItemLedEntry.SETRANGE("Item No.", "Item Ledger Entry"."Item No.");
                        ItemLedEntry.SETFILTER("Posting Date", '<%1', "Item Ledger Entry"."Posting Date");
                        ItemLedEntry.SETRANGE("Entry Type", "Item Ledger Entry"."Entry Type");
                        IF ItemLedEntry.FINDLAST THEN BEGIN
                            ValueEntry.SETRANGE("Item Ledger Entry No.", ItemLedEntry."Entry No.");
                            ValueEntry.SETRANGE("Entry Type", ValueEntry."Entry Type"::"Direct Cost");
                            ValueEntry.SETRANGE("Item Charge No.", '');
                            IF ValueEntry.FINDFIRST THEN;
                        END;
                        //Austral Sugeevan 19/11/2015 <<<

                        InvoicedQty += "Item Ledger Entry"."Invoiced Quantity";
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    VE.RESET;
                    VE.SETRANGE(VE."Item Ledger Entry No.", "Item Ledger Entry"."Entry No.");
                    VE.SETRANGE(VE."Entry Type", VE."Entry Type"::"Direct Cost");
                    //VE.SETRANGE(VE."Item Charge No.",'');
                    IF VE.FIND('-') THEN
                        REPEAT
                            ActualCost += VE."Cost Amount (Actual)";
                        UNTIL VE.NEXT = 0;

                    //On Pre Section >>>
                    /*CLEAR(DecTotalShpment);
                    CLEAR(DecTotalStandard);
                    CLEAR(QTY);
                    CLEAR( CostAmount);
                    //ILE.CALCFIELDS("Cost Amount (Actual)");
                    
                    DecTotalShpment :=  decTotal + decDuty + decFreight + decCUSTOMS + decArtwork + decWarranty+decQA+decStor;
                    IF RVItem.GET("Item Ledger Entry"."Item No.") THEN
                       IF RVItem."Costing Method" =  RVItem."Costing Method" :: Standard THEN
                           DecTotalStandard := "Item Ledger Entry"."Invoiced Quantity" *
                                               RVItem."Unit Cost"
                       ELSE IF RVItem."Costing Method" =  RVItem."Costing Method" :: Average THEN
                         BEGIN
                           ILE.RESET;
                           ILE.SETFILTER(ILE."Posting Date",'%1..%2',0D,"Item Ledger Entry"."Posting Date");
                           ILE.SETRANGE(ILE."Item No.","Item Ledger Entry"."Item No.") ;
                           IF ILE.FIND('-') THEN
                             REPEAT
                              ILE.CALCFIELDS("Cost Amount (Actual)");
                    
                               QTY+=ILE.Quantity;
                               CostAmount+=ILE."Cost Amount (Actual)";
                             UNTIL ILE.NEXT = 0;
                             IF (QTY <> 0) THEN
                               DecTotalStandard := (CostAmount/QTY) *"Item Ledger Entry"."Invoiced Quantity"
                             ELSE
                               DecTotalStandard := 0;
                         END;
                      TotShipment += DecTotalShpment;
                      TotStandard += DecTotalStandard;*/
                    //On Pre Section <<<

                end;

                trigger OnPreDataItem()
                begin
                    CurrReport.CREATETOTALS("Value Entry"."Cost Amount (Actual)", "Value Entry"."Discount Amount", "Invoiced Quantity");

                    CLEAR(TotdecDuty);
                    CLEAR(TotdecFreight);
                    CLEAR(TotdecCUSTOMS);
                    CLEAR(TotdecTotal);
                    CLEAR(TotdecArtwork);
                    CLEAR(TotdecQA);
                    CLEAR(TotdecWarranty);
                    CLEAR(TotdecStor);
                    CLEAR(InvoicedQty);
                    CLEAR(DecTotalShpment);
                    CLEAR(DecTotalStandard);
                    //Austral Sugeevan 18/11/2015 >>>
                    CLEAR(UnitPrice);
                    //Austral Sugeevan 18/11/2015 <<<
                end;
            }

            trigger OnPreDataItem()
            begin
                CurrReport.CREATETOTALS("Value Entry"."Cost Amount (Actual)", "Value Entry"."Discount Amount");
            end;
        }
    }
    requestpage
    {

        layout
        {
        }
        actions
        {
        }
    }
    labels
    {
    }

    trigger OnPreReport()
    begin
        ItemFilter := Item.GETFILTERS;
        ItemLedgEntryFilter := "Item Ledger Entry".GETFILTERS;
        PeriodText := "Value Entry".GETFILTER("Posting Date");
    end;

    var
        Vend: Record Vendor;
        PeriodText: Text[30];
        ItemFilter: Text[250];
        ItemLedgEntryFilter: Text[250];
        decLandedCost: Decimal;
        RecPostedInvoice: Record "Purch. Inv. Header";
        decExRate: Decimal;
        cCurrCode: Code[10];
        VE: Record "Value Entry";
        ActualCost: Decimal;
        ILE: Record "Item Ledger Entry";
        VE1: Record "Value Entry";
        DecTotalShpment: Decimal;
        DecTotalStandard: Decimal;
        RVItem: Record Item;
        QTY: Decimal;
        CostAmount: Decimal;
        TotShipment: Decimal;
        TotStandard: Decimal;
        Text000: Label 'Period: %1';
        ValueEntryCount: Integer;
        UnitPrice: Decimal;
        ValueEntry: Record "Value Entry";
        TotdecDuty: Decimal;
        TotdecFreight: Decimal;
        TotdecCUSTOMS: Decimal;
        TotdecTotal: Decimal;
        TotdecArtwork: Decimal;
        TotdecQA: Decimal;
        InvoicedQty: Decimal;
        TotdecWarranty: Decimal;
        TotdecStor: Decimal;
        GrandTotdecDuty: Decimal;
        GrandTotdecFreight: Decimal;
        GrandTotdecCUSTOMS: Decimal;
        GrandTotdecTotal: Decimal;
        GrandTotdecArtwork: Decimal;
        GrandTotdecQA: Decimal;
        decDuty: Decimal;
        decFreight: Decimal;
        decCUSTOMS: Decimal;
        decTotal: Decimal;
        decArtwork: Decimal;
        decQA: Decimal;
        decWarranty: Decimal;
        decStor: Decimal;
}

