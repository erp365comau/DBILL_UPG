pageextension 50002 "Customer CardExt" extends "Customer Card"
{
    layout
    {
        addafter("Home Page")
        {
            field("MSDS/Quotes Email"; Rec."MSDS/Quotes Email")
            {
                ApplicationArea = all;
            }
            field("Send Document Type"; Rec."Send Document Type")
            {
                ApplicationArea = all;
            }
            field("Quote Document Type"; Rec."Quote Document Type")
            {
                ApplicationArea = all;
            }
        }
        addlast(Payments)
        {
            field("Customer Bank Code"; Rec."Customer Bank Code")
            {
                ApplicationArea = all;
            }
        }
    }
}