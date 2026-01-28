tableextension 50122 ManufacturingSetupExt extends "Manufacturing Setup"
{
    fields
    {
        field(50000; "Default Flushing Filter"; Option)
        {
            OptionMembers = Manual,Forward,Backward,"Pick + Forward","Pick + Backward","All Methods";
        }
        field(50001; "Default Location"; Code[10])
        {
        }
    }
}