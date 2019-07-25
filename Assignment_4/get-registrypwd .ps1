function get-registrypwd 
{
<#
.SYNOPSIS
A cmdlet to looks for passwords stored on the local windows registry.
.DESCRIPTION
This script will try to find  the autologin in the macheain while it's confugerd 
.EXAMPLE
PS C:\> . .\Get-Registry-Passwords.ps1

.LINK
https://expert-advice.org/windows-server/how-to-set-up-auto-login-windows-server-2012-and-2016/
https://github.com/HarmJ0y/PowerUp/blob/master/PowerUp.ps1
.NOTES
This script has been created for completing the requirements of the SecurityTube PowerShell for Penetration Testers Certification Exam
http://www.securitytube-training.com/online-courses/powershell-for-pentesters/
Student ID:3270

#> 


     # this code was copied from powerup project it was a part from the project 
     # https://github.com/HarmJ0y/PowerUp/blob/master/PowerUp.ps1
     # @HarmJ0y
     # after made the envirement ready to be executed :) 

[CmdletBinding()] Param()
# here we assighend $AutoAdminLogon to the registry key locatef  hklm:SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon and aboiding errors
$AutoAdminLogon = $(Get-ItemProperty -Path "hklm:SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name AutoAdminLogon -ErrorAction SilentlyContinue)

if ($AutoAdminLogon.AutoAdminLogon -ne 0){
# if there are credantails devide them as requested 
    $DefaultDomainName = $(Get-ItemProperty -Path "hklm:SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DefaultDomainName -ErrorAction SilentlyContinue).DefaultDomainName

    $DefaultUserName = $(Get-ItemProperty -Path "hklm:SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DefaultUserName -ErrorAction SilentlyContinue).DefaultUserName

    $DefaultPassword = $(Get-ItemProperty -Path "hklm:SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DefaultPassword -ErrorAction SilentlyContinue).DefaultPassword



    if ($DefaultUserName) {
        # add the information to $out then print $out 
        $out = New-Object System.Collections.Specialized.OrderedDictionary

        $out.add('DefaultDomainName', $DefaultDomainName)

        $out.add('DefaultUserName', $DefaultUserName)

        $out.add('DefaultPassword', $DefaultPassword )

        $out

    }


        # if the registry key saved as "AltDefault"
    $AltDefaultDomainName = $(Get-ItemProperty -Path "hklm:SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name AltDefaultDomainName -ErrorAction SilentlyContinue).AltDefaultDomainName

    $AltDefaultUserName = $(Get-ItemProperty -Path "hklm:SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name AltDefaultUserName -ErrorAction SilentlyContinue).AltDefaultUserName

    $AltDefaultPassword = $(Get-ItemProperty -Path "hklm:SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name AltDefaultPassword -ErrorAction SilentlyContinue).AltDefaultPassword


    # add the information to $out then print $out 
    if ($AltDefaultUserName) {

        $out = New-Object System.Collections.Specialized.OrderedDictionary

        $out.add('AltDefaultDomainName', $AltDefaultDomainName)

        $out.add('AltDefaultUserName', $AltDefaultUserName)

        $out.add('AltDefaultPassword', $AltDefaultPassword )

        $out

    }

}  
}
 
