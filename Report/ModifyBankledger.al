report 50094 "Modify Bank ledger"
{
    Permissions = TableData 5601 = rimd;
    ProcessingOnly = true;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem("FA Ledger Entry"; "FA Ledger Entry")
        {

            trigger OnAfterGetRecord()
            begin
                IF COPYSTR("Document No.", 1, 8) = 'OPBAL-FA' THEN BEGIN
                    //"Bank Account Ledger Entry".Open := FALSE;
                    "FA Ledger Entry".Amount := ROUND(Amount, 0.01);
                    "FA Ledger Entry"."Debit Amount" := ROUND("Debit Amount", 0.01);
                    "FA Ledger Entry"."Credit Amount" := ROUND("Credit Amount", 0.01);
                    "FA Ledger Entry"."Amount (LCY)" := ROUND("Amount (LCY)", 0.01);

                    MODIFY;
                END;
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
}

