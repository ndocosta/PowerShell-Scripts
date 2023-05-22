#App Registration Permissions
#SharePoint Sites.Read.All (Application Permission)

#Parameters
$SharePointOnlineAdminUrl = "https://m365x043024-admin.sharepoint.com"
$clientID = "9681712e-201b-419a-a788-ef1ff68084b9"
$certThumbprint = "EA4232F82903E9CB5591EA7597389DF9EE0BF000"
$tenant = "m365x043024.onmicrosoft.com"
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