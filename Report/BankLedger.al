report 50073 "Bank Ledger"
{
    Permissions = TableData 17 = rimd,
                  TableData 271 = rimd;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Bank Account Ledger Entry"; "Bank Account Ledger Entry")
        {
            DataItemTableView = WHERE("Entry No." = CONST(1659290));

            trigger OnAfterGetRecord()
            begin
                "Posting Date" := 20181031D;
                "Document Date" := 20181031D;

                Open := FALSE;
                MODIFY;
            end;
        }
        dataitem("G/L Entry"; "G/L Entry")
        {
            DataItemTableView = WHERE("Entry No." = FILTER(1659290 | 1659291));

            trigger OnAfterGetRecord()
            begin
                "G/L Entry"."Posting Date" := 20181031D;
                "G/L Entry"."Document Date" := 20181031D;
                "G/L Entry".MODIFY;
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

