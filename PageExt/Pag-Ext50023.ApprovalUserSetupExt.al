pageextension 50023 "Approval User SetupExt" extends "Approval User Setup"
{
    layout
    {
        addafter("E-Mail")
        {
            field("Recipient E-Mail"; Rec."Recipient E-Mail")
            {
                ApplicationArea = all;
            }
        }
    }
}