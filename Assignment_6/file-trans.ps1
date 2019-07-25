function trans-file {
    <#
    .DESCRIPTION
    Transfare file from client to server 
    .EXAMPLE
    PS C:\> . .\trans-file.ps1
    PS C:\> trans-file -Target 127.0.0.1 -localfile c:\users\public\test.txt -remotefiel c:\test.txt  
    .PARAMETER Target
    The target IP Address.
    .PARAMETER localfile
    local file that would be tranmsfare 
    .PARAMETER remotefiel
    path to be copy to
    .LINK
    https://blog.ipswitch.com/use-powershell-copy-item-cmdlet-transfer-files-winrm
    https://stackoverflow.com/questions/10011794/hardcode-password-into-powershells-new-pssession
    .NOTES
    This script has been created for completing the requirements of the SecurityTube PowerShell for Penetration Testers Certification Exam
    http://www.securitytube-training.com/online-courses/powershell-for-pentesters/
    Student ID:3270
    
    #>
    
    
    [CmdletBinding()] Param(
        [Parameter(Mandatory = $true)]
        [string]
        $Target ,
    
        [Parameter(Mandatory = $true)]
        [string]
        $localfile  , 

        [Parameter(Mandatory = $true)]
        [string]
        $remoteFiel 
    )
    # making the password secure
    $username = "lab\administrator"
    $pass = "P@ssw0rd"  
    $Secpass = ConvertTo-SecureString $pass -AsPlainText -Force 
    $creds = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $username, $Secpass  

    # execute the session 
    $connect = New-PSSession -ComputerName $Target -Credential $creds
    $content= Get-Content $localfile
    # do the magic  
    try {
        invoke-command -session $connect -script {param($contents,$Filepath) $Contents | Out-File "$Filepath"} -argumentlist $Content,$remoteFiel

        Write-Host "File transferred successfully" -ForegroundColor Green
    }
    catch {
        Write-Host "Something Went Wrong" -ForegroundColor Red
    }
   }
