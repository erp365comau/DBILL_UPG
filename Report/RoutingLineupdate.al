report 50095 "Routing Line update"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Report/RoutingLineupdate.rdl';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem("Routing Line"; "Routing Line")
        {

            trigger OnAfterGetRecord()
            begin
                "Routing Line".VALIDATE("No.");
                "Routing Line".MODIFY(TRUE);
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

