report 50024 "Minimum Stock Level"
{
    // J12052 20190306 LK - CREATE REPORT
    // J12052 20190307 LK - ADD OPTION TO LIST ONLY ITEMS NEEDS TO MAKE, COLOR ACCORDING TO QTY
    DefaultLayout = RDLC;
    RDLCLayout = 'Report/MinimumStockLevel.rdl';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = WHERE(Blocked = FILTER(false));
            RequestFilterFields = "No.", "Inventory Posting Group", "Manufacturing Policy", Inventory, "Replenishment System", "Item Category Code", "Date Filter", "Minimum Order Quantity";
            column(No_Item; Item."No.")
            {
            }
            column(Description_Item; Item.Description)
            {
            }
            column(BaseUnitofMeasure_Item; Item."Base Unit of Measure")
            {
            }
            column(ProductGroupCode_Item; Item."Item Category Code")
            {
            }
            column(ItemCategoryCode_Item; Item."Item Category Code")
            {
            }
            column(MinimumQuantity_Item; Item."Minimum Order Quantity")
            {
            }
            column(Inventory_Item; Item.Inventory)
            {
            }
            column(QtyonPurchOrder_Item; Item."Qty. on Purch. Order")
            {
            }
            column(QtyonSalesOrder_Item; Item."Qty. on Sales Order")
            {
            }
            column(QtyonProdOrder_Item; Item."Qty. on Prod. Order")
            {
            }
            column(OrderToMake; OrderToMake)
            {
            }
            column(ReportFilter; ReportFilter)
            {
            }
            column(ReportTitle; ReportTitle)
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }

            trigger OnAfterGetRecord()
            begin
                OrderToMake := 0;
                OrderToMake := Item.Inventory - Item."Minimum Order Quantity" - Item."Qty. on Sales Order" + (Item."Qty. on Purch. Order" + Item."Qty. on Prod. Order");

                IF DisplayOnlyItemsToMake AND (OrderToMake > 0) THEN
                    CurrReport.SKIP;
            end;
        }
    }
    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    field(DisplayOnlyItemsToMake; DisplayOnlyItemsToMake)
                    {
                        Caption = 'Display Only Items To Make';
                        ApplicationArea = All;
                    }
                }
            }
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
        ReportTitle := 'Minimum Stock Level';
        ReportFilter := Item.GETFILTERS;
    end;

    var
        ReportTitle: Text;
        ReportFilter: Text;
        DisplayOnlyItemsToMake: Boolean;
        OrderToMake: Decimal;
}

