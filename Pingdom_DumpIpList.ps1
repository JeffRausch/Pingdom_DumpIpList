#Set Variables
$inputPage = "https://www.pingdom.com/rss/probe_servers.xml"
$outputFile_ByTitle = Join-Path $PSScriptRoot "PingdomIPList_ByTitle.txt"
$outputFile_ByIp = Join-Path $PSScriptRoot "PingdomIPList_ByIP.txt"

#Retrieve the RSS feed doc containing all the Pingdom probe IPs
[xml]$xmlDoc = Invoke-WebRequest $inputPage

#Array to hold only the items we care about
$itemList = @()

#Loop through all items and only keep the ones that match our requirements
foreach($item in $xmlDoc.rss.channel.item){
    if ($item.region -eq "NA" -and $item.state -eq "Active"){
        $itemList += $item
    }
}

#Sort the object by Title, grab only the Title and IP, format the output, and save it to a file
$itemList | Sort-Object -Property title | Select-Object -Property title, ip | Format-Table | Out-File $outputFile_ByTitle

#Sort the object by IP, grab only the IP and Title, format the output, and save it to a file
#NOTE: Cast IP as System.Version so that it sorts as expected (ie. 2.2.2.2 before 12.12.12.12)
$itemList | Sort-Object -Property { [System.Version] $_.ip } | Select-Object -Property ip, title | Format-Table | Out-File $outputFile_ByIp
