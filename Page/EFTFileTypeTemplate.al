page 50001 "EFT File Type Template"
{
    ApplicationArea = All;
    Caption = 'EFT File Type Template';
    PageType = Card;
    SourceTable = "EFT File Type Template";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("EFT File Type"; Rec."EFT File Type")
                {
                    ApplicationArea = all;
                }
                field("Record Type"; Rec."Record Type")
                {
                    ApplicationArea = all;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = all;
                }
                field(TableID; Rec.TableID)
                {
                    ApplicationArea = all;
                }
                field("Table Name"; Rec."Table Name")
                {
                    ApplicationArea = all;
                }
                field(FieldID; Rec.FieldID)
                {
                    ApplicationArea = all;
                }
                field("Field Name"; Rec."Field Name")
                {
                    ApplicationArea = all;
                }
                field("Field Caption"; Rec."Field Caption")
                {
                    ApplicationArea = all;
                }
                field("Do Testfield"; Rec."Do Testfield")
                {
                    ApplicationArea = all;
                }
                field(Length; Rec.Length)
                {
                    ApplicationArea = all;
                }
                field("Default Character"; Rec."Default Character")
                {
                    ApplicationArea = all;
                }
                field("Fill Character"; Rec."Fill Character")
                {
                    ApplicationArea = all;
                }
                field("Fill Option"; Rec."Fill Option")
                {
                    ApplicationArea = all;
                }
                field("Format String"; Rec."Format String")
                {
                    ApplicationArea = all;
                }
                field(ABS; Rec.ABS)
                {
                    ApplicationArea = all;
                }
                field("Multiply By"; Rec."Multiply By")
                {
                    ApplicationArea = all;
                }
                field("Reverse Sign"; Rec."Reverse Sign")
                {
                    ApplicationArea = all;
                }
                field("Length Type"; Rec."Length Type")
                {
                    ApplicationArea = all;
                }
                field("Add Number"; Rec."Add Number")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}
