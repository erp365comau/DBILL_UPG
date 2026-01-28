pageextension 50024 "Production JournalExt" extends "Production Journal"
{

    trigger OnOpenPage()
    begin
        MfgSetup.GET;
        FlushingFilter := MfgSetup."Default Flushing Filter";
    end;

    var
        MfgSetup: Record "Manufacturing Setup";
}
