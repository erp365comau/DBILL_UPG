pageextension 50020 "Bank Acc. Reconcil. LinesExt" extends "Bank Acc. Reconciliation Lines"
{
    layout
    {
        addafter("Statement Amount")
        {
            field(Check; Rec.Check)
            {
                ApplicationArea = all;
            }
        }
    }
}