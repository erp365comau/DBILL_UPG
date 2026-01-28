/* codeunit 50022 "Item Description Modify"
{
    Permissions = tabledata "Item Ledger Entry" = RIMD;

    trigger OnRun()
    var
        ILE: Record "Item Ledger Entry";
        Item: Record Item;
    begin
        if ILE.FindSet() then
            repeat
                if not Item.Get(ILE."Item No.") then
                    exit;
                if Item.Description <> ILE."Item Description" then begin
                    ILE."Item Description" := Item.Description;
                    ILE.MODIFY(TRUE);
                end;
            until ILE.Next() = 0;
    end;
}
 */