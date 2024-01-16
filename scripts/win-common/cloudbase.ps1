# Allow TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

# download installer
$client = new-object System.Net.WebClient
$client.DownloadFile("https://github.com/cloudbase/cloudbase-init/releases/download/1.1.4/CloudbaseInitSetup_1_1_4_x64.msi", "C:\Windows\Temp\CloudbaseInitSetup_Stable_x64.msi" )

# install Cloudbase-Init
start-process -FilePath 'C:\Windows\Temp\CloudbaseInitSetup_Stable_x64.msi' -ArgumentList '/qn /l*v C:\Windows\Temp\cloud-init.log' -passthru | wait-process

# Move conf files to Cloudbase directory
#move-item F:/cloudbase-init.conf "C:\Program Files\Cloudbase Solutions\Cloudbase-Init\conf\cloudbase-init.conf" -force
#move-item F:/cloudbase-init-unattend.conf "C:\Program Files\Cloudbase Solutions\Cloudbase-Init\conf\cloudbase-init-unattend.conf" -force

# Run sysprep
start-process -nonewwindow -FilePath "C:/Windows/system32/sysprep/sysprep.exe" -ArgumentList "/generalize /oobe /unattend:C:\progra~1\cloudb~1\cloudb~1\conf\Unattend.xml" -wait

