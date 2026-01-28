report 50000 "Aged Acc. Pay. BackDating"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Report/AgedAccPayBackDating.rdl';
    Caption = 'Aged Acc. Pay. (BackDating)';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Search Name", Blocked;
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
            }
            column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(USERID; USERID)
            {
            }
            column(SubTitle; SubTitle)
            {
            }
            column(Aged_By_____DateTitle; 'Aged By ' + DateTitle)
            {
            }
            column(Vendor_TABLECAPTION__________AccountFilter; Vendor.TABLECAPTION + ': ' + AccountFilter)
            {
            }
            column(AccountFilter; AccountFilter)
            {
            }
            column(UseCurrencyNo; UseCurrencyNo)
            {
            }
            column(VenRecordNo; VenRecordNo)
            {
            }
            column(PrintOnePrPage; PrintOnePrPage)
            {
            }
            column(ColumnHeader_3_; ColumnHeader[3])
            {
            }
            column(ColumnHeader_2_; ColumnHeader[2])
            {
            }
            column(ColumnHeader_4_; ColumnHeader[4])
            {
            }
            column(ColumnHeaderHeader; ColumnHeaderHeader)
            {
            }
            column(ColumnHeader_1_; ColumnHeader[1])
            {
            }
            column(DateTitle; DateTitle)
            {
            }
            column(ColumnHeader_5_; ColumnHeader[5])
            {
            }
            column(PrintEntryDetails; PrintEntryDetails)
            {
            }
            column(ColumnHeader_1__Control1450037; ColumnHeader[1])
            {
            }
            column(ColumnHeader_2__Control1450038; ColumnHeader[2])
            {
            }
            column(ColumnHeader_3__Control1450039; ColumnHeader[3])
            {
            }
            column(ColumnHeader_4__Control1450040; ColumnHeader[4])
            {
            }
            column(ColumnHeaderHeader_Control1450041; ColumnHeaderHeader)
            {
            }
            column(ColumnHeader_5__Control1450058; ColumnHeader[5])
            {
            }
            column(Vendor__No__; "No.")
            {
            }
            column(Vendor_Name; Name)
            {
            }
            column(Vendor__Phone_No__; "Phone No.")
            {
            }
            column(BlockedDescription; BlockedDescription)
            {
            }
            column(Vendor_Contact; Contact)
            {
            }
            column(AccountNetChange; AccountNetChange)
            {
            }
            column(GetCurrencyCode____; GetCurrencyCode(''))
            {
            }
            column(PrintAccountDetails; PrintAccountDetails)
            {
            }
            column(Vendor___Aged_Accounts_PayableCaption; Vendor___Aged_Accounts_PayableCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Amounts_are_in_Document_Currency__Totals_are_in_LCY_Caption; Amounts_are_in_Document_Currency__Totals_are_in_LCY_CaptionLbl)
            {
            }
            column(Amounts_are_in_Vendor_Currency__Totals_are_in_LCY_Caption; Amounts_are_in_Vendor_Currency__Totals_are_in_LCY_CaptionLbl)
            {
            }
            column(All_amounts_are_in_LCY_Caption; All_amounts_are_in_LCY_CaptionLbl)
            {
            }
            column(Currency_CodeCaption; Currency_CodeCaptionLbl)
            {
            }
            column(DescriptionCaption; DescriptionCaptionLbl)
            {
            }
            column(Document_No_Caption; Document_No_CaptionLbl)
            {
            }
            column(Document_TypeCaption; Document_TypeCaptionLbl)
            {
            }
            column(BalanceCaption; BalanceCaptionLbl)
            {
            }
            column(Currency_CodeCaption_Control1450042; Currency_CodeCaption_Control1450042Lbl)
            {
            }
            column(NameCaption; NameCaptionLbl)
            {
            }
            column(No_Caption; No_CaptionLbl)
            {
            }
            column(BalanceCaption_Control1450010; BalanceCaption_Control1450010Lbl)
            {
            }
            column(Vendor__Phone_No__Caption; FIELDCAPTION("Phone No."))
            {
            }
            column(Vendor_ContactCaption; FIELDCAPTION(Contact))
            {
            }
            column(Net_ChangeCaption; Net_ChangeCaptionLbl)
            {
            }
            dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
            {
                DataItemTableView = SORTING("Entry No.");
                column(EntryDate; FORMAT(EntryDate))
                {
                }
                column(Vendor_Ledger_Entry__Document_Type_; "Document Type")
                {
                }
                column(Vendor_Ledger_Entry__Document_No__; "External Document No.")
                {
                }
                column(Vendor_Ledger_Entry_Description; Description)
                {
                }
                column(GetCurrencyCode_CurrencyCode_; GetCurrencyCode(CurrencyCode))
                {
                }
                column(EntryAmount_1_; EntryAmount[1])
                {
                    AutoFormatType = 1;
                }
                column(EntryAmount_2_; EntryAmount[2])
                {
                    AutoFormatType = 1;
                }
                column(EntryAmount_3_; EntryAmount[3])
                {
                    AutoFormatType = 1;
                }
                column(EntryAmount_4_; EntryAmount[4])
                {
                    AutoFormatType = 1;
                }
                column(EntryAmount_5__EntryAmount_4__EntryAmount_3__EntryAmount_2__EntryAmount_1_; EntryAmount[5] + EntryAmount[4] + EntryAmount[3] + EntryAmount[2] + EntryAmount[1])
                {
                    AutoFormatType = 1;
                }
                column(EntryAmount_5_; EntryAmount[5])
                {
                    AutoFormatType = 1;
                }
                column(Vendor_Ledger_Entry_Entry_No_; "Entry No.")
                {
                }

                trigger OnAfterGetRecord()
                var
                    RemainingAmount: Decimal;
                    RemainingAmountLCY: Decimal;
                    i: Integer;
                begin
                    CALCFIELDS("Remaining Amount", "Remaining Amt. (LCY)");
                    RemainingAmount := "Remaining Amount";
                    RemainingAmountLCY := "Remaining Amt. (LCY)";

                    CASE UseAgingDate OF
                        UseAgingDate::"Posting Date":
                            EntryDate := "Posting Date";
                        UseAgingDate::"Document Date":
                            EntryDate := "Document Date";
                        UseAgingDate::"Due Date":
                            EntryDate := "Due Date";
                    END;

                    CASE UseCurrency OF
                        UseCurrency::"Document Currency":
                            CurrencyCode := "Currency Code";
                        UseCurrency::"Vendor Currency":
                            RemainingAmount :=
                              ROUND(
                                CurrencyExchangeRate.ExchangeAmtFCYToFCY(
                                  PeriodStartDate[5],
                                  "Currency Code",
                                  CurrencyCode,
                                  "Remaining Amount"),
                                Currency."Amount Rounding Precision");
                        UseCurrency::LCY:
                            RemainingAmount := RemainingAmountLCY;
                    END;

                    FOR i := 1 TO 5 DO BEGIN
                        IF (EntryDate >= PeriodStartDate[i]) AND
                           (EntryDate <= CLOSINGDATE(CALCDATE('-1D', PeriodStartDate[i + 1])))
                        THEN BEGIN
                            EntryAmount[i] := RemainingAmount;
                            IF PrintTotalsPerCurrency AND (CurrencyCode <> '') THEN BEGIN
                                UpdateTotal(
                                  CVLedgerEntryBuffer2, TempCurrency2, CurrencyCode, i, RemainingAmount, RemainingAmountLCY);
                                UpdateTotal(
                                  CVLedgerEntryBuffer3, TempCurrency3, CurrencyCode, i, RemainingAmount, RemainingAmountLCY);
                            END;
                            UpdateTotal(CVLedgerEntryBuffer4, TempCurrency4, '', i, 0, RemainingAmountLCY);
                            UpdateTotal(CVLedgerEntryBuffer5, TempCurrency4, '', i, 0, RemainingAmountLCY);
                        END ELSE
                            EntryAmount[i] := 0;
                    END;
                end;

                trigger OnPreDataItem()
                var
                    DtldVendorLedgEntry: Record "Detailed Vendor Ledg. Entry";
                begin
                    RESET;
                    DtldVendorLedgEntry.SETCURRENTKEY("Vendor No.", "Posting Date", "Entry Type");
                    DtldVendorLedgEntry.SETRANGE("Vendor No.", Vendor."No.");
                    DtldVendorLedgEntry.SETRANGE("Posting Date", CALCDATE('<+1D>', PeriodStartDate[5]), PeriodStartDate[6]);
                    DtldVendorLedgEntry.SETRANGE("Entry Type", DtldVendorLedgEntry."Entry Type"::Application);
                    IF DtldVendorLedgEntry.FIND('-') THEN
                        REPEAT
                            "Entry No." := DtldVendorLedgEntry."Vendor Ledger Entry No.";
                            MARK(TRUE);
                        UNTIL DtldVendorLedgEntry.NEXT = 0;

                    SETCURRENTKEY("Vendor No.", Open);
                    SETRANGE("Vendor No.", Vendor."No.");
                    SETRANGE(Open, TRUE);
                    SETRANGE("Posting Date", 0D, PeriodStartDate[5]);
                    IF FIND('-') THEN
                        REPEAT
                            MARK(TRUE);
                        UNTIL NEXT = 0;

                    SETCURRENTKEY("Entry No.");
                    SETRANGE(Open);
                    MARKEDONLY(TRUE);
                    SETRANGE("Date Filter", 0D, PeriodStartDate[5]);
                end;
            }
            dataitem(AccountTotalsPerCurrency; Integer)
            {
                DataItemTableView = SORTING(Number)
                                    WHERE(Number = FILTER(1 ..));
                column(GetCurrencyCode_TempCurrency2_Code_; GetCurrencyCode(TempCurrency2.Code))
                {
                }
                column(Vendor_Name_Control1450072; Vendor.Name)
                {
                }
                column(Vendor__No___Control1450073; Vendor."No.")
                {
                }
                column(AccountTotalPerCurrency_1_; AccountTotalPerCurrency[1])
                {
                    AutoFormatExpression = TempCurrency2.Code;
                    AutoFormatType = 1;
                }
                column(AccountTotalPerCurrency_2_; AccountTotalPerCurrency[2])
                {
                    AutoFormatExpression = TempCurrency2.Code;
                    AutoFormatType = 1;
                }
                column(AccountTotalPerCurrency_3_; AccountTotalPerCurrency[3])
                {
                    AutoFormatExpression = TempCurrency2.Code;
                    AutoFormatType = 1;
                }
                column(AccountTotalPerCurrency_4_; AccountTotalPerCurrency[4])
                {
                    AutoFormatExpression = TempCurrency2.Code;
                    AutoFormatType = 1;
                }
                column(AccTotalPerCurrency_5__AccTotalPerCurrency_4__AccTotalPerCurrency_3__AccTotalPerCurrency_2__AccTotalPerCurrency_1_; AccountTotalPerCurrency[5] + AccountTotalPerCurrency[4] + AccountTotalPerCurrency[3] + AccountTotalPerCurrency[2] + AccountTotalPerCurrency[1])
                {
                    AutoFormatExpression = TempCurrency2.Code;
                    AutoFormatType = 1;
                }
                column(AccountTotalPerCurrency_5_; AccountTotalPerCurrency[5])
                {
                    AutoFormatExpression = TempCurrency2.Code;
                    AutoFormatType = 1;
                }
                column(AccountTotalsPerCurrency_Number; Number)
                {
                }

                trigger OnAfterGetRecord()
                var
                    i: Integer;
                    OK: Boolean;
                begin
                    IF Number = 1 THEN
                        OK := TempCurrency2.FIND('-')
                    ELSE
                        OK := TempCurrency2.NEXT <> 0;
                    IF NOT OK THEN
                        CurrReport.BREAK;

                    FOR i := 1 TO 5 DO
                        AccountTotalPerCurrency[i] := GetAccountTotalPerCurrency(TempCurrency2.Code, i);
                end;
            }
            dataitem(AccountTotals; Integer)
            {
                DataItemTableView = SORTING(Number)
                                    WHERE(Number = CONST(1));
                column(GetCurrencyCode_____Control1450078; GetCurrencyCode(''))
                {
                }
                column(Vendor_Name_Control1450079; Vendor.Name)
                {
                }
                column(Vendor__No___Control1450080; Vendor."No.")
                {
                }
                column(AccountTotal_1_; AccountTotal[1])
                {
                    AutoFormatExpression = '';
                    AutoFormatType = 1;
                }
                column(AccountTotal_2_; AccountTotal[2])
                {
                    AutoFormatExpression = '';
                    AutoFormatType = 1;
                }
                column(AccountTotal_3_; AccountTotal[3])
                {
                    AutoFormatExpression = '';
                    AutoFormatType = 1;
                }
                column(AccountTotal_4_; AccountTotal[4])
                {
                    AutoFormatExpression = '';
                    AutoFormatType = 1;
                }
                column(AccountTotal_5__AccountTotal_4__AccountTotal_3__AccountTotal_2__AccountTotal_1_; AccountTotal[5] + AccountTotal[4] + AccountTotal[3] + AccountTotal[2] + AccountTotal[1])
                {
                    AutoFormatExpression = '';
                    AutoFormatType = 1;
                }
                column(AccountTotal_5_; AccountTotal[5])
                {
                    AutoFormatExpression = '';
                    AutoFormatType = 1;
                }
                column(AccountTotals_Number; Number)
                {
                }
                column(Total__All_Currencies_Caption; Total__All_Currencies_CaptionLbl)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    FOR i := 1 TO 5 DO
                        AccountTotal[i] := GetAccountTotal(i);
                end;
            }

            trigger OnAfterGetRecord()
            var
                VendorLedgerEntry: Record "Vendor Ledger Entry";
                CurrencyFactor: Decimal;
            begin
                IF PrintTotalsPerCurrency THEN BEGIN
                    CVLedgerEntryBuffer2.RESET;
                    CVLedgerEntryBuffer2.DELETEALL;
                    TempCurrency2.DELETEALL;
                END;
                CVLedgerEntryBuffer4.RESET;
                CVLedgerEntryBuffer4.DELETEALL;

                VendorLedgerEntry.SETCURRENTKEY("Vendor No.", Open, Positive, "Due Date", "Currency Code");
                VendorLedgerEntry.SETRANGE("Vendor No.", "No.");
                VendorLedgerEntry.SETRANGE(Open, TRUE);
                CALCFIELDS("Net Change (LCY)");
                AccountNetChange := "Net Change (LCY)";
                VendorLedgerEntry.SETRANGE("Posting Date", 0D, PeriodStartDate[5]);
                IF AccountNetChange = 0 THEN
                    IF NOT VendorLedgerEntry.FINDFIRST THEN
                        CurrReport.SKIP;

                HasEntry := TRUE;

                CASE UseCurrency OF
                    UseCurrency::"Vendor Currency":
                        BEGIN
                            CurrencyCode := "Currency Code";
                            IF NOT Currency.GET("Currency Code") THEN
                                Currency.INIT;
                            CurrencyFactor := CurrencyExchangeRate.ExchangeRate(PeriodStartDate[5], "Currency Code");
                        END;
                    UseCurrency::LCY, UseCurrency::"Document Currency":
                        CurrencyCode := '';
                END;

                CASE Blocked OF
                    Vendor.Blocked::All:
                        BlockedDescription := Text1450000;
                    Vendor.Blocked::Payment:
                        BlockedDescription := Text1450001;
                    ELSE
                        BlockedDescription := '';
                END;

                IF (UseCurrency = UseCurrency::"Vendor Currency") AND
                   ("Currency Code" <> '')
                THEN
                    AccountNetChange :=
                      ROUND(
                        CurrencyExchangeRate.ExchangeAmtFCYToFCY(
                          PeriodStartDate[5],
                          "Currency Code",
                          CurrencyCode,
                          AccountNetChange),
                        Currency."Amount Rounding Precision");

                // SOLVE THE PROPERTY OF NEWPAGEPERRECORD
                IF PrintOnePrPage THEN
                    VenRecordNo := VenRecordNo + 1;
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.NEWPAGEPERRECORD := PrintOnePrPage;
                SETRANGE("Date Filter", 0D, PeriodStartDate[5]);

                // SOLVE OPTION VARIABLE
                UseCurrencyNo := UseCurrency;
            end;
        }
        dataitem(TotalsPerCurrency; Integer)
        {
            DataItemTableView = SORTING(Number)
                                WHERE(Number = FILTER(1 ..));
            column(GetCurrencyCode_TempCurrency3_Code_; GetCurrencyCode(TempCurrency3.Code))
            {
            }
            column(TotalPerCurrency_1_; TotalPerCurrency[1])
            {
                AutoFormatExpression = TempCurrency3.Code;
                AutoFormatType = 1;
            }
            column(TotalPerCurrency_2_; TotalPerCurrency[2])
            {
                AutoFormatExpression = TempCurrency3.Code;
                AutoFormatType = 1;
            }
            column(TotalPerCurrency_3_; TotalPerCurrency[3])
            {
                AutoFormatExpression = TempCurrency3.Code;
                AutoFormatType = 1;
            }
            column(TotalPerCurrency_4_; TotalPerCurrency[4])
            {
                AutoFormatExpression = TempCurrency3.Code;
                AutoFormatType = 1;
            }
            column(TotalPerCurrency_5__TotalPerCurrency_4__TotalPerCurrency_3__TotalPerCurrency_2__TotalPerCurrency_1_; TotalPerCurrency[5] + TotalPerCurrency[4] + TotalPerCurrency[3] + TotalPerCurrency[2] + TotalPerCurrency[1])
            {
                AutoFormatExpression = TempCurrency3.Code;
                AutoFormatType = 1;
            }
            column(TotalPerCurrency_5_; TotalPerCurrency[5])
            {
                AutoFormatExpression = TempCurrency3.Code;
                AutoFormatType = 1;
            }
            column(TotalsPerCurrency_Number; Number)
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            var
                OK: Boolean;
            begin
                IF NOT HasEntry THEN
                    CurrReport.BREAK;
                IF Number = 1 THEN
                    OK := TempCurrency3.FIND('-')
                ELSE
                    OK := TempCurrency3.NEXT <> 0;
                IF NOT OK THEN
                    CurrReport.BREAK;

                FOR i := 1 TO 5 DO
                    TotalPerCurrency[i] := GetTotalPerCurrency(TempCurrency3.Code, i);
            end;
        }
        dataitem(Totals; Integer)
        {
            DataItemTableView = SORTING(Number)
                                WHERE(Number = CONST(1));
            column(GetCurrencyCode_____Control1450066; GetCurrencyCode(''))
            {
            }
            column(Total_1_; Total[1])
            {
                AutoFormatExpression = '';
                AutoFormatType = 1;
            }
            column(Total_2_; Total[2])
            {
                AutoFormatExpression = '';
                AutoFormatType = 1;
            }
            column(Total_3_; Total[3])
            {
                AutoFormatExpression = '';
                AutoFormatType = 1;
            }
            column(Total_4_; Total[4])
            {
                AutoFormatExpression = '';
                AutoFormatType = 1;
            }
            column(Total_5__Total_4__Total_3__Total_2__Total_1_; Total[5] + Total[4] + Total[3] + Total[2] + Total[1])
            {
                AutoFormatExpression = '';
                AutoFormatType = 1;
            }
            column(Total_5_; Total[5])
            {
                AutoFormatExpression = '';
                AutoFormatType = 1;
            }
            column(Totals_Number; Number)
            {
            }
            column(TotalCaption_Control1450067; TotalCaption_Control1450067Lbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                IF NOT HasEntry THEN
                    CurrReport.BREAK;
                FOR i := 1 TO 5 DO
                    Total[i] := GetTotal(i);
            end;
        }
    }
    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(AgedAsOf; PeriodStartDate[5])
                    {
                        Caption = 'Aged As Of';
                        ApplicationArea = All;
                    }
                    field(PeriodLength; PeriodLength)
                    {
                        Caption = 'Period Length';
                        ApplicationArea = All;
                    }
                    field(UseAgingDate; UseAgingDate)
                    {
                        Caption = 'Use Aging Date';
                        ApplicationArea = All;
                    }
                    field(UseCurrency; UseCurrency)
                    {
                        Caption = 'Use Currency';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            UpdateRequestForm;
                        end;
                    }
                    field(PrintTotalsPerCurrency; PrintTotalsPerCurrency)
                    {
                        Caption = 'Print Totals Per Currency';
                        Enabled = PrintTotalsPerCurrencyEnable;
                        ApplicationArea = All;
                    }
                    field(PrintOnePrPage; PrintOnePrPage)
                    {
                        Caption = 'New Page per Vendor';
                        ApplicationArea = All;
                    }
                    field(PrintAccountDetails; PrintAccountDetails)
                    {
                        Caption = 'Print Account Details';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            UpdateRequestForm;
                        end;
                    }
                    field(PrintEntryDetails; PrintEntryDetails)
                    {
                        Caption = 'Print Entry Details';
                        Enabled = PrintEntryDetailsEnable;
                        ApplicationArea = All;
                    }
                }
            }
        }
        actions
        {
        }
        trigger OnInit()
        begin
            PrintTotalsPerCurrencyEnable := TRUE;
            PrintEntryDetailsEnable := TRUE;
        end;

        trigger OnOpenPage()
        begin
            IF PeriodStartDate[5] = 0D THEN
                PeriodStartDate[5] := WORKDATE;
            IF FORMAT(PeriodLength) = '' THEN
                EVALUATE(PeriodLength, '<30D>');
            UpdateRequestForm;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    var
        i: Integer;
    begin
        AccountFilter := Vendor.GETFILTERS;
        EntryNo := 0;

        PeriodStartDate[6] := 99991231D;
        FOR i := 4 DOWNTO 2 DO BEGIN
            PeriodStartDate[i] := CALCDATE('-' + FORMAT(PeriodLength), PeriodStartDate[i + 1]);
            ColumnHeader[i] :=
              FORMAT(PeriodStartDate[5] - PeriodStartDate[i + 1] + 1) + ' - ' +
              FORMAT(PeriodStartDate[5] - PeriodStartDate[i]) +
              ' Days';
        END;

        ColumnHeader[1] := Text1450016 + FORMAT(PeriodStartDate[5] - PeriodStartDate[2] + 1) + Text1450026;
        ColumnHeader[5] := Text1450008;
        SubTitle := '(';
        IF PrintEntryDetails THEN
            SubTitle := Text1450027
        ELSE
            SubTitle := Text1450028;
        SubTitle := '(' + SubTitle + Text1450029 + FORMAT(PeriodStartDate[5], 0, 4) + ')';

        CASE UseAgingDate OF
            UseAgingDate::"Due Date":
                BEGIN
                    DateTitle := Text1450030;
                    ColumnHeaderHeader := Text1450033;
                END;
            UseAgingDate::"Posting Date":
                BEGIN
                    DateTitle := Text1450031;
                    ColumnHeaderHeader := Text1450034;
                END;
            UseAgingDate::"Document Date":
                BEGIN
                    DateTitle := Text1450032;
                    ColumnHeaderHeader := Text1450034;
                END;
        END;
    end;

    var
        GLSetup: Record "General Ledger Setup";
        Currency: Record Currency;
        TempCurrency2: Record Currency temporary;
        TempCurrency3: Record Currency temporary;
        TempCurrency4: Record Currency temporary;
        CVLedgerEntryBuffer2: Record "CV Ledger Entry Buffer" temporary;
        CVLedgerEntryBuffer3: Record "CV Ledger Entry Buffer" temporary;
        CVLedgerEntryBuffer4: Record "CV Ledger Entry Buffer" temporary;
        CVLedgerEntryBuffer5: Record "CV Ledger Entry Buffer" temporary;
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        PeriodStartDate: array[6] of Date;
        EntryDate: Date;
        PeriodLength: DateFormula;
        AccountFilter: Text[250];
        ColumnHeader: array[5] of Text[30];
        ColumnHeaderHeader: Text[30];
        SubTitle: Text[88];
        DateTitle: Text[30];
        BlockedDescription: Text[50];
        CurrencyCode: Code[10];
        UseAgingDate: Option "Posting Date","Document Date","Due Date";
        UseCurrency: Option "Document Currency","Vendor Currency",LCY;
        PrintOnePrPage: Boolean;
        PrintAccountDetails: Boolean;
        PrintEntryDetails: Boolean;
        PrintTotalsPerCurrency: Boolean;
        HasGLSetup: Boolean;
        HasEntry: Boolean;
        EntryNo: Integer;
        Text1450000: Label '*** This vendor is blocked ***';
        Text1450001: Label '*** This vendor is blocked for payments ***';
        Text1450016: Label 'Over ';
        Text1450026: Label ' Days';
        Text1450027: Label 'Detail';
        Text1450028: Label 'Summary';
        Text1450029: Label ', aged as of ';
        Text1450030: Label 'Due Date';
        Text1450031: Label 'Posting Date';
        Text1450032: Label 'Document Date';
        Text1450033: Label 'Aged Overdue Amounts';
        Text1450034: Label 'Aged Vendor Balances';
        EntryAmount: array[5] of Decimal;
        AccountNetChange: Decimal;
        Text1450008: Label 'Current';
        AccountTotal: array[5] of Decimal;
        AccountTotalPerCurrency: array[5] of Decimal;
        Total: array[5] of Decimal;
        TotalPerCurrency: array[5] of Decimal;
        UseCurrencyNo: Integer;
        VenRecordNo: Integer;
        i: Integer;
        PrintTotalsPerCurrencyEnable: Boolean;
        PrintEntryDetailsEnable: Boolean;
        Vendor___Aged_Accounts_PayableCaptionLbl: Label 'Vendor - Aged Accounts Payable';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Amounts_are_in_Document_Currency__Totals_are_in_LCY_CaptionLbl: Label 'Amounts are in Document Currency, Totals are in LCY.';
        Amounts_are_in_Vendor_Currency__Totals_are_in_LCY_CaptionLbl: Label 'Amounts are in Vendor Currency, Totals are in LCY.';
        All_amounts_are_in_LCY_CaptionLbl: Label 'All amounts are in LCY.';
        Currency_CodeCaptionLbl: Label 'Currency Code';
        DescriptionCaptionLbl: Label 'Description';
        Document_No_CaptionLbl: Label 'Document No.';
        Document_TypeCaptionLbl: Label 'Document Type';
        BalanceCaptionLbl: Label 'Balance';
        Currency_CodeCaption_Control1450042Lbl: Label 'Currency Code';
        NameCaptionLbl: Label 'Name';
        No_CaptionLbl: Label 'No.';
        BalanceCaption_Control1450010Lbl: Label 'Balance';
        Net_ChangeCaptionLbl: Label 'Net Change';
        Total__All_Currencies_CaptionLbl: Label 'Total (All Currencies)';
        TotalCaptionLbl: Label 'Total';
        TotalCaption_Control1450067Lbl: Label 'Total';

    local procedure UpdateTotal(var CVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var TempCurrency: Record Currency; CurrencyCode: Code[20]; i: Integer; Amount: Decimal; AmountLCY: Decimal)
    begin
        IF NOT TempCurrency.GET(CurrencyCode) THEN BEGIN
            TempCurrency.INIT;
            TempCurrency.Code := CurrencyCode;
            TempCurrency.INSERT;
        END;
        CVLedgerEntryBuffer.RESET;
        CVLedgerEntryBuffer.SETRANGE("Currency Code", CurrencyCode);
        CVLedgerEntryBuffer.SETRANGE("Transaction No.", i);
        IF CVLedgerEntryBuffer.FIND('-') THEN BEGIN
            CVLedgerEntryBuffer.Amount := CVLedgerEntryBuffer.Amount + Amount;
            CVLedgerEntryBuffer."Amount (LCY)" := CVLedgerEntryBuffer."Amount (LCY)" + AmountLCY;
            CVLedgerEntryBuffer.MODIFY;
        END ELSE BEGIN
            EntryNo := EntryNo + 1;
            CVLedgerEntryBuffer."Entry No." := EntryNo;
            CVLedgerEntryBuffer."Currency Code" := CurrencyCode;
            CVLedgerEntryBuffer."Transaction No." := i;
            CVLedgerEntryBuffer.Amount := Amount;
            CVLedgerEntryBuffer."Amount (LCY)" := AmountLCY;
            CVLedgerEntryBuffer.INSERT;
        END;
    end;

    local procedure GetTotalPerCurrency(CurrencyCode: Code[20]; i: Integer): Decimal
    begin
        CVLedgerEntryBuffer3.RESET;
        CVLedgerEntryBuffer3.SETRANGE("Currency Code", CurrencyCode);
        CVLedgerEntryBuffer3.SETRANGE("Transaction No.", i);
        IF CVLedgerEntryBuffer3.FIND('-') THEN
            EXIT(CVLedgerEntryBuffer3.Amount);

        EXIT(0);
    end;

    local procedure GetAccountTotalPerCurrency(CurrencyCode: Code[20]; i: Integer): Decimal
    begin
        CVLedgerEntryBuffer2.RESET;
        CVLedgerEntryBuffer2.SETRANGE("Currency Code", CurrencyCode);
        CVLedgerEntryBuffer2.SETRANGE("Transaction No.", i);
        IF CVLedgerEntryBuffer2.FIND('-') THEN
            EXIT(CVLedgerEntryBuffer2.Amount);

        EXIT(0);
    end;

    local procedure GetCurrencyCode(CurrencyCode: Code[10]): Code[10]
    begin
        IF CurrencyCode = '' THEN BEGIN
            IF NOT HasGLSetup THEN
                HasGLSetup := GLSetup.GET;
            EXIT(GLSetup."LCY Code");
        END;
        EXIT(CurrencyCode);
    end;

    local procedure UpdateRequestForm()
    begin
        PageUpdateRequestForm;
    end;

    local procedure GetTotal(i: Integer): Decimal
    begin
        CVLedgerEntryBuffer5.RESET;
        CVLedgerEntryBuffer5.SETRANGE("Currency Code", '');
        CVLedgerEntryBuffer5.SETRANGE("Transaction No.", i);
        IF CVLedgerEntryBuffer5.FIND('-') THEN
            EXIT(CVLedgerEntryBuffer5."Amount (LCY)");

        EXIT(0);
    end;

    local procedure GetAccountTotal(i: Integer): Decimal
    begin
        CVLedgerEntryBuffer4.RESET;
        CVLedgerEntryBuffer4.SETRANGE("Currency Code", '');
        CVLedgerEntryBuffer4.SETRANGE("Transaction No.", i);
        IF CVLedgerEntryBuffer4.FIND('-') THEN
            EXIT(CVLedgerEntryBuffer4."Amount (LCY)");

        EXIT(0);
    end;

    local procedure PageUpdateRequestForm()
    begin
        PrintTotalsPerCurrencyEnable := UseCurrency <> UseCurrency::LCY;
        IF PrintTotalsPerCurrencyEnable = FALSE THEN
            PrintTotalsPerCurrency := FALSE;
        PrintEntryDetailsEnable := PrintAccountDetails = TRUE;
        IF PrintEntryDetailsEnable = FALSE THEN
            PrintEntryDetails := FALSE;
    end;
}

