report 50033 "UPDATE SALES LINE"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Report/UPDATESALESLINE.rdl';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem("Sales Line"; "Sales Line")
        {
            DataItemTableView = WHERE(Type = CONST(Item));

            trigger OnAfterGetRecord()
            begin
                "Sales Line"."Ordered Qty." := "Sales Line".Quantity;
                "Sales Line".MODIFY;
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

