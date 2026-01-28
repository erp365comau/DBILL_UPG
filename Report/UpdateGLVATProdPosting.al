report 50007 "Update GL VAT Prod Posting"
{
    // Austral Sugeevan 23/12/2015 >>> Designed this Report

    Caption = 'Update GL VAT Prod Posting';
    ProcessingOnly = true;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem("Sales Line"; "Sales Line")
        {

            trigger OnAfterGetRecord()
            begin
                VALIDATE("VAT Prod. Posting Group", 'VAT9');
                MODIFY;
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

    trigger OnPostReport()
    begin
        MESSAGE(STRSUBSTNO('Successfully Updated %1 Records.', FORMAT("Sales Line".COUNT)));
    end;

    trigger OnPreReport()
    var
        GLAccount: Record "G/L Account";
    begin
        IF NOT CONFIRM(STRSUBSTNO('Total Records - %1 && Filtered Records - %2. Do you want to proceed?', FORMAT("Sales Line".COUNT),
                                      FORMAT("Sales Line".COUNT))) THEN
            CurrReport.QUIT;
    end;
}

