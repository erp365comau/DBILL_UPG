pageextension 50005 "Vendor CardExt" extends "Vendor Card"
{
    layout
    {
        addafter("Home Page")
        {
            field("Fax No. 2"; Rec."Fax No. 2")
            {
                ApplicationArea = all;
            }
            field("E-Mail 2"; Rec."E-Mail 2")
            {
                ApplicationArea = all;
            }
            field("PO Document Type"; Rec."PO Document Type")
            {
                ApplicationArea = all;
            }
            field("Remittance Document Type"; Rec."Remittance Document Type")
            {
                ApplicationArea = all;
            }
        }
    }
}