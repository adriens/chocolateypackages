function Invoke-GitClone($url, $path) {
  Push-Location $path
  git clone $url
  Pop-Location
}

Update-ExecutionPolicy Unrestricted
Enable-RemoteDesktop

# scoop!
Invoke-Expression (New-Object System.Net.WebClient).DownloadString("https://get.scoop.sh")
scoop install sudo
scoop install concfg

# enable fancy Windows features
cinst Microsoft-Hyper-V-All -source windowsFeatures
cinst IIS-WebServerRole -source windowsfeatures

# no MSDN license here
cinst VisualStudio2012WDX
cinst VisualStudioExpress2012Web
cinst VisualStudioExpress2012Windows8

# everything else
cinst all -source https://myget.org/F/fullblowndotnet

$ps_profile_path = Join-Path $ENV:USERPROFILE "Documents\WindowsPowerShell"
$ps_modules_path = Join-Path $profile_path "Modules"

New-Item $ps_modules_path -Type Directory

# my PowerShell profile
Invoke-GitClone -url git@github.com:AnthonyMastrean/WindowsPowerShell.git -path $ps_profile_path

# and all my fave Modules
@(
  "git@github.com:AnthonyMastrean/remember.git",
  "git@github.com:AnthonyMastrean/powertab.git",
  "git@github.com:AnthonyMastrean/chocolatey-dev.git",
  "git@github.com:dahlbyk/posh-git.git",
  "git@github.com:dahlbyk/posh-hg.git",
  "git@github.com:Iristyle/Posh-VsVars.git",
) | %{ Invoke-GitClone -url $_ -path $ps_modules_path }

# pinned applicatin shortcuts
Install-ChocolateyPinnedTaskBarItem "${ENV:PROGRAMFILES(X86)}\Google\Chrome\Application"
Install-ChocolateyPinnedTaskBarItem "$ENV:WINDIR\System32\WindowsPowerShell\v1.0\powershell.exe"
Install-ChocolateyPinnedTaskBarItem "$ENV:PROGRAMFILES\Notepad2\notepad2.exe"
Install-ChocolateyPinnedTaskBarItem "$ENV:WINDIR\System32\SnippingTool.exe"

Install-WindowsUpdates -AcceptEula
