report 50032 "UPDATE SHIPMENT LINE"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Report/UPDATESHIPMENTLINE.rdl';
    Permissions = TableData 111 = rm;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem("Sales Shipment Line"; "Sales Shipment Line")
        {
            DataItemTableView = WHERE(Type = CONST(Item));

            trigger OnAfterGetRecord()
            begin
                IF SalesLine.GET(SalesLine."Document Type"::Order, "Sales Shipment Line"."Order No.", "Sales Shipment Line"."Order Line No.") THEN BEGIN
                    "Sales Shipment Line"."Ordered Qty." := SalesLine.Quantity;
                    "Sales Shipment Line".MODIFY;
                END
                ELSE BEGIN
                    SalesShipLine.RESET;
                    SalesShipLine.SETRANGE(SalesShipLine."Order No.", "Sales Shipment Line"."Order No.");
                    SalesShipLine.SETRANGE(SalesShipLine."Order Line No.", "Sales Shipment Line"."Order Line No.");
                    IF SalesShipLine.FINDSET THEN
                        REPEAT
                            "Sales Shipment Line"."Ordered Qty." := "Sales Shipment Line"."Ordered Qty." + SalesShipLine.Quantity;
                            "Sales Shipment Line".MODIFY;
                        UNTIL SalesShipLine.NEXT = 0;
                END;
            end;

            trigger OnPostDataItem()
            begin
                MESSAGE('DONE');
            end;
        }
    }
    requestpage
    {

        layout
        {
        }
        actions
        {
        }
    }
    labels
    {
    }

    var
        SalesLine: Record "Sales Line";
        SalesShipLine: Record "Sales Shipment Line";
}

