report 50043 "Statement - AD- P"
{
    // 0.01 Austral Siva 21.10.2011 Move the Address to right side
    // 0.02 Austral Sugeevan 20.11.2011 -- Made Header in RTC Design
    // Austral Sugeevan 23/01/2014 --> Adjusted Logo Size
    DefaultLayout = RDLC;
    RDLCLayout = 'Report/StatementADP.50043.rdl';
    ApplicationArea = all;
    Caption = 'Statement - AD- CEBECO';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Print Statements", "Date Filter";
            column(Customer_No_; "No.")
            {
            }
            dataitem(HeaderFooter; Integer)
            {
                DataItemTableView = SORTING(Number)
                                    WHERE(Number = CONST(1));
                column(CustomerAddress_1_; CustomerAddress[1])
                {
                }
                column(CustomerAddress_2_; CustomerAddress[2])
                {
                }
                column(CustomerAddress_3_; CustomerAddress[3])
                {
                }
                column(CustomerAddress_4_; CustomerAddress[4])
                {
                }
                column(CustomerAddress_5_; CustomerAddress[5])
                {
                }
                column(CustomerAddress_6_; CustomerAddress[6])
                {
                }
                column(CustomerAddress_7_; CustomerAddress[7])
                {
                }
                column(CustomerAddress_8_; CustomerAddress[8])
                {
                }
                column(FORMAT_ToDate_; FORMAT(ToDate))
                {
                }
                column(Customer__No__; Customer."No.")
                {
                }
                column(CurrReport_PAGENO; CurrReport.PAGENO)
                {
                }
                column(CurrencyLabel; CurrencyLabel)
                {
                }
                column(CompanyAddress_4_; CompanyAddress[4])
                {
                }
                column(CompanyAddress_3_; CompanyAddress[3])
                {
                }
                column(CompanyAddress_2_; CompanyAddress[2])
                {
                }
                column(CompanyAddress_1_; CompanyAddress[1])
                {
                }
                column(CompanyAddress_5_; CompanyAddress[5])
                {
                }
                column(PhoneNo; PhoneNo)
                {
                }
                column(FaxNo; FaxNo)
                {
                }
                column(VATRegNo; VATRegNo)
                {
                }
                column(GiroNo; GiroNo)
                {
                }
                column(Bank; Bank)
                {
                }
                column(AccountNo; AccountNo)
                {
                }
                column(CompanyInformation__Bank_Account_No__; CompanyInformation."Bank Account No.")
                {
                }
                column(CompanyInformation__Bank_Name_; CompanyInformation."Bank Name")
                {
                }
                column(CompanyInformation__Giro_No__; CompanyInformation."Giro No.")
                {
                }
                column(CompanyInformation__VAT_Registration_No__; CompanyInformation."VAT Registration No.")
                {
                }
                column(CompanyInformation__Fax_No__1; CompanyInformation."Fax No.")
                {
                }
                column(CompanyInformation__Phone_No__; CompanyInformation."Phone No. 2")
                {
                }
                column(PrintLCY; PrintLCY)
                {
                }
                column(StatementStyle; StatementStyle)
                {
                }
                column(AgingMethod; AgingMethod)
                {
                }
                column(CompanyInfo__Phone_No__; CompanyInfo."Phone No.")
                {
                }
                column(CompanyInfo_Picture; CompanyInfo.Picture)
                {
                }
                column(CompanyInformation__Fax_No__; CompanyInfo."Fax No.")
                {
                }
                column(DebitBalance; DebitBalance)
                {
                }
                column(CreditBalance; -CreditBalance)
                {
                }
                column(StatementBalance; StatementBalance)
                {
                }
                column(DebitBalance_Control1500072; DebitBalance)
                {
                }
                column(CreditBalance_Control1500073; -CreditBalance)
                {
                }
                column(AgingDaysText; AgingDaysText)
                {
                }
                column(AgingHead_1_; AgingHead[1])
                {
                }
                column(AgingHead_2_; AgingHead[2])
                {
                }
                column(AgingHead_3_; AgingHead[3])
                {
                }
                column(AgingHead_4_; AgingHead[4])
                {
                }
                column(StatementBalance_Control1500074; StatementBalance)
                {
                }
                column(AgingAmount_4_; AgingAmount[4])
                {
                }
                column(AgingAmount_3_; AgingAmount[3])
                {
                }
                column(AgingAmount_2_; AgingAmount[2])
                {
                }
                column(AgingAmount_1_; AgingAmount[1])
                {
                }
                column(CompanyAdd_1_; CompanyAdd[1])
                {
                }
                column(CompanyAdd_2_; CompanyAdd[2])
                {
                }
                column(CompanyAdd_1__Control1000000003; CompanyAdd[1])
                {
                }
                column(CompanyAdd_3_; CompanyAdd[3])
                {
                }
                column(CompanyAdd_1__Control1000000005; CompanyAdd[1])
                {
                }
                column(CompanyAdd_4_; CompanyAdd[4])
                {
                }
                column(CompanyAdd_5_; CompanyAdd[5])
                {
                }
                column(CompanyInfo__Bank_Name_; CompanyInfo."Bank Name")
                {
                }
                column(CompanyInfo__Bank_Account_No__; CompanyInfo."Bank Account No.")
                {
                }
                column(CompanyInfo__BankBranchNo; CompanyInfo."Bank Branch No.")
                {
                }
                column(STATEMENTCaption; STATEMENTCaptionLbl)
                {
                }
                column(Statement_Date_Caption; Statement_Date_CaptionLbl)
                {
                }
                column(Account_Number_Caption; Account_Number_CaptionLbl)
                {
                }
                column(Currency_Caption; Currency_CaptionLbl)
                {
                }
                column(Page_Caption; Page_CaptionLbl)
                {
                }
                column(BalanceCaption; BalanceCaptionLbl)
                {
                }
                column(CreditsCaption; CreditsCaptionLbl)
                {
                }
                column(DebitsCaption; DebitsCaptionLbl)
                {
                }
                column(Due_DateCaption; Due_DateCaptionLbl)
                {
                }
                column(No_Caption; No_CaptionLbl)
                {
                }
                column(DocumentCaption; DocumentCaptionLbl)
                {
                }
                column(DateCaption; DateCaptionLbl)
                {
                }
                column(Statement_BalanceCaption; Statement_BalanceCaptionLbl)
                {
                }
                column(Statement_BalanceCaption_Control1500071; Statement_BalanceCaption_Control1500071Lbl)
                {
                }
                column(Statement_Aging_Caption; Statement_Aging_CaptionLbl)
                {
                }
                column(Aged_Amounts_Caption; Aged_Amounts_CaptionLbl)
                {
                }
                column(HeaderFooter_Number; Number)
                {
                }
                dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
                {
                    CalcFields = "Remaining Amt. (LCY)", "Remaining Amount";
                    DataItemLink = "Customer No." = FIELD("No."),
                                   "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                   "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter");
                    DataItemLinkReference = Customer;
                    DataItemTableView = SORTING("Customer No.", Open)
                                        WHERE("Remaining Amount" = FILTER(<> 0));

                    trigger OnPreDataItem()
                    begin
                        IF (AgingMethod = AgingMethod::None) AND (StatementStyle = StatementStyle::Balance) THEN
                            CurrReport.BREAK;    // Optimization
                        // Find ledger entries which are open and posted before the statement date.
                        LedgEntryLast := 0;
                        IF (StatementStyle = StatementStyle::"Open Item") THEN
                            SETRANGE("Date Filter", 0D, ToDate);
                        SETRANGE("Posting Date", 0D, ToDate);
                    end;
                }
                dataitem("Balance Forward"; Integer)
                {
                    DataItemTableView = SORTING(Number)
                                        WHERE(Number = CONST(1));
                    column(BalanceToPrintLCY; BalanceToPrintLCY)
                    {
                    }
                    column(FORMAT_FromDate___1_; FORMAT(FromDate - 1))
                    {
                    }
                    column(Balance_ForwardCaption; Balance_ForwardCaptionLbl)
                    {
                    }
                    column(Bal_FwdCaption; Bal_FwdCaptionLbl)
                    {
                    }
                    column(Balance_Forward_Number; Number)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        IF (StatementStyle <> StatementStyle::Balance) THEN
                            CurrReport.BREAK;
                    end;
                }
                dataitem(CustLedgerEntry3; "Cust. Ledger Entry")
                {
                    CalcFields = Amount, "Amount (LCY)", "Remaining Amount", "Remaining Amt. (LCY)";
                    DataItemLink = "Customer No." = FIELD("No.");
                    DataItemLinkReference = Customer;
                    DataItemTableView = SORTING("Customer No.", "Posting Date")
                                        WHERE("Remaining Amount" = FILTER(<> 0));
                    column(BalanceToPrint; BalanceToPrint)
                    {
                    }
                    column(FORMAT__Due_Date__; FORMAT("Due Date"))
                    {
                    }
                    column(CustLedgerEntry3__Document_No__; "Document No.")
                    {
                    }
                    column(CustLedgerEntry3__Document_Type_; "Document Type")
                    {
                    }
                    column(FORMAT__Posting_Date__; FORMAT("Posting Date"))
                    {
                    }
                    column(OpenDrBal; OpenDrBal)
                    {
                    }
                    column(OpenCrBal; ABS(OpenCrBal))
                    {
                    }
                    column(BalanceToPrintLCY_Control1500085; BalanceToPrintLCY)
                    {
                    }
                    column(CustLedgerEntry3__Due_Date__Control1500088; FORMAT("Due Date"))
                    {
                    }
                    column(CustLedgerEntry3__Document_No___Control1500089; "Document No.")
                    {
                    }
                    column(CustLedgerEntry3__Document_Type__Control1500090; "Document Type")
                    {
                    }
                    column(FORMAT__Posting_Date___Control1500091; FORMAT("Posting Date"))
                    {
                    }
                    column(OpenDrBalLCY; OpenDrBalLCY)
                    {
                    }
                    column(OpenCrBalLCY; OpenCrBalLCY)
                    {
                    }
                    column(CustLedgerEntry3_Entry_No_; "Entry No.")
                    {
                    }
                    column(CustLedgerEntry3_Customer_No_; "Customer No.")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        OpenCrBal := 0;
                        OpenDrBal := 0;
                        OpenCrBalLCY := 0;
                        OpenDrBalLCY := 0;
                        IF PrintLCY THEN BEGIN
                            BalanceToPrintLCY := BalanceToPrintLCY + "Remaining Amt. (LCY)";
                            IF "Remaining Amt. (LCY)" >= 0 THEN BEGIN
                                DebitBalance := DebitBalance + "Remaining Amt. (LCY)";
                                OpenDrBalLCY := "Remaining Amt. (LCY)";
                            END
                            ELSE BEGIN
                                CreditBalance := CreditBalance + "Remaining Amt. (LCY)";
                                OpenCrBalLCY := "Remaining Amt. (LCY)";
                            END
                        END ELSE BEGIN
                            BalanceToPrint := BalanceToPrint + "Remaining Amount";
                            IF "Remaining Amount" >= 0 THEN BEGIN
                                DebitBalance := DebitBalance + "Remaining Amount";
                                OpenDrBal := "Remaining Amount";
                            END ELSE BEGIN
                                CreditBalance := CreditBalance + "Remaining Amount";
                                OpenCrBal := "Remaining Amount";
                            END
                        END;
                    end;

                    trigger OnPreDataItem()
                    begin
                        IF (StatementStyle = StatementStyle::Balance) THEN
                            CurrReport.BREAK;
                        SETRANGE("Posting Date", 0D, ToDate);
                        SETRANGE("Date Filter", 0D, ToDate);
                    end;
                }
                dataitem("AgingCust. Ledger Entry"; "Cust. Ledger Entry")
                {
                    CalcFields = "Remaining Amount", "Remaining Amt. (LCY)";
                    DataItemLink = "Customer No." = FIELD("No.");
                    DataItemLinkReference = Customer;
                    DataItemTableView = SORTING("Customer No.", "Posting Date")
                                        WHERE("Remaining Amount" = FILTER(<> 0));

                    trigger OnAfterGetRecord()
                    begin
                        CASE AgingMethod OF
                            AgingMethod::"Due Date":
                                BEGIN
                                    IF (("Due Date" >= Periodstartdate[1]) AND ("Due Date" <= PeriodEndingDate[1])) THEN BEGIN
                                        TempCustLedgerEntry1.INIT;
                                        TempCustLedgerEntry1 := "AgingCust. Ledger Entry";
                                        TempCustLedgerEntry1.INSERT;
                                    END;
                                    IF (("Due Date" >= Periodstartdate[2]) AND ("Due Date" <= PeriodEndingDate[2])) THEN BEGIN
                                        TempCustLedgerEntry2.INIT;
                                        TempCustLedgerEntry2 := "AgingCust. Ledger Entry";
                                        TempCustLedgerEntry2.INSERT;
                                    END;
                                    IF (("Due Date" >= Periodstartdate[3]) AND ("Due Date" <= PeriodEndingDate[3])) THEN BEGIN
                                        TempCustLedgerEntry3.INIT;
                                        TempCustLedgerEntry3 := "AgingCust. Ledger Entry";
                                        TempCustLedgerEntry3.INSERT;
                                    END;
                                    IF (("Due Date" >= Periodstartdate[4]) AND ("Due Date" <= PeriodEndingDate[4])) THEN BEGIN
                                        TempCustLedgerEntry4.INIT;
                                        TempCustLedgerEntry4 := "AgingCust. Ledger Entry";
                                        TempCustLedgerEntry4.INSERT;
                                    END;
                                END;

                            AgingMethod::"Trans Date", AgingMethod::None:
                                BEGIN
                                    IF (("Posting Date" >= Periodstartdate[1]) AND ("Posting Date" <= PeriodEndingDate[1])) THEN BEGIN
                                        TempCustLedgerEntry1.INIT;
                                        TempCustLedgerEntry1 := "AgingCust. Ledger Entry";
                                        TempCustLedgerEntry1.INSERT;
                                    END;
                                    IF (("Posting Date" >= Periodstartdate[2]) AND ("Posting Date" <= PeriodEndingDate[2])) THEN BEGIN
                                        TempCustLedgerEntry2.INIT;
                                        TempCustLedgerEntry2 := "AgingCust. Ledger Entry";
                                        TempCustLedgerEntry2.INSERT;
                                    END;
                                    IF (("Posting Date" >= Periodstartdate[3]) AND ("Posting Date" <= PeriodEndingDate[3])) THEN BEGIN
                                        TempCustLedgerEntry3.INIT;
                                        TempCustLedgerEntry3 := "AgingCust. Ledger Entry";
                                        TempCustLedgerEntry3.INSERT;
                                    END;
                                    IF (("Posting Date" >= Periodstartdate[4]) AND ("Posting Date" <= PeriodEndingDate[4])) THEN BEGIN
                                        TempCustLedgerEntry4.INIT;
                                        TempCustLedgerEntry4 := "AgingCust. Ledger Entry";
                                        TempCustLedgerEntry4.INSERT;
                                    END;
                                END;

                            AgingMethod::"Doc Date":
                                BEGIN
                                    IF (("Document Date" >= Periodstartdate[1]) AND ("Document Date" <= PeriodEndingDate[1])) THEN BEGIN
                                        TempCustLedgerEntry1.INIT;
                                        TempCustLedgerEntry1 := "AgingCust. Ledger Entry";
                                        TempCustLedgerEntry1.INSERT;
                                    END;
                                    IF (("Document Date" >= Periodstartdate[2]) AND ("Document Date" <= PeriodEndingDate[2])) THEN BEGIN
                                        TempCustLedgerEntry2.INIT;
                                        TempCustLedgerEntry2 := "AgingCust. Ledger Entry";
                                        TempCustLedgerEntry2.INSERT;
                                    END;
                                    IF (("Document Date" >= Periodstartdate[3]) AND ("Document Date" <= PeriodEndingDate[3])) THEN BEGIN
                                        TempCustLedgerEntry3.INIT;
                                        TempCustLedgerEntry3 := "AgingCust. Ledger Entry";
                                        TempCustLedgerEntry3.INSERT;
                                    END;
                                    IF (("Document Date" >= Periodstartdate[4]) AND ("Document Date" <= PeriodEndingDate[4])) THEN BEGIN
                                        TempCustLedgerEntry4.INIT;
                                        TempCustLedgerEntry4 := "AgingCust. Ledger Entry";
                                        TempCustLedgerEntry4.INSERT;
                                    END;
                                END;
                        END;
                    end;

                    trigger OnPreDataItem()
                    begin
                        SETRANGE("Posting Date", 0D, ToDate);
                        SETRANGE("Date Filter", 0D, ToDate);
                    end;
                }
                dataitem("Detailed Cust. Ledg. Entry"; "Detailed Cust. Ledg. Entry")
                {
                    DataItemLink = "Customer No." = FIELD("No.");
                    DataItemLinkReference = Customer;
                    DataItemTableView = SORTING("Customer No.", "Posting Date");
                    column(BalanceToPrint_Control1500052; BalanceToPrint)
                    {
                    }
                    column(Detailed_Cust__Ledg__Entry__Credit_Amount_; "Credit Amount")
                    {
                    }
                    column(Detailed_Cust__Ledg__Entry__Debit_Amount_; "Debit Amount")
                    {
                    }
                    column(FORMAT_DueDate_; FORMAT(DueDate))
                    {
                    }
                    column(Detailed_Cust__Ledg__Entry__Document_No__; "Document No.")
                    {
                    }
                    column(Detailed_Cust__Ledg__Entry__Document_Type_; "Document Type")
                    {
                    }
                    column(FORMAT__Posting_Date___Control1500058; FORMAT("Posting Date"))
                    {
                    }
                    column(BalanceToPrintLCY_Control1500059; BalanceToPrintLCY)
                    {
                    }
                    column(Detailed_Cust__Ledg__Entry__Credit_Amount__LCY__; "Credit Amount (LCY)")
                    {
                    }
                    column(Detailed_Cust__Ledg__Entry__Debit_Amount__LCY__; "Debit Amount (LCY)")
                    {
                    }
                    column(FORMAT_DueDate__Control1500062; FORMAT(DueDate))
                    {
                    }
                    column(Detailed_Cust__Ledg__Entry__Document_No___Control1500063; "Document No.")
                    {
                    }
                    column(Detailed_Cust__Ledg__Entry__Document_Type__Control1500064; "Document Type")
                    {
                    }
                    column(FORMAT__Posting_Date___Control1500065; FORMAT("Posting Date"))
                    {
                    }
                    column(StatementComplete; StatementComplete)
                    {
                    }
                    column(Detailed_Cust__Ledg__Entry_Entry_No_; "Entry No.")
                    {
                    }
                    column(Detailed_Cust__Ledg__Entry_Customer_No_; "Customer No.")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        CustLedEntry.RESET;
                        CustLedEntry.SETRANGE("Entry No.", "Cust. Ledger Entry No.");
                        IF CustLedEntry.FINDFIRST THEN
                            REPEAT
                                DueDate := CustLedEntry."Due Date";
                            UNTIL CustLedEntry.NEXT = 0;
                        IF PrintLCY THEN BEGIN
                            BalanceToPrintLCY := BalanceToPrintLCY + "Amount (LCY)";
                            IF "Amount (LCY)" >= 0 THEN
                                DebitBalance := DebitBalance + "Amount (LCY)"
                            ELSE
                                CreditBalance := CreditBalance + "Amount (LCY)";
                        END ELSE BEGIN
                            BalanceToPrint := BalanceToPrint + Amount;
                            IF Amount >= 0 THEN
                                DebitBalance := DebitBalance + Amount
                            ELSE
                                CreditBalance := CreditBalance + Amount;
                        END;
                    end;

                    trigger OnPreDataItem()
                    begin
                        IF (StatementStyle <> StatementStyle::Balance) THEN
                            CurrReport.BREAK;
                        SETRANGE("Posting Date", FromDate, ToDate);
                    end;
                }
                dataitem(EndOfCustomer; Integer)
                {
                    DataItemTableView = SORTING(Number)
                                        WHERE(Number = CONST(1));
                    column(Just_For_Adding_One_Record_to_Dataset_; 'Just For Adding One Record to Dataset')
                    {
                    }
                    column(EndOfCustomer_Number; Number)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        StatementComplete := TRUE;
                        IF UpdateNumbers AND (NOT CurrReport.PREVIEW) THEN BEGIN
                            Customer.MODIFY; //  just update the Last Statement No
                            COMMIT;
                        END;

                        IF ISSERVICETIER THEN BEGIN
                            CalcOpenLedgEntry;
                            IF (AgingMethod = AgingMethod::"Due Date") THEN
                                AgingDaysText := Text1500009
                            ELSE
                                AgingDaysText := Text1500010;

                            IF PrintLCY AND (StatementStyle = StatementStyle::Balance) THEN
                                StatementBalance := BalanceToPrintLCY
                            ELSE
                                IF (NOT PrintLCY) AND (StatementStyle = StatementStyle::Balance) THEN
                                    StatementBalance := BalanceToPrint
                                ELSE
                                    IF StatementStyle = StatementStyle::"Open Item" THEN
                                        StatementBalance := BalanceToPrint;
                        END;
                    end;
                }
            }

            trigger OnAfterGetRecord()
            begin
                DebitBalance := 0;
                CreditBalance := 0;
                CLEAR(AmountDue);
                Print := FALSE;
                IF AllHavingBalance THEN BEGIN
                    SETRANGE("Date Filter", 0D, ToDate);
                    CALCFIELDS("Net Change");
                    Print := "Net Change" <> 0;
                END;
                IF (NOT Print) AND AllHavingEntries THEN BEGIN
                    "Cust. Ledger Entry".RESET;
                    IF (StatementStyle = StatementStyle::Balance) THEN BEGIN
                        "Cust. Ledger Entry".SETCURRENTKEY("Customer No.", "Posting Date");
                        "Cust. Ledger Entry".SETRANGE("Posting Date", FromDate, ToDate);
                    END ELSE BEGIN
                        "Cust. Ledger Entry".SETCURRENTKEY("Customer No.", "Posting Date");
                        "Cust. Ledger Entry".SETRANGE("Posting Date", FromDate, ToDate);
                        "Cust. Ledger Entry".SETRANGE(Open, TRUE);
                    END;
                    "Cust. Ledger Entry".SETRANGE("Customer No.", "No.");
                    Print := "Cust. Ledger Entry".FIND('-');
                END;

                IF NOT Print THEN
                    CurrReport.SKIP;
                //CurrExchRate.SETRANGE("Currency Code","Cust. Ledger Entry"."Currency Code");
                //IF CurrExchRate.FIND('-') THEN
                //  ExchangeRate := CurrExchRate."Relational Exch. Rate Amount";
                IF (StatementStyle = StatementStyle::Balance) THEN BEGIN
                    SETRANGE("Date Filter", 0D, FromDate - 1);
                    //CALCFIELDS("Net Change");
                    CALCFIELDS("Net Change", "Net Change (LCY)");
                    BalanceToPrint := "Net Change";
                    SETRANGE("Date Filter");
                    //IF (PrintLCY) AND ("Currency Code" <> '') THEN
                    //   BalanceToPrintLCY := "Net Change" * ExchangeRate
                    IF PrintLCY THEN
                        BalanceToPrintLCY := "Net Change (LCY)"
                    ELSE
                        BalanceToPrintLCY := "Net Change";
                END ELSE BEGIN
                    BalanceToPrint := 0;
                    BalanceToPrintLCY := 0;
                END;

                /* Update Statement Number so it can be printed on the document. However,
                  defer actually updating the customer file until the statement is complete. */
                IF "Last Statement No." >= 9999 THEN
                    "Last Statement No." := 1
                ELSE
                    "Last Statement No." := "Last Statement No." + 1;
                CurrReport.PAGENO := 1;

                FormatAddress.Customer(CustomerAddress, Customer);
                LedgEntryLast := 0;
                StatementComplete := FALSE;

            end;

            trigger OnPreDataItem()
            begin
                //IF STRPOS(OSVERSION,'NT') = 0 THEN
                //  OSSystem := OSSystem::Windows
                //ELSE
                //  OSSystem := OSSystem::NT;

                /* remove user-entered date filter; info now in FromDate & ToDate */
                SETRANGE("Date Filter");
                CalcAging;

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
                    field(AllHavingEntries; AllHavingEntries)
                    {
                        Caption = 'Print All with Entries';
                        ApplicationArea = All;
                    }
                    field(AllHavingBalance; AllHavingBalance)
                    {
                        Caption = 'Print All with Balance';
                        ApplicationArea = All;
                    }
                    field(UpdateNumbers; UpdateNumbers)
                    {
                        Caption = 'Update Statement No.';
                        ApplicationArea = All;
                    }
                    field(PrintCompany; PrintCompany)
                    {
                        Caption = 'Print Company Address';
                        ApplicationArea = All;
                    }
                    field(PrintLCY; PrintLCY)
                    {
                        Caption = 'Print in LCY';
                        ApplicationArea = All;
                    }
                    field(StatementStyle; StatementStyle)
                    {
                        Caption = 'Statement Style';
                        OptionCaption = 'Open Item,Balance';
                        ApplicationArea = All;
                    }
                    field(AgingMethod; AgingMethod)
                    {
                        Caption = 'Aged By';
                        OptionCaption = 'None,Due Date,Trans Date,Doc Date';
                        ApplicationArea = All;
                    }
                    field(PeriodCalculation; PeriodCalculation)
                    {
                        Caption = 'Length of Aging Periods';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            IF (AgingMethod <> AgingMethod::None) AND (PeriodCalculation = '') THEN
                                ERROR('You must enter a Length of Aging Periods if you select aging.');
                        end;
                    }
                }
            }
        }
        actions
        {
        }
        trigger OnOpenPage()
        begin
            IF (NOT AllHavingEntries) AND (NOT AllHavingBalance) THEN
                AllHavingBalance := TRUE;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        IF PrintLCY THEN
            CurrencyLabel := 'Local (LCY)'
        ELSE
            CurrencyLabel := 'Customer';

        IF (NOT AllHavingEntries) AND (NOT AllHavingBalance) THEN
            ERROR(Text1500001);
        IF UpdateNumbers AND (CurrReport.PREVIEW) THEN
            ERROR(Text1500002);
        FromDate := Customer.GETRANGEMIN("Date Filter");
        ToDate := Customer.GETRANGEMAX("Date Filter");

        IF (StatementStyle = StatementStyle::Balance) AND (FromDate = ToDate) THEN
            ERROR(Text1500003);

        IF (AgingMethod <> AgingMethod::None) AND (PeriodCalculation = '') THEN
            ERROR(Text1500004);

        IF PrintCompany THEN BEGIN
            CompanyInformation.GET('');
            FormatAddress.Company(CompanyAddress, CompanyInformation);
            PhoneNo := 'Phone No.';
            FaxNo := 'Fax No.';
            VATRegNo := 'VAT Reg. No.';
            GiroNo := 'GIRO No.';
            Bank := 'Bank';
            AccountNo := 'Account No.';
        END;// ELSE
            // CLEAR(CompanyAddress);
            //0.01--->>Begin
        IF CompanyInfo.GET THEN BEGIN
            CompanyInfo.CALCFIELDS(CompanyInfo.Picture);
            //0.01--->>END
            FormatAddress.Company(CompanyAdd, CompanyInfo);

        END;


        CompanyInfo.CALCFIELDS(Picture);
    end;

    var
        OpenDrBal: Decimal;
        OpenDrBalLCY: Decimal;
        OpenCrBal: Decimal;
        OpenCrBalLCY: Decimal;
        Periodstartdate: array[5] of Date;
        StatementBalance: Decimal;
        PeriodLength2: DateFormula;
        ExchangeRate: Decimal;
        FaxNo: Text[50];
        VATRegNo: Text[50];
        GiroNo: Text[50];
        Bank: Text[50];
        AccountNo: Text[50];
        CompanyInformation: Record "Company Information";
        FormatAddress: Codeunit "Format Address";
        StatementStyle: Option "Open Item",Balance;
        AllHavingEntries: Boolean;
        AllHavingBalance: Boolean;
        UpdateNumbers: Boolean;
        PhoneNo: Text[50];
        AgingMethod: Option "None","Due Date","Trans Date","Doc Date";
        PrintCompany: Boolean;
        PeriodCalculation: Code[10];
        Print: Boolean;
        FromDate: Date;
        ToDate: Date;
        AgingDate: Date;
        CustomerAddress: array[8] of Text[50];
        CompanyAddress: array[8] of Text[50];
        BalanceToPrint: Decimal;
        BalanceToPrintLCY: Decimal;
        DebitBalance: Decimal;
        CreditBalance: Decimal;
        AgingHead: array[4] of Text[14];
        CurrencyLabel: Text[30];
        AmountDue: array[4] of Decimal;
        AgingDaysText: Text[16];
        PeriodEndingDate: array[5] of Date;
        StatementComplete: Boolean;
        PrintLCY: Boolean;
        i: Integer;
        LedgEntryLast: Integer;
        OSSystem: Option Windows,NT;
        Text1500000: Label 'Aged statements have limit of %1 open ledger entries per customer.';
        Text1500001: Label 'You must select either All with Entries or All with Balance.';
        Text1500002: Label 'You must print statements if you want to update statement numbers.';
        Text1500003: Label 'You must enter a range of dates (not just one date) in the Date Filter if you want to print Balance Forward Statements.';
        Text1500004: Label 'You must enter a Length of Aging Periods if you select aging.';
        Text1500005: Label 'days';
        Text1500006: Label 'Over';
        Text1500007: Label 'Upto';
        Text1500008: Label 'The Date Formula %1 cannot be used. Try to restate it. E.g. 1M+CM instead of CM+1M.';
        Currencies: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        TempCustLedgerEntry1: Record "Cust. Ledger Entry" temporary;
        TempCustLedgerEntry2: Record "Cust. Ledger Entry" temporary;
        TempCustLedgerEntry3: Record "Cust. Ledger Entry" temporary;
        TempCustLedgerEntry4: Record "Cust. Ledger Entry" temporary;
        AgingAmount: array[4] of Decimal;
        CustLedEntry: Record "Cust. Ledger Entry";
        DueDate: Date;
        Text1500009: Label 'Days overdue:';
        Text1500010: Label 'Days old:';
        CompanyInfo: Record "Company Information";
        CompanyAdd: array[8] of Text[50];
        STATEMENTCaptionLbl: Label 'STATEMENT';
        Statement_Date_CaptionLbl: Label 'Statement Date:';
        Account_Number_CaptionLbl: Label 'Account Number:';
        Currency_CaptionLbl: Label 'Currency:';
        Page_CaptionLbl: Label 'Page:';
        BalanceCaptionLbl: Label 'Balance';
        CreditsCaptionLbl: Label 'Credits';
        DebitsCaptionLbl: Label 'Debits';
        Due_DateCaptionLbl: Label 'Due Date';
        No_CaptionLbl: Label 'No.';
        DocumentCaptionLbl: Label 'Document';
        DateCaptionLbl: Label 'Date';
        Statement_BalanceCaptionLbl: Label 'Statement Balance';
        Statement_BalanceCaption_Control1500071Lbl: Label 'Statement Balance';
        Statement_Aging_CaptionLbl: Label 'Statement Aging:';
        Aged_Amounts_CaptionLbl: Label 'Aged Amounts:';
        Balance_ForwardCaptionLbl: Label 'Balance Forward';
        Bal_FwdCaptionLbl: Label 'Bal Fwd';

    procedure GetTermsString(var CustLedgerEntry: Record "Cust. Ledger Entry"): Text[250]
    var
        InvoiceHeader: Record "Sales Invoice Header";
        PaymentTerms: Record "Payment Terms";
    begin
        WITH CustLedgerEntry DO BEGIN
            IF ("Document No." = '') OR ("Document Type" <> "Document Type"::Invoice) THEN
                EXIT('');

            IF InvoiceHeader.READPERMISSION THEN
                IF InvoiceHeader.GET("Document No.") THEN
                    IF PaymentTerms.GET(InvoiceHeader."Payment Terms Code") THEN BEGIN
                        IF PaymentTerms.Description <> '' THEN
                            EXIT(PaymentTerms.Description)
                        ELSE
                            EXIT(InvoiceHeader."Payment Terms Code");
                    END ELSE
                        EXIT(InvoiceHeader."Payment Terms Code");
        END;

        IF Customer."Payment Terms Code" <> '' THEN
            IF PaymentTerms.GET(Customer."Payment Terms Code") THEN BEGIN
                IF PaymentTerms.Description <> '' THEN
                    EXIT(PaymentTerms.Description)
                ELSE
                    EXIT(Customer."Payment Terms Code");
            END ELSE
                EXIT(Customer."Payment Terms Code");

        EXIT('');
    end;

    procedure CalcAging()
    begin
        IF AgingMethod = AgingMethod::None THEN
            EXIT;
        AgingDaysText := '';
        EVALUATE(PeriodLength2, '-' + FORMAT(PeriodCalculation));
        IF AgingMethod = AgingMethod::"Due Date" THEN BEGIN
            PeriodEndingDate[1] := 99991231D;
            Periodstartdate[1] := ToDate + 1;
        END ELSE BEGIN
            PeriodEndingDate[1] := ToDate;
            Periodstartdate[1] := CALCDATE(PeriodLength2, ToDate + 1);
        END;
        FOR i := 2 TO 4 DO BEGIN
            PeriodEndingDate[i] := Periodstartdate[i - 1] - 1;
            Periodstartdate[i] := CALCDATE(PeriodLength2, PeriodEndingDate[i] + 1);
        END;
        Periodstartdate[i] := 0D;
        FOR i := 1 TO 4 DO
            IF PeriodEndingDate[i] < Periodstartdate[i] THEN
                ERROR(Text1500008, PeriodCalculation);
        IF AgingMethod = AgingMethod::"Due Date" THEN BEGIN
            i := 2;
            WHILE i < 4 DO BEGIN
                AgingHead[i] := STRSUBSTNO('%1 - %2 %3', ToDate - PeriodEndingDate[i] + 1, ToDate - Periodstartdate[i] + 1, Text1500005);
                i := i + 1;
            END;
            AgingHead[1] := 'Current';
            AgingHead[2] := STRSUBSTNO('%1 %2 %3', Text1500007, ToDate - Periodstartdate[2] + 1, Text1500005);
        END ELSE
            i := 1;

        WHILE i < 4 DO BEGIN
            AgingHead[1] := 'Current';
            AgingHead[i] := STRSUBSTNO('%1 - %2 %3', ToDate - PeriodEndingDate[i] + 1, ToDate - Periodstartdate[i] + 1, Text1500005);
            i := i + 1;
        END;
        AgingHead[i] := STRSUBSTNO('%1 %2 %3', Text1500006, ToDate - Periodstartdate[i - 1] + 1, Text1500005);
    end;

    procedure CalcOpenLedgEntry()
    begin
        CLEAR(AgingAmount);
        IF (NOT PrintLCY) THEN BEGIN
            TempCustLedgerEntry1.RESET;
            TempCustLedgerEntry1.SETRANGE("Customer No.", "AgingCust. Ledger Entry"."Customer No.");
            TempCustLedgerEntry1.SETRANGE("Date Filter", 0D, ToDate);
            TempCustLedgerEntry1.SETRANGE("Posting Date", 0D, ToDate);
            IF TempCustLedgerEntry1.FIND('-') THEN
                REPEAT
                    TempCustLedgerEntry1.CALCFIELDS("Remaining Amount");
                    AgingAmount[1] += TempCustLedgerEntry1."Remaining Amount";
                UNTIL TempCustLedgerEntry1.NEXT = 0;
        END ELSE BEGIN
            TempCustLedgerEntry1.RESET;
            TempCustLedgerEntry1.SETRANGE("Customer No.", "AgingCust. Ledger Entry"."Customer No.");
            TempCustLedgerEntry1.SETRANGE("Date Filter", 0D, ToDate);
            TempCustLedgerEntry1.SETRANGE("Posting Date", 0D, ToDate);
            IF TempCustLedgerEntry1.FIND('-') THEN
                REPEAT
                    TempCustLedgerEntry1.CALCFIELDS("Remaining Amt. (LCY)");
                    AgingAmount[1] += TempCustLedgerEntry1."Remaining Amt. (LCY)";
                UNTIL TempCustLedgerEntry1.NEXT = 0;
        END;
        IF (NOT PrintLCY) THEN BEGIN
            TempCustLedgerEntry2.RESET;
            TempCustLedgerEntry2.SETRANGE("Customer No.", "AgingCust. Ledger Entry"."Customer No.");
            TempCustLedgerEntry2.SETRANGE("Date Filter", 0D, ToDate);
            TempCustLedgerEntry2.SETRANGE("Posting Date", 0D, ToDate);
            IF TempCustLedgerEntry2.FIND('-') THEN
                REPEAT
                    TempCustLedgerEntry2.CALCFIELDS("Remaining Amount");
                    AgingAmount[2] += TempCustLedgerEntry2."Remaining Amount";
                UNTIL TempCustLedgerEntry2.NEXT = 0;
        END ELSE BEGIN
            TempCustLedgerEntry2.RESET;
            TempCustLedgerEntry2.SETRANGE("Customer No.", "AgingCust. Ledger Entry"."Customer No.");
            TempCustLedgerEntry2.SETRANGE("Date Filter", 0D, ToDate);
            TempCustLedgerEntry2.SETRANGE("Posting Date", 0D, ToDate);
            IF TempCustLedgerEntry2.FIND('-') THEN
                REPEAT
                    TempCustLedgerEntry2.CALCFIELDS("Remaining Amt. (LCY)");
                    AgingAmount[2] += TempCustLedgerEntry2."Remaining Amt. (LCY)";
                UNTIL TempCustLedgerEntry2.NEXT = 0;
        END;
        IF (NOT PrintLCY) THEN BEGIN
            TempCustLedgerEntry3.RESET;
            TempCustLedgerEntry3.SETRANGE("Customer No.", "AgingCust. Ledger Entry"."Customer No.");
            TempCustLedgerEntry3.SETRANGE("Date Filter", 0D, ToDate);
            TempCustLedgerEntry3.SETRANGE("Posting Date", 0D, ToDate);
            IF TempCustLedgerEntry3.FIND('-') THEN
                REPEAT
                    TempCustLedgerEntry3.CALCFIELDS("Remaining Amount");
                    AgingAmount[3] += TempCustLedgerEntry3."Remaining Amount";
                UNTIL TempCustLedgerEntry3.NEXT = 0;
        END ELSE BEGIN
            TempCustLedgerEntry3.RESET;
            TempCustLedgerEntry3.SETRANGE("Customer No.", "AgingCust. Ledger Entry"."Customer No.");
            TempCustLedgerEntry3.SETRANGE("Date Filter", 0D, ToDate);
            TempCustLedgerEntry3.SETRANGE("Posting Date", 0D, ToDate);
            IF TempCustLedgerEntry3.FIND('-') THEN
                REPEAT
                    TempCustLedgerEntry3.CALCFIELDS("Remaining Amount");
                    AgingAmount[3] += TempCustLedgerEntry3."Remaining Amount";
                UNTIL TempCustLedgerEntry3.NEXT = 0;
        END;
        IF (NOT PrintLCY) THEN BEGIN
            TempCustLedgerEntry4.RESET;
            TempCustLedgerEntry4.SETRANGE("Customer No.", "AgingCust. Ledger Entry"."Customer No.");
            TempCustLedgerEntry4.SETRANGE("Date Filter", 0D, ToDate);
            TempCustLedgerEntry4.SETRANGE("Posting Date", 0D, ToDate);
            IF TempCustLedgerEntry4.FIND('-') THEN
                REPEAT
                    TempCustLedgerEntry4.CALCFIELDS("Remaining Amount");
                    AgingAmount[4] += TempCustLedgerEntry4."Remaining Amount";
                UNTIL TempCustLedgerEntry4.NEXT = 0;
        END ELSE BEGIN
            TempCustLedgerEntry4.RESET;
            TempCustLedgerEntry4.SETRANGE("Customer No.", "AgingCust. Ledger Entry"."Customer No.");
            TempCustLedgerEntry4.SETRANGE("Date Filter", 0D, ToDate);
            TempCustLedgerEntry4.SETRANGE("Posting Date", 0D, ToDate);
            IF TempCustLedgerEntry4.FIND('-') THEN
                REPEAT
                    TempCustLedgerEntry4.CALCFIELDS("Remaining Amount");
                    AgingAmount[4] += TempCustLedgerEntry4."Remaining Amount";
                UNTIL TempCustLedgerEntry4.NEXT = 0;
        END;
    end;

    procedure UpdateVariables(Period2: Code[10]; AllEntries: Boolean; ALlBalance: Boolean)
    begin
        PeriodCalculation := Period2;
        AllHavingEntries := AllEntries;
        AllHavingBalance := ALlBalance;
        AgingMethod := AgingMethod::"Due Date";
    end;
}

