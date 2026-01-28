report 80001 "G/L update from VAT Entry"
{
    ProcessingOnly = true;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem("VAT Entry"; "VAT Entry")
        {
            dataitem("G/L Entry"; "G/L Entry")
            {
                DataItemLink = "Document No." = FIELD("Document No."),
                               "Posting Date" = FIELD("Posting Date");
                RequestFilterFields = "User ID", "Journal Batch Name", "Entry No.";

                trigger OnAfterGetRecord()
                begin
                    //IF ABS(Amount) = "VAT Entry"."Amount 2" THEN BEGIN
                    Window.UPDATE(1, "Entry No.");
                    IF Amount < 0 THEN BEGIN
                        Amount := ABS("VAT Entry".Amount) * -1;
                        "Credit Amount" := ABS(Amount);
                        MODIFY;
                    END ELSE BEGIN
                        Amount := ABS("VAT Entry".Amount);
                        "Debit Amount" := Amount;
                        MODIFY;
                    END;
                    //END;
                end;
            }

            trigger OnPreDataItem()
            begin
                Window.OPEN('G/L Entry No. #1#######################')
            end;
        }
    }
    requestpage
    {

        layout
        {
        }
        actions
        {
        }
    }
    labels
    {
    }

    var
        Window: Dialog;
}

