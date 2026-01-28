report 50020 "Update Item VAT Prod Posting"
{
    // Austral Sugeevan 23/12/2015 >>> Designed this Report

    Caption = 'Update Item VAT Prod Posting';
    ProcessingOnly = true;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(Item; Item)
        {

            trigger OnAfterGetRecord()
            begin
                "VAT Prod. Posting Group" := 'VAT9';
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
        MESSAGE(STRSUBSTNO('Successfully Updated %1 Records.', FORMAT(Item.COUNT)));
    end;

    trigger OnPreReport()
    var
        Item2: Record Item;
    begin
        IF NOT CONFIRM(STRSUBSTNO('Total Records - %1 && Filtered Records - %2. Do you want to proceed?', FORMAT(Item2.COUNT),
                                      FORMAT(Item.COUNT))) THEN
            CurrReport.QUIT;
    end;
}

