TermGroup

New-PnPTermGroup -Name "WM Central Europe" -id "ad83ac93-3fa2-4790-a294-2699307e8321"

Termsets

$termGroup = "ad83ac93-3fa2-4790-a294-2699307e8321"

New-PnPTermSet -Name "Format" -TermGroup $termGroup -Id "9f174ece-ee14-4f58-bc92-18c89ac74984" -Lcid "1033"

New-PnPTermSet -Name "Repertoire Unit" -TermGroup $termGroup -Id "2557dadd-2147-4a9e-b2b6-f14622a59e5b" -Lcid "1033"

New-PnPTermSet -Name "Genre" -TermGroup $termGroup -Id "231805d8-d531-4a06-9fbb-1efed3bbf90e" -Lcid "1033"

New-PnPTermSet -Name "Year" -TermGroup $termGroup -Id "0B98D864-3F71-4D10-9085-1F75436ECF77" -Lcid "1033"

New-PnPTermSet -Name "Label" -TermGroup $termGroup -Id "F9C9AC1C-9128-4C44-8C3C-8844ED2D9831" -Lcid "1033"





