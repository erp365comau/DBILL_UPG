/* codeunit 50023 "Payment Method Modify"
{
    Permissions = tabledata "Sales Cr.Memo Header" = RIMD;

    trigger OnRun()
    var
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
    begin
        if SalesCrMemoHeader.FindFirst() then
            repeat
                if SalesCrMemoHeader."Payment Method Code" = 'OTHER' then begin
                    SalesCrMemoHeader."Payment Method Code" := 'CARD';
                    SalesCrMemoHeader.Modify(TRUE);
                end;
            until SalesCrMemoHeader.Next() = 0;
    end;
}
 */