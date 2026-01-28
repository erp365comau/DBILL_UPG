pageextension 50030 "Manufacturing SetupExt" extends "Manufacturing Setup"
{
    layout
    {
        addafter("Cost Incl. Setup")
        {
            field("Default Flushing Filter"; Rec."Default Flushing Filter")
            {
                ApplicationArea = all;
            }
        }
    }
}