report 90003 "LINE QTY UPDATE"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Report/LINEQTYUPDATE.rdl';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem("Production BOM Line"; "Production BOM Line")
        {

            trigger OnAfterGetRecord()
            begin
                "Production BOM Line".VALIDATE("Production BOM Line"."Quantity per", Quantity);
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

