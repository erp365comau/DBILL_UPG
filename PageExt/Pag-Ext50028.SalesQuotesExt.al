pageextension 50028 "Sales QuotesExt" extends "Sales Quotes"
{
    actions
    {
        addlast(processing)
        {
            action("ExportProforma")
            {
                ApplicationArea = all;
                Image = Print;

                trigger OnAction()
                begin
                    //Austral Sugeevan 13/10/2014 >>>
                    CLEAR(SalesHeader);
                    SalesHeader.SETRANGE("Document Type", Rec."Document Type");
                    SalesHeader.SETRANGE("No.", Rec."No.");
                    REPORT.RUNMODAL(REPORT::"Export - Proforma", TRUE, FALSE, SalesHeader);
                    //Austral Sugeevan 13/10/2014 <<<
                end;
            }
            action("ExportProformaLCY")
            {
                ApplicationArea = all;
                Image = Print;

                trigger OnAction()
                begin
                    //Austral Sugeevan 13/10/2014 >>>
                    CLEAR(SalesHeader);
                    SalesHeader.SETRANGE("Document Type", Rec."Document Type");
                    SalesHeader.SETRANGE("No.", Rec."No.");
                    REPORT.RUNMODAL(REPORT::"Export - Proforma LCY", TRUE, FALSE, SalesHeader);
                    //Austral Sugeevan 13/10/2014 <<<
                end;
            }
        }
    }
    var
        SalesHeader: Record "Sales Header";
}
