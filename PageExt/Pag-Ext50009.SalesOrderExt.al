pageextension 50009 "Sales OrderExt" extends "Sales Order"
{

    layout
    {
        addlast(General)
        {
            field("Unit Price Changed"; Rec."Unit Price Changed")
            {
                ApplicationArea = all;
            }
        }
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
        modify(Post)
        {
            Visible = false;
        }
        addlast(processing)
        {
            action("Export Proforma")
            {
                ApplicationArea = all;
                trigger OnAction()
                begin
                    //Austral Sugeevan 26/10/2014 >>>
                    CLEAR(SalesHeader);
                    SalesHeader.SETRANGE("Document Type", Rec."Document Type");
                    SalesHeader.SETRANGE("No.", Rec."No.");
                    REPORT.RUNMODAL(REPORT::"Export - Proforma - Order", TRUE, FALSE, SalesHeader);
                    //Austral Sugeevan 26/10/2014 <<<}
                end;
            }
            action("ExportProformaLCY")
            {
                ApplicationArea = all;
                trigger OnAction()
                begin
                    //Austral Sugeevan 26/10/2014 >>>
                    CLEAR(SalesHeader);
                    SalesHeader.SETRANGE("Document Type", Rec."Document Type");
                    SalesHeader.SETRANGE("No.", Rec."No.");
                    REPORT.RUNMODAL(REPORT::"Export - Proforma LCY - Order", TRUE, FALSE, SalesHeader);
                    //Austral Sugeevan 26/10/2014 <<<}
                end;
            }
        }
        /*    modify("Foreign Trade")
           {
               visible = true;
           } */
    }
    procedure GetReportID(): Integer
    var
        RVReportSelection: Record "Report Selections";
        IVReport: Integer;
    begin
        RVReportSelection.RESET;
        IF RVReportSelection.GET(RVReportSelection.Usage::"S.Order", 1) THEN
            EXIT(RVReportSelection."Report ID");
    end;

    var
        SalesHeader: Record "Sales Header";
}
