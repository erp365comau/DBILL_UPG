pageextension 50008 "Sales QuoteExt" extends "Sales Quote"
{
    layout
    {
        addlast("Foreign Trade")
        {
            field("Shipping Mark"; Rec."Shipping Mark")
            {
                ApplicationArea = BasicEU;
            }
            field("Vessel No."; Rec."Vessel No.")
            {
                ApplicationArea = BasicEU;
            }
            field("Voyage No."; Rec."Voyage No.")
            {
                ApplicationArea = BasicEU;
            }
            field("Seal No."; Rec."Seal No.")
            {
                ApplicationArea = BasicEU;
            }
            field("Container No."; Rec."Container No.")
            {
                ApplicationArea = BasicEU;
            }
        }
    }
    actions
    {
        addlast(processing)
        {
            action("Export Proforma")
            {
                ApplicationArea = all;
                Image = Print;

                trigger OnAction()
                begin
                    CLEAR(SalesHeader);
                    SalesHeader.SETRANGE("Document Type", Rec."Document Type");
                    SalesHeader.SETRANGE("No.", Rec."No.");
                    REPORT.RUNMODAL(REPORT::"Export - Proforma", TRUE, FALSE, SalesHeader);
                end;
            }
            action("Export Proforma LCY")
            {
                ApplicationArea = all;
                Image = Print;

                trigger OnAction()
                begin
                    CLEAR(SalesHeader);
                    SalesHeader.SETRANGE("Document Type", Rec."Document Type");
                    SalesHeader.SETRANGE("No.", Rec."No.");
                    REPORT.RUNMODAL(REPORT::"Export - Proforma LCY", TRUE, FALSE, SalesHeader);
                end;
            }
        }
    }
    var
        SalesHeader: Record "Sales Header";
}
