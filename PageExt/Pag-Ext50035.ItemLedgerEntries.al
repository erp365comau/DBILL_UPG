/* pageextension 50035 "Item Ledger EntryExt" extends "Item Ledger Entries"
{

    actions
    {
        addlast(Processing)
        {
            action("Update Item Descriptions")
            {
                ApplicationArea = All;
                Caption = 'Update Item Descriptions';
                Image = Update;
                trigger OnAction()
                var
                    ItemDescriptionModify: Codeunit "Item Description Modify";
                begin
                    ItemDescriptionModify.Run();
                end;
            }
        }
    }
}

 */