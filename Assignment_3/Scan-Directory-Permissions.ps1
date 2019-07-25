function Scan-Directory-Permissions
{ 
<#
.SYNOPSIS
A cmdlet to check the security permissions of the windows\system32 folder .
.DESCRIPTION
This script checks if the user execute the script has the right on these folders and show the folders can be write or no .
.PARAMETER Dir
The directory to check, default  "Windows\System32".
.EXAMPLE
PS C:\> . .\Scan-Directory-Permissionss.ps1
PS C:\> Scan-Directory-Permissions -Dir "C:\ProgramData"
.LINK
https://github.com/ankh2054/windows-pentest/blob/master/Powershell/folderperms.ps1
.NOTES
This script has been created for completing the requirements of the SecurityTube PowerShell for Penetration Testers Certification Exam
http://www.securitytube-training.com/online-courses/powershell-for-pentesters/
Student ID: 3270
#>

[CmdletBinding()] Param(
    [Parameter(Mandatory = $false, ValueFromPipeline=$true)]
    [Alias("d" ,"diroctory")]
    [string]
    $dir = 'C:\Windows\System32\'
)
# creating test file to test the weiteablwe folders 
$filecopy = "test.txt"
New-Item $filecopy -Type File | Out-Null
Write-Host -foregroundColor yello "Copying test.txt to all Dir to get the writeable list "
$folders  = Get-ChildItem $dir -Directory

foreach($folder in $folders) {
    # copy test file to all directoryes then take that has no errores to show to host *_*
    Copy-Item $filecopy -Destination $folder.fullname -errorAction SilentlyContinue -errorVariable errors
    if ($errors.Count -le 0)
    {
        Write-Host -foregroundColor Green "Access granted:" $folder
        $removefile = $folder.fullname + "\" + $filecopy
        Remove-Item $removefile 
    }
    else 
    {
         Write-Host -foregroundColor Red "Access denied :" $folder
    }
        

    }

}
