report 90012 "Routing line"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Report/Routingline.rdl';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem("Routing Line"; "Routing Line")
        {

            trigger OnAfterGetRecord()
            begin
                "Routing Line".VALIDATE("Routing Line"."Run Time", 1);
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

