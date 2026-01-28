pageextension 50006 "Vendor ListExt" extends "Vendor List"
{
    layout
    {
        addafter("Fax No.")
        {
            field(Balance; Rec.Balance)
            {
                ApplicationArea = all;
            }
        }
    }
}