pageextension 50004 "Customer Ledger EntriesExt" extends "Customer Ledger Entries"
{
    actions
    {
        addlast(processing)
        {
            action("Print Delivery Docket")
            {
                ApplicationArea = all;
                trigger OnAction()
                var
                    SalesInvLine: Record "Sales Invoice Line";
                    TempSalesShptLine: Record "Sales Shipment Line";
                    SalesShipmentHeader: Record "Sales Shipment Header";
                //DeliveryDocketReport: Report "Delivery Docket - AD BA";
                begin
                    if Rec."Document Type" <> Rec."Document Type"::Invoice THEN
                        EXIT;
                    SalesInvLine.SETRANGE("Document No.", Rec."Document No.");
                    SalesInvLine.SETRANGE(Type, SalesInvLine.Type::Item);
                    IF SalesInvLine.FINDFIRST THEN BEGIN
                        REPEAT
                            SalesInvLine.GetSalesShptLines(TempSalesShptLine);
                        UNTIL SalesInvLine.NEXT = 0;
                        IF TempSalesShptLine.FINDFIRST THEN BEGIN
                            SalesShipmentHeader.SETRANGE("No.", TempSalesShptLine."Document No.");
                            // REPORT.RUNMODAL(REPORT::"Delivery Docket - AD BA", TRUE, FALSE, SalesShipmentHeader);
                        END;
                    END;
                end;
            }
        }
    }
}