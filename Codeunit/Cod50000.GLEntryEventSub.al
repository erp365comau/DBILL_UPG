codeunit 50000 "GL Entry EventSubs"
{
    [EventSubscriber(ObjectType::Table, Database::"G/L Entry", OnAfterCopyGLEntryFromGenJnlLine, '', false, false)]
    local procedure "G/L Entry_OnAfterCopyGLEntryFromGenJnlLine"(var GLEntry: Record "G/L Entry"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        GLEntry.Description2 := GenJournalLine.Description2;
        GLEntry."BAS Adjustment" := false;
        GLEntry."BAS Doc. No." := '';
        GLEntry."BAS Version" := 0;
    end;

}
