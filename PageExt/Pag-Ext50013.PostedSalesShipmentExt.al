pageextension 50013 "Posted Sales ShipmentExt" extends "Posted Sales Shipment"
{
    layout
    {
        addafter("Shipment Date")
        {
            field("Shipping Mark"; Rec."Shipping Mark")
            {
                ApplicationArea = all;
            }
            field("Vessel No."; Rec."Vessel No.")
            {
                ApplicationArea = all;
            }
            field("Voyage No."; Rec."Voyage No.")
            {
                ApplicationArea = all;
            }
            field("Seal No."; Rec."Seal No.")
            {
                ApplicationArea = all;
            }
            field("Container No."; Rec."Container No.")
            {
                ApplicationArea = all;
            }
        }

    }
}