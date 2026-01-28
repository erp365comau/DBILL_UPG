pageextension 50014 "Posted Sales InvoiceExt" extends "Posted Sales Invoice"
{
    layout
    {
        addafter("EU 3-Party Trade")
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
    actions
    {
        addlast(processing)
        {
            action("ExportInvoice")
            {
                ApplicationArea = all;
                Image = Print;

                trigger OnAction()
                begin
                    //Austral Sugeevan 13/10/2014 >>>
                    CLEAR(SalesInvHeader);
                    SalesInvHeader.SETRANGE("No.", Rec."No.");
                    REPORT.RUNMODAL(REPORT::"Export - Invoice", TRUE, FALSE, SalesInvHeader);
                    //Austral Sugeevan 13/10/2014 <<<
                end;
            }
            action(" PrintOld")
            {
                ApplicationArea = all;
                Image = Print;

                trigger OnAction()
                begin
                    //J13049 >>> 
                    SalesInvHeader := Rec;
                    CurrPage.SETSELECTIONFILTER(SalesInvHeader);
                    REPORT.RUNMODAL(50087, TRUE, FALSE, SalesInvHeader);
                    //J13049 <<<
                end;
            }
        }
    }
    var
        SalesInvHeader: Record "Sales Invoice Header";
}
