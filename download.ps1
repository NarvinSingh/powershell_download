add-type @"
using System.Net;
using System.Security.Cryptography.X509Certificates;
public class TrustAllCertsPolicy : ICertificatePolicy {
  public bool CheckValidationResult(
    ServicePoint srvPoint,
    X509Certificate certificate,
    WebRequest request,
    int certificateProblem) {
      return true;
    }
}
"@
$AllProtocols = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
[System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
$credential = New-Object System.Management.Automation.PSCredential ('username', (ConvertTo-SecureString 'password' -AsPlainText -Force))
$n = 10

for ($i = 1; $i -le $n; $i++)
{
    $file = "filname.part$i.ext"
    
    write-host "Downloading $file" -ForegroundColor Green
    Invoke-WebRequest -Uri "https://server/path/to/$file" -OutFile "C:\path\to\$file" -Proxy 'http://my-proxy:8080' -ProxyUseDefaultCredentials -Credential $credential
}
