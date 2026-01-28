report 90007 ILE
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Report/ILE.rdl';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem("FA Depreciation Book"; "FA Depreciation Book")
        {

            trigger OnAfterGetRecord()
            begin
                "FA Depreciation Book".VALIDATE("FA Depreciation Book"."Straight-Line %", "FA Depreciation Book"."Straight-Line %" * 100);
                //"Production BOM Line".VALIDATE("Production BOM Line"."Quantity per",Quantity);
                //"Value Entry".VALIDATE("Value Entry"."Variant Code",'');
                //"Machine Center".VALIDATE("Flushing Method","Machine Center"."Flushing Method"::Manual);
                //"Item Journal Line".VALIDATE("Item Journal Line"."Qty. (Phys. Inventory)","Item Journal Line".Quantity);
                //"Routing Header".VALIDATE(Status,"Routing Header".Status::Certified);
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
}

