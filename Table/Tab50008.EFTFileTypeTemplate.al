table 50008 "EFT File Type Template"
{
    Caption = 'EFT File Type Template';


    fields
    {
        field(1; "EFT File Type"; Code[20])
        {
            Caption = 'EFT File Type';
        }
        field(2; "Record Type"; Option)
        {
            Caption = 'Record Type';
            OptionMembers = Header,Body,Footer,Footer2,Body2,Footer3;
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; TableID; Integer)
        {
            Caption = 'TableID';

            trigger OnValidate()
            begin
                CALCFIELDS("Table Name");
            end;
        }
        field(5; "Table Name"; Text[30])
        {
            Caption = 'Table Name';
        }
        field(6; FieldID; Integer)
        {
            Caption = 'FieldID';

            trigger OnValidate()
            begin
                CALCFIELDS("Table Name");
            end;
        }
        field(7; "Field Name"; Text[30])
        {
            Caption = 'Field Name';
        }
        field(8; "Field Caption"; Text[250])
        {
            Caption = 'Field Caption';
        }
        field(9; "Do Testfield"; Boolean)
        {
            Caption = 'Do Testfield';
        }
        field(10; Length; Integer)
        {
            Caption = 'Length';
        }
        field(11; "Default Character"; Text[1])
        {
            Caption = 'Default Character';
        }
        field(12; "Fill Character"; Text[1])
        {
            Caption = 'Fill Character';
        }
        field(13; "Fill Option"; Option)
        {
            Caption = 'Fill Option';
            OptionMembers = Before,After;
        }
        field(14; "Format String"; Text[30])
        {
            Caption = 'Format String';
        }
        field(15; ABS; Boolean)
        {
            Caption = 'ABS';
        }
        field(16; "Multiply By"; Decimal)
        {
            Caption = 'Multiply By';
        }
        field(17; "Reverse Sign"; Boolean)
        {
            Caption = 'Reverse Sign';
        }
        field(18; "Length Type"; Option)
        {
            Caption = 'Length Type';
            OptionMembers = ,Equal,"Less or Equal";
        }
        field(19; "Add Number"; Decimal)
        {
            Caption = 'Add Number';
        }
    }
    keys
    {
      key(PK; "EFT File Type","Record Type","Line No.")
        {
            Clustered = true;
        }
    }
}