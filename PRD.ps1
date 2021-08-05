﻿## Connect PNP

## PROD
connect-pnponline -url https://wmg.sharepoint.com/sites/CE-Focus-List -UseWebLogin

## TPA DEV
connect-pnponline -url https://wmgdev.sharepoint.com/sites/CE-Focus-List

## WMG DEV
connect-pnponline -url https://wmg.sharepoint.com/sites/Dev.CentralEurope -UseWebLogin

## Layer2 Dev 3 FC 4
connect-pnponline -url https://warnermusicdev03.sharepoint.com/sites/FocusList04

## Layer2 Dev 4 FC 2
connect-pnponline -url https://warnermusicdev04.sharepoint.com/sites/FocusList02 -UseWebLogin
disconnect-pnponline

Connect-SPOService https://wmg-admin.sharepoint.com/


## Template

$templatePath = "C:\Users\thomaspaul\Warner Music Group\CE-FocusList - General\Entwicklung\XML\Template_FocusList - Child.xml"
$templatePath = "C:\Users\thomaspaul\Warner Music Group\CE-FocusList - General\Entwicklung\PS\Template_FocusList20210218.xml"
$templatePath = "C:\Users\thomaspaul\Warner Music Group\CE-FocusList - General\Entwicklung\PS\Template_FocusList - Add_Dom20210302.xml"
$templatePath = "C:\Users\thomaspaul\Warner Music Group\CE-FocusList - General\Entwicklung\PS\Template_FocusList20210222 incl DOM.xml"
$templatePath = "C:\Users\thomaspaul\Warner Music Group\CE-FocusList - General\Entwicklung\PS\Template_FocusList_allField.xml"
$templatePath = "C:\Users\thomaspaul\Warner Music Group\CE-FocusList - General\Entwicklung\PS\Template_FocusList - Add_CuC20210310.xml"
$templatePath = "C:\Users\thomaspaul\Warner Music Group\CE-FocusList - General\Entwicklung\PS\Template_FocusList - AddView_CnC_Master.xml"
$templatePath = "C:\Users\thomaspaul\Warner Music Group\CE-FocusList - General\Entwicklung\PS\Template_FocusList - AddField_MPN.xml"
$templatePath = "C:\Users\thomaspaul\Warner Music Group\CE-FocusList - General\Entwicklung\PS\Template_FocusList - AddView_MPN.xml"
$templatePath = "C:\Users\thomaspaul\Warner Music Group\CE-FocusList - General\Entwicklung\PS\Template_FocusList - AddView_MPNalltime.xml"
$templatePath = "C:\Users\thomaspaul\Warner Music Group\CE-FocusList - General\Entwicklung\PS\Template_FocusList - AddField HipHop"
$templatePath = "C:\Users\thomaspaul\Warner Music Group\CE-FocusList - General\Entwicklung\PS\Template_FocusList - AddView HipHop.xml"
$templatePath = "C:\Users\thomaspaul\Warner Music Group\CE-FocusList - General\Entwicklung\PS\Template_FocusList - AddField_DSP_Pitch.xml"
$templatePath = "C:\Users\thomaspaul\Warner Music Group\CE-FocusList - General\Entwicklung\PS\Template_FocusList - AddView_OPS.xml"
$templatePath = "C:\Users\thomaspaul\Warner Music Group\CE-FocusList - General\Entwicklung\PS\focuslistPRD20210726_import.xml"
Get-PnPProvisioningTemplate -Out c:\temp\focuslist11.pnp
Apply-PnPProvisioningTemplate -path $templatePath


## Install SP Module
Uninstall-Module -Name SharePointPnPPowerShellOnline -AllVersions -Force
Install-Module -Name SharePointPnPPowerShellOnline
Install-Module SharePointPnPPowerShellOnline
Update-Module SharePointPnPPowerShell*

##ClientPage Type Change:
$PageName = "Focus-List-INT"
Set-PnPClientSidePage -Identity $PageName -LayoutType Home

##Export to XML:
Export-PnPTermGroupToXml -Out c:\temp\termprod20210722.xml -Identity "WM Central Europe"
Import-PnPTermGroupFromXml -Path c:\temp\termprod20210316.xml
Export-PnPTaxonomy -Path c:\temp\genre.txt -TermSetId 231805d8-d531-4a06-9fbb-1efed3bbf90e -Lcid 1033
Export-PnPTaxonomy -Path c:\temp\format.txt -TermSetId 9f174ece-ee14-4f58-bc92-18c89ac74984
Export-PnPTaxonomy -Path c:\temp\label.txt -TermSetId f9c9ac1c-9128-4c44-8c3c-8844ed2d9831
Export-PnPTaxonomy -Path c:\temp\unit.txt -TermSetId 2557dadd-2147-4a9e-b2b6-f14622a59e5b



Connect-PnPOnline -Url https://wmg.sharepoint.com -UseWebLogin

Export-PnPListToProvisioningTemplate -Out "C:\Users\thomaspaul\Warner Music Group\CE-FocusList - General\Entwicklung\PS\focuslistPRD20210803.xml" -List "Focus List"
Export-PnPListToProvisioningTemplate -Out c:\temp\focuslistField.xml -List "FocusList_Field"
Export-PnPListToProvisioningTemplate -Out c:\temp\matrix.xml -List "FocusList_Matrix"

Uninstall-Module -Name SharePointPnPPowerShellOnline -AllVersions -Force
Install-Module -Name PnP.PowerShell -AllowPrerelease