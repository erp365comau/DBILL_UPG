report 50015 "Job Card"
{
    // Austral Sugeevan 16/10/2014 >>> Designed this Report
    // Austral Sugeevan 17/10/2014 >>> Added UOM Column
    // Austral Sugeevan 02/12/2014 >>> Changed Groupings in RTC Design
    // Austral Sugeevan 03/12/2014 >>> Added two new columns in RTC Design - Issued By and Received By
    // Austral Sugeevan 23/04/2015 >>> RTC Layout Mods on Sorting and Added a new Column - Date
    // Austral Sugeevan 10/05/2015 >>> Changed Groupings in RTC Design
    DefaultLayout = RDLC;
    RDLCLayout = 'Report/JobCard.rdl';
    ApplicationArea = all;
    Caption = 'Job Card 2';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Production Order"; "Production Order")
        {
            DataItemTableView = SORTING(Status, "No.")
                                WHERE(Status = CONST(Released));
            RequestFilterFields = "No.", "Due Date";
            column(No_ProductionOrder; "No.")
            {
            }
            column(DueDate_ProductionOrder; "Due Date")
            {
            }
            column(ProdOrdFilters__; ProdOrdFilters)
            {
            }
            column(CompanyName__; COMPANYNAME)
            {
            }
            dataitem("Prod. Order Line"; "Prod. Order Line")
            {
                DataItemLink = Status = FIELD(Status),
                               "Prod. Order No." = FIELD("No.");
                DataItemTableView = SORTING(Status, "Prod. Order No.", "Line No.");
                column(Description_ProdOrderLine; Description)
                {
                }
                column(RemainingQuantity_ProdOrderLine; "Remaining Quantity")
                {
                }
                column(ItemNo_ProdOrderLine; "Item No.")
                {
                }
                column(RoutingNotFound__; RoutingNotFound)
                {
                }
                column(UnitofMeasureCode_ProdOrderLine; "Unit of Measure Code")
                {
                }
                dataitem("Prod. Order Routing Line"; "Prod. Order Routing Line")
                {
                    DataItemLink = Status = FIELD(Status),
                                   "Prod. Order No." = FIELD("Prod. Order No."),
                                   "Routing Reference No." = FIELD("Routing Reference No."),
                                   "Routing No." = FIELD("Routing No.");
                    DataItemTableView = SORTING(Status, "Prod. Order No.", "Routing Reference No.", "Routing No.", "Operation No.")
                                        WHERE("Work Center No." = FILTER(<> ''));
                    column(WorkCenterNo_ProdOrderRoutingLine; "Work Center No.")
                    {
                    }
                    column(ProdOrdLine_RemainingQty__; ProdOrdLine."Remaining Quantity")
                    {
                    }
                    column(ProdOrdLine_Status__; ProdOrdLine.Status)
                    {
                    }
                    column(OperationNo_ProdOrderRoutingLine; "Operation No.")
                    {
                    }
                    column(Type_ProdOrderRoutingLine; Type)
                    {
                    }
                    column(No_ProdOrderRoutingLine; "No.")
                    {
                    }
                    column(RoutingLinkCode_ProdOrderRoutingLine; "Routing Link Code")
                    {
                    }
                    dataitem("Prod. Order Component"; "Prod. Order Component")
                    {
                        DataItemLink = Status = FIELD(Status),
                                       "Prod. Order No." = FIELD("Prod. Order No."),
                                       "Routing Link Code" = FIELD("Routing Link Code");
                        DataItemTableView = SORTING(Status, "Prod. Order No.", "Prod. Order Line No.", "Line No.");
                        column(RemainingQuantity_ProdOrderComponent; "Remaining Quantity")
                        {
                        }
                        column(RoutingLinkCode_ProdOrderComponent; "Routing Link Code")
                        {
                        }
                        column(ComponentRemainQty__; ComponentRemainQty)
                        {
                        }
                        column(ItemNo_ProdOrderComponent; "Item No.")
                        {
                        }
                        column(Description_ProdOrderComponent; Description)
                        {
                        }
                        column(UnitofMeasureCode_ProdOrderComponent; "Unit of Measure Code")
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            CLEAR(ProdOrdCompLine);
                            CLEAR(ComponentRemainQty);
                            ProdOrdCompLine.SETCURRENTKEY(Status, "Prod. Order No.", "Routing Link Code", "Flushing Method");
                            ProdOrdCompLine.SETRANGE(Status, Status);
                            ProdOrdCompLine.SETRANGE("Prod. Order No.", "Prod. Order No.");
                            ProdOrdCompLine.SETRANGE("Routing Link Code", "Routing Link Code");
                            ProdOrdCompLine.SETRANGE("Item No.", "Item No.");
                            IF ProdOrdCompLine.FINDFIRST THEN
                                REPEAT
                                    ComponentRemainQty += ProdOrdCompLine."Remaining Quantity";
                                UNTIL ProdOrdCompLine.NEXT = 0;
                        end;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        CLEAR(ProdOrdLine);
                        ProdOrdLine.SETCURRENTKEY(Status, "Prod. Order No.", "Routing No.", "Routing Reference No.");
                        ProdOrdLine.SETRANGE(Status, Status);
                        ProdOrdLine.SETRANGE("Prod. Order No.", "Prod. Order No.");
                        ProdOrdLine.SETRANGE("Routing Reference No.", "Routing Reference No.");
                        ProdOrdLine.SETRANGE("Routing No.", "Routing No.");
                        IF ProdOrdLine.FINDFIRST THEN;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    CLEAR(ProdOrdRoutLine);
                    ProdOrdRoutLine.SETRANGE(Status, Status);
                    ProdOrdRoutLine.SETRANGE("Prod. Order No.", "Prod. Order No.");
                    ProdOrdRoutLine.SETRANGE("Routing Reference No.", "Routing Reference No.");
                    ProdOrdRoutLine.SETRANGE("Routing No.", "Routing No.");
                    RoutingNotFound := ProdOrdRoutLine.ISEMPTY;
                end;
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

    trigger OnPreReport()
    begin
        ProdOrdFilters := "Production Order".GETFILTERS;
    end;

    var
        ProdOrdFilters: Text[250];
        ProdOrdLine: Record "Prod. Order Line";
        ProdOrdRoutLine: Record "Prod. Order Routing Line";
        RoutingNotFound: Boolean;
        ProdOrdCompLine: Record "Prod. Order Component";
        ComponentRemainQty: Decimal;
}

