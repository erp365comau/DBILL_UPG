pageextension 50015 "Posted Sales InvoicesExt" extends "Posted Sales Invoices"
{
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
            action("PrintOld")
            {
                ApplicationArea = all;
                Image = Print;

                trigger OnAction()
                begin
                    //J13049 >>> 
                    SalesInvHeader := Rec;
                    CurrPage.SETSELECTIONFILTER(SalesInvHeader);
                    REPORT.RUNMODAL(50087, TRUE, FALSE, SalesInvHeader);
                    //J13049 <<<}
                end;
            }
        }
    }
    var
        SalesInvHeader: Record "Sales Invoice Header";
}
