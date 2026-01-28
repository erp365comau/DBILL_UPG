report 50084 "Export into Sales Inv,Ship"
{
    Permissions = TableData 111 = rm,
                  TableData 113 = rm;
    ProcessingOnly = true;
    ApplicationArea = all;
    dataset
    {
        dataitem("Sales Shipment Line"; "Sales Shipment Line")
        {

            trigger OnAfterGetRecord()
            begin
                //1
                /*
                "Outstanding Quantity 2" := "Outstanding Quantity";
                "Outstanding Quantity" := 0;
                MODIFY;
                */

                //2
                "Outstanding Quantity" := "Ordered Qty.";
                "Ordered Qty." := 0;
                MODIFY;

            end;
        }
        dataitem("Sales Invoice Line"; "Sales Invoice Line")
        {

            trigger OnAfterGetRecord()
            begin
                //1
                /*
                "Outstanding Quantity 2" := "Outstanding Quantity";
                "Outstanding Quantity" := 0;
                MODIFY;
                */

                //2
                "Outstanding Quantity" := "Ordered Qty.";
                "Ordered Qty." := 0;
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

    trigger OnPostReport()
    begin
        MESSAGE('Done.');
    end;
}

