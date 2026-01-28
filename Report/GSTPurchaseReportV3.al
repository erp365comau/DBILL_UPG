report 50038 "GST Purchase Report v3"
{
    // Austral Sugeevan 24/11/2014 >>> Added a new Column in RTC Design and Excel - VAT Registration No.
    // J13839 20200110 LK - ADD VENDOR INV NO AND DOC DATE
    DefaultLayout = RDLC;
    RDLCLayout = 'Report/GSTPurchaseReportv3.rdl';
    Caption = 'GST Purchase Report v3';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("GST Purchase Entry"; "GST Purchase Entry")
        {
            DataItemTableView = SORTING("Entry No.")
                                WHERE("GST Entry No." = FILTER(<> 0));
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
            }
            column(FORMAT_EndDate_0_4_; FORMAT(EndDate, 0, 4))
            {
            }
            column(FORMAT_StartDate_0_4_; FORMAT(StartDate, 0, 4))
            {
            }
            /* column(ExportToExcel; ExportToExcel)
            {
            } */
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(USERID; USERID)
            {
            }
            column(GST_Purchase_Entry__Posting_Date_; FORMAT("Posting Date"))
            {
            }
            column(GST_Purchase_Entry__Document_No__; "Document No.")
            {
            }
            column(GST_Purchase_Entry__Document_Type_; "Document Type")
            {
            }
            column(GST_Purchase_Entry__Vendor_No__; "Vendor No.")
            {
            }
            column(VendorInvoiceNo; VendorInvoiceNo)
            {
            }
            column(DocumentDate; DocumentDate)
            {
            }
            column(GST_Purchase_Entry__Vendor_Name_; "Vendor Name")
            {
            }
            column(GST_Purchase_Entry__Document_Line_Code_; "Document Line Code")
            {
            }
            column(LineTotal; LineTotal)
            {
            }
            column(GST_Purchase_Entry_Amount; Amount)
            {
            }
            column(GST_Purchase_Entry__GST_Base_; "GST Base")
            {
            }
            column(GSTPercent; GSTPercent)
            {
            }
            column(GST_Purchase_Entry__VAT_Prod__Posting_Group_; "VAT Prod. Posting Group")
            {
            }
            column(GST_Purchase_Entry__VAT_Bus__Posting_Group_; "VAT Bus. Posting Group")
            {
            }
            column(GST_Purchase_Entry__Document_Line_Description_; "Document Line Description")
            {
            }
            column(BaseTotal; BaseTotal)
            {
            }
            column(AmountTotal; AmountTotal)
            {
            }
            column(LinesTotal; LinesTotal)
            {
            }
            column(GST_Purchase_Entry_Entry_No_; "Entry No.")
            {
            }
            column(GST_Purchase_Entry__Posting_Date_Caption; GST_Purchase_Entry__Posting_Date_CaptionLbl)
            {
            }
            column(GST_Purchase_Entry__Document_No__Caption; FIELDCAPTION("Document No."))
            {
            }
            column(GST_Purchase_Entry__Document_Type_Caption; FIELDCAPTION("Document Type"))
            {
            }
            column(GST_Purchase_Entry__Vendor_No__Caption; FIELDCAPTION("Vendor No."))
            {
            }
            column(GST_Purchase_Entry__Vendor_Name_Caption; FIELDCAPTION("Vendor Name"))
            {
            }
            column(GST_Purchase_ReportCaption; GST_Purchase_ReportCaptionLbl)
            {
            }
            column(Report_CreatedCaption; Report_CreatedCaptionLbl)
            {
            }
            column(CompanyCaption; CompanyCaptionLbl)
            {
            }
            column(Start_DateCaption; Start_DateCaptionLbl)
            {
            }
            column(End_DateCaption; End_DateCaptionLbl)
            {
            }
            column(UserCaption; UserCaptionLbl)
            {
            }
            column(GST_Bus__Posting_GroupCaption; GST_Bus__Posting_GroupCaptionLbl)
            {
            }
            column(GST_Prod__Posting_GroupCaption; GST_Prod__Posting_GroupCaptionLbl)
            {
            }
            column(GST__Caption; GST__CaptionLbl)
            {
            }
            column(GST_BaseCaption; GST_BaseCaptionLbl)
            {
            }
            column(GST_AmountCaption; GST_AmountCaptionLbl)
            {
            }
            column(Total_PurchaseCaption; Total_PurchaseCaptionLbl)
            {
            }
            column(CodeCaption; CodeCaptionLbl)
            {
            }
            column(DescriptionCaption; DescriptionCaptionLbl)
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            column(Vendor_VATRegistrationNo__; Vendor."VAT Registration No.")
            {
            }
            column(VATRegistrationNoCaption__; VATRegistrationNoCaption)
            {
            }

            trigger OnAfterGetRecord()
            begin
                AmountTotal := AmountTotal + Amount;
                BaseTotal := BaseTotal + "GST Base";

                IF "GST Base" <> 0 THEN
                    GSTPercent := FORMAT(Amount / "GST Base" * 100, 0, '<Precision,2:><Standard Format,0>')
                ELSE
                    GSTPercent := '';

                LineTotal := Amount + "GST Base";

                //Austral Sugeevan 24/11/2014 >>>
                CLEAR(Vendor);
                IF Vendor.GET("Vendor No.") THEN;
                //Austral Sugeevan 24/11/2014 <<<
                //J13839---------------------------->>>
                CLEAR(VendorInvoiceNo);
                CLEAR(DocumentDate);
                IF "GST Purchase Entry"."Document Type" = "GST Purchase Entry"."Document Type"::Invoice THEN BEGIN
                    PuchInvHeader.RESET;
                    IF PuchInvHeader.GET("GST Purchase Entry"."Document No.") THEN BEGIN
                        VendorInvoiceNo := PuchInvHeader."Vendor Invoice No.";
                        DocumentDate := PuchInvHeader."Document Date";
                    END;
                END;
                //J13839----------------------------<<<

                /* IF ExportToExcel THEN BEGIN
                    RowNo := RowNo + 1;
                    ColumnNo := 1;
                    EnterCell(FORMAT("Posting Date"), FALSE, FALSE, FALSE, TempExcelBuffer."Cell Type"::Date);

                    ColumnNo := ColumnNo + 1;
                    EnterCell("Document No.", FALSE, FALSE, FALSE, TempExcelBuffer."Cell Type"::Text);

                    ColumnNo := ColumnNo + 1;
                    EnterCell(FORMAT("Document Type"), FALSE, FALSE, FALSE, TempExcelBuffer."Cell Type"::Text);

                    ColumnNo := ColumnNo + 1;
                    EnterCell("Vendor No.", FALSE, FALSE, FALSE, TempExcelBuffer."Cell Type"::Text);

                    //J13839------------------------>>>
                    ColumnNo := ColumnNo + 1;
                    EnterCell(VendorInvoiceNo, FALSE, FALSE, FALSE, TempExcelBuffer."Cell Type"::Text);

                    ColumnNo := ColumnNo + 1;
                    EnterCell(FORMAT(DocumentDate), FALSE, FALSE, FALSE, TempExcelBuffer."Cell Type"::Date);
                    //J13839------------------------<<<
                    //Austral Sugeevan 24/11/2014 >>>
                    ColumnNo := ColumnNo + 1;
                    EnterCell(Vendor."VAT Registration No.", FALSE, FALSE, FALSE, TempExcelBuffer."Cell Type"::Text);
                    //Austral Sugeevan 24/11/2014 <<<

                    ColumnNo := ColumnNo + 1;
                    EnterCell("Vendor Name", FALSE, FALSE, FALSE, TempExcelBuffer."Cell Type"::Text);

                    ColumnNo := ColumnNo + 1;
                    EnterCell("Document Line Description", FALSE, FALSE, FALSE, TempExcelBuffer."Cell Type"::Text);

                    ColumnNo := ColumnNo + 1;
                    EnterCell("VAT Bus. Posting Group", FALSE, FALSE, FALSE, TempExcelBuffer."Cell Type"::Text);

                    ColumnNo := ColumnNo + 1;
                    EnterCell("VAT Prod. Posting Group", FALSE, FALSE, FALSE, TempExcelBuffer."Cell Type"::Text);

                    ColumnNo := ColumnNo + 1;
                    EnterCell(GSTPercent, FALSE, FALSE, FALSE, TempExcelBuffer."Cell Type"::Number);

                    ColumnNo := ColumnNo + 1;
                    EnterCell(FORMAT("GST Base", 0, '<Precision,2:><Standard Format,0>'), FALSE, FALSE, FALSE, TempExcelBuffer."Cell Type"::Number);

                    ColumnNo := ColumnNo + 1;
                    EnterCell(FORMAT(Amount, 0, '<Precision,2:><Standard Format,0>'), FALSE, FALSE, FALSE, TempExcelBuffer."Cell Type"::Number);

                    ColumnNo := ColumnNo + 1;
                    EnterCell(
                      FORMAT(Amount + "GST Base", 0, '<Precision,2:><Standard Format,0>'), FALSE, FALSE, FALSE, TempExcelBuffer."Cell Type"::Number);

                    ColumnNo := ColumnNo + 1;
                    EnterCell("Document Line Code", FALSE, FALSE, FALSE, TempExcelBuffer."Cell Type"::Text);
                END;

                LinesTotal := LinesTotal + LineTotal; */
            end;

            trigger OnPreDataItem()
            begin
                SETRANGE("Posting Date", StartDate, EndDate);
                AmountTotal := 0;
                BaseTotal := 0;
                LinesTotal := 0;
                /* IF ExportToExcel THEN BEGIN
                    TempExcelBuffer.DELETEALL;
                    RowNo := 0;
                    ColumnNo := 0;

                    RowNo := RowNo + 1;
                    ColumnNo := 1;
                    EnterCell('Company Name', TRUE, FALSE, FALSE, TempExcelBuffer."Cell Type"::Text);
                    ColumnNo := ColumnNo + 1;
                    EnterCell(COMPANYNAME, FALSE, FALSE, FALSE, TempExcelBuffer."Cell Type"::Text);

                    RowNo := RowNo + 1;

                    RowNo := RowNo + 1;
                    ColumnNo := 1;
                    EnterCell('Start date', TRUE, FALSE, FALSE, TempExcelBuffer."Cell Type"::Text);
                    ColumnNo := ColumnNo + 1;
                    EnterCell(FORMAT(StartDate), FALSE, FALSE, FALSE, TempExcelBuffer."Cell Type"::Date);

                    RowNo := RowNo + 1;
                    ColumnNo := 1;
                    EnterCell('End date', TRUE, FALSE, FALSE, TempExcelBuffer."Cell Type"::Text);
                    ColumnNo := ColumnNo + 1;
                    EnterCell(FORMAT(EndDate), FALSE, FALSE, FALSE, TempExcelBuffer."Cell Type"::Date);

                    RowNo := RowNo + 1;

                    RowNo := RowNo + 1;
                    ColumnNo := 1;
                    EnterCell('Report created', TRUE, FALSE, FALSE, TempExcelBuffer."Cell Type"::Text);
                    ColumnNo := ColumnNo + 1;
                    EnterCell(FORMAT(TODAY), FALSE, FALSE, FALSE, TempExcelBuffer."Cell Type"::Date);

                    RowNo := RowNo + 1;
                    ColumnNo := 1;
                    EnterCell('Created by', TRUE, FALSE, FALSE, TempExcelBuffer."Cell Type"::Text);
                    ColumnNo := ColumnNo + 1;
                    EnterCell(FORMAT(USERID), FALSE, FALSE, FALSE, TempExcelBuffer."Cell Type"::Text);

                    RowNo := RowNo + 1;

                    RowNo := RowNo + 1;
                    ColumnNo := 1;
                    EnterCell(FIELDCAPTION("Posting Date"), TRUE, FALSE, FALSE, TempExcelBuffer."Cell Type"::Text);

                    ColumnNo := ColumnNo + 1;
                    EnterCell(FIELDCAPTION("Document No."), TRUE, FALSE, FALSE, TempExcelBuffer."Cell Type"::Text);

                    ColumnNo := ColumnNo + 1;
                    EnterCell(FIELDCAPTION("Document Type"), TRUE, FALSE, FALSE, TempExcelBuffer."Cell Type"::Text);

                    ColumnNo := ColumnNo + 1;
                    EnterCell('Vendor Code', TRUE, FALSE, FALSE, TempExcelBuffer."Cell Type"::Text);

                    //J13839------------------------------->>>
                    ColumnNo := ColumnNo + 1;
                    EnterCell('Vendor Invoice No.', TRUE, FALSE, FALSE, TempExcelBuffer."Cell Type"::Text);

                    ColumnNo := ColumnNo + 1;
                    EnterCell('Document Date', TRUE, FALSE, FALSE, TempExcelBuffer."Cell Type"::Text);

                    //J13839-------------------------------<<<
                    //Austral Sugeevan 24/11/2014 >>>
                    ColumnNo := ColumnNo + 1;
                    EnterCell(VATRegistrationNoCaption, TRUE, FALSE, FALSE, TempExcelBuffer."Cell Type"::Text);
                    //Austral Sugeevan 24/11/2014 <<<

                    ColumnNo := ColumnNo + 1;
                    EnterCell('Vendor Name', TRUE, FALSE, FALSE, TempExcelBuffer."Cell Type"::Text);

                    ColumnNo := ColumnNo + 1;
                    EnterCell('Description', TRUE, FALSE, FALSE, TempExcelBuffer."Cell Type"::Text);

                    ColumnNo := ColumnNo + 1;
                    EnterCell('GST Bus. Posting Group', TRUE, FALSE, FALSE, TempExcelBuffer."Cell Type"::Text);

                    ColumnNo := ColumnNo + 1;
                    EnterCell('GST Prod. Posting Group', TRUE, FALSE, FALSE, TempExcelBuffer."Cell Type"::Text);

                    ColumnNo := ColumnNo + 1;
                    EnterCell('GST%', TRUE, FALSE, FALSE, TempExcelBuffer."Cell Type"::Text);

                    ColumnNo := ColumnNo + 1;
                    EnterCell(FIELDCAPTION("GST Base"), TRUE, FALSE, FALSE, TempExcelBuffer."Cell Type"::Text);

                    ColumnNo := ColumnNo + 1;
                    EnterCell('GST Amount', TRUE, FALSE, FALSE, TempExcelBuffer."Cell Type"::Text);

                    ColumnNo := ColumnNo + 1;
                    EnterCell('Total Purchase', TRUE, FALSE, FALSE, TempExcelBuffer."Cell Type"::Text);

                    ColumnNo := ColumnNo + 1;
                    EnterCell('Code', TRUE, FALSE, FALSE, TempExcelBuffer."Cell Type"::Text);
                END; */
            end;
        }
        dataitem(Difference; "GST Purchase Entry")
        {
            DataItemTableView = SORTING("Entry No.")
                                WHERE("GST Entry No." = FILTER(0));
            PrintOnlyIfDetail = true;
            column(Difference__Document_Line_Code_; "Document Line Code")
            {
            }
            column(LineTotal_Control1500005; LineTotal)
            {
            }
            column(Difference_Amount; Amount)
            {
            }
            column(Difference__GST_Base_; "GST Base")
            {
            }
            column(GSTPercent_Control1500024; GSTPercent)
            {
            }
            column(Difference__VAT_Prod__Posting_Group_; "VAT Prod. Posting Group")
            {
            }
            column(Difference__VAT_Bus__Posting_Group_; "VAT Bus. Posting Group")
            {
            }
            column(Difference__Document_Line_Description_; "Document Line Description")
            {
            }
            column(Difference__Vendor_Name_; "Vendor Name")
            {
            }
            column(Difference__Vendor_No__; "Vendor No.")
            {
            }
            column(Difference__Document_Type_; "Document Type")
            {
            }
            column(Difference__Document_No__; "Document No.")
            {
            }
            column(Difference__Posting_Date_; FORMAT("Posting Date"))
            {
            }
            column(Difference_Entry_No_; "Entry No.")
            {
            }
            column(VAT_EntryCaption; VAT_EntryCaptionLbl)
            {
            }
            column(Vendor2_VATRegistrationNo__; Vendor2."VAT Registration No.")
            {
            }

            trigger OnAfterGetRecord()
            begin
                IF "GST Base" <> 0 THEN
                    GSTPercent := FORMAT(Amount / "GST Base" * 100, 0, '<Precision,2:><Standard Format,0>')
                ELSE
                    GSTPercent := '';

                LineTotal := Amount + "GST Base";

                //Austral Sugeevan 24/11/2014 >>>
                CLEAR(Vendor2);
                IF Vendor2.GET("Vendor No.") THEN;
                //Austral Sugeevan 24/11/2014 <<<
            end;
        }
    }
    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(StartDate; StartDate)
                    {
                        Caption = 'Start date';
                        ApplicationArea = all;
                    }
                    field(EndDate; EndDate)
                    {
                        Caption = 'End date';
                        ApplicationArea = all;
                    }
                    /*  field(ExportToExcel; ExportToExcel)
                     {
                         Caption = 'Export to Excel';
                     } */
                }
            }
        }

    }


    trigger OnPostReport()
    begin
        /*    IF ExportToExcel THEN BEGIN
               TempExcelBuffer.CreateBookAndOpenExcel('GST Purchases', '', COMPANYNAME, USERID);
               ERROR('');
           END; */
    end;

    trigger OnPreReport()
    begin
        IF EndDate = 0D THEN
            EndDate := WORKDATE;
    end;

    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        StartDate: Date;
        EndDate: Date;
        //ExportToExcel: Boolean;
        ColumnNo: Integer;
        RowNo: Integer;
        GSTPercent: Text[30];
        LineTotal: Decimal;
        AmountTotal: Decimal;
        BaseTotal: Decimal;
        LinesTotal: Decimal;
        GST_Purchase_Entry__Posting_Date_CaptionLbl: Label 'Posting Date';
        GST_Purchase_ReportCaptionLbl: Label 'GST Purchase Report';
        Report_CreatedCaptionLbl: Label 'Report Created';
        CompanyCaptionLbl: Label 'Company';
        Start_DateCaptionLbl: Label 'Start Date';
        End_DateCaptionLbl: Label 'End Date';
        UserCaptionLbl: Label 'User';
        GST_Bus__Posting_GroupCaptionLbl: Label 'GST Bus. Posting Group';
        GST_Prod__Posting_GroupCaptionLbl: Label 'GST Prod. Posting Group';
        GST__CaptionLbl: Label 'GST %';
        GST_BaseCaptionLbl: Label 'GST Base';
        GST_AmountCaptionLbl: Label 'GST Amount';
        Total_PurchaseCaptionLbl: Label 'Total Purchase';
        CodeCaptionLbl: Label 'Code';
        DescriptionCaptionLbl: Label 'Description';
        TotalCaptionLbl: Label 'Total';
        VAT_EntryCaptionLbl: Label 'VAT Entry';
        Vendor: Record Vendor;
        Vendor2: Record Vendor;
        VATRegistrationNoCaption: Label 'VAT Registration No.';
        PuchInvHeader: Record "Purch. Inv. Header";
        VendorInvoiceNo: Code[50];
        DocumentDate: Date;

    /* procedure EnterCell(CellValue: Text[250]; Bold: Boolean; Italic: Boolean; Underline: Boolean; CellType: Option)
    begin
        TempExcelBuffer.INIT;
        TempExcelBuffer.VALIDATE("Row No.", RowNo);
        TempExcelBuffer.VALIDATE("Column No.", ColumnNo);
        TempExcelBuffer."Cell Value as Text" := CellValue;
        TempExcelBuffer.Formula := '';
        TempExcelBuffer.Bold := Bold;
        TempExcelBuffer.Italic := Italic;
        TempExcelBuffer.Underline := Underline;
        TempExcelBuffer."Cell Type" := CellType;
        TempExcelBuffer.INSERT;
    end; */
}