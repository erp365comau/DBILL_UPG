pageextension 50019 "Bank Account CardExt" extends "Bank Account Card"
{
    layout
    {
        addafter("EFT Balancing Record Required")
        {
            field("EFT File Type"; Rec."EFT File Type")
            {
                ApplicationArea = all;
            }
            field("EFT Bank User Number"; Rec."EFT Bank User Number")
            {
                ApplicationArea = all;
            }
            field("EFT UPS"; Rec."EFT UPS")
            {
                ApplicationArea = all;
            }
            field("VTS ID"; Rec."VTS ID")
            {
                ApplicationArea = all;
            }
            field("Bank Name"; Rec."Bank Name")
            {
                ApplicationArea = all;
            }
            field("EFT Bank Code 2"; Rec."EFT Bank Code")
            {
                ApplicationArea = all;
            }
            field("DD File Type"; Rec."DD File Type")
            {
                ApplicationArea = all;
            }
            field("DD Bank User Number"; Rec."DD Bank User Number")
            {
                ApplicationArea = all;
            }
            field("DD UPS"; Rec."DD UPS")
            {
                ApplicationArea = all;
            }
        }
    }
}