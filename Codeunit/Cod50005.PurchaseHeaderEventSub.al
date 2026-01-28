codeunit 50005 "Purchase Header EventSub"
{
    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", OnBeforeConfirmDeletion, '', false, false)]
    local procedure "Purchase Header_OnBeforeConfirmDeletion"(var PurchaseHeader: Record "Purchase Header"; var Result: Boolean; var IsHandled: Boolean)
    var
        SourceCode: Record "Source Code";
        SourceCodeSetup: Record "Source Code Setup";
        PostPurchDelete: Codeunit "PostPurch-Delete";
        ConfirmManagement: Codeunit "Confirm Management";
    begin

        SourceCodeSetup.Get();
        SourceCodeSetup.TestField("Deleted Document");
        SourceCode.Get(SourceCodeSetup."Deleted Document");

        PostPurchDelete.InitDeleteHeader(
          PurchaseHeader, PurchRcptHeader, PurchInvHeader, PurchCrMemoHeader,
          ReturnShptHeader, PurchInvHeaderPrepmt, PurchCrMemoHeaderPrepmt, SourceCode.Code);

        if PurchRcptHeader."No." <> '' then
            if not ConfirmManagement.GetResponseOrDefault(StrSubstNo(Text009, PurchRcptHeader."No."), true) then
                exit;
        if PurchInvHeader."No." <> '' then
            if not ConfirmManagement.GetResponseOrDefault(StrSubstNo(Text012, PurchInvHeader."No."), true) then
                exit;
        if PurchCrMemoHeader."No." <> '' then
            if not ConfirmManagement.GetResponseOrDefault(StrSubstNo(Text014, PurchCrMemoHeader."No."), true) then
                exit;
        if ReturnShptHeader."No." <> '' then
            if not ConfirmManagement.GetResponseOrDefault(StrSubstNo(Text029, ReturnShptHeader."No."), true) then
                exit;
        if PurchaseHeader."Prepayment No." <> '' then
            if not ConfirmManagement.GetResponseOrDefault(StrSubstNo(Text044 + Text045 + Text011, TRUE, PurchInvHeaderPrepmt."No."), true) then
                exit;
        if PurchaseHeader."Prepmt. Cr. Memo No." <> '' then
            if not ConfirmManagement.GetResponseOrDefault(StrSubstNo(Text046 + Text047 + Text011, TRUE, PurchCrMemoHeaderPrepmt."No."), true) then
                exit;
        IsHandled := true;
    end;


    var
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        ReturnShptHeader: Record "Return Shipment Header";
        PurchInvHeaderPrepmt: Record "Purch. Inv. Header";
        PurchCrMemoHeaderPrepmt: Record "Purch. Cr. Memo Hdr.";
        Text009: Label 'Deleting this document will cause a gap in the number series for receipts. An empty receipt %1 will be created to fill this gap in the number series.\\Do you want to continue?', Comment = '%1 = Document No.';
        Text011: Label 'Do you want to continue?';
        Text012: Label 'Deleting this document will cause a gap in the number series for posted invoices. An empty posted invoice %1 will be created to fill this gap in the number series.\\Do you want to continue?', Comment = '%1 = Document No.';
        Text014: Label 'Deleting this document will cause a gap in the number series for posted credit memos. An empty posted credit memo %1 will be created to fill this gap in the number series.\\Do you want to continue?', Comment = '%1 = Document No.';
        Text029: Label 'Deleting this document will cause a gap in the number series for return shipments. An empty return shipment %1 will be created to fill this gap in the number series.\\Do you want to continue?', Comment = '%1 = Document No.';
        Text044: Label 'Do you want to print prepayment credit memo %1?';
        Text045: Label 'Deleting this document will cause a gap in the number series for prepayment invoices. An empty prepayment invoice %1 will be created to fill this gap in the number series.\\Do you want to continue?';
        Text046: Label 'Deleting this document will cause a gap in the number series for prepayment credit memos. An empty prepayment credit memo %1 will be created to fill this gap in the number series.\\Do you want to continue?';
        Text047: Label 'Deleting this document will cause a gap in the number series for prepayment credit memos.';
}
