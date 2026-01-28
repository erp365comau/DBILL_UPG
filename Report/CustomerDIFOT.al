report 50025 "Customer DIFOT"
{
    // J14510 20201019 LK - ADD OPEN SALES ORDERS TO LIST - DESIGN CHANGE
    DefaultLayout = RDLC;
    RDLCLayout = 'Report/CustomerDIFOT.rdl';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Sales Shipment Header"; "Sales Shipment Header")
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Sell-to Customer No.", "No.", "Bill-to Customer No.", "Posting Date", "Shipment Date", "Order Date";
            column(No_SalesShipmentHeader; "Sales Shipment Header"."No.")
            {
            }
            column(SelltoCustomerNo_SalesShipmentHeader; "Sales Shipment Header"."Sell-to Customer No.")
            {
            }
            column(SelltoCustomerName_SalesShipmentHeader; "Sales Shipment Header"."Sell-to Customer Name")
            {
            }
            column(OrderDate_SalesShipmentHeader; "Sales Shipment Header"."Order Date")
            {
            }
            column(ExternalDocumentNo_SalesShipmentHeader; "Sales Shipment Header"."External Document No.")
            {
            }
            column(OrderNo_SalesShipmentHeader; "Sales Shipment Header"."Order No.")
            {
            }
            dataitem("Sales Shipment Line"; "Sales Shipment Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.")
                                    WHERE(Type = FILTER(Item),
                                          Quantity = FILTER(> 0));
                column(RequestedDeliveryDate_SalesShipmentLine; "Sales Shipment Line"."Requested Delivery Date")
                {
                }
                column(No_SalesShipmentLine; "Sales Shipment Line"."No.")
                {
                }
                column(Description_SalesShipmentLine; "Sales Shipment Line".Description)
                {
                }
                column(UnitofMeasure_SalesShipmentLine; "Sales Shipment Line"."Unit of Measure")
                {
                }
                column(PlannedDeliveryDate_SalesShipmentLine; "Sales Shipment Line"."Planned Delivery Date")
                {
                }
                column(InvoiceNo; InvoiceNo)
                {
                }
                column(PostingDate_SalesShipmentLine; "Sales Shipment Line"."Posting Date")
                {
                }
                column(Quantity_SalesShipmentLine; "Sales Shipment Line".Quantity)
                {
                }
                column(ShipmentDate_SalesShipmentLine; "Sales Shipment Line"."Shipment Date")
                {
                }
                column(OnTime; OnTime)
                {
                }
                column(InFull; InFull)
                {
                }
                column(DaysForDelivery; DaysForDelivery)
                {
                }
                column(InvoicedDate; InvoicedDate)
                {
                }
                column(OrderedQty_SalesShipmentLine; "Sales Shipment Line"."Ordered Qty.")
                {
                }
                column(DeliveryPersentage; DeliveryPersentage)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    // ON TIME
                    IF "Sales Shipment Line"."Planned Shipment Date" = 0D THEN
                        "Sales Shipment Line"."Planned Shipment Date" := "Sales Shipment Line"."Shipment Date";

                    OnTime := TRUE;
                    IF "Sales Shipment Line"."Planned Shipment Date" < "Sales Shipment Line"."Shipment Date" THEN
                        OnTime := FALSE;

                    DaysForDelivery := 0;
                    DaysForDelivery := "Sales Shipment Line"."Posting Date" - "Sales Shipment Header"."Order Date";

                    // DELIVERY %
                    DeliveryPersentage := 0;
                    IF "Sales Shipment Line"."Ordered Qty." <> 0 THEN
                        DeliveryPersentage := ("Sales Shipment Line".Quantity / "Sales Shipment Line"."Ordered Qty.") * 100;

                    // IN FULL
                    InFull := TRUE;
                    IF DeliveryPersentage <> 100 THEN
                        InFull := FALSE;

                    // INVOICED OR NOT
                    CLEAR(InvoicedDate);
                    InvoiceNo := '';
                    ItemLedgerEntry.RESET;
                    ItemLedgerEntry.SETRANGE(ItemLedgerEntry."Document No.", "Sales Shipment Header"."No.");
                    ItemLedgerEntry.SETRANGE(ItemLedgerEntry."Document Type", ItemLedgerEntry."Document Type"::"Sales Shipment");
                    ItemLedgerEntry.SETRANGE(ItemLedgerEntry."Document Line No.", "Sales Shipment Line"."Line No.");
                    ItemLedgerEntry.SETFILTER(ItemLedgerEntry."Invoiced Quantity", '<>%1', 0);
                    IF ItemLedgerEntry.FINDSET THEN
                        REPEAT
                            ValueEntry.RESET;
                            ValueEntry.SETRANGE(ValueEntry."Item Ledger Entry No.", ItemLedgerEntry."Entry No.");
                            ValueEntry.SETRANGE(ValueEntry."Document Type", ValueEntry."Document Type"::"Sales Invoice");
                            IF ValueEntry.FINDFIRST THEN BEGIN
                                InvoiceNo := ValueEntry."Document No.";
                                InvoicedDate := ValueEntry."Posting Date";
                            END;
                        UNTIL ItemLedgerEntry.NEXT = 0;
                end;
            }
            dataitem("Sales Header"; "Sales Header")
            {
                DataItemTableView = WHERE("Document Type" = CONST(Order));
                PrintOnlyIfDetail = true;
                RequestFilterFields = "Sell-to Customer No.", "No.", "Bill-to Customer No.", "Posting Date", "Order Date", "Shipment Date";
                column(SelltoCustomerNo_SalesHeader; "Sales Header"."Sell-to Customer No.")
                {
                }
                column(No_SalesHeader; "Sales Header"."No.")
                {
                }
                column(ExternalDocumentNo_SalesHeader; "Sales Header"."External Document No.")
                {
                }
                column(OrderDate_SalesHeader; "Sales Header"."Order Date")
                {
                }
                column(PromisedDeliveryDate_SalesHeader; "Sales Header"."Promised Delivery Date")
                {
                }
                column(SelltoCustomerName_SalesHeader; "Sales Header"."Sell-to Customer Name")
                {
                }
                dataitem("Sales Line"; "Sales Line")
                {
                    DataItemLink = "Document Type" = FIELD("Document Type"),
                               "Document No." = FIELD("No.");
                    DataItemTableView = SORTING("Document Type", "Document No.", "Line No.")
                                    WHERE(Type = CONST(Item),
                                          Quantity = FILTER(> 0));
                    column(No_SalesLine; "Sales Line"."No.")
                    {
                    }
                    column(Description_SalesLine; "Sales Line".Description)
                    {
                    }
                    column(UnitofMeasure_SalesLine; "Sales Line"."Unit of Measure")
                    {
                    }
                    column(Quantity_SalesLine; "Sales Line".Quantity)
                    {
                    }
                    column(PlannedShipmentDate_SalesLine; "Sales Line"."Planned Shipment Date")
                    {
                    }
                    column(QuantityShipped_SalesLine; "Sales Line"."Quantity Shipped")
                    {
                    }
                    column(InvoiceNo_Open; InvoiceNo)
                    {
                    }
                    column(OnTime_Open; OnTime)
                    {
                    }
                    column(InFull_Open; InFull)
                    {
                    }
                    column(DaysForDelivery_Open; DaysForDelivery)
                    {
                    }
                    column(InvoicedDate_Open; InvoicedDate)
                    {
                    }
                    column(DeliveryPersentage_Open; DeliveryPersentage)
                    {
                    }
                    column(ShipmentDate_Open; ShipmentDate)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        CLEAR(InvoicedDate);
                        CLEAR(InvoiceNo);
                        CLEAR(ShipmentDate);
                        SalesInvHeader.RESET;
                        SalesInvHeader.SETRANGE("Order No.", "Sales Line"."Document No.");
                        IF SalesInvHeader.FINDFIRST THEN BEGIN
                            InvoiceNo := SalesInvHeader."No.";
                            InvoicedDate := SalesInvHeader."Posting Date";
                            ShipmentDate := SalesInvHeader."Shipment Date";
                        END;

                        // DELIVERY %
                        DeliveryPersentage := 0;
                        IF "Sales Line".Quantity <> 0 THEN
                            DeliveryPersentage := ("Sales Line"."Quantity Shipped" / "Sales Line".Quantity) * 100;

                        //days taken
                        DaysForDelivery := 0;
                        IF InvoicedDate <> 0D THEN
                            DaysForDelivery := InvoicedDate - "Sales Header"."Order Date";

                        //on time
                        OnTime := TRUE;
                        IF ShipmentDate > "Sales Line"."Planned Shipment Date" THEN
                            OnTime := FALSE;

                        // IN FULL
                        InFull := TRUE;
                        IF DeliveryPersentage <> 100 THEN
                            InFull := FALSE;
                    end;
                }
            }
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
        OrderedQty: Decimal;
        OnTime: Boolean;
        InFull: Boolean;
        QuantityDifference: Decimal;
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        DaysForDelivery: Integer;
        ItemLedgerEntry: Record "Item Ledger Entry";
        ValueEntry: Record "Value Entry";
        InvoicedDate: Date;
        InvoiceNo: Code[20];
        DeliveryPersentage: Decimal;
        SalesInvHeader: Record "Sales Invoice Header";
        ShipmentDate: Date;
}

