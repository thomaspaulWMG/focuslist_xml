$sourceListName = "Focus List"
$viewName = "to_archive"
$destinationListName = "Focus List_currentYear_arc"
$siteUrl = "https://wmg.sharepoint.com/sites/CE-Focus-List"

$logfilePath = "$(Get-Location)\Logs\"
$logfileName = "UploadSkript-$(Get-Date -Format "MM.dd.yyyy-HH.mm").log"
$errorLogfilePath = "$(Get-Location)\Logs\"
$errorLogfileName = "UploadSkriptError.log"

Function LogWrite
{
    Param ([string]$logstring)

    Write-Host $logstring
    if (!(Test-Path $logfilePath)) {
        New-Item -Path $logfilePath -ItemType Directory -Force | Out-Null
    }

    $fullPath = "$logfilePath$logFileName"
    if(!(Test-Path $fullPath)){
        New-Item -path $logfilePath -name $logFileName -type File | Out-Null
    }

   Add-Content -Path $fullPath -Value $logstring
}

Function LogError
{
    Param ([string]$logstring)

    Write-Host $logstring
    if (!(Test-Path $errorLogfilePath)) {
        New-Item -Path $errorLogfilePath -ItemType Directory -Force | Out-Null
    }

    $fullPath = "$errorLogfilePath$errorLogfileName"
    if(!(Test-Path $fullPath)){
        New-Item -path $errorLogfilePath -name $errorLogfileName -type File | Out-Null
    }

   Add-Content -Path $fullPath -Value $logstring
}

function Get-Metadata{
    param ($listItem, $view)
    $fieldValues = @{}
    $viewFieldArray = [System.Collections.ArrayList]::new()
    foreach($viewField in $listView.ViewFields)
    {
        [void]$viewFieldArray.Add($viewField)
    }

    foreach($fieldValue in $listItem.FieldValues.GetEnumerator())
    {
        #Check if field is in view and is not an internal field
        if($fieldValue.Value -ne $null -and !$fieldValues.ContainsKey($fieldValue.Key) -and $viewFieldArray.Contains($fieldValue.Key) -and !($fieldValue.Key -eq "ID") -and !($fieldValue.Key.Contains("_x003a_")))
        {
            if($fieldValue.Value.GetType().Name -eq "FieldLookupValue")
            {
                if($fieldValue.Value.LookupId -ne $null)
                {
                    #If the child item cant find a mapped item, it throws an error. Can be commented out, then the child lookup will be empty
                    $lookupId = $fieldValue.Value.LookupId
                    $mappedValue = $idMapping[$lookupId.ToString()]
                    if($mappedValue -ne $null)
                    {
                        $fieldValues.Add($fieldValue.Key, $idMapping[$lookupId.ToString()])
                    }
                    else
                    {
                        throw "No mapped value found"
                    }
                }
            }
            elseif($fieldValue.Value.GetType().Name -eq "FieldUserValue")
            {
                $fieldValues.Add($fieldValue.Key, $fieldValue.Value.Email)
            }
            elseif($fieldValue.Value.GetType().Name -eq "TaxonomyFieldValue")
            {
                $fieldValues.Add($fieldValue.Key, $fieldValue.Value.TermGuid)
            }
            elseif($fieldValue.Value.GetType().Name -eq "FieldUrlValue")
            {
                if($fieldValue.Value.Url -ne $null)
                {
                    $url = $fieldValue.Value.Url
                    $description = $fieldValue.Value.Description 
                    $fieldValues.Add($fieldValue.Key, "${url}, ${description}")
                }
            }
            else
            {
                #Sometimes dates are malformed, whith the cast i put them back into SharePoint accepted strings 
                switch -Regex ($fieldValue.Value)
                {
                    '\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z' {
                        if($fieldValue.Value.GetType().Name -ne "DateTime")
                        {
                            if($fieldValue.Key -eq "Last_x0020_Modified")
                            {
                                $fieldValues.Add("Modified", ([datetime]::ParseExact($($fieldValue.Value),'yyyy-MM-ddTHH:mm:ssZ', $null))); 
                            }
                            elseif($fieldValue.Key -eq "Created_x0020_Date")
                            {
                                $fieldValues.Add("Created", ([datetime]::ParseExact($($fieldValue.Value),'yyyy-MM-ddTHH:mm:ssZ', $null))); 
                            }
                            
                        }
                        break; 
                    }
                    default 
                    {
                        $fieldValues.Add($fieldValue.Key, $fieldValue.Value)
                    }
                }
            }
        }
    }

    return $fieldValues
}

LogWrite("[$(Get-Date -Format "HH:mm.ss.fff")] Connecting to SharePoint Site $($siteUrl)")
Connect-PnPOnline -Url $siteUrl -UseWebLogin

LogWrite("[$(Get-Date -Format "HH:mm.ss.fff")] Getting source list")
$sourceList = Get-PnPList -Identity $sourceListName
$sourceListContentTypes = Get-PnPContentType -List $sourceList

LogWrite("[$(Get-Date -Format "HH:mm.ss.fff")] Getting destination list")
$destinationList = Get-PnPList -Identity $destinationListName
$destinationListContentTypes = Get-PnPContentType -List $destinationList

LogWrite("[$(Get-Date -Format "HH:mm.ss.fff")] Getting source items")
$listView  = Get-PnPView -List $sourceList.Id -Identity $viewName -Includes ListViewXml
$items = Get-PnPListItem -List $sourceList -PageSize 2000 -Query $listView.ListViewXml

$idMapping = @{}

foreach($item in $items)
{
    try{
        LogWrite("[$(Get-Date -Format "HH:mm.ss.fff")] Iterating item $($item["Title"])")
        $listItem = $null
        Get-PnPProperty -ClientObject $item -Property Versions, ContentType
        $versions = $item.Versions
        for($i = $versions.Count; $i -gt 0; $i--)
        {
            $version = $versions[$i -1]
            LogWrite("[$(Get-Date -Format "HH:mm.ss.fff")] Uploading version $($version.VersionLabel)")
            $fieldValues = Get-Metadata($version, $listView)
            if($listItem -eq $null)
            {
	            $listItem = Add-PnPListItem -List $destinationList -Values $fieldValues -ContentType $item.ContentType.Name -ErrorAction Stop
            }
            else
            {
                Set-PnPListItem -List $destinationList -Values $fieldValues -Identity $listItem -ContentType $item.ContentType.Name -ErrorAction Stop
            }
        }

        LogWrite("[$(Get-Date -Format "HH:mm.ss.fff")] Uploading last version")
        $fieldValues = Get-Metadata($item, $listView)
        if($listItem -eq $null)
        {
	        $listItem = Add-PnPListItem -List $destinationList -Values $fieldValues -ContentType $item.ContentType.Name -ErrorAction Stop
        }
        else
        {
            Set-PnPListItem -List $destinationList -Values $fieldValues -Identity $listItem -ContentType $item.ContentType.Name -ErrorAction Stop
        }

        #Change "Prod_ID" to the ID Field that should be mapped
        $idMapping.Add($item.FieldValues["ID"].ToString(), $listItem.id)

        #LogWrite("[$(Get-Date -Format "HH:mm.ss.fff")] Removing original item")
        #Remove-PnpListItem -List $sourceListName -Identity $item -Recycle -Force
    }
    catch {
        LogWrite("[$(Get-Date -Format "HH:mm.ss.fff")] Error while writing")
        LogError("[$(Get-Date -Format "HH:mm.ss.fff")] Error while writing")
        LogError($_.Exception)
    }

}