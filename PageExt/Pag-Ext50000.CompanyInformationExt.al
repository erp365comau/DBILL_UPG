pageextension 50000 "Company InformationExt" extends "Company Information"
{
    layout
    {
        addafter(Picture)
        {
            field(Picture2; Rec.Picture2)
            {
                ApplicationArea = all;
            }
        }
    }
}