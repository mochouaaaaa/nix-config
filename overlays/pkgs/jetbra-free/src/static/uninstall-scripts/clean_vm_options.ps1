# Add a counter to track found variables
Write-Host "Clean up VM_OPTIONS environment variable tool"
Write-Host "============================="
Write-Host ""

$userVars = [Environment]::GetEnvironmentVariables('User')
$systemVars = [Environment]::GetEnvironmentVariables('Machine')
$userVMOptions = $userVars.Keys | Where-Object { $_ -like '*_VM_OPTIONS' }
$systemVMOptions = $systemVars.Keys | Where-Object { $_ -like '*_VM_OPTIONS' }
$totalFound = ($userVMOptions + $systemVMOptions).Count

Write-Host "Discovered environment variables:"
Write-Host "----------------"
if ($userVMOptions) {
    Write-Host "`nUser-level environment variables:"
    $userVMOptions | ForEach-Object { Write-Host "- $_" }
}
if ($systemVMOptions) {
    Write-Host "`nSystem-level environment variables:"
    $systemVMOptions | ForEach-Object { Write-Host "- $_" }
}
if ($totalFound -eq 0) {
    Write-Host "No VM_OPTIONS environment variables were found"
    Write-Host "`nPress any key to exit..."
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
    exit
}

Write-Host "`nFind $totalFound An environment variable that needs to be cleaned"
Write-Host "Note: Administrator permission is required for cleaning these variables"
# Check if it is currently running as an administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    $message = "This operation needs to be run with administrator privileges. Restart as administrator?"
    $answer = Read-Host "Is it running again with administrator privileges?(Y/N)"
    if ($answer -match '^[Yy]$' -or $answer -eq '') {
        $scriptPath = $MyInvocation.MyCommand.Definition
        if (-not (Test-Path $scriptPath)) {
        # Restart using remote execution compatible
        Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -Command `"irm http://127.0.0.1:8123/static/uninstall-scripts/clean_vm_options.ps1 | iex`"" -Verb RunAs
        exit
         }
        Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -File `"$scriptPath`"" -Verb RunAs
        exit
    } else {
        Write-Host "The user canceled the escalation operation."
        exit 1
    }
}

Write-Host "Currently running with administrator privileges."
Write-Host "Start cleaning up the VM_OPTIONS environment variables..."
Write-Host "Continue in 3 seconds..."
Start-Sleep -Seconds 3

$foundCount = 0

$userVars = [Environment]::GetEnvironmentVariables('User')
foreach ($var in $userVars.Keys) {
    if ($var -like '*_VM_OPTIONS') {
        [Environment]::SetEnvironmentVariable($var, $null, 'User')
        Write-Host "User environment variables have been deleted: $var"
        $foundCount++
    }
}

$systemVars = [Environment]::GetEnvironmentVariables('Machine')
foreach ($var in $systemVars.Keys) {
    if ($var -like '*_VM_OPTIONS') {
        [Environment]::SetEnvironmentVariable($var, $null, 'Machine')
        Write-Host "System environment variables have been deleted: $var"
        $foundCount++
    }
}

# Check if any variables were found
if ($foundCount -eq 0) {
    Write-Host "`nNo VM_OPTIONS environment variables were found`n"
} else {
    Write-Host "`nCleaning is complete!`n"
    Write-Host "Note: Some programs may require a restart for the changes to take effect"
}

Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
