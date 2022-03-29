<#
.SYNOPSIS
    Sets the provided profile as the default AWS cli profile.

.DESCRIPTION
    Manage-AWSProfile sets the provided profile as the default AWS cli profile. To unset the default profile use Manage-AWSProfile -ProfileName <profileName> -Unset.

.PARAMETER ProfileName
    Name of the AWS profile to set as default. Can't be used with -Unset

.PARAMETER List
    Flag, when set will outputs a list all profiles.

.PARAMETER Current
    Flag, when set will outputs values for environment variables: AWS_EB_PROFILE, AWS_PROFILE, AWS_DEFAULT_PROFILE

.PARAMETER Unset
    Flag, when set the function will unset the default profile. Can't be used with -ProfileName.

.EXAMPLE
     Manage-AWSProfile profile-name

.EXAMPLE
     Manage-AWSProfile -p profile-name

.EXAMPLE
     Manage-AWSProfile -ProfileName profile-name

.EXAMPLE
     Manage-AWSProfile -u

.EXAMPLE
     Manage-AWSProfile -unset

.EXAMPLE
     Manage-AWSProfile
.EXAMPLE
     Manage-AWSProfile -List
.EXAMPLE
     Manage-AWSProfile -L -Unset
.EXAMPLE
     Manage-AWSProfile -L -C -P profile-name
.NOTES
    Author:  Eytan Yammer
    Twitter: @eyammer
#>
function Manage-AWSProfile {
    param(
        [string][Alias('P')]$ProfileName = "$($args[0])",
        [switch][Alias('U')]$Unset,
        [switch][Alias('L')]$List,
        [switch][Alias('C')]$Current
    )
    if ($unset -and $ProfileName) {
        Write-Error "Can't use -ProfileName and -Unset together"
        Exit 1
    }
    if (-not ($ProfileName -or $List -or $Unset -or $Current)) {
        Write-Output "Please choose profile:"
        $i = 0
        $profiles = Get-AWSProfile
        foreach ($prof in ($profiles)){
            $i += 1
            Write-Output "$i`: $prof"
        }
        [int]$number = Read-Host "Press a number to select a profile"
        Set-AWSProfile -p $profiles[$number - 1]
    }
    if ($ProfileName) { Set-AWSProfile -p $ProfileName }
    if ($List) { Write-Output "`r`nAvailable Profiles:" $(Get-AWSProfile) }
    if ($Unset) { Clear-AWSProfile}
    if ($Current) { Show-AWSProfile }
}
function Set-AWSProfile {
    param(
        [string][Alias('p')]$ProfileName
    )
    $available_profiles = Get-AWSProfile
        
    if ($available_profiles -contains $ProfileName) {
        $env:AWS_DEFAULT_PROFILE = $ProfileName
        $env:AWS_PROFILE = $ProfileName
        $env:AWS_EB_PROFILE = $ProfileName
            
        Write-Output "`r`nAWS profile set to: " $ProfileName 
           
    }
    else {   
        Write-Output "Profile $ProfileName not found in $Global:credentials_location `r`n"
        Write-Output "Available profiles:" 
        $available_profiles
    }
}
function Clear-AWSProfile {
    if ($env:AWS_DEFAULT_PROFILE) { Remove-Item Env:\AWS_DEFAULT_PROFILE } 
    if ($env:AWS_PROFILE) { Remove-Item Env:\AWS_PROFILE }
    if ($env:AWS_EB_PROFILE) { Remove-Item Env:\AWS_EB_PROFILE }
    Write-Output "Default AWS profile cleared."
}
function Get-AWSProfile {
    $path = "$HOME\.aws\credentials"
    if ($env:AWS_CONFIG_FILE) {
        $path = $env:AWS_CONFIG_FILE
    } 
    if (-not  (Test-Path -Path $path) ) {
        Write-Error "AWS config file not found at $path"
        Exit 1
    }
    $available_profiles = @()
    foreach ($line in $(Get-Content "$path")) {
        if ($line -match “^\[(.+)\]”) {
            $available_profiles += ($line.Trim("[", "]"))
        }
    }
    return $available_profiles
}

function Show-AWSProfile {
    if (-not ($env:AWS_EB_PROFILE -or $env:AWS_PROFILE -or $env:AWS_DEFAULT_PROFILE)) {
        Write-Output "`r`nNo AWS profile set."
    }
    if ($env:AWS_DEFAULT_PROFILE) { Write-Output "AWS_DEFAULT_PROFILE is set to $env:AWS_DEFAULT_PROFILE" } 
    if ($env:AWS_PROFILE) { Write-Output "AWS_PROFILE is set to $env:AWS_PROFILE" }
    if ($env:AWS_EB_PROFILE) { Write-Output "AWS_EB_PROFILE is set to $env:AWS_EB_PROFILE" }
}