codeunit 50103 EFTManagement
{


    procedure EFT_Export(VAR locRecGenJournalLine: Record "Gen. Journal Line"; VAR locRecEFTFileType: Record "EFT File Type"; locTransactionDate: Date)
    begin
        GenJnlLine.COPY(locRecGenJournalLine);
        locRecEFTFileType.TESTFIELD(locRecEFTFileType."EFT Nos.");

        RecEFTFileType.FIND('-');
        RecEFTFileType.MODIFY;

        GenJnlLine.MODIFYALL("EFT Transaction Date", locTransactionDate);
        GenJnlLine.MODIFYALL("EFT No.", NoSeriesMgt.GetNextNo(locRecEFTFileType."EFT Nos.", GenJnlLine."Posting Date", TRUE));
        GenJnlLine.MODIFYALL("EFT Exported", TRUE);
        GenJnlLine.MODIFYALL("EFT Time", TIME);
        GenJnlLine.MODIFYALL("EFT Date", TODAY);
        GenJnlLine.MODIFYALL("EFT User ID", USERID);

        locRecGenJournalLine := GenJnlLine;
    end;

    procedure Cancel_EFT_Export(VAR locRecGenJournalLine: Record "Gen. Journal Line")
    begin
        GenJnlLine.COPY(locRecGenJournalLine);

        RecEFTFileType.FIND('-');
        RecEFTFileType.MODIFY;

        GenJnlLine.MODIFYALL("EFT Transaction Date", 0D);
        GenJnlLine.MODIFYALL("EFT No.", '');
        GenJnlLine.MODIFYALL("EFT Time", 0T);
        GenJnlLine.MODIFYALL("EFT Date", 0D);
        GenJnlLine.MODIFYALL("EFT User ID", '');
        GenJnlLine.MODIFYALL("EFT Exported", FALSE);

        locRecGenJournalLine := GenJnlLine;
    end;


    var
        GenJnlLine: Record "Gen. Journal Line";
        RecEFTFileType: Record "EFT File Type";
        NoSeriesMgt: Codeunit "No. Series";
}
