pageextension 50040 SalesOrdersListExt extends "Sales Order List"
{
    actions
    {
        modify(Post)
        {
            Visible = false;
        }
    }
}
