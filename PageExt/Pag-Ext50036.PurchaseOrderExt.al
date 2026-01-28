pageextension 50036 PurchaseOrderExt extends "Purchase Order List"
{
    actions
    {
        addlast(Processing)
        {
            /* action(ReopenPurchaseOrder)
            {
                ApplicationArea = All;
                Caption = 'Reopen Purchase Order';
                Image = Reopen;
                trigger OnAction()
                var
                    PurchaseHeader: Record "Purchase Header";
                begin
                    PurchaseHeader.get(Rec."Document Type", Rec."No.");
                    PurchaseHeader.Status := PurchaseHeader.Status::Open;
                    PurchaseHeader.Modify();
                end;
            }
            action(DeletePurchaseOrder)
            {
                ApplicationArea = All;
                Caption = 'Delete Purchase Order';
                Image = Reopen;
                trigger OnAction()
                var
                    PurchaseHeader: Record "Purchase Header";
                begin
                    PurchaseHeader.get(Rec."Document Type", Rec."No.");
                    PurchaseHeader.Delete();
                end;
            } */
        }
    }
}
