function Enable-DevEnv {
    Push-Location 'C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools\Common7\Tools'
    cmd /c "VsDevCmd.bat&set" |
    ForEach-Object {
      if ($_ -match "=") {
        $v = $_.split("="); set-item -force -path "ENV:\$($v[0])"  -value "$($v[1])"
      }
    }
    Pop-Location
    write-host "Visual Studio 2017 Command Prompt variables set." -ForegroundColor Yellow -NoNewline
}

function Enable-DevEnv15 {
    Push-Location 'c:\Program Files (x86)\Microsoft Visual Studio 14.0\VC'
    cmd /c "vcvarsall.bat x64 & set" |
    ForEach-Object {
      if ($_ -match "=") {
        $v = $_.split("="); set-item -force -path "ENV:\$($v[0])"  -value "$($v[1])"
      }
    }
    Pop-Location
    $Env:Path = "C:\Qt\Qt5.8.0\5.8\msvc2015_64\bin;" + $Env:Path
    write-host "Visual Studio 2015 Command Prompt variables set." -ForegroundColor Yellow -NoNewline
}

function prompt {
    $dir = split-path $pwd -leaf

    if($pwd -like $home) { $dir = '~' }

    Write-Host $dir -NoNewline -Foreground blue

    Write-VcsStatus
    Write-Host " >" -NoNewLine

    return " "
}

#Import-Module PSColor
Import-Module Get-ChildItemColor
Import-Module posh-git

Set-Alias l Get-ChildItemColor -option AllScope
Set-Alias ls Get-ChildItemColorFormatWide -option AllScope

remove-item alias:curl
remove-item alias:wget

#Set-Alias vim gvim

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
