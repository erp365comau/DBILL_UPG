report 50019 "Update GL IPG"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Report/UpdateGLIPG.rdl';
    Permissions = TableData 17 = rim;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem("Value Entry"; "Value Entry")
        {

            trigger OnAfterGetRecord()
            begin
                GLEntry.RESET;
                GLEntry.SETRANGE("Document No.", "Value Entry"."Document No.");
                GLEntry.SETRANGE(Amount, "Value Entry"."Cost Posted to G/L");
                GLEntry.SETRANGE("Posting Date", "Value Entry"."Posting Date");
                IF GLEntry.FIND('-') THEN
                    REPEAT
                        IF Item.GET("Value Entry"."Item No.") THEN;
                        GLEntry.Description3 := Item."Inventory Posting Group";
                        GLEntry.MODIFY;

                    UNTIL GLEntry.NEXT <= 0;
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
        Item: Record Item;
        GLEntry: Record "G/L Entry";
}

