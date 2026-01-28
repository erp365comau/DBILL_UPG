pageextension 50016 "Posted Sales Credit MemosExt" extends "Posted Sales Credit Memos"
{
    layout
    {
        addafter("Currency Code")
        {
            field("Payment Method Code"; Rec."Payment Method Code")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addlast(processing)
        {
            action("PrintOld")
            {
                ApplicationArea = all;
                Image = Print;

                trigger OnAction()
                begin
                    //J13049>>>
                    SalesCrMemoHeader := Rec;
                    CurrPage.SETSELECTIONFILTER(SalesCrMemoHeader);
                    REPORT.RUNMODAL(50083, TRUE, FALSE, SalesCrMemoHeader);
                    //J13049 <<<
                end;
            }
            /* action("Update Payment Methods")
            {
                ApplicationArea = All;
                Caption = 'Update Payment Methods';
                Image = Update;
                trigger OnAction()
                var
                    PaymentMethodModify: Codeunit "Payment Method Modify";
                begin
                    PaymentMethodModify.Run();
                end;
            } */
        }
    }
    var
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
}
