report 90001 "Sales Price"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Report/SalesPrice.rdl';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "Inventory Posting Group", "Item Category Code";

            trigger OnAfterGetRecord()
            begin
                /*
                IF item1.GET("Sales Price"."Item No.") THEN BEGIN
                //"Production BOM Header".VALIDATE(Description,ITEM1.Description );
                "Sales Price".VALIDATE("Unit of Measure Code",item1."Base Unit of Measure");
                 MODIFY;
                END;
                */
                Item.VALIDATE(Item."Item Category Code", 'RAWMATERIA');
                MODIFY;

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
        item1: Record Item;
}

