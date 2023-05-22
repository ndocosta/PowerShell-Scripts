#App Registration Permissions
#SharePoint Sites.Read.All (Application Permission)

#Parameters
$SharePointOnlineAdminUrl = "https://<tenant>-admin.sharepoint.com"
$clientID = "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
$certThumbprint = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
$tenant = "<tenant>.onmicrosoft.com"
$FileExtensionToSearch = "exe"
$CSVFile = "C:\Temp\SharePoint_Files_" + $FileExtensionToSearch + ".csv"


$SearchQuery = "Filetype:" + $FileExtensionToSearch

#Connect to PnP Online
Connect-PnPOnline -Url $SharePointOnlineAdminUrl -Tenant $tenant -ClientId $clientID -Thumbprint $certThumbprint

#Execute Search
$SearchResults = Submit-PnPSearchQuery -Query $SearchQuery -All -TrimDuplicates $False -SelectProperties Filename, Path, Author, Size, ListItemID, LastModifiedTime, ParentLink

#Collect Data from search results
$Results = @()
ForEach ($ResultRow in $SearchResults.ResultRows)
{    
    $Results += [pscustomobject] @{
        Filename     = $ResultRow["Filename"]
        Author       = $ResultRow["Author"]
        Size         = $ResultRow["Size"]
        LastModified = $ResultRow["LastModifiedTime"]
        ListItemID   = $ResultRow["ListItemID"]
        ParentFolder = $ResultRow["ParentLink"]
        URL          = $ResultRow["Path"]
    }
}

Write-Host "Total Results: $($Results.Count)"

#Export results to CSV
$Results | Export-Csv -Path $CSVFile -NoTypeInformation -Encoding UTF8