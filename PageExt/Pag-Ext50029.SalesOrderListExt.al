pageextension 50029 SalesOrdersList extends "Sales Order List"
{
    layout
    {
        addlast(Control1)
        {
            field("Unit Price Changed"; Rec."Unit Price Changed")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addlast(processing)
        {
            action("Check Unit Price")
            {
                ApplicationArea = all;
                trigger OnAction()
                begin
                    Codeunit.Run(50020);
                end;
            }
            action("Export Proforma")
            {
                ApplicationArea = all;
                Image = Print;

                trigger OnAction()
                begin
                    CLEAR(SalesHeader);
                    SalesHeader.SETRANGE("Document Type", Rec."Document Type");
                    SalesHeader.SETRANGE("No.", Rec."No.");
                    REPORT.RUNMODAL(REPORT::"Export - Proforma - Order", TRUE, FALSE, SalesHeader);
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
                    REPORT.RUNMODAL(REPORT::"Export - Proforma LCY - Order", TRUE, FALSE, SalesHeader);
                end;
            }
            action("Import Sales Orders")
            {
                ApplicationArea = all;
                Image = Excel;

                trigger OnAction()
                var
                    SalesOrderExcelImport: Codeunit "Sales Order Excel Import";
                begin
                    SalesOrderExcelImport.ReadExcelSheet();
                end;
            }
        }
    }
    var
        SalesHeader: Record "Sales Header";
}