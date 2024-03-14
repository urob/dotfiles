# You need to enable virtualization and WSL before this will work
# dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
# dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

function Get-Input {
    param (
        [string]$prompt,
        [string]$default
    )

    $userInput = Read-Host "$prompt [$default]"

    if ([string]::IsNullOrWhiteSpace($userInput)) {
        return $default
    } else {
        return $userInput
    }
}

function Get-Good-Temp-File-Path {
    param (
        [string]$baseName,
        [string]$extension
    )
    $badName = [System.IO.Path]::GetRandomFileName()
    $goodName = [System.IO.Path]::GetFileNameWithoutExtension($badName)
    $tempFolder = [System.IO.Path]::GetTempPath()
    $goodPath = "$tempFolder$baseName-$goodName.$extension"
    return $goodPath
}

$wslDistroName = Get-Input -prompt "WSL Distro Name" -default "NixOS"
$installFolder = Get-Input -prompt "Install Folder" -default "$env:USERPROFILE\WSL\$wslDistroName"

$url = "https://github.com/nix-community/NixOS-WSL/releases/latest/download/nixos-wsl.tar.gz"
$outputPath = Get-Good-Temp-File-Path -baseName "NixOS" -extension "tar.gz"

$webClient = New-Object System.Net.WebClient
$webClient.DownloadFile($url, $outputPath)

wsl --import $wslDistroName $installFolder $outputPath\nixos-wsl.tar.gz

Remove-Item $outputPath

Write-Output "Done with distro install, rebuilding"

wsl -d $wslDistroName --user root ./initialize-root.sh $nixUser "$nixUserFullName" "`"$env:USERPROFILE`"" $multiUser

Write-Output "Done with initialize-root.sh, shutting down wsl"
wsl --shutdown

Write-Output "Running initialize-user-1.sh"
wsl -d $wslDistroName --user $nixUser ./initialize-user-1.sh $multiUser
wsl --shutdown

Write-Output "Running initialize-user-2.sh"
wsl -d $wslDistroName --user $nixUser bash --login -c `"./initialize-user-2.sh \`""$env:USERPROFILE"\`" $multiUser `"

Write-Output "Configuring default username for WSL"
& $alpine config --default-user $nixUser

Write-Output "Done!"
