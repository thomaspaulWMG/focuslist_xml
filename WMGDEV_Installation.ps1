connect-pnponline -url https://wmgdev.sharepoint.com/sites/CE-Focus-List 
-UseWebLogin
$templatePath = "C:\Users\thomaspaul\Warner Music Group\CE-FocusList - General\Entwicklung\XML\Template_FocusList - Child.xml"

Connect-PnPOnline -Url https://wmgdev-admin.sharepoint.com -UseWebLogin
Add-PnPSiteCollectionAppCatalog -Site https://wmgdev.sharepoint.com/sites/CE-Focus-List

Apply-PnPProvisioningTemplate -path $templatePath

Apply-PnPProvisioningTemplate -Path c:\temp\focuslist10.pnp

Import-PnPTermGroupFromXml -Path c:\temp\termprod.xml

Export-PnPListToProvisioningTemplate -Out c:\temp\focuslistDEV210113.xml -List "Focus List"

##ClientPage Type Change:
$PageName = "Test-HWO"
Set-PnPClientSidePage -Identity $PageName -LayoutType Home

#Set Parameters
$AdminCenterURL="https://wmgdev-admin.sharepoint.com"
$SiteURL = "https://wmg.sharepoint.com/sites/CE-Focus-List/"
 
#Connect to SharePoint Online
Connect-SPOService -Url $AdminCenterURL -Credential (Get-Credential)
 
#Disable Social Bar on Site Pages
#für eine Sitecollection
$SiteURL = "https://wmg.sharepoint.com/sites/CE-Focus-List/"
Set-SPOSite -Identity $SiteURL -SocialBarOnSitePagesDisabled $True
#für ganzen Tenant
Set-SPOTenant -SocialBarOnSitePagesDisabled $true