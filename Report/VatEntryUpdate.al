report 90080 "Vat Entry Update"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Report/VatEntryUpdate.rdl';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem("VAT Entry"; "VAT Entry")
        {
            RequestFilterFields = "VAT Bus. Posting Group", "VAT Prod. Posting Group";

            trigger OnAfterGetRecord()
            begin
                "Amount 2" := Base * 0.15;
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

