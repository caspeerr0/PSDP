function Run-Simple-WebServer
{ 
<#
.SYNOPSIS
 PowerShell Web Server. This basic webserver allows for the upload ,download ,list,and delete .

.DESCRIPTION
A cmdlet to launch a simple PowerShell Web Server. This basic webserver allows for the upload ,download ,list,and delete , Here is a simple way to execute command over http protocole. 

.PARAMETER WebRoot
The webroot of the server, the web server will work from you can spacfy one  default is the same folder have the script

.PARAMETER url
The url to run the webserver on. -u for short

.EXAMPLE
PS C:\> . .\web-ser.ps1
PS C:\> Run-Simple-WebServer

.LINK
http://obscuresecurity.blogspot.mx/2014/05/dirty-powershell-webserver.html
https://gist.github.com/wagnerandrade/5424431

.NOTES
This script has been created for completing the requirements of the SecurityTube PowerShell for Penetration Testers Certification Exam
http://www.securitytube-training.com/online-courses/powershell-for-pentesters/
Student ID:3270
#>

[CmdletBinding()] Param( 

       [Parameter(Mandatory = $false)]
       [String]
       $WebRoot = ".",
       
       [Parameter(Mandatory = $false)]
       [Alias("u")]
       [String]
       $url = 'http://localhost:8080/'

    )

$routes = @{
    # Simple response
    "/hellow" = { return '<html><body>Hello world!</body></html>' } 
    # uploaad file pased on post data
    "/upload" = { (Set-Content -Path (Join-Path $WebRoot ($context.Request.QueryString[0])) -Value ($context.Request.QueryString[1]))
                     return "Succesfully uploaded" }
    # list the file in the diroctory 
    "/list" = { return dir $WebRoot }
    # download file in the diroctory 
    "/download" = { return (Get-Content (Join-Path $WebRoot ($context.Request.QueryString[0]))) }
    # delete file in the diroctory 
    "/delete" = { (rm (Join-Path $WebRoot ($context.Request.QueryString[0])))
                     return "file deleted" }
    # shuts downthe server 
    "/out" = { exit }

}
# this code was borrowed from from http://obscuresecurity.blogspot.com/2014/05/dirty-powershell-webserver.html
    $listener = New-Object System.Net.HttpListener
    $listener.Prefixes.Add($url)
    $listener.Start()

    write-host "listening to $url "
    try{
      while ($listener.IsListening)
      {
        $context = $listener.GetContext()
        $requestUrl = $context.Request.Url
        $response = $context.Response
       
        
        Write-Host " $requestUrl"
       
        $localPath = $requestUrl.LocalPath
        $route = $routes.Get_Item($requestUrl.LocalPath)
        # if the user request somthing not in the zone 
        if ($route -eq $null)
        {
          $response.StatusCode = 404
        }
        else
        {
          $content = & $route
          $buffer = [System.Text.Encoding]::UTF8.GetBytes($content)
          $response.ContentLength64 = $buffer.Length
          $response.OutputStream.Write($buffer, 0, $buffer.Length)
        }
        
        $response.Close()
        $responseStatus = $response.StatusCode
        Write-Host "< $responseStatus"
      }
    }catch{ }
  }
