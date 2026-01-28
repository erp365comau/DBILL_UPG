report 50098 "Remittance Advice - AD VP"
{
    // 0.01 Austral Jozef 16.01.2008 - Add field DocDescription
    DefaultLayout = RDLC;
    RDLCLayout = 'Report/RemittanceAdviceADVP.rdl';
    ApplicationArea = all;
    Caption = 'Remittance Advice - AD';
    Permissions = TableData 270 = m;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(FindVendors; "Gen. Journal Line")
        {
            DataItemTableView = SORTING("Journal Template Name", "Journal Batch Name", "Line No.")
                                WHERE("Account Type" = FILTER(Vendor));
            RequestFilterFields = "Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.";

            trigger OnAfterGetRecord()
            var
                bolFound: Boolean;
            begin
                IF ("Account Type" = "Account Type"::Vendor) AND
                  ("Account No." <> '')
                THEN
                    IF NOT VendTemp.GET("Account No.") THEN BEGIN
                        Vend.GET("Account No.");
                        VendTemp := Vend;
                        VendTemp.INSERT;
                    END;

                VendRec.GET(VendTemp."No.");

                //IF CreateEmailFile.CheckSkipVendor("Send Document Type",VendRec,SendEmail,1) THEN
                //   CurrReport.SKIP;

                bolFound := FALSE;

                VendTemp.COPYFILTERS(VendTemp2);
                IF VendTemp.FIND('-') THEN
                    REPEAT
                        IF VendRec."No." = VendTemp."No." THEN
                            bolFound := TRUE;

                    UNTIL (VendTemp.NEXT <= 0) OR (bolFound);

                VendTemp.RESET;

                IF bolFound THEN BEGIN
                    IF NOT CurrReport.PREVIEW THEN
                        IF SendEmail THEN
                            ERROR(Text50002);
                    /*IF SendEmail THEN BEGIN
                     GenJnlLine.COPYFILTERS(FindVendors);
                     GenJnlLine.SETRANGE("Line No.", FindVendors."Line No.");
                     VendorRec.COPYFILTERS(VendRec);
                     VendorRec.SETRANGE("No.",VendRec."No.");
                     EVALUATE(locReportID,COPYSTR(CurrReport.OBJECTID(FALSE),7));
                     CreateEmailFile.CreateJob2(locReportID,DATABASE::"Gen. Journal Line",10000,GenJnlLine.GETVIEW,VendorRec.GETVIEW,TRUE,
                     NewSendDocumentType);
                     CurrReport.SKIP;
                    END;*/
                END;

            end;
        }
        dataitem(Vendor; Vendor)
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";

            trigger OnPreDataItem()
            begin
                // Dataitem is here just to display request form - filters set by the user will be used later.
                CurrReport.BREAK;
            end;
        }
        dataitem(VendLoop; Integer)
        {
            DataItemTableView = SORTING(Number);
            dataitem(GenJnlLine; "Gen. Journal Line")
            {
                DataItemTableView = SORTING("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");
                column(GenJnlLine_Journal_Template_Name; "Journal Template Name")
                {
                }
                column(GenJnlLine_Journal_Batch_Name; "Journal Batch Name")
                {
                }
                column(GenJnlLine_Line_No_; "Line No.")
                {
                }
                dataitem(PrintSettledLoop; Integer)
                {
                    DataItemTableView = SORTING(Number);
                    column(CompanyInfoPicture; CompanyInfo.Picture)
                    {
                    }
                    column(Comapanyaddr_FaxNo_Data; CompanyInfo."Fax No.")
                    {
                    }
                    column(Comapanyaddr_Phone_Caption; CompanyInfo."Phone No.")
                    {
                    }
                    column(Comapanyaddr3; CompanyAddr[3])
                    {
                    }
                    column(Comapanyaddr2; CompanyAddr[2])
                    {
                    }
                    column(Comapanyaddr1; CompanyAddr[1])
                    {
                    }
                    column(ABN_Data; CompanyInfo.ABN)
                    {
                    }
                    column(Date_Data; PostingDate)
                    {
                    }
                    column(Creditor_No_Data; Vend."No.")
                    {
                    }
                    column(Our_Account_No_Data; Vend."Our Account No.")
                    {
                    }
                    column(ComapanyaddrHomePage_Data; CompanyInfo."Home Page")
                    {
                    }
                    column(ComapanyaddrBank_Name_Data; CompanyInfo."Bank Name")
                    {
                    }
                    column(BSB_Data; CompanyInfo."Bank Branch No.")
                    {
                    }
                    column(Company_Bank_Account_data; CompanyInfo."Bank Account No.")
                    {
                    }
                    column(Comapanyaddr4; CompanyAddr[4])
                    {
                    }
                    column(CheckToAddr_Data1; CheckToAddr[1])
                    {
                    }
                    column(CheckToAddr_Data2; CheckToAddr[2])
                    {
                    }
                    column(CheckToAddr_Data3; CheckToAddr[3])
                    {
                    }
                    column(CheckToAddr_Data4; CheckToAddr[4])
                    {
                    }
                    column(CheckToAddr_Data5; CheckToAddr[5])
                    {
                    }
                    column(Document_No_Data; DocNo)
                    {
                    }
                    column(DocDate_data; DocDate)
                    {
                    }
                    column(Amount_Data; LineAmount + LineDiscount)
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Discount_Data; LineDiscount)
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Line_Amount_data; LineAmount)
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(TotalAmount_data; TotalLineAmount - TotWHTAmount)
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Total_Text_Data; TotalText)
                    {
                    }
                    column(Fax_No_Caption; Fax_No_CaptionLbl)
                    {
                    }
                    column(Phone_No_Caption; Phone_No_CaptionLbl)
                    {
                    }
                    column(ABN_Caption; ABN_CaptionLbl)
                    {
                    }
                    column(Payment_DAte_caption; Payment_DAte_captionLbl)
                    {
                    }
                    column(Creditor_Code_Caption; Creditor_Code_CaptionLbl)
                    {
                    }
                    column(our_Account_No; our_Account_NoLbl)
                    {
                    }
                    column(Web_Caption; Web_CaptionLbl)
                    {
                    }
                    column(Bank_Caption; Bank_CaptionLbl)
                    {
                    }
                    column(BSB_Caption; BSB_CaptionLbl)
                    {
                    }
                    column(Account_No_Caption; Account_No_CaptionLbl)
                    {
                    }
                    column(Tax_InvoiceCaption; Tax_InvoiceCaptionLbl)
                    {
                    }
                    column(To_CAption; To_CAptionLbl)
                    {
                    }
                    column(DocumentNo_Caption; DocumentNo_CaptionLbl)
                    {
                    }
                    column(Document_Date_CAption; Document_Date_CAptionLbl)
                    {
                    }
                    column(Amount_Caption; Amount_CaptionLbl)
                    {
                    }
                    column(Discount_Caption; Discount_CaptionLbl)
                    {
                    }
                    column(Net_Amount_Caption; Net_Amount_CaptionLbl)
                    {
                    }
                    column(PrintSettledLoop_Number; Number)
                    {
                    }

                    trigger OnAfterGetRecord()
                    var
                        GenJnlLine1: Record "Gen. Journal Line";
                    begin
                        IF TRUE THEN BEGIN
                            IF FoundLast THEN BEGIN
                                IF RemainingAmount <> 0 THEN BEGIN
                                    DocType := Text015;
                                    DocNo := '';
                                    ExtDocNo := '';
                                    LineAmount := RemainingAmount;
                                    LineAmount2 := RemainingAmount;
                                    LineDiscount := 0;
                                    RemainingAmount := 0;
                                    LineWHT := 0;
                                END ELSE
                                    CurrReport.BREAK;
                            END ELSE BEGIN
                                CASE ApplyMethod OF
                                    ApplyMethod::OneLineOneEntry:
                                        BEGIN
                                            CASE BalancingType OF
                                                BalancingType::Customer:
                                                    BEGIN
                                                        CustLedgEntry.RESET;
                                                        CustLedgEntry.SETCURRENTKEY("Document No.");
                                                        CustLedgEntry.SETRANGE("Document Type", GenJnlLine."Applies-to Doc. Type");
                                                        CustLedgEntry.SETRANGE("Document No.", GenJnlLine."Applies-to Doc. No.");
                                                        CustLedgEntry.SETRANGE("Customer No.", BalancingNo);
                                                        CustLedgEntry.FIND('-');
                                                        CustUpdateAmounts(CustLedgEntry, RemainingAmount);
                                                    END;
                                                BalancingType::Vendor:
                                                    BEGIN
                                                        VendLedgEntry.RESET;
                                                        VendLedgEntry.SETCURRENTKEY("Document No.");
                                                        VendLedgEntry.SETRANGE("Document Type", GenJnlLine."Applies-to Doc. Type");
                                                        VendLedgEntry.SETRANGE("Document No.", GenJnlLine."Applies-to Doc. No.");
                                                        VendLedgEntry.SETRANGE("Vendor No.", BalancingNo);
                                                        VendLedgEntry.FIND('-');
                                                        VendUpdateAmounts(VendLedgEntry, RemainingAmount);
                                                    END;
                                            END;
                                            RemainingAmount := RemainingAmount - LineAmount2;
                                            FoundLast := TRUE;
                                        END;
                                    ApplyMethod::OneLineID:
                                        BEGIN
                                            CASE BalancingType OF
                                                BalancingType::Customer:
                                                    BEGIN
                                                        CustUpdateAmounts(CustLedgEntry, RemainingAmount);
                                                        FoundLast := (CustLedgEntry.NEXT = 0) OR (RemainingAmount <= 0);
                                                        IF FoundLast AND NOT FoundNegative THEN BEGIN
                                                            CustLedgEntry.SETRANGE(Positive, FALSE);
                                                            FoundLast := NOT CustLedgEntry.FIND('-');
                                                            FoundNegative := TRUE;
                                                        END;
                                                    END;
                                                BalancingType::Vendor:
                                                    BEGIN
                                                        VendUpdateAmounts(VendLedgEntry, RemainingAmount);
                                                        FoundLast := (VendLedgEntry.NEXT = 0) OR (RemainingAmount <= 0);
                                                        IF FoundLast AND NOT FoundNegative THEN BEGIN
                                                            VendLedgEntry.SETRANGE(Positive, FALSE);
                                                            FoundLast := NOT VendLedgEntry.FIND('-');
                                                            FoundNegative := TRUE;
                                                        END;
                                                    END;
                                            END;
                                            RemainingAmount := RemainingAmount - LineAmount2;
                                        END;
                                    ApplyMethod::MoreLinesOneEntry:
                                        BEGIN
                                            CurrentLineAmount := GenJnlLine2.Amount;
                                            LineAmount2 := CurrentLineAmount;

                                            IF GenJnlLine2."Applies-to ID" <> '' THEN
                                                ERROR(
                                                  Text016 +
                                                  Text017);
                                            GenJnlLine2.TESTFIELD("Check Printed", FALSE);
                                            GenJnlLine2.TESTFIELD("Bank Payment Type", GenJnlLine2."Bank Payment Type"::"Computer Check");

                                            IF GenJnlLine2."Applies-to Doc. No." = '' THEN BEGIN
                                                DocType := Text015;
                                                DocNo := '';
                                                ExtDocNo := '';
                                                LineAmount := CurrentLineAmount;
                                                LineDiscount := 0;
                                            END ELSE BEGIN
                                                CASE BalancingType OF
                                                    BalancingType::"G/L Account":
                                                        BEGIN
                                                            DocType := FORMAT(GenJnlLine2."Document Type");
                                                            DocNo := GenJnlLine2."Document No.";
                                                            ExtDocNo := GenJnlLine2."External Document No.";
                                                            LineAmount := CurrentLineAmount;
                                                            LineDiscount := 0;
                                                        END;
                                                    BalancingType::Customer:
                                                        BEGIN
                                                            CustLedgEntry.RESET;
                                                            CustLedgEntry.SETCURRENTKEY("Document No.");
                                                            CustLedgEntry.SETRANGE("Document Type", GenJnlLine2."Applies-to Doc. Type");
                                                            CustLedgEntry.SETRANGE("Document No.", GenJnlLine2."Applies-to Doc. No.");
                                                            CustLedgEntry.SETRANGE("Customer No.", BalancingNo);
                                                            CustLedgEntry.FIND('-');
                                                            CustUpdateAmounts(CustLedgEntry, CurrentLineAmount);
                                                            LineAmount := CurrentLineAmount;
                                                        END;
                                                    BalancingType::Vendor:
                                                        BEGIN
                                                            VendLedgEntry.RESET;
                                                            VendLedgEntry.SETCURRENTKEY("Document No.");
                                                            VendLedgEntry.SETRANGE("Document Type", GenJnlLine2."Applies-to Doc. Type");
                                                            VendLedgEntry.SETRANGE("Document No.", GenJnlLine2."Applies-to Doc. No.");
                                                            VendLedgEntry.SETRANGE("Vendor No.", BalancingNo);
                                                            VendLedgEntry.FIND('-');
                                                            VendUpdateAmounts(VendLedgEntry, CurrentLineAmount);
                                                            LineAmount := CurrentLineAmount;
                                                        END;
                                                    BalancingType::"Bank Account":
                                                        BEGIN
                                                            DocType := FORMAT(GenJnlLine2."Document Type");
                                                            DocNo := GenJnlLine2."Document No.";
                                                            ExtDocNo := GenJnlLine2."External Document No.";
                                                            LineAmount := CurrentLineAmount;
                                                            LineDiscount := 0;
                                                        END;
                                                END;
                                            END;
                                            FoundLast := GenJnlLine2.NEXT = 0;
                                        END;
                                END;
                            END;
                            GenJnlLine1.COPY(GenJnlLine);
                            IF (GenJnlLine1."Interest Amount" <> 0) THEN
                                GenJnlLine1.VALIDATE(Amount, GenJnlLine1.Amount - GenJnlLine1."Interest Amount");
                            IF NOT WHTSkip THEN BEGIN
                                IF WHTPostingSetup.GET(
                                     GenJnlLine1."WHT Business Posting Group",
                                     GenJnlLine1."WHT Product Posting Group")
                                THEN
                                    IF (WHTPostingSetup."Realized WHT Type" = WHTPostingSetup."Realized WHT Type"::Earliest) THEN
                                        LineWHT := WHTManagement.CalcVendExtraWHTForEarliest(GenJnlLine1)
                                    ELSE
                                        LineWHT := WHTManagement.WHTAmountJournal(GenJnlLine1, FALSE);
                            END ELSE
                                LineWHT := 0;

                            TotWHTAmount := LineWHT;
                            TotalLineAmount := TotalLineAmount + LineAmount2;
                            TotalLineDiscount := TotalLineDiscount + LineDiscount;
                        END ELSE BEGIN
                            IF FoundLast THEN
                                CurrReport.BREAK;
                            FoundLast := TRUE;
                            DocType := Text018;
                            DocNo := Text010;
                            ExtDocNo := Text010;
                            LineAmount := 0;
                            LineDiscount := 0;
                        END;
                    end;

                    trigger OnPostDataItem()
                    begin
                        FirstPage := FALSE;
                    end;

                    trigger OnPreDataItem()
                    begin
                        FirstPage := TRUE;
                        FoundLast := FALSE;
                        TotalLineAmount := 0;
                        TotalLineDiscount := 0;

                        IF TRUE THEN
                            IF FirstPage THEN BEGIN
                                FoundLast := TRUE;
                                CASE ApplyMethod OF
                                    ApplyMethod::OneLineOneEntry:
                                        FoundLast := FALSE;
                                    ApplyMethod::OneLineID:
                                        CASE BalancingType OF
                                            BalancingType::Customer:
                                                BEGIN
                                                    CustLedgEntry.RESET;
                                                    CustLedgEntry.SETCURRENTKEY("Customer No.", Open, Positive);
                                                    CustLedgEntry.SETRANGE("Customer No.", BalancingNo);
                                                    CustLedgEntry.SETRANGE(Open, TRUE);
                                                    CustLedgEntry.SETRANGE(Positive, TRUE);
                                                    CustLedgEntry.SETRANGE("Applies-to ID", GenJnlLine."Applies-to ID");
                                                    FoundLast := NOT CustLedgEntry.FIND('-');
                                                    IF FoundLast THEN BEGIN
                                                        CustLedgEntry.SETRANGE(Positive, FALSE);
                                                        FoundLast := NOT CustLedgEntry.FIND('-');
                                                        FoundNegative := TRUE;
                                                    END ELSE
                                                        FoundNegative := FALSE;
                                                END;
                                            BalancingType::Vendor:
                                                BEGIN
                                                    VendLedgEntry.RESET;
                                                    VendLedgEntry.SETCURRENTKEY("Vendor No.", Open, Positive);
                                                    VendLedgEntry.SETRANGE("Vendor No.", BalancingNo);
                                                    VendLedgEntry.SETRANGE(Open, TRUE);
                                                    VendLedgEntry.SETRANGE(Positive, TRUE);
                                                    VendLedgEntry.SETRANGE("Applies-to ID", GenJnlLine."Applies-to ID");
                                                    FoundLast := NOT VendLedgEntry.FIND('-');
                                                    IF FoundLast THEN BEGIN
                                                        VendLedgEntry.SETRANGE(Positive, FALSE);
                                                        FoundLast := NOT VendLedgEntry.FIND('-');
                                                        FoundNegative := TRUE;
                                                    END ELSE
                                                        FoundNegative := FALSE;
                                                END;
                                        END;
                                    ApplyMethod::MoreLinesOneEntry:
                                        FoundLast := FALSE;
                                END;
                            END
                            ELSE
                                FoundLast := FALSE;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    WHTSkip := GenJnlLine."Skip WHT";
                    InterestAmount := GenJnlLine."Interest Amount";
                    InterestAmountLCY := GenJnlLine."Interest Amount (LCY)";

                    IF TRUE THEN BEGIN
                        IF Amount = 0 THEN
                            CurrReport.SKIP;

                        TESTFIELD("Bal. Account Type", "Bal. Account Type"::"Bank Account");
                        BankAcc2.GET("Bal. Account No.");
                        BankAcc2.TESTFIELD(Blocked, FALSE);

                        IF "Bal. Account No." <> BankAcc2."No." THEN
                            CurrReport.SKIP;

                        IF ("Account No." <> '') AND ("Bal. Account No." <> '') THEN BEGIN
                            BalancingType := "Account Type";
                            BalancingNo := "Account No.";
                            RemainingAmount := Amount;
                            IF FALSE THEN BEGIN
                                ApplyMethod := ApplyMethod::MoreLinesOneEntry;
                                GenJnlLine2.RESET;
                                GenJnlLine2.SETCURRENTKEY("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");
                                GenJnlLine2.SETRANGE("Journal Template Name", "Journal Template Name");
                                GenJnlLine2.SETRANGE("Journal Batch Name", "Journal Batch Name");
                                GenJnlLine2.SETRANGE("Posting Date", "Posting Date");
                                GenJnlLine2.SETRANGE("Document No.", "Document No.");
                                GenJnlLine2.SETRANGE("Account Type", "Account Type");
                                GenJnlLine2.SETRANGE("Account No.", "Account No.");
                                GenJnlLine2.SETRANGE("Bal. Account Type", "Bal. Account Type");
                                GenJnlLine2.SETRANGE("Bal. Account No.", "Bal. Account No.");
                                GenJnlLine2.SETRANGE("Bank Payment Type", "Bank Payment Type");
                                GenJnlLine2.FIND('-');
                                RemainingAmount := 0;
                            END ELSE
                                IF "Applies-to Doc. No." <> '' THEN
                                    ApplyMethod := ApplyMethod::OneLineOneEntry
                                ELSE
                                    IF "Applies-to ID" <> '' THEN
                                        ApplyMethod := ApplyMethod::OneLineID
                                    ELSE
                                        ApplyMethod := ApplyMethod::Payment;
                        END ELSE
                            IF "Account No." = '' THEN
                                FIELDERROR("Account No.", Text004)
                            ELSE
                                FIELDERROR("Bal. Account No.", Text004);

                        CLEAR(CheckToAddr);
                        ContactText := '';
                        CLEAR(SalesPurchPerson);
                        CASE BalancingType OF
                            BalancingType::"G/L Account":
                                BEGIN
                                    CheckToAddr[1] := GenJnlLine.Description;
                                END;
                            BalancingType::Customer:
                                BEGIN
                                    Cust.GET(BalancingNo);
                                    IF Cust.Blocked = Cust.Blocked::All THEN
                                        ERROR(Text064, Cust.FIELDCAPTION(Blocked), Cust.Blocked, Cust.TABLECAPTION, Cust."No.");
                                    Cust.Contact := '';
                                    FormatAddr.Customer(CheckToAddr, Cust);
                                    IF BankAcc2."Currency Code" <> "Currency Code" THEN
                                        ERROR(Text005);
                                    IF Cust."Salesperson Code" <> '' THEN BEGIN
                                        ContactText := Text006;
                                        SalesPurchPerson.GET(Cust."Salesperson Code");
                                    END;
                                END;
                            BalancingType::Vendor:
                                BEGIN
                                    Vend.GET(BalancingNo);
                                    IF Vend.Blocked IN [Vend.Blocked::All, Vend.Blocked::Payment] THEN
                                        ERROR(Text064, Vend.FIELDCAPTION(Blocked), Vend.Blocked, Vend.TABLECAPTION, Vend."No.");
                                    Vend.Contact := '';
                                    FormatAddr.Vendor(CheckToAddr, Vend);
                                    IF BankAcc2."Currency Code" <> "Currency Code" THEN
                                        ERROR(Text005);
                                    IF Vend."Purchaser Code" <> '' THEN BEGIN
                                        ContactText := Text007;
                                        SalesPurchPerson.GET(Vend."Purchaser Code");
                                    END;
                                END;
                            BalancingType::"Bank Account":
                                BEGIN
                                    BankAcc.GET(BalancingNo);
                                    BankAcc.TESTFIELD(Blocked, FALSE);
                                    BankAcc.Contact := '';
                                    FormatAddr.BankAcc(CheckToAddr, BankAcc);
                                    IF BankAcc2."Currency Code" <> BankAcc."Currency Code" THEN
                                        ERROR(Text008);
                                    IF BankAcc."Our Contact Code" <> '' THEN BEGIN
                                        ContactText := Text009;
                                        SalesPurchPerson.GET(BankAcc."Our Contact Code");
                                    END;
                                END;
                        END;

                        CheckDateText := FORMAT("Posting Date", 0, 4);

                        //Jozef
                        PostingDate := "Posting Date";
                    END;
                end;

                trigger OnPreDataItem()
                begin
                    COPYFILTERS(FindVendors);
                    CurrReport.CREATETOTALS(GenJnlLine.Amount);
                    SETRANGE("Account No.", VendTemp."No.");

                    CompanyInfo.GET;
                    CompanyInfo.CALCFIELDS(Picture);
                    FormatAddr.Company(CompanyAddr, CompanyInfo);
                    //BankAcc2.GET(BankAcc2."No.");
                    //BankAcc2.TESTFIELD(Blocked,FALSE);
                    ChecksPrinted := 0;

                    SETRANGE("Account Type", GenJnlLine."Account Type"::"Fixed Asset");
                    IF FIND('-') THEN
                        GenJnlLine.FIELDERROR("Account Type");
                    SETRANGE("Account Type");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                IF Number = 1 THEN
                    VendTemp.FIND('-')
                ELSE
                    VendTemp.NEXT;

                VendRec.GET(VendTemp."No.");

                //IF CreateEmailFile.CheckSkipVendor("Send Document Type",VendRec,SendEmail,1) THEN
                //   CurrReport.SKIP;

                IF NOT CurrReport.PREVIEW THEN
                    IF SendEmail THEN
                        ERROR(Text50002);
                IF SendEmail THEN BEGIN
                    CurrReport.SKIP;
                END;
            end;

            trigger OnPreDataItem()
            begin
                VendTemp.COPYFILTERS(Vendor);
                SETRANGE(Number, 1, VendTemp.COUNT);
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

    trigger OnInitReport()
    begin
        //jozef
        InitValues;
    end;

    trigger OnPreReport()
    begin
        InitTextVariable;

        VendTemp2.COPYFILTERS(Vendor); //0.07 CSA Jozef 25.10.2006
    end;

    var
        Text000: Label 'Preview is not allowed.';
        Text001: Label 'Last Check No. must be filled in.';
        Text002: Label 'Filters on %1 and %2 are not allowed.';
        Text003: Label 'XXXXXXXXXXXXXXXX';
        Text004: Label 'must be entered.';
        Text005: Label 'The Bank Account and the General Journal Line must have the same currency.';
        Text006: Label 'Salesperson';
        Text007: Label 'Purchaser';
        Text008: Label 'Both Bank Accounts must have the same currency.';
        Text009: Label 'Our Contact';
        Text010: Label 'XXXXXXXXXX';
        Text011: Label 'XXXX';
        Text012: Label 'XX.XXXXXXXXXX.XXXX';
        Text013: Label '%1 already exists.';
        Text014: Label 'Check for %1 %2';
        Text015: Label 'Payment';
        Text016: Label 'In the Check report, One Check per Vendor and Document No.\';
        Text017: Label 'must not be activated when Applies-to ID is specified in the journal lines.';
        Text018: Label 'XXX';
        Text019: Label 'Total';
        Text020: Label 'The total amount of check %1 is %2. The amount must be positive.';
        Text021: Label 'VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID';
        Text022: Label 'NON-NEGOTIABLE';
        Text023: Label 'Test print';
        Text024: Label 'XXXX.XX';
        Text025: Label 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
        Text026: Label 'ZERO';
        Text027: Label 'HUNDRED';
        Text028: Label 'AND';
        Text029: Label '%1 results in a written number that is too long.';
        Text030: Label ' is already applied to %1 %2 for customer %3.';
        Text031: Label ' is already applied to %1 %2 for vendor %3.';
        Text032: Label 'ONE';
        Text033: Label 'TWO';
        Text034: Label 'THREE';
        Text035: Label 'FOUR';
        Text036: Label 'FIVE';
        Text037: Label 'SIX';
        Text038: Label 'SEVEN';
        Text039: Label 'EIGHT';
        Text040: Label 'NINE';
        Text041: Label 'TEN';
        Text042: Label 'ELEVEN';
        Text043: Label 'TWELVE';
        Text044: Label 'THIRTEEN';
        Text045: Label 'FOURTEEN';
        Text046: Label 'FIFTEEN';
        Text047: Label 'SIXTEEN';
        Text048: Label 'SEVENTEEN';
        Text049: Label 'EIGHTEEN';
        Text050: Label 'NINETEEN';
        Text051: Label 'TWENTY';
        Text052: Label 'THIRTY';
        Text053: Label 'FORTY';
        Text054: Label 'FIFTY';
        Text055: Label 'SIXTY';
        Text056: Label 'SEVENTY';
        Text057: Label 'EIGHTY';
        Text058: Label 'NINETY';
        Text059: Label 'THOUSAND';
        Text060: Label 'MILLION';
        Text061: Label 'BILLION';
        CompanyInfo: Record "Company Information";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        GenJnlLine2: Record "Gen. Journal Line";
        GenJnlLine3: Record "Gen. Journal Line";
        Cust: Record Customer;
        CustLedgEntry: Record "Cust. Ledger Entry";
        Vend: Record Vendor;
        VendLedgEntry: Record "Vendor Ledger Entry";
        BankAcc: Record "Bank Account";
        BankAcc2: Record "Bank Account";
        Currency: Record Currency;
        FormatAddr: Codeunit "Format Address";
        DimensionManagement: Codeunit DimensionManagement;
        CompanyAddr: array[8] of Text[50];
        CheckToAddr: array[8] of Text[50];
        OnesText: array[20] of Text[30];
        TensText: array[10] of Text[30];
        ExponentText: array[5] of Text[30];
        BalancingType: Option "G/L Account",Customer,Vendor,"Bank Account";
        BalancingNo: Code[20];
        ContactText: Text[30];
        CheckNoText: Text[30];
        CheckDateText: Text[30];
        CheckAmountText: Text[30];
        DescriptionLine: array[2] of Text[80];
        DocType: Text[30];
        DocNo: Text[30];
        ExtDocNo: Text[30];
        VoidText: Text[30];
        LineAmount: Decimal;
        LineDiscount: Decimal;
        TotalLineAmount: Decimal;
        TotalLineDiscount: Decimal;
        RemainingAmount: Decimal;
        CurrentLineAmount: Decimal;
        FoundLast: Boolean;
        FirstPage: Boolean;
        FoundNegative: Boolean;
        ApplyMethod: Option Payment,OneLineOneEntry,OneLineID,MoreLinesOneEntry;
        ChecksPrinted: Integer;
        HighestLineNo: Integer;
        TotalText: Text[30];
        DocDate: Date;
        i: Integer;
        Text062: Label 'G/L Account,Customer,Vendor,Bank Account';
        CurrencyCode2: Code[10];
        NetAmount: Text[30];
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        LineAmount2: Decimal;
        Text063: Label 'Net Amount %1';
        GLSetup: Record "General Ledger Setup";
        Text064: Label '%1 must not be %2 for %3 %4.';
        WHTSkip: Boolean;
        InterestAmountLCY: Decimal;
        InterestAmount: Decimal;
        LineWHT: Decimal;
        TotWHTAmount: Decimal;
        WHTManagement: Codeunit WHTManagement;
        WHTPostingSetup: Record "WHT Posting Setup";
        DocDescription: Text[100];
        Text50000: Label 'Net Amount %1';
        Text50001: Label 'Total Amount';
        VendTemp: Record Vendor temporary;
        VendorRec: Record Vendor;
        VendRec: Record Vendor;
        "Send Document Type": Option " ",Mail,"E-mail",Fax,All,"Mail/Blank";
        VendTemp2: Record Vendor;
        SendEmail: Boolean;
        Text50002: Label 'You cannot print if you want to email or fax the report.';
        locSalesInv: Record "Sales Invoice Header";
        locReportID: Integer;
        PostingDate: Date;
        NewSendDocumentType: Option Default,"E-mail",Fax;
        txtACN: Text[30];
        Fax_No_CaptionLbl: Label 'Fax No.';
        Phone_No_CaptionLbl: Label 'Phone No.';
        ABN_CaptionLbl: Label 'ABN';
        Payment_DAte_captionLbl: Label 'Payment Date';
        Creditor_Code_CaptionLbl: Label 'Creditor Code';
        our_Account_NoLbl: Label 'Our Account No.';
        Web_CaptionLbl: Label 'WEB:';
        Bank_CaptionLbl: Label 'Bank';
        BSB_CaptionLbl: Label 'BSB';
        Account_No_CaptionLbl: Label 'Account No.';
        Tax_InvoiceCaptionLbl: Label 'Tax Invoice';
        To_CAptionLbl: Label 'To:';
        DocumentNo_CaptionLbl: Label 'Document No.';
        Document_Date_CAptionLbl: Label 'Document Date';
        Amount_CaptionLbl: Label 'Amount';
        Discount_CaptionLbl: Label 'Discount';
        Net_Amount_CaptionLbl: Label 'Net Amount';

    procedure FormatNoText(var NoText: array[2] of Text[80]; No: Decimal; CurrencyCode: Code[10])
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
    begin
        CLEAR(NoText);
        NoTextIndex := 1;
        NoText[1] := '****';

        IF No < 1 THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent, Text026)
        ELSE BEGIN
            FOR Exponent := 4 DOWNTO 1 DO BEGIN
                PrintExponent := FALSE;
                Ones := No DIV POWER(1000, Exponent - 1);
                Hundreds := Ones DIV 100;
                Tens := (Ones MOD 100) DIV 10;
                Ones := Ones MOD 10;
                IF Hundreds > 0 THEN BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Hundreds]);
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text027);
                END;
                IF Tens >= 2 THEN BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[Tens]);
                    IF Ones > 0 THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
                END ELSE
                    IF (Tens * 10 + Ones) > 0 THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones]);
                IF PrintExponent AND (Exponent > 1) THEN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent]);
                No := No - (Hundreds * 100 + Tens * 10 + Ones) * POWER(1000, Exponent - 1);
            END;
        END;

        AddToNoText(NoText, NoTextIndex, PrintExponent, Text028);
        AddToNoText(NoText, NoTextIndex, PrintExponent, FORMAT(No * 100) + '/100');

        IF CurrencyCode <> '' THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent, CurrencyCode);
    end;

    local procedure AddToNoText(var NoText: array[2] of Text[80]; var NoTextIndex: Integer; var PrintExponent: Boolean; AddText: Text[30])
    begin
        PrintExponent := TRUE;

        WHILE STRLEN(NoText[NoTextIndex] + ' ' + AddText) > MAXSTRLEN(NoText[1]) DO BEGIN
            NoTextIndex := NoTextIndex + 1;
            IF NoTextIndex > ARRAYLEN(NoText) THEN
                ERROR(Text029, AddText);
        END;

        NoText[NoTextIndex] := DELCHR(NoText[NoTextIndex] + ' ' + AddText, '<');
    end;

    local procedure CustUpdateAmounts(var CustLedgEntry2: Record "Cust. Ledger Entry"; RemainingAmount2: Decimal)
    begin
        IF (ApplyMethod = ApplyMethod::OneLineOneEntry) OR
           (ApplyMethod = ApplyMethod::MoreLinesOneEntry)
        THEN BEGIN
            GenJnlLine3.RESET;
            GenJnlLine3.SETCURRENTKEY(
              "Account Type", "Account No.", "Applies-to Doc. Type", "Applies-to Doc. No.");
            GenJnlLine3.SETRANGE("Account Type", GenJnlLine3."Account Type"::Customer);
            GenJnlLine3.SETRANGE("Account No.", CustLedgEntry2."Customer No.");
            GenJnlLine3.SETRANGE("Applies-to Doc. Type", CustLedgEntry2."Document Type");
            GenJnlLine3.SETRANGE("Applies-to Doc. No.", CustLedgEntry2."Document No.");
            IF ApplyMethod = ApplyMethod::OneLineOneEntry THEN
                GenJnlLine3.SETFILTER("Line No.", '<>%1', GenJnlLine."Line No.")
            ELSE
                GenJnlLine3.SETFILTER("Line No.", '<>%1', GenJnlLine2."Line No.");
            IF CustLedgEntry2."Document Type" <> CustLedgEntry2."Document Type"::" " THEN
                IF GenJnlLine3.FIND('-') THEN
                    GenJnlLine3.FIELDERROR(
                      "Applies-to Doc. No.",
                      STRSUBSTNO(
                        Text030,
                        CustLedgEntry2."Document Type", CustLedgEntry2."Document No.",
                        CustLedgEntry2."Customer No."));
        END;

        DocType := FORMAT(CustLedgEntry2."Document Type");
        DocNo := CustLedgEntry2."Document No.";
        ExtDocNo := CustLedgEntry2."External Document No.";
        DocDate := CustLedgEntry2."Posting Date";
        CurrencyCode2 := CustLedgEntry2."Currency Code";

        //0.01 Austral Jozef 16.01.2008
        DocDescription := CustLedgEntry2.Description;

        CustLedgEntry2.CALCFIELDS("Remaining Amount");

        LineAmount := -(CustLedgEntry2."Remaining Amount" - CustLedgEntry2."Remaining Pmt. Disc. Possible" -
          CustLedgEntry2."Accepted Payment Tolerance");
        LineAmount2 :=
          ROUND(
            ExchangeAmt(CustLedgEntry2."Posting Date", GenJnlLine."Currency Code", CurrencyCode2, LineAmount),
            Currency."Amount Rounding Precision");

        IF ((CustLedgEntry2."Document Type" = CustLedgEntry2."Document Type"::Invoice) AND
           (GenJnlLine."Posting Date" <= CustLedgEntry2."Pmt. Discount Date") AND
           (LineAmount2 <= RemainingAmount2)) OR CustLedgEntry2."Accepted Pmt. Disc. Tolerance"
        THEN BEGIN
            LineDiscount := -CustLedgEntry2."Remaining Pmt. Disc. Possible";
            IF CustLedgEntry2."Accepted Payment Tolerance" <> 0 THEN
                LineDiscount := LineDiscount - CustLedgEntry2."Accepted Payment Tolerance";
        END ELSE BEGIN
            IF RemainingAmount2 >=
               ROUND(
                -(ExchangeAmt(CustLedgEntry2."Posting Date", GenJnlLine."Currency Code", CurrencyCode2,
                  CustLedgEntry2."Remaining Amount")), Currency."Amount Rounding Precision")
            THEN
                LineAmount2 :=
                  ROUND(
                    -(ExchangeAmt(CustLedgEntry2."Posting Date", GenJnlLine."Currency Code", CurrencyCode2,
                      CustLedgEntry2."Remaining Amount")), Currency."Amount Rounding Precision")
            ELSE BEGIN
                LineAmount2 := RemainingAmount2;
                LineAmount :=
                  ROUND(
                    ExchangeAmt(CustLedgEntry2."Posting Date", CurrencyCode2, GenJnlLine."Currency Code",
                    LineAmount2), Currency."Amount Rounding Precision");
            END;
            LineDiscount := 0;
        END;
    end;

    local procedure VendUpdateAmounts(var VendLedgEntry2: Record "Vendor Ledger Entry"; RemainingAmount2: Decimal)
    begin
        IF (ApplyMethod = ApplyMethod::OneLineOneEntry) OR
           (ApplyMethod = ApplyMethod::MoreLinesOneEntry)
        THEN BEGIN
            GenJnlLine3.RESET;
            GenJnlLine3.SETCURRENTKEY(
              "Account Type", "Account No.", "Applies-to Doc. Type", "Applies-to Doc. No.");
            GenJnlLine3.SETRANGE("Account Type", GenJnlLine3."Account Type"::Vendor);
            GenJnlLine3.SETRANGE("Account No.", VendLedgEntry2."Vendor No.");
            GenJnlLine3.SETRANGE("Applies-to Doc. Type", VendLedgEntry2."Document Type");
            GenJnlLine3.SETRANGE("Applies-to Doc. No.", VendLedgEntry2."Document No.");
            IF ApplyMethod = ApplyMethod::OneLineOneEntry THEN
                GenJnlLine3.SETFILTER("Line No.", '<>%1', GenJnlLine."Line No.")
            ELSE
                GenJnlLine3.SETFILTER("Line No.", '<>%1', GenJnlLine2."Line No.");
            IF VendLedgEntry2."Document Type" <> VendLedgEntry2."Document Type"::" " THEN
                IF GenJnlLine3.FIND('-') THEN
                    GenJnlLine3.FIELDERROR(
                      "Applies-to Doc. No.",
                      STRSUBSTNO(
                        Text031,
                        VendLedgEntry2."Document Type", VendLedgEntry2."Document No.",
                        VendLedgEntry2."Vendor No."));
        END;

        DocType := FORMAT(VendLedgEntry2."Document Type");
        DocNo := VendLedgEntry2."Document No.";
        ExtDocNo := VendLedgEntry2."External Document No.";
        DocDate := VendLedgEntry2."Posting Date";
        CurrencyCode2 := VendLedgEntry2."Currency Code";

        //0.01 Austral Jozef 16.01.2008
        DocDescription := VendLedgEntry2.Description;

        VendLedgEntry2.CALCFIELDS("Remaining Amount");

        LineAmount := -(VendLedgEntry2."Remaining Amount" - VendLedgEntry2."Remaining Pmt. Disc. Possible" -
          VendLedgEntry2."Accepted Payment Tolerance");

        LineAmount2 :=
          ROUND(
            ExchangeAmt(VendLedgEntry2."Posting Date", GenJnlLine."Currency Code", CurrencyCode2, LineAmount),
            Currency."Amount Rounding Precision");

        IF (((VendLedgEntry2."Document Type" = VendLedgEntry2."Document Type"::Invoice) OR
           (VendLedgEntry2."Document Type" = VendLedgEntry2."Document Type"::"Credit Memo")) AND
           (GenJnlLine."Posting Date" <= VendLedgEntry2."Pmt. Discount Date") AND
           (LineAmount2 <= RemainingAmount2)) OR VendLedgEntry2."Accepted Pmt. Disc. Tolerance"
        THEN BEGIN
            LineDiscount := -VendLedgEntry2."Remaining Pmt. Disc. Possible";
            IF VendLedgEntry2."Accepted Payment Tolerance" <> 0 THEN
                LineDiscount := LineDiscount - VendLedgEntry2."Accepted Payment Tolerance";
        END ELSE BEGIN
            IF RemainingAmount2 >=
                ROUND(
                 -(ExchangeAmt(VendLedgEntry2."Posting Date", GenJnlLine."Currency Code", CurrencyCode2,
                   VendLedgEntry2."Amount to Apply")), Currency."Amount Rounding Precision")
             THEN BEGIN
                LineAmount2 :=
                  ROUND(
                    -(ExchangeAmt(VendLedgEntry2."Posting Date", GenJnlLine."Currency Code", CurrencyCode2,
                      VendLedgEntry2."Amount to Apply")), Currency."Amount Rounding Precision");
                LineAmount :=
                  ROUND(
                    ExchangeAmt(VendLedgEntry2."Posting Date", CurrencyCode2, GenJnlLine."Currency Code",
                    LineAmount2), Currency."Amount Rounding Precision");
            END ELSE BEGIN
                LineAmount2 := RemainingAmount2;
                LineAmount :=
                  ROUND(
                    ExchangeAmt(VendLedgEntry2."Posting Date", CurrencyCode2, GenJnlLine."Currency Code",
                    LineAmount2), Currency."Amount Rounding Precision");
            END;
            LineDiscount := 0;
        END;
    end;

    procedure InitTextVariable()
    begin
        OnesText[1] := Text032;
        OnesText[2] := Text033;
        OnesText[3] := Text034;
        OnesText[4] := Text035;
        OnesText[5] := Text036;
        OnesText[6] := Text037;
        OnesText[7] := Text038;
        OnesText[8] := Text039;
        OnesText[9] := Text040;
        OnesText[10] := Text041;
        OnesText[11] := Text042;
        OnesText[12] := Text043;
        OnesText[13] := Text044;
        OnesText[14] := Text045;
        OnesText[15] := Text046;
        OnesText[16] := Text047;
        OnesText[17] := Text048;
        OnesText[18] := Text049;
        OnesText[19] := Text050;

        TensText[1] := '';
        TensText[2] := Text051;
        TensText[3] := Text052;
        TensText[4] := Text053;
        TensText[5] := Text054;
        TensText[6] := Text055;
        TensText[7] := Text056;
        TensText[8] := Text057;
        TensText[9] := Text058;

        ExponentText[1] := '';
        ExponentText[2] := Text059;
        ExponentText[3] := Text060;
        ExponentText[4] := Text061;
    end;

    procedure InitializeRequest(BankAcc: Code[20]; LastCheckNo: Code[20]; NewOneCheckPrVend: Boolean; NewReprintChecks: Boolean; NewTestPrint: Boolean; NewPreprintedStub: Boolean)
    begin
        IF BankAcc <> '' THEN
            IF BankAcc2.GET(BankAcc) THEN BEGIN
            END;
    end;

    procedure ExchangeAmt(PostingDate: Date; CurrencyCode: Code[10]; CurrencyCode2: Code[10]; Amount: Decimal) Amount2: Decimal
    begin
        IF (CurrencyCode <> '') AND (CurrencyCode2 = '') THEN
            Amount2 :=
              CurrencyExchangeRate.ExchangeAmtLCYToFCY(
                PostingDate, CurrencyCode, Amount, CurrencyExchangeRate.ExchangeRate(PostingDate, CurrencyCode))
        ELSE IF (CurrencyCode = '') AND (CurrencyCode2 <> '') THEN
            Amount2 :=
              CurrencyExchangeRate.ExchangeAmtFCYToLCY(
                PostingDate, CurrencyCode2, Amount, CurrencyExchangeRate.ExchangeRate(PostingDate, CurrencyCode2))
        ELSE IF (CurrencyCode <> '') AND (CurrencyCode2 <> '') AND (CurrencyCode <> CurrencyCode2) THEN
            Amount2 := CurrencyExchangeRate.ExchangeAmtFCYToFCY(PostingDate, CurrencyCode2, CurrencyCode, Amount)
        ELSE
            Amount2 := Amount;
    end;

    procedure InitValues()
    begin
        SendEmail := FALSE;
        "Send Document Type" := "Send Document Type"::All;
    end;
}

