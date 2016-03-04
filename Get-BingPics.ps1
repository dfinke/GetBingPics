function Get-BingPics {
    param(
        [Parameter(ValueFromPipeline=$true)]
        $q
    )
        
    Process {
        
        $Key=$env:BingPicKey
        if(!$env:BingPicKey) {
            Throw '$env:BingPicKey needs to be set'
        }

        $Base64KeyBytes = [Text.Encoding]::ASCII.GetBytes("ignored:$Key")
        $Base64Key = [Convert]::ToBase64String($Base64KeyBytes)

        $url = "https://api.datamarket.azure.com/Bing/Search/Image?`$format=json&Query='$q'"

        $r=Invoke-RestMethod $url -Headers @{ 'Authorization' = "Basic $Base64Key" }

        $links = $r.d.results| % {
            '<a href="{1}"><img src="{0}" alt="{2}", title="{2}" /></a>' -f ($_.Thumbnail.MediaUrl),($_.MediaUrl),($_.Title)
        }

@"
<html>
<body>
<h1>"{0}" pictures</h1>
{1}
</body>
</html>
"@ -f $q, ($links -join ' ') | Set-Content -Encoding Ascii "c:\temp\pics.html"

        Invoke-Item "c:\temp\pics.html"
    }
}

