@echo off
color 0B
setlocal ENABLEDELAYEDEXPANSION
title Script-Ware Windows Support Tool

net file 2>nul>nul
if '!errorlevel!' == '0' (
    goto menu
) else (
    echo Please run the script as an administrator and try again.
    timeout 7 2>nul>nul
    exit
)

:menu
    cls
    echo ================================================
    echo     Script-Ware Windows 10/11 Support Tool
    echo ================================================
    echo.
    echo [1] Make a log file for staff.
    echo [2] Script-Ware not showing up after clicking on it.
    echo [3] Excluding Anti-viruses from tampering with Script-Ware core files
    echo [4] Error 0x4, 0x1, Script-Ware was unable to gather information or Missing dependency.
    echo [5] Inaccurate Time Error
    echo [6] Error 403
    echo.
    echo ================================================
    echo               Enter a option:
    set /p process_name=
    if !process_name! == 1 (
        goto tasks
    ) else if !process_name! == 2 (
        goto notopening
    ) else if !process_name! == 3 (
        goto antivirus
    ) else if !process_name! == 4 (
        goto missingvcredist
    ) else if !process_name! == 5 (
        goto inaccuratetimeerror
    ) else if !process_name! == 6 (
        goto error403
    ) else (
        cls
        echo Please enter a valid option.
        timeout 2 2>nul>nul
        goto menu
    )

:tasks
    cls
    set filelocation="%~dp0log.txt"
    tasklist /v | powershell -Command "$input | ForEach-Object { $_ -replace '!USERNAME!', 'username' }" > !filelocation!
    echo The file has been made in !filelocation!, If a staff member asked you to send it, please do so.
    timeout 7 2>nul>nul
    goto menu

:notopening
    if exist !localappdata!\ScriptWare_Software_LTD (
        cls
        rd /s /q !localappdata!\ScriptWare_Software_LTD
        echo Success, please try opening Script-Ware.
        timeout 7 2>nul>nul
        goto menu
    ) else if exist !localappdata!\ScriptWare (
        cls
        rd /s /q !localappdata!\ScriptWare
        echo Success, please try opening Script-Ware.
        timeout 7 2>nul>nul
        goto menu
    ) else (
        cls
        echo Script-Ware Folder in !localappdata! was not found. Please try restarting your computer and opening Script-Ware again.
        timeout 7 2>nul>nul
        goto menu
    )

:antivirus
    cls
    echo Example files path: D:\Other\AntivirusDisabled\Script-Ware
    echo Example core files path: C:\Users\YourUser\AppData\Roaming\IFYey3nrAOUIy
    echo.
    set /p your_install_path=Please copy and paste the EXACT and ONLY location of Script-Ware Folder: 
    if not exist !your_install_path! (
        echo !your_install_path! is not a valid path to a folder.
        timeout 2 2>nul>nul
        goto antivirus
    )
    set /p your_dll_folder_path=Please copy and paste the EXACT and ONLY location of Script-Ware Core Folder, you can copy it from README.txt: 
    if not exist !your_dll_folder_path! (
        echo !your_dll_folder_path! is not a valid path to a folder.
        timeout 2 2>nul>nul
        goto antivirus
    )
    powershell -command "Add-MpPreference -ExclusionPath '!your_install_path!' ; Add-MpPreference -ExclusionPath '!your_dll_folder_path!'"
    echo Folder exclusions added.
    timeout 3 2>nul>nul
    goto menu

:missingvcredist
    cls
    set "url=https://aka.ms/vs/17/release/vc_redist.x86.exe"
    set "filename=!USERPROFILE!\Downloads\vc_redist.x86.exe"
    echo Downloading file from !url!...
    powershell -command "(New-Object System.Net.WebClient).DownloadFile('!url!', '!filename!')"
    if not exist "!filename!" (
        echo Error: Failed to download file from !url!
        timeout 2 2>nul>nul
        goto menu
    )
    echo File downloaded successfully to !filename!.
    echo Opening !filename!...
    start "" "!filename!"
    timeout 2 2>nul>nul
    goto menu

:inaccuratetimeerror
    cls
    w32tm /query /peers
    sc config w32time start= auto
    w32tm /config /syncfromflags:manual /manualpeerlist:time.apple.com
    w32tm /config /reliable:yes
    net stop w32time
    net start w32time
    w32tm /resync /nowait
    cls
    echo Success.
    timeout 2 2>nul>nul
    goto menu

:error403
    cls
    set processName=RobloxPlayerLauncher.exe
    echo Checking for !processName!...
    tasklist /nh /fi "imagename eq !processName!" | find /i "!processName!" > nul
    if !errorlevel! equ 0 (
        echo !processName! is running. Killing process...
        taskkill /im !processName! /f > nul
        echo !processName! has been killed.
    ) else (
        echo !processName! is not running.
    )
    set processName=RobloxPlayerBeta.exe
    echo Checking for !processName!...
    tasklist /nh /fi "imagename eq !processName!" | find /i "!processName!" > nul
    if !errorlevel! equ 0 (
        echo !processName! is running. Killing process...
        taskkill /im !processName! /f > nul
        echo !processName! has been killed.
    ) else (
        echo !processName! is not running.
    )
    echo Removing Roblox files...
    RD /S /Q "!LOCALAPPDATA!\Roblox"
    RD /S /Q "!PROGRAMFILES(x86)!\Roblox"
    RD /S /Q "!PROGRAMFILES!\Roblox"
    RD /S /Q "!APPDATA!\Roblox"
    echo Installing Roblox...
    set "url=https://setup.rbxcdn.com/RobloxPlayerLauncher.exe"
    set "filename=!USERPROFILE!\Downloads\RobloxPlayerLauncher.exe"
    echo Downloading file from !url!...
    powershell -command "(New-Object System.Net.WebClient).DownloadFile('!url!', '!filename!')"
    if not exist "!filename!" (
        echo Error: Failed to download file from !url!
        timeout 2 2>nul>nul
        goto menu
    )
    echo File downloaded successfully to !filename!.
    echo Opening !filename!...
    start "" "!filename!"
    cls
    echo Please restart Script-Ware and try injecting.
    timeout 7 2>nul>nul
    goto menu