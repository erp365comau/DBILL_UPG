pageextension 50017 "Payment JournalExt" extends "Payment Journal"
{
    layout
    {
        addafter(Description)
        {
            field(Description2; Rec.Description2)
            {
                ApplicationArea = all;
            }
        }
        addafter("Has Payment Export Error")
        {
            field("EFT No."; Rec."EFT No.")
            {
                ApplicationArea = all;
            }
            field("EFT Time"; Rec."EFT Time")
            {
                ApplicationArea = all;
            }
            field("EFT Date"; Rec."EFT Date")
            {
                ApplicationArea = all;
            }
            field("EFT User ID"; Rec."EFT User ID")
            {
                ApplicationArea = all;
            }
            field("EFT Exported"; Rec."EFT Exported")
            {
                ApplicationArea = all;
            }
            field("EFT Transaction Date"; Rec."EFT Transaction Date")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addlast(processing)
        {

            action("Export EFT")
            {
                ApplicationArea = all;
                Image = Print;

                trigger OnAction()
                begin
                    //EFT1.0 AUSTRAL Jozef 21.10.2007 -> Begin
                    GenJnlLine.RESET;
                    GenJnlLine.COPY(Rec);
                    GenJnlLine.SETRANGE("Journal Template Name", Rec."Journal Template Name");
                    GenJnlLine.SETRANGE("Journal Batch Name", Rec."Journal Batch Name");
                    //  REPORT.RUN(REPORT::"EFT Export", TRUE, FALSE, GenJnlLine);
                    //EFT1.0 AUSTRAL Jozef 21.10.2007 -> End
                end;
            }
            action("Cancel Export EFT")
            {
                ApplicationArea = all;
                Image = Print;

                trigger OnAction()
                var
                    EFTMngt: Codeunit EFTManagement;
                begin
                    //EFT1.0 AUSTRAL Jozef 21.10.2007 -> Begin
                    IF CONFIRM(Text50099, FALSE) THEN BEGIN
                        GenJnlLine.RESET;
                        GenJnlLine.COPY(Rec);
                        GenJnlLine.SETRANGE("Bank Payment Type", Rec."Bank Payment Type"::EFT);
                        GenJnlLine.SETRANGE("EFT Exported", TRUE);
                        EFTMngt.Cancel_EFT_Export(GenJnlLine);
                    END;
                    //EFT1.0 AUSTRAL Jozef 21.10.2007 -> End
                end;
            }
            action("Print Payment Voucher")
            {
                ApplicationArea = all;
                Image = Print;

                trigger OnAction()
                begin
                    //Austral Sugeevan 30/09/2014 >>>
                    CLEAR(GenJnlLine);
                    GenJnlLine.SETRANGE("Journal Template Name", Rec."Journal Template Name");
                    GenJnlLine.SETRANGE("Journal Batch Name", Rec."Journal Batch Name");
                    REPORT.RUN(REPORT::"Payment Voucher - AD", TRUE, FALSE, GenJnlLine);
                    //Austral Sugeevan 30/09/2014 <<<
                end;
            }
        }
    }
    var
        GenJnlLine: Record "Gen. Journal Line";
        Text50099: Label '<Cancel EFT export?>';
}