pageextension 50001 "General Ledger EntriesExt" extends "General Ledger Entries"
{
    layout
    {
        addafter(Description)
        {
            field(Description2; Rec.Description2)
            {
                ApplicationArea = all;
            }
            field(Description3; Rec.Description3)
            {
                ApplicationArea = all;
            }
        }
    }
}