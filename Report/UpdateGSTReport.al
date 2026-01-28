report 50018 "Update GST Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Report/UpdateGSTReport.rdl';
    Permissions = TableData 28160 = rimd,
                  TableData 28161 = rimd;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem("VAT Entry"; "VAT Entry")
        {
            DataItemTableView = WHERE(Type = FILTER(Sale | Purchase));

            trigger OnAfterGetRecord()
            begin
                IF Type = Type::Purchase THEN BEGIN
                    IF "Document Type" = "Document Type"::Invoice THEN BEGIN
                        IF NOT PurchInvTemp.GET("Document No.") THEN BEGIN
                            PurchInvTemp.INIT;
                            PurchInvTemp."No." := "Document No.";
                            PurchInvTemp.INSERT;
                        END;
                    END;
                    IF "Document Type" = "Document Type"::"Credit Memo" THEN BEGIN
                        IF NOT PurchCrTemp.GET("Document No.") THEN BEGIN
                            PurchCrTemp.INIT;
                            PurchCrTemp."No." := "Document No.";
                            PurchCrTemp.INSERT;
                        END;
                    END;
                END ELSE
                    IF Type = Type::Sale THEN BEGIN
                        IF "Document Type" = "Document Type"::Invoice THEN BEGIN
                            IF NOT SalesInvTemp.GET("Document No.") THEN BEGIN
                                SalesInvTemp.INIT;
                                SalesInvTemp."No." := "Document No.";
                                SalesInvTemp.INSERT;
                            END;
                        END;
                        IF "Document Type" = "Document Type"::"Credit Memo" THEN BEGIN
                            IF NOT SalesCrTemp.GET("Document No.") THEN BEGIN
                                SalesCrTemp.INIT;
                                SalesCrTemp."No." := "Document No.";
                                SalesCrTemp.INSERT;
                            END;
                        END;
                    END;
            end;

            trigger OnPostDataItem()
            begin
                IF PurchInvTemp.FINDSET THEN
                    REPEAT
                        VATEntry.RESET;
                        VATEntry.SETRANGE(Type, VATEntry.Type::Purchase);
                        VATEntry.SETRANGE("Document Type", VATEntry."Document Type"::Invoice);
                        VATEntry.SETRANGE("Document No.", PurchInvTemp."No.");
                        VATEntry.FINDFIRST;
                        PurchInvHead.GET(PurchInvTemp."No.");
                        IF PurchInvHead."Currency Factor" = 0 THEN
                            PurchInvHead."Currency Factor" := 1;
                        PurchInvLine.SETRANGE("Document No.", PurchInvHead."No.");
                        IF PurchInvLine.FINDSET THEN
                            REPEAT
                                IF PurchInvLine.Amount <> 0 THEN
                                    InsertGSTReport1(VATEntry."Entry No.", PurchInvLine);
                            UNTIL PurchInvLine.NEXT = 0;
                    UNTIL PurchInvTemp.NEXT = 0;

                IF PurchCrTemp.FINDSET THEN
                    REPEAT
                        VATEntry.RESET;
                        VATEntry.SETRANGE(Type, VATEntry.Type::Purchase);
                        VATEntry.SETRANGE("Document Type", VATEntry."Document Type"::"Credit Memo");
                        VATEntry.SETRANGE("Document No.", PurchCrTemp."No.");
                        VATEntry.FINDFIRST;
                        PurchCrHead.GET(PurchCrTemp."No.");
                        IF PurchCrHead."Currency Factor" = 0 THEN
                            PurchCrHead."Currency Factor" := 1;
                        PurchCrLine.SETRANGE("Document No.", PurchCrHead."No.");
                        IF PurchCrLine.FINDSET THEN
                            REPEAT
                                IF PurchCrLine.Amount <> 0 THEN
                                    InsertGSTReport2(VATEntry."Entry No.", PurchCrLine);
                            UNTIL PurchCrLine.NEXT = 0;
                    UNTIL PurchCrTemp.NEXT = 0;

                IF SalesInvTemp.FINDSET THEN
                    REPEAT
                        VATEntry.RESET;
                        VATEntry.SETRANGE(Type, VATEntry.Type::Sale);
                        VATEntry.SETRANGE("Document Type", VATEntry."Document Type"::Invoice);
                        VATEntry.SETRANGE("Document No.", SalesInvTemp."No.");
                        VATEntry.FINDFIRST;
                        SalesInvHead.GET(SalesInvTemp."No.");
                        IF SalesInvHead."Currency Factor" = 0 THEN
                            SalesInvHead."Currency Factor" := 1;
                        SalesInvLine.SETRANGE("Document No.", SalesInvHead."No.");
                        IF SalesInvLine.FINDSET THEN
                            REPEAT
                                IF SalesInvLine.Amount <> 0 THEN
                                    InsertGSTReport3(VATEntry."Entry No.", SalesInvLine);
                            UNTIL SalesInvLine.NEXT = 0;
                    UNTIL SalesInvTemp.NEXT = 0;

                IF SalesCrTemp.FINDSET THEN
                    REPEAT
                        VATEntry.RESET;
                        VATEntry.SETRANGE(Type, VATEntry.Type::Sale);
                        VATEntry.SETRANGE("Document Type", VATEntry."Document Type"::"Credit Memo");
                        VATEntry.SETRANGE("Document No.", SalesCrTemp."No.");
                        VATEntry.FINDFIRST;
                        SalesCrHead.GET(SalesCrTemp."No.");
                        SalesCrLine.SETRANGE("Document No.", SalesCrHead."No.");
                        IF SalesCrHead."Currency Factor" = 0 THEN
                            SalesCrHead."Currency Factor" := 1;
                        IF SalesCrLine.FINDSET THEN
                            REPEAT
                                IF SalesCrLine.Amount <> 0 THEN
                                    InsertGSTReport4(VATEntry."Entry No.", SalesCrLine);
                            UNTIL SalesCrLine.NEXT = 0;
                    UNTIL SalesCrTemp.NEXT = 0;
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

    var
        Text28000: Label 'No Matching Document';
        PurchInvTemp: Record "Purch. Inv. Header" temporary;
        PurchCrTemp: Record "Purch. Cr. Memo Hdr." temporary;
        SalesInvTemp: Record "Sales Invoice Header" temporary;
        SalesCrTemp: Record "Sales Cr.Memo Header" temporary;
        PurchInvLine: Record "Purch. Inv. Line";
        PurchCrLine: Record "Purch. Cr. Memo Line";
        SalesInvLine: Record "Sales Invoice Line";
        SalesCrLine: Record "Sales Cr.Memo Line";
        PurchInvHead: Record "Purch. Inv. Header";
        PurchCrHead: Record "Purch. Cr. Memo Hdr.";
        SalesInvHead: Record "Sales Invoice Header";
        SalesCrHead: Record "Sales Cr.Memo Header";
        VATEntry: Record "VAT Entry";

    procedure InsertGSTReport(VATEntryNo: Integer; GenJnlLine2: Record "VAT Entry")
    var
        GSTSaleReport: Record "GST Sales Entry";
        GSTPurchReport: Record "GST Purchase Entry";
        EntryNo: Integer;
    begin
        //IF NOT GLSetup."GST Report" THEN
        //  EXIT;
        /*WITH GenJnlLine2 DO BEGIN
          //IF "System-Created Entry" THEN
          //  EXIT;
          IF "Type" = "Type"::Sale THEN BEGIN
            IF GSTSaleReport.FINDLAST THEN
              EntryNo := GSTSaleReport."Entry No." + 1
            ELSE
              EntryNo := 1;
        
            GSTSaleReport.INIT;
            GSTSaleReport."Entry No." := EntryNo;
            GSTSaleReport."GST Entry No." := VATEntryNo;
            GSTSaleReport."Posting Date" := "Posting Date";
            IF "Document Type" = "Document Type"::Invoice THEN
              GSTSaleReport."Document Type" := GSTSaleReport."Document Type"::Invoice;
            IF "Document Type" = "Document Type"::"Credit Memo" THEN
              GSTSaleReport."Document Type" := GSTSaleReport."Document Type"::"Credit Memo";
            IF "Document Type" = "Document Type"::Payment THEN
              GSTSaleReport."Document Type" := GSTSaleReport."Document Type"::Payment;
        
            GSTSaleReport."Document No." := "Document No.";
            //GSTSaleReport."Document Line No." := "Line No.";
            GSTSaleReport."Document Line Type" := GSTSaleReport."Document Line Type"::"G/L Account";
            GSTSaleReport."Document Line Description" := Text28000;
            GSTSaleReport."GST Entry Type" := GSTSaleReport."GST Entry Type"::Sale;
            GSTSaleReport."GST Base" := "VAT Base Amount (LCY)";
            GSTSaleReport.Amount := "VAT Amount (LCY)";
            GSTSaleReport."VAT Calculation Type" := "VAT Calculation Type";
            GSTSaleReport."VAT Bus. Posting Group" := "VAT Bus. Posting Group";
            GSTSaleReport."VAT Prod. Posting Group" := "VAT Prod. Posting Group";
            GSTSaleReport.INSERT;
          END ELSE
            IF "Gen. Posting Type" = "Gen. Posting Type"::Purchase THEN BEGIN
              IF GSTPurchReport.FINDLAST THEN
                EntryNo := GSTPurchReport."Entry No." + 1
              ELSE
                EntryNo := 1;
        
              GSTPurchReport.INIT;
              GSTPurchReport."Entry No." := EntryNo;
              GSTPurchReport."GST Entry No." := VATEntryNo;
              GSTPurchReport."Posting Date" := "Posting Date";
              IF "Document Type" = "Document Type"::Invoice THEN
                GSTPurchReport."Document Type" := GSTPurchReport."Document Type"::Invoice;
              IF "Document Type" = "Document Type"::"Credit Memo" THEN
                GSTPurchReport."Document Type" := GSTPurchReport."Document Type"::"Credit Memo";
              IF "Document Type" = "Document Type"::Payment THEN
                GSTPurchReport."Document Type" := GSTPurchReport."Document Type"::Payment;
        
              GSTPurchReport."Document No." := "Document No.";
              GSTPurchReport."Document Line No." := "Line No.";
              GSTPurchReport."Document Line Type" := GSTPurchReport."Document Line Type"::"G/L Account";
              GSTPurchReport."Document Line Description" := Text28000;
              GSTPurchReport."GST Entry Type" := GSTPurchReport."GST Entry Type"::Purchase;
              GSTPurchReport."GST Base" := "VAT Base Amount (LCY)";
              GSTPurchReport.Amount := "VAT Amount (LCY)";
              GSTPurchReport."VAT Calculation Type" := "VAT Calculation Type";
              GSTPurchReport."VAT Bus. Posting Group" := "VAT Bus. Posting Group";
              GSTPurchReport."VAT Prod. Posting Group" := "VAT Prod. Posting Group";
              GSTPurchReport.INSERT;
            END;
        END;*/

    end;

    procedure InsertGSTReport1(VATEntryNo: Integer; PurchInvLine2: Record "Purch. Inv. Line")
    var
        GSTSaleReport: Record "GST Sales Entry";
        GSTPurchReport: Record "GST Purchase Entry";
        EntryNo: Integer;
    begin
        WITH PurchInvLine2 DO BEGIN
            IF GSTPurchReport.FINDLAST THEN
                EntryNo := GSTPurchReport."Entry No." + 1
            ELSE
                EntryNo := 1;

            GSTPurchReport.INIT;
            GSTPurchReport."Entry No." := EntryNo;
            GSTPurchReport."GST Entry No." := VATEntryNo;
            GSTPurchReport."Posting Date" := PurchInvHead."Posting Date";
            //IF "Document Type" = "Document Type"::Invoice THEN
            GSTPurchReport."Document Type" := GSTPurchReport."Document Type"::Invoice;
            //IF "Document Type" = "Document Type"::"Credit Memo" THEN
            //  GSTPurchReport."Document Type" := GSTPurchReport."Document Type"::"Credit Memo";
            //IF "Document Type" = "Document Type"::Payment THEN
            //  GSTPurchReport."Document Type" := GSTPurchReport."Document Type"::Payment;

            GSTPurchReport."Document No." := "Document No.";
            GSTPurchReport."Document Line No." := "Line No.";
            GSTPurchReport."Document Line Type" := Type;
            GSTPurchReport."Document Line Description" := Description;
            GSTPurchReport."Document Line Code" := "No.";
            GSTPurchReport."Vendor No." := PurchInvHead."Pay-to Vendor No.";
            GSTPurchReport."Vendor Name" := PurchInvHead."Pay-to Name";
            GSTPurchReport."GST Entry Type" := GSTPurchReport."GST Entry Type"::Purchase;
            GSTPurchReport."GST Base" := ROUND(Amount * PurchInvHead."Currency Factor", 0.01);
            GSTPurchReport.Amount := ROUND(("Amount Including VAT" - Amount) * PurchInvHead."Currency Factor", 0.01);
            GSTPurchReport."VAT Calculation Type" := "VAT Calculation Type";
            GSTPurchReport."VAT Bus. Posting Group" := "VAT Bus. Posting Group";
            GSTPurchReport."VAT Prod. Posting Group" := "VAT Prod. Posting Group";
            GSTPurchReport.INSERT;
        END;
    end;

    procedure InsertGSTReport2(VATEntryNo: Integer; PurchInvLine2: Record "Purch. Cr. Memo Line")
    var
        GSTSaleReport: Record "GST Sales Entry";
        GSTPurchReport: Record "GST Purchase Entry";
        EntryNo: Integer;
    begin
        WITH PurchInvLine2 DO BEGIN
            IF GSTPurchReport.FINDLAST THEN
                EntryNo := GSTPurchReport."Entry No." + 1
            ELSE
                EntryNo := 1;

            GSTPurchReport.INIT;
            GSTPurchReport."Entry No." := EntryNo;
            GSTPurchReport."GST Entry No." := VATEntryNo;
            GSTPurchReport."Posting Date" := PurchCrHead."Posting Date";
            //IF "Document Type" = "Document Type"::Invoice THEN
            //  GSTPurchReport."Document Type" := GSTPurchReport."Document Type"::Invoice;
            //IF "Document Type" = "Document Type"::"Credit Memo" THEN
            GSTPurchReport."Document Type" := GSTPurchReport."Document Type"::"Credit Memo";
            //IF "Document Type" = "Document Type"::Payment THEN
            //  GSTPurchReport."Document Type" := GSTPurchReport."Document Type"::Payment;

            GSTPurchReport."Document No." := "Document No.";
            GSTPurchReport."Document Line No." := "Line No.";
            GSTPurchReport."Document Line Type" := Type;
            GSTPurchReport."Document Line Code" := "No.";
            GSTPurchReport."Vendor No." := PurchCrHead."Pay-to Vendor No.";
            GSTPurchReport."Vendor Name" := PurchCrHead."Pay-to Name";
            GSTPurchReport."Document Line Description" := Description;
            GSTPurchReport."GST Entry Type" := GSTPurchReport."GST Entry Type"::Purchase;
            GSTPurchReport."GST Base" := -ROUND(Amount * PurchCrHead."Currency Factor", 0.01);
            GSTPurchReport.Amount := -ROUND(("Amount Including VAT" - Amount) * PurchCrHead."Currency Factor", 0.01);
            GSTPurchReport."VAT Calculation Type" := "VAT Calculation Type";
            GSTPurchReport."VAT Bus. Posting Group" := "VAT Bus. Posting Group";
            GSTPurchReport."VAT Prod. Posting Group" := "VAT Prod. Posting Group";
            GSTPurchReport.INSERT;
        END;
    end;

    procedure InsertGSTReport3(VATEntryNo: Integer; PurchInvLine2: Record "Sales Invoice Line")
    var
        GSTPurchReport: Record "GST Sales Entry";
        EntryNo: Integer;
    begin
        WITH PurchInvLine2 DO BEGIN
            IF GSTPurchReport.FINDLAST THEN
                EntryNo := GSTPurchReport."Entry No." + 1
            ELSE
                EntryNo := 1;

            GSTPurchReport.INIT;
            GSTPurchReport."Entry No." := EntryNo;
            GSTPurchReport."GST Entry No." := VATEntryNo;
            GSTPurchReport."Posting Date" := SalesInvHead."Posting Date";
            //IF "Document Type" = "Document Type"::Invoice THEN
            GSTPurchReport."Document Type" := GSTPurchReport."Document Type"::Invoice;
            //IF "Document Type" = "Document Type"::"Credit Memo" THEN
            //  GSTPurchReport."Document Type" := GSTPurchReport."Document Type"::"Credit Memo";
            //IF "Document Type" = "Document Type"::Payment THEN
            //  GSTPurchReport."Document Type" := GSTPurchReport."Document Type"::Payment;

            GSTPurchReport."Document No." := "Document No.";
            GSTPurchReport."Document Line No." := "Line No.";
            GSTPurchReport."Document Line Type" := Type;
            GSTPurchReport."Document Line Description" := Description;
            GSTPurchReport."Document Line Code" := "No.";
            GSTPurchReport."Customer No." := SalesInvHead."Bill-to Customer No.";
            GSTPurchReport."Customer Name" := SalesInvHead."Bill-to Name";
            GSTPurchReport."GST Entry Type" := GSTPurchReport."GST Entry Type"::Purchase;
            GSTPurchReport."GST Base" := ROUND(Amount * SalesInvHead."Currency Factor", 0.01);
            GSTPurchReport.Amount := ROUND(("Amount Including VAT" - Amount) * SalesInvHead."Currency Factor", 0.01);
            GSTPurchReport."VAT Calculation Type" := "VAT Calculation Type";
            GSTPurchReport."VAT Bus. Posting Group" := "VAT Bus. Posting Group";
            GSTPurchReport."VAT Prod. Posting Group" := "VAT Prod. Posting Group";
            GSTPurchReport.INSERT;
        END;
    end;

    procedure InsertGSTReport4(VATEntryNo: Integer; PurchInvLine2: Record "Sales Cr.Memo Line")
    var
        GSTPurchReport: Record "GST Sales Entry";
        EntryNo: Integer;
    begin
        WITH PurchInvLine2 DO BEGIN
            IF GSTPurchReport.FINDLAST THEN
                EntryNo := GSTPurchReport."Entry No." + 1
            ELSE
                EntryNo := 1;

            GSTPurchReport.INIT;
            GSTPurchReport."Entry No." := EntryNo;
            GSTPurchReport."GST Entry No." := VATEntryNo;
            GSTPurchReport."Posting Date" := SalesCrHead."Posting Date";
            //IF "Document Type" = "Document Type"::Invoice THEN
            //GSTPurchReport."Document Type" := GSTPurchReport."Document Type"::Invoice;
            //IF "Document Type" = "Document Type"::"Credit Memo" THEN
            GSTPurchReport."Document Type" := GSTPurchReport."Document Type"::"Credit Memo";
            //IF "Document Type" = "Document Type"::Payment THEN
            //  GSTPurchReport."Document Type" := GSTPurchReport."Document Type"::Payment;

            GSTPurchReport."Document No." := "Document No.";
            GSTPurchReport."Document Line No." := "Line No.";
            GSTPurchReport."Document Line Type" := Type;
            GSTPurchReport."Document Line Description" := Description;
            GSTPurchReport."Document Line Code" := "No.";
            GSTPurchReport."Customer No." := SalesCrHead."Bill-to Customer No.";
            GSTPurchReport."Customer Name" := SalesCrHead."Bill-to Name";
            GSTPurchReport."GST Entry Type" := GSTPurchReport."GST Entry Type"::Purchase;
            GSTPurchReport."GST Base" := ROUND(Amount * SalesCrHead."Currency Factor", 0.01);
            GSTPurchReport.Amount := ROUND(("Amount Including VAT" - Amount) * SalesCrHead."Currency Factor", 0.01);
            GSTPurchReport."VAT Calculation Type" := "VAT Calculation Type";
            GSTPurchReport."VAT Bus. Posting Group" := "VAT Bus. Posting Group";
            GSTPurchReport."VAT Prod. Posting Group" := "VAT Prod. Posting Group";
            GSTPurchReport.INSERT;
        END;
    end;
}

