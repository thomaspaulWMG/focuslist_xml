connect-pnponline -url https://warnermusicdev03.sharepoint.com/sites/FocusList04 
-UseWebLogin
$templatePath = "C:\Users\thomaspaul\Warner Music Group\CE-FocusList - General\Entwicklung\XML\Template_FocusList - Child.xml"

Apply-PnPProvisioningTemplate -path $templatePath

Apply-PnPProvisioningTemplate -Path c:\temp\focuslist11.pnp
Import-PnPTermGroupFromXml -Path c:\temp\termprod.xml

$templatePath = "c:\temp\focuslist.xml"

Apply-PnPProvisioningTemplate -path $templatePath