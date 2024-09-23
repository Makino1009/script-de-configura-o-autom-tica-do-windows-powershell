# CADA LINHA REMOVE UM DOS BLOATWARES (VOCÊ VAI SABER QUAL É QUAL SÓ DE BATER O OLHO).
# NOTA: ELES PODEM CONTINUAR NO MENU INICIAL, MAS NÃO ESTARÃO MAIS NO COMPUTADOR. 
# TESTADO E FUNCIONANDO

echo ATENÇÃO: NAO MEXER NO COMPUTADOR ENQUANTO ESSE SCRIPT ESTÁ SENDO EXECUTADO. 
pause

echo REMOVENDO O BLOATWARE...

Get-AppxPackage -Name "Microsoft.WindowsAlarms" | Remove-AppxPackage;
Get-AppxPackage -Name "SpotifyAB.SpotifyMusic" | Remove-AppxPackage;
Get-AppxPackage -Name "Microsoft.549981C3F5F10" | Remove-AppxPackage;
Get-AppxPackage -Name "Microsoft.SkypeApp" | Remove-AppxPackage;
Get-AppxPackage -Name "Microsoft.WindowsFeedbackHub" | Remove-AppxPackage;
Get-AppxPackage -Name "Microsoft.MicrosoftSolitaireCollection" | Remove-AppxPackage;
Get-AppxPackage -Name "Microsoft.WindowsSoundRecorder" | Remove-AppxPackage;
Get-AppxPackage -Name "Microsoft.Microsoft3DViewer" | Remove-AppxPackage;
Get-AppxPackage -Name "Microsoft.XboxGamingOverlay" | Remove-AppxPackage;
Get-AppxPackage -Name "Microsoft.YourPhone" | Remove-AppxPackage;
Get-AppxPackage -Name "Microsoft.ZuneVideo" | Remove-AppxPackage;
Get-AppxPackage -Name "Microsoft.Office.OneNote" | Remove-AppxPackage;
Get-AppxPackage -Name "Microsoft.Getstarted" | Remove-AppxPackage;
Get-AppxPackage -Name "Microsoft.YourPhone" | Remove-AppxPackage;
Get-AppxPackage -Name "WindowsCamera" | Remove-AppxPackage;
Get-AppxPackage -Name "Microsoft.ZuneVideo" | Remove-AppxPackage;
Get-AppxPackage -Name "Microsoft.Todos" | Remove-AppxPackage;
Get-AppxPackage -Name "Microsoft.ScreenSketch" | Remove-AppxPackage;
Get-AppxPackage -Name "Microsoft.People" | Remove-AppxPackage;
Get-AppxPackage -Name "Microsoft.GetHelp" | Remove-AppxPackage;
Get-AppxPackage -Name "Microsoft.GamingApp" | Remove-AppxPackage;
Get-AppxPackage -Name "Microsoft.BingWeather" | Remove-AppxPackage;
Get-AppxPackage -Name "Microsoft.BingNews" | Remove-AppxPackage;
Get-AppxPackage -Name "Microsoft.Windows.Photos" | Remove-AppxPackage;
Get-AppxPackage -Name "microsoft.windowscommunicationsapps" | Remove-AppxPackage;
Get-AppxPackage -Name "microsoft.WindowsMaps" | Remove-AppxPackage;
Get-AppxPackage -Name "Microsoft.MicrosoftOfficeHub" | Remove-AppxPackage;
Get-AppxPackage -Name "Microsoft.ZuneMusic" | Remove-AppxPackage;
Get-AppxPackage -Name "Microsoft.MicrosoftStickyNotes" | Remove-AppxPackage;
Get-AppxPackage -Name "Microsoft.Office" | Remove-AppxPackage;
Get-AppxPackage -Name "Spotify.Spotify" | Remove-AppxPackage;
Get-AppxPackage -Name "Skype" | Remove-AppxPackage;
Get-AppxPackage -Name "Microsoft.OneDrive" | Remove-AppxPackage;
Get-AppxPackage -Name "Microsoft.OneNote" | Remove-AppxPackage;
Get-AppxPackage -Name "Microsoft.Xbox" | Remove-AppxPackage;
Get-AppxPackage -Name "Microsoft.MixedReality.Portal" | Remove-AppxPackage;
Get-AppxPackage -Name "Microsoft.MSPaint" | Remove-AppxPackage;
Get-AppxPackage *xboxapp* | Remove-AppxPackage;


# A PARTE DEBAIXO REMOVE O ONEDRIVE. É UM SCRIPT PRA REMOVER ELE E TODA A PORCARIA QUE FICA NO PC EM SEGUIDA. COPIEI DE UMA RESPOSTA NUM FÓRUM GRINGO.
# TESTADO E FUNCIONANDO

echo REMOVENDO O ONEDRIVE...

Import-Module -DisableNameChecking $PSScriptRoot\..\lib\force-mkdir.psm1
Import-Module -DisableNameChecking $PSScriptRoot\..\lib\take-own.psm1

taskkill.exe /F /IM "OneDrive.exe"
taskkill.exe /F /IM "explorer.exe"

if (Test-Path "$env:systemroot\System32\OneDriveSetup.exe") {
    & "$env:systemroot\System32\OneDriveSetup.exe" /uninstall
}
if (Test-Path "$env:systemroot\SysWOW64\OneDriveSetup.exe") {
    & "$env:systemroot\SysWOW64\OneDriveSetup.exe" /uninstall
}

force-mkdir "HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\OneDrive"
sp "HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\OneDrive" "DisableFileSyncNGSC" 1

rm -Recurse -Force -ErrorAction SilentlyContinue "$env:localappdata\Microsoft\OneDrive"
rm -Recurse -Force -ErrorAction SilentlyContinue "$env:programdata\Microsoft OneDrive"
rm -Recurse -Force -ErrorAction SilentlyContinue "C:\OneDriveTemp"

New-PSDrive -PSProvider "Registry" -Root "HKEY_CLASSES_ROOT" -Name "HKCR"
mkdir -Force "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}"
sp "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" "System.IsPinnedToNameSpaceTree" 0
mkdir -Force "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}"
sp "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" "System.IsPinnedToNameSpaceTree" 0
Remove-PSDrive "HKCR"

reg load "hku\Default" "C:\Users\Default\NTUSER.DAT"
reg delete "HKEY_USERS\Default\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "OneDriveSetup" /f
reg unload "hku\Default"

rm -Force -ErrorAction SilentlyContinue "$env:userprofile\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk"

start "explorer.exe"

sleep 15

foreach ($item in (ls "$env:WinDir\WinSxS\*onedrive*")) {
    Takeown-Folder $item.FullName
    rm -Recurse -Force $item.FullName
}

 
# DEIXA O DNS DO GOOGLE JÁ CONFIGURADO

Get-WmiObject -Class Win32_IP4RouteTable | where { $_.destination -eq '0.0.0.0' -and $_.mask -eq '0.0.0.0'} | Sort-Object metric1 | select interfaceindex | set-DnsClientServerAddress -ServerAddresses ('8.8.8.8', '8.8.4.4')
