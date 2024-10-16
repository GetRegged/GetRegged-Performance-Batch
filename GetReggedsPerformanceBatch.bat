@echo off

title GetRegged's Performance Batch

:: Version #
Set Version=1.0

:: Enable Delayed Expansion
setlocal enabledelayedexpansion >nul 2>nul

:: Set Powershell Execution Policy to Unrestricted
powershell "Set-ExecutionPolicy Unrestricted" >nul 2>nul

:: Enable ANSI Escape Sequences
reg add "HKCU\CONSOLE" /v "VirtualTerminalLevel" /t REG_DWORD /d "1" /f >nul 2>nul

:: Disable UAC
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableLUA" /t REG_DWORD /d "0" /f >nul 2>nul

:: Getting Admin Permissions
IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

if '%errorlevel%' NEQ '0' (
    goto UACPrompt
) else ( goto GotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:GotAdmin
    pushd "%CD%"
    CD /D "%~dp0"

::Get Device Info
for /f "tokens=2*" %%a in ('reg.exe query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v EditionID') do set "editionID=%%b"
for /f "tokens=2*" %%a in ('reg.exe query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v DisplayVersion') do set "versionID=%%b"
for /f "tokens=2*" %%a in ('reg.exe query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v CurrentBuild') do set "buildID=%%b"
for /f "tokens=2*" %%a in ('reg.exe query "HKCU\Volatile Environment" /v USERNAME') do set "userID=%%b"
for /f "tokens=2*" %%a in ('reg.exe query "HKLM\SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName" /v ComputerName') do set "computerID=%%b"
for /f "tokens=5*" %%a in ('powercfg -list ^| findstr \*') do set powerplanID=%%a
for /f "tokens=2 delims=()" %%a in ('wmic timezone get caption /value') do set tzone1=%%a
for /f "tokens=3 delims=()" %%a in ('wmic timezone get caption /value') do set tzone2=%%a

::════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
:: Main Menu
:Menu
chcp 65001 >nul 2>&1
cls
set c=[94m
set t=[0m
set w=[31m
set y=[0m
set u=[4m
set q=[0m
echo.
echo.
echo.
echo.
echo                       %w%██████%y%%c%╗%y% %w%███████%y%%c%╗%y%%w%████████%y%%c%╗%y%    %w%██████%y%%c%╗%y% %w%███████%y%%c%╗%y% %w%██████%y%%c%╗%y%  %w%██████%y%%c%╗%y% %w%███████%y%%c%╗%y%%w%██████%y%%c%╗%y% 
echo                      %w%██%y%%c%╔════╝%y% %w%██%y%%c%╔════╝%y%%c%╚══%y%%w%██%y%%c%╔══╝%y%    %w%██%y%%c%╔══%y%%w%██%y%%c%╗%y%%w%██%y%%c%╔════╝%y%%w%██%y%%c%╔════╝%y% %w%██%y%%c%╔════╝%y% %w%██%y%%c%╔════╝%y%%w%██%y%%c%╔══%y%%w%██%y%%c%╗%y%  
echo                      %w%██%y%%c%║%y%  %w%███%c%╗%y%%w%█████%y%%c%╗%y%     %w%██%y%%c%║%y%       %w%██████%y%%c%╔╝%y%%w%█████%y%%c%╗%y%  %w%██%y%%c%║%y%  %w%███%c%╗%y%%w%██%y%%c%║%y%  %w%███%c%╗%y%%w%█████%y%%c%╗%y%  %w%██%y%%c%║  %y%%w%██%y%%c%║%y% 
echo                      %w%██%y%%c%║%y%   %w%██%y%%c%║%y%%w%██%y%%c%╔══╝%y%     %w%██%y%%c%║%y%       %w%██%y%%c%╔══%y%%w%██%y%%c%╗%y%%w%██%y%%c%╔══╝%y%  %w%██%y%%c%║%y%   %w%██%y%%c%║%y%%w%██%y%%c%║%y%   %w%██%y%%c%║%y%%w%██%y%%c%╔══╝%y%  %w%██%y%%c%║  %y%%w%██%y%%c%║%y%     
echo                      %c%╚%y%%w%██████%y%%c%╔╝%y%%w%███████%y%%c%╗%y%   %w%██%y%%c%║%y%       %w%██%y%%c%║  %y%%w%██%y%%c%║%y%%w%███████%y%%c%╗%y%%c%╚%y%%w%██████%y%%c%╔╝%y%%c%╚%y%%w%██████%y%%c%╔╝%y%%w%███████%y%%c%╗%y%%w%██████%y%%c%╔╝%y%
echo                       %c%╚═════╝%y% %c%╚══════╝%y%   %c%╚═╝%y%       %c%╚═╝  ╚═╝%y%%c%╚══════╝%y% %c%╚═════╝%y%  %c%╚═════╝%y% %c%╚══════╝%y%%c%╚═════╝%y%          
echo                                                       %c%%u%Version: %Version%%q%%t%
echo.
echo.
echo %w%════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════%y%
echo.
echo.
echo.
echo                           %w%[%y% %c%%u%1%q%%t% %w%]%y% %c%Activate/Deactivate%t%                 		   %w%[%y% %c%%u%2%q% %t%%w%]%y% %c%Performance Tweaks%t%
echo. 
echo.
echo                           %w%[%y% %c%%u%3%q%%t% %w%]%y% %c%Option3%t%						   %w%[%y% %c%%u%4%q% %t%%w%]%y% %c%Power Plan%t%
echo.
echo.
echo                           %w%[%y% %c%%u%5%q%%t% %w%]%y% %c%Temp Tamer%t%                           	           %w%[%y% %c%%u%6%q%%t% %w%]%y% %c%Option6%t%
echo.
echo.
echo								%w%[%y% %c%%u%0%q%%t% %w%]%y% %c%Exit%t%
echo.
echo.
set choice=
set /p choice=
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='0' goto Exit
if '%choice%'=='1' goto WindowsActivation
if '%choice%'=='2' goto PerformanceTweaks
if '%choice%'=='3' goto Option3
if '%choice%'=='4' goto PowerPlan
if '%choice%'=='5' goto TempTamer
if '%choice%'=='6' goto Option6

::════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
:WindowsActivation
cls
set c=[94m
set t=[0m
set w=[31m
set y=[0m
set u=[4m
set q=[0m
echo.
echo.
echo.
echo.
echo                       %w%██████%y%%c%╗%y% %w%███████%y%%c%╗%y%%w%████████%y%%c%╗%y%    %w%██████%y%%c%╗%y% %w%███████%y%%c%╗%y% %w%██████%y%%c%╗%y%  %w%██████%y%%c%╗%y% %w%███████%y%%c%╗%y%%w%██████%y%%c%╗%y% 
echo                      %w%██%y%%c%╔════╝%y% %w%██%y%%c%╔════╝%y%%c%╚══%y%%w%██%y%%c%╔══╝%y%    %w%██%y%%c%╔══%y%%w%██%y%%c%╗%y%%w%██%y%%c%╔════╝%y%%w%██%y%%c%╔════╝%y% %w%██%y%%c%╔════╝%y% %w%██%y%%c%╔════╝%y%%w%██%y%%c%╔══%y%%w%██%y%%c%╗%y%  
echo                      %w%██%y%%c%║%y%  %w%███%c%╗%y%%w%█████%y%%c%╗%y%     %w%██%y%%c%║%y%       %w%██████%y%%c%╔╝%y%%w%█████%y%%c%╗%y%  %w%██%y%%c%║%y%  %w%███%c%╗%y%%w%██%y%%c%║%y%  %w%███%c%╗%y%%w%█████%y%%c%╗%y%  %w%██%y%%c%║  %y%%w%██%y%%c%║%y% 
echo                      %w%██%y%%c%║%y%   %w%██%y%%c%║%y%%w%██%y%%c%╔══╝%y%     %w%██%y%%c%║%y%       %w%██%y%%c%╔══%y%%w%██%y%%c%╗%y%%w%██%y%%c%╔══╝%y%  %w%██%y%%c%║%y%   %w%██%y%%c%║%y%%w%██%y%%c%║%y%   %w%██%y%%c%║%y%%w%██%y%%c%╔══╝%y%  %w%██%y%%c%║  %y%%w%██%y%%c%║%y%     
echo                      %c%╚%y%%w%██████%y%%c%╔╝%y%%w%███████%y%%c%╗%y%   %w%██%y%%c%║%y%       %w%██%y%%c%║  %y%%w%██%y%%c%║%y%%w%███████%y%%c%╗%y%%c%╚%y%%w%██████%y%%c%╔╝%y%%c%╚%y%%w%██████%y%%c%╔╝%y%%w%███████%y%%c%╗%y%%w%██████%y%%c%╔╝%y%
echo                       %c%╚═════╝%y% %c%╚══════╝%y%   %c%╚═╝%y%       %c%╚═╝  ╚═╝%y%%c%╚══════╝%y% %c%╚═════╝%y%  %c%╚═════╝%y% %c%╚══════╝%y%%c%╚═════╝%y%          
echo                                                       %c%%u%Version: %Version%%q%%t%
echo.
echo.
echo %w%════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════%y%
echo.
echo.					
echo							      System: Windows 10/11
echo							     Edition: %editionID%
echo							     Version: %versionID%
echo							       Build: %buildID%
echo							      Status: %status%
echo.
echo                                       %w%[%y% %c%%u%1%q%%t% %w%]%y% %c%Activate%t%               %w%[%y% %c%%u%2%q%%t% %w%]%y% %c%Deactivate%t%
echo.
echo.
echo.
echo.
echo								%w%[%y% %c%%u%0%q%%t% %w%]%y% %c%Menu%t%
echo.
echo.
set choice=
set /p choice=
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='0' goto menu
if '%choice%'=='1' goto activate
if '%choice%'=='2' goto deactivate

:activate
cls
cscript //B "%windir%\system32\slmgr.vbs" /skms kms8.msguides.com >nul 2>nul
echo Windows activated
timeout /t 2 /nobreak >nul 2>nul
goto menuexit

:deactivate
cls
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform" /v "KeyManagementServiceName" /f>nul
cscript //B "%windir%\system32\slmgr.vbs" -ipk VK7JG-NPHTM-C97JM-9MPGT-3V66T
echo Windows deactivated
timeout /t 2 /nobreak >nul 2>nul
goto menuexit

::════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
:PerformanceTweaks

cls
set c=[94m
set t=[0m
set w=[31m
set y=[0m
set u=[4m
set q=[0m
echo.
echo.
echo.
echo.
echo                       %w%██████%y%%c%╗%y% %w%███████%y%%c%╗%y%%w%████████%y%%c%╗%y%    %w%██████%y%%c%╗%y% %w%███████%y%%c%╗%y% %w%██████%y%%c%╗%y%  %w%██████%y%%c%╗%y% %w%███████%y%%c%╗%y%%w%██████%y%%c%╗%y% 
echo                      %w%██%y%%c%╔════╝%y% %w%██%y%%c%╔════╝%y%%c%╚══%y%%w%██%y%%c%╔══╝%y%    %w%██%y%%c%╔══%y%%w%██%y%%c%╗%y%%w%██%y%%c%╔════╝%y%%w%██%y%%c%╔════╝%y% %w%██%y%%c%╔════╝%y% %w%██%y%%c%╔════╝%y%%w%██%y%%c%╔══%y%%w%██%y%%c%╗%y%  
echo                      %w%██%y%%c%║%y%  %w%███%c%╗%y%%w%█████%y%%c%╗%y%     %w%██%y%%c%║%y%       %w%██████%y%%c%╔╝%y%%w%█████%y%%c%╗%y%  %w%██%y%%c%║%y%  %w%███%c%╗%y%%w%██%y%%c%║%y%  %w%███%c%╗%y%%w%█████%y%%c%╗%y%  %w%██%y%%c%║  %y%%w%██%y%%c%║%y% 
echo                      %w%██%y%%c%║%y%   %w%██%y%%c%║%y%%w%██%y%%c%╔══╝%y%     %w%██%y%%c%║%y%       %w%██%y%%c%╔══%y%%w%██%y%%c%╗%y%%w%██%y%%c%╔══╝%y%  %w%██%y%%c%║%y%   %w%██%y%%c%║%y%%w%██%y%%c%║%y%   %w%██%y%%c%║%y%%w%██%y%%c%╔══╝%y%  %w%██%y%%c%║  %y%%w%██%y%%c%║%y%     
echo                      %c%╚%y%%w%██████%y%%c%╔╝%y%%w%███████%y%%c%╗%y%   %w%██%y%%c%║%y%       %w%██%y%%c%║  %y%%w%██%y%%c%║%y%%w%███████%y%%c%╗%y%%c%╚%y%%w%██████%y%%c%╔╝%y%%c%╚%y%%w%██████%y%%c%╔╝%y%%w%███████%y%%c%╗%y%%w%██████%y%%c%╔╝%y%
echo                       %c%╚═════╝%y% %c%╚══════╝%y%   %c%╚═╝%y%       %c%╚═╝  ╚═╝%y%%c%╚══════╝%y% %c%╚═════╝%y%  %c%╚═════╝%y% %c%╚══════╝%y%%c%╚═════╝%y%          
echo                                                       %c%%u%Version: %Version%%q%%t%
echo.
echo.
echo %w%════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════%y%
echo.
echo.
echo.
echo.
echo.
echo                                           Do you want to create a restor point?
echo.
echo.
echo                                              %w%[%y% %c%%u%1%q%%t% %w%]%y% %c%Yes%t%               %w%[%y% %c%%u%2%q%%t% %w%]%y% %c%No%t%
echo.
echo.
echo.
echo.
echo.
echo.
echo.
set choice=
set /p choice=
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto RestorePoint
if '%choice%'=='2' goto WindowsVersion

:RestorePoint
:: Creating restore point
cls
echo Creating restore point
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" /v "SystemRestorePointCreationFrequency" /t REG_DWORD /d "0" /f
powershell -ExecutionPolicy Bypass -Command "Checkpoint-Computer -Description 'GetRegged Performance Batch' -RestorePointType 'MODIFY_SETTINGS'"

cls
echo Restore point created
timeout /t 2 /nobreak >nul 2>nul

:WindowsVersion
cls
set c=[94m
set t=[0m
set w=[31m
set y=[0m
set u=[4m
set q=[0m
echo.
echo.
echo.
echo.
echo                       %w%██████%y%%c%╗%y% %w%███████%y%%c%╗%y%%w%████████%y%%c%╗%y%    %w%██████%y%%c%╗%y% %w%███████%y%%c%╗%y% %w%██████%y%%c%╗%y%  %w%██████%y%%c%╗%y% %w%███████%y%%c%╗%y%%w%██████%y%%c%╗%y% 
echo                      %w%██%y%%c%╔════╝%y% %w%██%y%%c%╔════╝%y%%c%╚══%y%%w%██%y%%c%╔══╝%y%    %w%██%y%%c%╔══%y%%w%██%y%%c%╗%y%%w%██%y%%c%╔════╝%y%%w%██%y%%c%╔════╝%y% %w%██%y%%c%╔════╝%y% %w%██%y%%c%╔════╝%y%%w%██%y%%c%╔══%y%%w%██%y%%c%╗%y%  
echo                      %w%██%y%%c%║%y%  %w%███%c%╗%y%%w%█████%y%%c%╗%y%     %w%██%y%%c%║%y%       %w%██████%y%%c%╔╝%y%%w%█████%y%%c%╗%y%  %w%██%y%%c%║%y%  %w%███%c%╗%y%%w%██%y%%c%║%y%  %w%███%c%╗%y%%w%█████%y%%c%╗%y%  %w%██%y%%c%║  %y%%w%██%y%%c%║%y% 
echo                      %w%██%y%%c%║%y%   %w%██%y%%c%║%y%%w%██%y%%c%╔══╝%y%     %w%██%y%%c%║%y%       %w%██%y%%c%╔══%y%%w%██%y%%c%╗%y%%w%██%y%%c%╔══╝%y%  %w%██%y%%c%║%y%   %w%██%y%%c%║%y%%w%██%y%%c%║%y%   %w%██%y%%c%║%y%%w%██%y%%c%╔══╝%y%  %w%██%y%%c%║  %y%%w%██%y%%c%║%y%     
echo                      %c%╚%y%%w%██████%y%%c%╔╝%y%%w%███████%y%%c%╗%y%   %w%██%y%%c%║%y%       %w%██%y%%c%║  %y%%w%██%y%%c%║%y%%w%███████%y%%c%╗%y%%c%╚%y%%w%██████%y%%c%╔╝%y%%c%╚%y%%w%██████%y%%c%╔╝%y%%w%███████%y%%c%╗%y%%w%██████%y%%c%╔╝%y%
echo                       %c%╚═════╝%y% %c%╚══════╝%y%   %c%╚═╝%y%       %c%╚═╝  ╚═╝%y%%c%╚══════╝%y% %c%╚═════╝%y%  %c%╚═════╝%y% %c%╚══════╝%y%%c%╚═════╝%y%          
echo                                                       %c%%u%Version: %Version%%q%%t%
echo.
echo.
echo %w%════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════%y%
echo.
echo.
echo.
echo.
echo.
echo                                              Which Windows version do you use?
echo.
echo.
echo                                       %w%[%y% %c%%u%1%q%%t% %w%]%y% %c%Windows 10%t%               %w%[%y% %c%%u%2%q%%t% %w%]%y% %c%Windows 11%t%
echo.
echo.
echo.
echo.
echo.
echo.
echo.
set choice=
set /p choice=
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto Windows10
if '%choice%'=='2' goto Windows11

:Windows10

cls
:: BCD Tweaks
echo Applying BCD Tweaks exclusive Windows 10
bcdedit /set platformtick No >nul 2>nul
bcdedit /set tscsyncpolicy Enhanced >nul 2>nul
bcdedit /set firstmegabytepolicy UseAll >nul 2>nul
bcdedit /set avoidlowmemory 0x8000000 >nul 2>nul
bcdedit /set nolowmem Yes >nul 2>nul
bcdedit /set allowedinmemorysettings 0x0 >nul 2>nul
bcdedit /set isolatedcontext No >nul 2>nul
bcdedit /set vsmlaunchtype Off >nul 2>nul
bcdedit /set vm No >nul 2>nul
bcdedit /set x2apicpolicy Enable >nul 2>nul
bcdedit /set configaccesspolicy Default >nul 2>nul
bcdedit /set MSI Default >nul 2>nul
bcdedit /set usephysicaldestination No >nul 2>nul
bcdedit /set usefirmwarepcisettings No >nul 2>nul
bcdedit /set disableelamdrivers Yes >nul 2>nul
bcdedit /set pae ForceEnable >nul 2>nul
bcdedit /set nx optout >nul 2>nul
bcdedit /set highestmode Yes >nul 2>nul
bcdedit /set forcefipscrypto No >nul 2>nul
bcdedit /set noumex Yes >nul 2>nul
bcdedit /set uselegacyapicmode No >nul 2>nul
bcdedit /set ems No >nul 2>nul
bcdedit /set extendedinput Yes >nul 2>nul
bcdedit /set debug No >nul 2>nul
bcdedit /set hypervisorlaunchtype Off >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Delete Microcode (https://www.reddit.com/r/overclocking/comments/enm8yj/how_to_actually_disable_intel_and_amd_microcode/)
echo Deleting Microcode
takeown /f "C:\Windows\System32\mcupdate_GenuineIntel.dll" /r /d y >nul 2>nul
takeown /f "C:\Windows\System32\mcupdate_AuthenticAMD.dll" /r /d y >nul 2>nul
del "C:\Windows\System32\mcupdate_GenuineIntel.dll" /s /f /q >nul 2>nul
del "C:\Windows\System32\mcupdate_AuthenticAMD.dll" /s /f /q >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

goto Windows11nocls

:Windows11
cls

:Windows11nocls

::TRIM für SSDs aktivieren (in der Regel standardmäßig aktiviert)
echo Applying SSD Tweaks
fsutil behavior set DisableDeleteNotify NTFS 0 >nul 2>nul
fsutil behavior set DisableDeleteNotify ReFS 0 >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: BCD Tweaks
echo Applying BCD Tweaks
bcdedit /set useplatformclock No >nul 2>nul
bcdedit /set disabledynamictick Yes >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Disable Mitigations
echo Disable Mitigations
:: powershell "ForEach($v in (Get-Command -Name \"Set-ProcessMitigation\").Parameters[\"Disable\"].Attributes.ValidValues){Set-ProcessMitigation -System -Disable $v.ToString() -ErrorAction SilentlyContinue}" >nul 2>nul
:: powershell "Remove-Item -Path \"HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\*\" -Recurse -ErrorAction SilentlyContinue" >nul 2>nul
:: reg add "HKLM\SOFTWARE\Policies\Microsoft\FVE" /v "DisableExternalDMAUnderLock" /t REG_DWORD /d "0" /f >nul 2>nul
:: reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "EnableVirtualizationBasedSecurity" /t REG_DWORD /d "0" /f >nul 2>nul
:: reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "HVCIMATRequired" /t REG_DWORD /d "0" /f >nul 2>nul
:: reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "DisableExceptionChainValidation" /t REG_DWORD /d "1" /f >nul 2>nul
:: reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "KernelSEHOPEnabled" /t REG_DWORD /d "0" /f >nul 2>nul
:: reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "EnableCfg" /t REG_DWORD /d "0" /f >nul 2>nul
:: reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" /v "ProtectionMode" /t REG_DWORD /d "0" /f >nul 2>nul
:: reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettings" /t REG_DWORD /d "1" /f >nul 2>nul
:: reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverride" /t REG_DWORD /d "3" /f >nul 2>nul
:: reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverrideMask" /t REG_DWORD /d "3" /f >nul 2>nul

:: Sub Mitigations
:: reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "MitigationOptions" /t REG_BINARY /d "222222222222222222222222222222222222222222222222" /f >nul 2>nul
:: timeout /t 1 /nobreak >nul 2>nul

:: NTFS Tweaks
:: echo Applying NTFS Tweaks
:: fsutil behavior set memoryusage 2 >nul 2>nul
:: fsutil behavior set mftzone 4 >nul 2>nul
:: fsutil behavior set disablelastaccess 1 >nul 2>nul
:: fsutil behavior set disabledeletenotify 0 >nul 2>nul
:: fsutil behavior set encryptpagingfile 0 >nul 2>nul
:: timeout /t 1 /nobreak >nul 2>nul

:: Disable Memory Compression
:: echo Disable Memory Compression
:: PowerShell -Command "Disable-MMAgent -MemoryCompression" >nul 2>nul
:: timeout /t 1 /nobreak >nul 2>nul

:: Disable Page Combining
:: echo Disable Page Combining
:: PowerShell -Command "Disable-MMAgent -PageCombining" >nul 2>nul
:: timeout /t 1 /nobreak >nul 2>nul

:: Win32Priority
echo Set Win32Priority
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d "38" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: IRQ8Priority
echo Set IRQ8Priority
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "IRQ8Priority" /t REG_DWORD /d "1" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Large System Cache
echo Enable Large System Cache
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d "0" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Disable Fast Startup
echo Disable Fast Startup
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "HiberbootEnabled" /t REG_DWORD /d "0" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Disable Hibernation
echo Disable Hibernation
powercfg /h off >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "HibernateEnabled" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "HibernateEnabledDefault" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "SleepReliabilityDetailedDiagnostics" /t REG_DWORD /d "0" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Disable Sleep Study
echo Disable Sleep Study
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "SleepStudyDisabled" /t REG_DWORD /d "1" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Disable DEP
echo Disable DEP
reg add "HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer\Main" /v "DEPOff" /t REG_DWORD /d "1" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Disable Automatic Maintenance
echo Disable Automatic Maintenance
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance" /v "MaintenanceDisabled" /t REG_DWORD /d "1" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Disable Paging Executive
echo Disable Paging Executive
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d "1" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Force contiguous memory allocation in the DirectX Graphics Kernel (melodytheneko)
echo Forcing contiguous memory allocation in the DirectX Graphics Kernel
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DpiMapIommuContiguous" /t REG_DWORD /d "1" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Disable FTH
echo Disable Fault Tolerant Heap
reg add "HKLM\SOFTWARE\Microsoft\FTH" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Disable ASLR
echo Disable Address Space Layout Randomization
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "MoveImages" /t REG_DWORD /d "0" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Disable Power Throttling
echo Disable Power Throttling
reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "CsEnabled" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "EnergyEstimationEnabled" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "EventProcessorEnabled" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "PlatformAoAcOverride" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\ModernSleep" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v "PowerThrottlingOff" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Executive" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Enable HAGS
echo Enable Hardware-Accelerated GPU Scheduling
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" /t REG_DWORD /d "2" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Enable Distribute Timers
echo Enable Distribution of Timers
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "DistributeTimers" /t REG_DWORD /d "1" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Enable GameMode
echo Enable GameMode
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "AllowAutoGameMode" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "AutoGameModeEnabled" /t REG_DWORD /d "1" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Disable Gamebar
echo Disable Gamebar
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Microsoft\WindowsRuntime\ActivatableClassId\Windows.Gaming.GameBar.PresenceServer.Internal.PresenceWriter" /v "ActivationType" /t REG_DWORD /d "0" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

::Processes Kill Time
echo Decrease Processes Kill Time 
reg add "HKCU\Control Panel\Desktop" /v "AutoEndTasks" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKCU\Control Panel\Desktop" /v "HungAppTimeout" /t REG_DWORD /d "1000" /f >nul 2>nul
reg add "HKCU\Control Panel\Desktop" /v "WaitToKillAppTimeout" /t REG_DWORD /d "2000" /f >nul 2>nul
reg add "HKCU\Control Panel\Desktop" /v "LowLevelHooksTimeout" /t REG_DWORD /d "1000" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

::Service Kill Time
echo Decrease Service Kill Time 
reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v "WaitToKillServiceTimeout" /t REG_DWORD /d "2000" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: MenuShowDelay
echo Reducing Menu Delay
reg add "HKCU\Control Panel\Desktop" /v "MenuShowDelay" /t REG_DWORD /d "0" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Disable GpuEnergyDrv
echo Disable GPU Energy Driver
reg add "HKLM\SYSTEM\CurrentControlSet\Services\GpuEnergyDrv" /v "Start" /t REG_DWORD /d "4" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\GpuEnergyDr" /v "Start" /t REG_DWORD /d "4" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Disable Windows Insider Experiments
echo Disable Windows Insider Experiments
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\System" /v "AllowExperimentation" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\System\AllowExperimentation" /v "value" /t REG_DWORD /d "0" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: MMCSS
echo Set MMCSS
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NoLazyMode" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "LazyModeTimeout" /t REG_DWORD /d "25000" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "AlwaysOn" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d "8" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d "6" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "SFIO Priority" /t REG_SZ /d "High" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Latency Sensitive" /t REG_SZ /d "True" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "Latency Sensitive" /t REG_SZ /d "True" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" /v "Latency Sensitive" /t REG_SZ /d "True" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Low Latency" /v "Latency Sensitive" /t REG_SZ /d "True" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Pro Audio" /v "Latency Sensitive" /t REG_SZ /d "True" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Window Manager" /v "Latency Sensitive" /t REG_SZ /d "True" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: System Responsiveness
echo Set System Responsiveness
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d "0" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Timestamp
echo Set Time Stamp Interval
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Reliability" /v "TimeStampInterval" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Reliability" /v "IoPriority" /t REG_DWORD /d "3" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: CSRSS
echo Set CSRSS to Realtime
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "4" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "3" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Disable Windows Remediation
echo Disable Windows Remediation
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "RemediationRequired" /t REG_DWORD /d "0" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Disable Windows Tips
echo Disable Windows Tips
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SoftLandingEnabled" /t REG_DWORD /d "0" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Disable Windows Spotlight
echo Disable Windows Spotlight
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "RotatingLockScreenOverlayEnabled" /t REG_DWORD /d "0" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Disable Shared Experiences
echo Disable Shared Experiences
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CDP" /v "CdpSessionUserAuthzPolicy" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CDP" /v "NearShareChannelUserAuthzPolicy" /t REG_DWORD /d "0" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Stop Explorer from Showing Frequent/Recent Files
echo Disable Frequent/Recent Files in Explorer
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowFrequent" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowRecent" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "TelemetrySalt" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoRecentDocsHistory" /t REG_DWORD /d "1" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

::Show Hidden Files and Folders in Explorer by default
echo Enable Show Hidden Files/Folders in Explorer
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Hidden" /t REG_DWORD /d "1" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

::Show File Extensions in Explorer by default
echo Enable Show File Extensions in Explorer
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d "0" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

::Show Toolbar in Explorer by default
echo Enable Show Toolbar in Explorer
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Ribbon" /v "MinimizedStateTabletModeOff" /t REG_DWORD /d "0" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Disable Tailored Experiences
echo Disable Tailored Experiences
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy" /v "TailoredExperiencesWithDiagnosticDataEnabled" /t REG_DWORD /d "0" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Disable Search History Logging
echo Disable Search History Logging
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "HistoryViewEnabled" /t REG_DWORD /d "0" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Disable Device History
echo Disable Device History
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "DeviceHistoryEnabled" /t REG_DWORD /d "0" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Disable Bing Search
echo Disable Bing Search
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /t REG_DWORD /d "0" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

::Disable GameDVR
echo Disable GameDVR
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\ApplicationManagement\AllowGameDVR" /v "value" /t REG_DWORD /d "0" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

::Disbale Shared User App Data
echo Disable Shared User App Data
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\ApplicationManagement\AllowSharedUserAppData" /v "value" /t REG_DWORD /d "0" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Disable Auto Install Minor Updates
echo Disbale Auto Install Minor Updates
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AutoInstallMinorUpdates" /t REG_DWORD /d "0" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Disable Notifications
echo Disable Notifications
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" /v "ToastEnabled" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings" /v "NOC_GLOBAL_SETTING_ALLOW_NOTIFICATION_SOUND" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings" /v "NOC_GLOBAL_SETTING_ALLOW_CRITICAL_TOASTS_ABOVE_LOCK" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\QuietHours" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\windows.immersivecontrolpanel_cw5n1h2txyewy!microsoft.windows.immersivecontrolpanel" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.AutoPlay" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.LowDisk" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.Print.Notification" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.SecurityAndMaintenance" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.WiFiNetworkManager" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Windows Privacy Settings
echo Set Windows Privacy Settings
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\activity" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appointments" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetoothSync" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\broadFileSystemAccess" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\cellularData" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\cellularData\Microsoft.Win32WebViewHost_cw5n1h2txyewy" /v "Value" /t REG_SZ /d "Allow" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\chat" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\contacts" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\documentsLibrary" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\email" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\gazeInput" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location\Microsoft.Win32WebViewHost_cw5n1h2txyewy" /v "Value" /t REG_SZ /d "Prompt" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\microphone" /v "Value" /t REG_SZ /d "Allow" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\microphone\Microsoft.Win32WebViewHost_cw5n1h2txyewy" /v "Value" /t REG_SZ /d "Prompt" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCall" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCallHistory" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\picturesLibrary" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\radios" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation\Microsoft.AccountsControl_cw5n1h2txyewy" /v "Value" /t REG_SZ /d "Prompt" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userDataTasks" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userNotificationListener" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\videosLibrary" /v "Value" /t REG_SZ /d "Deny" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\webcam" /v "Value" /t REG_SZ /d "Allow" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\webcam\Microsoft.Win32WebViewHost_cw5n1h2txyewy" /v "Value" /t REG_SZ /d "Allow" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Stop Windows from Reinstalling Preinstalled apps
echo Stopping Windows from Reinstalling Preinstalled apps
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "PreInstalledAppsEnabled" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SilentInstalledAppsEnabled" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "OemPreInstalledAppsEnabled" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "ContentDeliveryAllowed" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContentEnabled" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "PreInstalledAppsEverEnabled" /t REG_DWORD /d "0" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Disable Suggestions at Start
echo Disable Windows Suggestions
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SystemPaneSuggestionsEnabled" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338388Enabled" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-314559Enabled" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-280815Enabled" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-314563Enabled" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338393Enabled" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353694Enabled" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353696Enabled" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-310093Enabled" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-202914Enabled" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338387Enabled" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338389Enabled" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353698Enabled" /t REG_DWORD /d "0" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Disable Startup Apps
echo Disable Startup Apps
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run" /v "Discord" /t REG_BINARY /d "0300000066AF9C7C5A46D901" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run" /v "Synapse3" /t REG_BINARY /d "030000007DC437B0EA9FD901" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run" /v "Spotify" /t REG_BINARY /d "0300000070E93D7B5A46D901" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run" /v "EpicGamesLauncher" /t REG_BINARY /d "03000000F51C70A77A48D901" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run" /v "RiotClient" /t REG_BINARY /d "03000000A0EA598A88B2D901" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run" /v "Steam" /t REG_BINARY /d "03000000E7766B83316FD901" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Disable Microsoft Setting Synchronization
echo Disable Setting Synchronization
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Accessibility" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\AppSync" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\BrowserSettings" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Credentials" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\DesktopTheme" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Language" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\PackageState" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Personalization" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\StartLayout" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Windows" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Disable Windows Error Reporting
echo Disable Windows Error Reporting
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "DoReport" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "LoggingDisabled" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\PCHealth\ErrorReporting" /v "DoReport" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d "1" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Setting Service Priorities & Boost
echo Set Service Priorities
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\I/O System" /v "PassiveIntRealTimeWorkerPriority" /t REG_DWORD /d "18" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\KernelVelocity" /v "DisableFGBoostDecay" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\dwm.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "4" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\dwm.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "3" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\lsass.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\lsass.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\lsass.exe\PerfOptions" /v "PagePriority" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\ntoskrnl.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "4" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\ntoskrnl.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "3" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\SearchIndexer.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\SearchIndexer.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\svchost.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\TrustedInstaller.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\TrustedInstaller.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\wuauclt.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\wuauclt.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\audiodg.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "2" /f >nul 2>nul
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\audiodg.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "2" /f >nul 2>nul
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\dwm.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "4" /f >nul 2>nul
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\dwm.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "3" /f >nul 2>nul
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\lsass.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\lsass.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\lsass.exe\PerfOptions" /v "PagePriority" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\ntoskrnl.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "4" /f >nul 2>nul
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\ntoskrnl.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "3" /f >nul 2>nul
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\SearchIndexer.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\SearchIndexer.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\svchost.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\TrustedInstaller.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\TrustedInstaller.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\wuauclt.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\wuauclt.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "0" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Windows Defender
echo Disable Windows Defender
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Reporting" /v "DisableGenericReports" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "LocalSettingOverrideSpynetReporting" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "SpynetReporting" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "SubmitSamplesConsent" /t REG_DWORD /d "2" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\SmartScreen" /v "ConfigureAppInstallControlEnabled" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Threats" /v "Threats_ThreatSeverityDefaultAction" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Threats\ThreatSeverityDefaultAction" /v "1" /t REG_SZ /d "6" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Threats\ThreatSeverityDefaultAction" /v "2" /t REG_SZ /d "6" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Threats\ThreatSeverityDefaultAction" /v "4" /t REG_SZ /d "6" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Threats\ThreatSeverityDefaultAction" /v "5" /t REG_SZ /d "6" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\UX Configuration" /v "Notification_Suppress" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Sense" /v "Start" /t REG_DWORD /d "4" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WdNisSvc" /v "Start" /t REG_DWORD /d "4" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WinDefend" /v "Start" /t REG_DWORD /d "4" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SecurityHealthService" /v "Start" /t REG_DWORD /d "4" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\wscsvc" /v "Start" /t REG_DWORD /d "4" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableRoutinelyTakingAction" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "ServiceKeepAlive" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableBehaviorMonitoring" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableIOAVProtection" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableOnAccessProtection" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRealtimeMonitoring" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Reporting" /v "DisableEnhancedNotifications" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Notifications" /v "DisableNotifications" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications" /v "NoToastApplicationNotification" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications" /v "NoToastApplicationNotificationOnLockScreen" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\MsMpEng.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\MsMpEngCP.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\MRT" /v "DontReportInfectionInformation" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableSmartScreen" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\PhishingFilter" /v "EnabledV9" /t REG_DWORD /d "0" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Enable FSO
echo Enable Full Screen Optimizations
reg delete "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "OverlayTestMode" /f >nul 2>nul
reg add "HKCU\SYSTEM\GameConfigStore" /v "GameDVR_DSEBehavior" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKCU\SYSTEM\GameConfigStore" /v "GameDVR_FSEBehaviorMode" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKCU\SYSTEM\GameConfigStore" /v "GameDVR_EFSEFeatureFlags" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKCU\SYSTEM\GameConfigStore" /v "GameDVR_DXGIHonorFSEWindowsCompatible" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKCU\SYSTEM\GameConfigStore" /v "GameDVR_HonorUserFSEBehaviorMode" /t REG_DWORD /d "1" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Latency Tolerance (melodytheneko)
echo Set Latency Tolerance
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "MonitorLatencyTolerance" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "MonitorRefreshLatencyTolerance" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "ExitLatency" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "ExitLatencyCheckEnabled" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "Latency" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "LatencyToleranceDefault" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "LatencyToleranceFSVP" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "LatencyTolerancePerfOverride" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "LatencyToleranceScreenOffIR" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "LatencyToleranceVSyncEnabled" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "RtlCapabilityCheckLatency" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultD3TransitionLatencyActivelyUsed" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultD3TransitionLatencyIdleLongTime" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultD3TransitionLatencyIdleMonitorOff" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultD3TransitionLatencyIdleNoContext" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultD3TransitionLatencyIdleShortTime" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultD3TransitionLatencyIdleVeryLongTime" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceIdle0" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceIdle0MonitorOff" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceIdle1" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceIdle1MonitorOff" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceMemory" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceNoContext" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceNoContextMonitorOff" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceOther" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceTimerPeriod" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultMemoryRefreshLatencyToleranceActivelyUsed" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultMemoryRefreshLatencyToleranceMonitorOff" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultMemoryRefreshLatencyToleranceNoContext" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "Latency" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "MaxIAverageGraphicsLatencyInOneBucket" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "MiracastPerfTrackGraphicsLatency" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "MonitorLatencyTolerance" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "MonitorRefreshLatencyTolerance" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "TransitionLatency" /t REG_DWORD /d "1" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Resource Policy Values
echo Set Resource Policy Store Values
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\HardCap0" /v "CapPercentage" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\HardCap0" /v "SchedulingType" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\Paused" /v "CapPercentage" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\Paused" /v "SchedulingType" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\SoftCapFull" /v "CapPercentage" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\SoftCapFull" /v "SchedulingType" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\SoftCapLow" /v "CapPercentage" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\SoftCapLow" /v "SchedulingType" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Flags\BackgroundDefault" /v "IsLowPriority" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Flags\Frozen" /v "IsLowPriority" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Flags\FrozenDNCS" /v "IsLowPriority" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Flags\FrozenDNK" /v "IsLowPriority" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Flags\FrozenPPLE" /v "IsLowPriority" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Flags\Paused" /v "IsLowPriority" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Flags\PausedDNK" /v "IsLowPriority" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Flags\Pausing" /v "IsLowPriority" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Flags\PrelaunchForeground" /v "IsLowPriority" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Flags\ThrottleGPUInterference" /v "IsLowPriority" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\Critical" /v "BasePriority" /t REG_DWORD /d "82" /f >nul 2>nul
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\Critical" /v "OverTargetPriority" /t REG_DWORD /d "50" /f >nul 2>nul
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\CriticalNoUi" /v "BasePriority" /t REG_DWORD /d "82" /f >nul 2>nul
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\CriticalNoUi" /v "OverTargetPriority" /t REG_DWORD /d "50" /f >nul 2>nul
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\EmptyHostPPLE" /v "BasePriority" /t REG_DWORD /d "82" /f >nul 2>nul
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\EmptyHostPPLE" /v "OverTargetPriority" /t REG_DWORD /d "50" /f >nul 2>nul
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\High" /v "BasePriority" /t REG_DWORD /d "82" /f >nul 2>nul
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\High" /v "OverTargetPriority" /t REG_DWORD /d "50" /f >nul 2>nul
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\Low" /v "BasePriority" /t REG_DWORD /d "82" /f >nul 2>nul
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\Low" /v "OverTargetPriority" /t REG_DWORD /d "50" /f >nul 2>nul
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\Lowest" /v "BasePriority" /t REG_DWORD /d "82" /f >nul 2>nul
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\Lowest" /v "OverTargetPriority" /t REG_DWORD /d "50" /f >nul 2>nul
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\Medium" /v "BasePriority" /t REG_DWORD /d "82" /f >nul 2>nul
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\Medium" /v "OverTargetPriority" /t REG_DWORD /d "50" /f >nul 2>nul
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\MediumHigh" /v "BasePriority" /t REG_DWORD /d "82" /f >nul 2>nul
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\MediumHigh" /v "OverTargetPriority" /t REG_DWORD /d "50" /f >nul 2>nul
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\StartHost" /v "BasePriority" /t REG_DWORD /d "82" /f >nul 2>nul
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\StartHost" /v "OverTargetPriority" /t REG_DWORD /d "50" /f >nul 2>nul
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\VeryHigh" /v "BasePriority" /t REG_DWORD /d "82" /f >nul 2>nul
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\VeryHigh" /v "OverTargetPriority" /t REG_DWORD /d "50" /f >nul 2>nul
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\VeryLow" /v "BasePriority" /t REG_DWORD /d "82" /f >nul 2>nul
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\VeryLow" /v "OverTargetPriority" /t REG_DWORD /d "50" /f >nul 2>nul
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\IO\NoCap" /v "IOBandwidth" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Memory\NoCap" /v "CommitLimit" /t REG_DWORD /d "4294967295" /f >nul 2>nul
reg add "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Memory\NoCap" /v "CommitTarget" /t REG_DWORD /d "4294967295" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Disable P-States
echo Disable P-States
for /f %%i in ('wmic path Win32_VideoController get PNPDeviceID^| findstr /L "PCI\VEN_"') do (
	for /f "tokens=3" %%a in ('reg query "HKLM\SYSTEM\ControlSet001\Enum\%%i" /v "Driver"') do (
		for /f %%i in ('echo %%a ^| findstr "{"') do (
		     reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%i" /v "DisableDynamicPstate" /t REG_DWORD /d "1" /f >nul 2>nul
                   )
                )
             )        
timeout /t 3 /nobreak >nul 2>nul


echo Disable Telemetry
:: Disable Telemetry Through Task Scheduler
schtasks /end /tn "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" >nul 2>nul
schtasks /change /tn "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /disable >nul 2>nul
schtasks /end /tn "\Microsoft\Windows\Customer Experience Improvement Program\BthSQM" >nul 2>nul
schtasks /change /tn "\Microsoft\Windows\Customer Experience Improvement Program\BthSQM" /disable >nul 2>nul
schtasks /end /tn "\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask" >nul 2>nul
schtasks /change /tn "\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask" /disable >nul 2>nul
schtasks /end /tn "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" >nul 2>nul
schtasks /change /tn "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /disable >nul 2>nul
schtasks /end /tn "\Microsoft\Windows\Customer Experience Improvement Program\Uploader" >nul 2>nul
schtasks /change /tn "\Microsoft\Windows\Customer Experience Improvement Program\Uploader" /disable >nul 2>nul
schtasks /end /tn "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" >nul 2>nul
schtasks /change /tn "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /disable >nul 2>nul
schtasks /end /tn "\Microsoft\Windows\Application Experience\ProgramDataUpdater" >nul 2>nul
schtasks /change /tn "\Microsoft\Windows\Application Experience\ProgramDataUpdater" /disable >nul 2>nul
schtasks /end /tn "\Microsoft\Windows\Application Experience\StartupAppTask" >nul 2>nul
schtasks /change /tn "\Microsoft\Windows\Application Experience\StartupAppTask" /disable >nul 2>nul
schtasks /end /tn "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" >nul 2>nul
schtasks /change /tn "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /disable >nul 2>nul
schtasks /end /tn "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticResolver" >nul 2>nul
schtasks /change /tn "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticResolver" /disable >nul 2>nul
schtasks /end /tn "\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem" >nul 2>nul
schtasks /change /tn "\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem" /disable >nul 2>nul
schtasks /end /tn "\Microsoft\Windows\Shell\FamilySafetyMonitor" >nul 2>nul
schtasks /change /tn "\Microsoft\Windows\Shell\FamilySafetyMonitor" /disable >nul 2>nul
schtasks /end /tn "\Microsoft\Windows\Shell\FamilySafetyRefresh" >nul 2>nul
schtasks /change /tn "\Microsoft\Windows\Shell\FamilySafetyRefresh" /disable >nul 2>nul
schtasks /end /tn "\Microsoft\Windows\Shell\FamilySafetyUpload" >nul 2>nul
schtasks /change /tn "\Microsoft\Windows\Shell\FamilySafetyUpload" /disable >nul 2>nul
schtasks /end /tn "\Microsoft\Windows\Autochk\Proxy" >nul 2>nul
schtasks /change /tn "\Microsoft\Windows\Autochk\Proxy" /disable >nul 2>nul
schtasks /end /tn "\Microsoft\Windows\Maintenance\WinSAT" >nul 2>nul
schtasks /change /tn "\Microsoft\Windows\Maintenance\WinSAT" /disable >nul 2>nul
schtasks /end /tn "\Microsoft\Windows\Application Experience\AitAgent" >nul 2>nul
schtasks /change /tn "\Microsoft\Windows\Application Experience\AitAgent" /disable >nul 2>nul
schtasks /end /tn "\Microsoft\Windows\Windows Error Reporting\QueueReporting" >nul 2>nul
schtasks /change /tn "\Microsoft\Windows\Windows Error Reporting\QueueReporting" /disable >nul 2>nul
schtasks /end /tn "\Microsoft\Windows\CloudExperienceHost\CreateObjectTask" >nul 2>nul
schtasks /change /tn "\Microsoft\Windows\CloudExperienceHost\CreateObjectTask" /disable >nul 2>nul
schtasks /end /tn "\Microsoft\Windows\DiskFootprint\Diagnostics" >nul 2>nul
schtasks /change /tn "\Microsoft\Windows\DiskFootprint\Diagnostics" /disable >nul 2>nul
schtasks /end /tn "\Microsoft\Windows\FileHistory\File History (maintenance mode)" >nul 2>nul
schtasks /change /tn "\Microsoft\Windows\FileHistory\File History (maintenance mode)" /disable >nul 2>nul
schtasks /end /tn "\Microsoft\Windows\PI\Sqm-Tasks" >nul 2>nul
schtasks /change /tn "\Microsoft\Windows\PI\Sqm-Tasks" /disable >nul 2>nul
schtasks /end /tn "\Microsoft\Windows\NetTrace\GatherNetworkInfo" >nul 2>nul
schtasks /change /tn "\Microsoft\Windows\NetTrace\GatherNetworkInfo" /disable >nul 2>nul
schtasks /end /tn "\Microsoft\Windows\AppID\SmartScreenSpecific" >nul 2>nul
schtasks /change /tn "\Microsoft\Windows\AppID\SmartScreenSpecific" /disable >nul 2>nul
schtasks /end /tn "\Microsoft\Office\OfficeTelemetryAgentFallBack2016" >nul 2>nul
schtasks /change /tn "\Microsoft\Office\OfficeTelemetryAgentFallBack2016" /disable >nul 2>nul
schtasks /end /tn "\Microsoft\Office\OfficeTelemetryAgentLogOn2016" >nul 2>nul
schtasks /change /tn "\Microsoft\Office\OfficeTelemetryAgentLogOn2016" /disable >nul 2>nul
schtasks /end /tn "\Microsoft\Office\OfficeTelemetryAgentLogOn" >nul 2>nul
schtasks /change /TN "\Microsoft\Office\OfficeTelemetryAgentLogOn" /disable >nul 2>nul
schtasks /end /tn "\Microsoftd\Office\OfficeTelemetryAgentFallBack" >nul 2>nul
schtasks /change /TN "\Microsoftd\Office\OfficeTelemetryAgentFallBack" /disable >nul 2>nul
schtasks /end /tn "\Microsoft\Office\Office 15 Subscription Heartbeat" >nul 2>nul
schtasks /change /TN "\Microsoft\Office\Office 15 Subscription Heartbeat" /disable >nul 2>nul
schtasks /end /tn "\Microsoft\Windows\Time Synchronization\ForceSynchronizeTime" >nul 2>nul
schtasks /change /TN "\Microsoft\Windows\Time Synchronization\ForceSynchronizeTime" /disable >nul 2>nul
schtasks /end /tn "\Microsoft\Windows\Time Synchronization\SynchronizeTime" >nul 2>nul
schtasks /change /TN "\Microsoft\Windows\Time Synchronization\SynchronizeTime" /disable >nul 2>nul
schtasks /end /tn "\Microsoft\Windows\WindowsUpdate\Automatic App Update" >nul 2>nul
schtasks /change /TN "\Microsoft\Windows\WindowsUpdate\Automatic App Update" /disable >nul 2>nul
schtasks /end /tn "\Microsoft\Windows\Device Information\Device" >nul 2>nul
schtasks /change /TN "\Microsoft\Windows\Device Information\Device" /disable >nul 2>nul

:: Disable Telemetry Through Registry
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata" /v "PreventDeviceMetadataFromNetwork" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Permissions\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" /v "SensorPermissionState" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" /v "SensorPermissionState" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\WUDF" /v "LogEnable" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\WUDF" /v "LogLevel" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "DoNotShowFeedbackNotifications" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowCommercialDataPipeline" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowDeviceNameInTelemetry" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "LimitEnhancedDiagnosticDataWindowsAnalytics" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "MicrosoftEdgeDataOptIn" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Siuf\Rules" /v "NumberOfSIUFInPeriod" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\Siuf\Rules" /v "PeriodInNanoSeconds" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Policies\Microsoft\Assistance\Client\1.0" /v "NoExplicitFeedback" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Assistance\Client\1.0" /v "NoActiveHelp" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableInventory" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "AITEnable" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableUAR" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\TabletPC" /v "PreventHandwritingDataSharing" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\TabletPC" /v "DoSvc" /t REG_DWORD /d "3" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableLocation" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableLocationScripting" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableSensors" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableWindowsLocationProvider" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\DeviceHealthAttestationService" /v "DisableSendGenericDriverNotFoundToWER" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceInstall\Settings" /v "DisableSendGenericDriverNotFoundToWER" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\DriverDatabase\Policies\Settings" /v "DisableSendGenericDriverNotFoundToWER" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "PublishUserActivities" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableActivityFeed" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "UploadUserActivities" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Microsoft\SQMClient\Reliability" /v "CEIPEnable" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Microsoft\SQMClient\Reliability" /v "SqmLoggerRunning" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Microsoft\SQMClient\Windows" /v "DisableOptinExperience" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Microsoft\SQMClient\Windows" /v "SqmLoggerRunning" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Microsoft\SQMClient\IE" /v "SqmLoggerRunning" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\HandwritingErrorReports" /v "PreventHandwritingErrorReports" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\FileHistory" /v "Disabled" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\MediaPlayer\Preferences" /v "UsageTracking" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoUseStoreOpenWith" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableSoftLanding" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Peernet" /v "Disabled" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" /v DODownloadMode /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" /v value /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKCU\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" /v "HarvestContacts" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" /v "DisabledByGroupPolicy" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\MRT" /v "DontOfferThroughWUAU" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Biometrics" /v "Enabled" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\dmwappushservice" /v "Start" /t REG_DWORD /d "4" /f >nul 2>nul
reg add "HKLM\SYSTEM\DriverDatabase\Policies\Settings" /v "DisableSendGenericDriverNotFoundToWER" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKCU\Control Panel\International\User Profile" /v "HttpAcceptLanguageOptOut" /t REG_DWORD /d "1" /f >nul 2>nul

:: Disable AutoLoggers
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\AppModel" /v "Start" /t REG_DWORD /d "0" /f >nul 2>nul 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\Cellcore" /v "Start" /t REG_DWORD /d "0" /f >nul 2>nul 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\Circular Kernel Context Logger" /v "Start" /t REG_DWORD /d "0" /f >nul 2>nul 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\CloudExperienceHostOobe" /v "Start" /t REG_DWORD /d "0" /f >nul 2>nul 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\DataMarket" /v "Start" /t REG_DWORD /d "0" /f >nul 2>nul 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\DefenderApiLogger" /v "Start" /t REG_DWORD /d "0" /f >nul 2>nul 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\DefenderAuditLogger" /v "Start" /t REG_DWORD /d "0" /f >nul 2>nul 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\DiagLog" /v "Start" /t REG_DWORD /d "0" /f >nul 2>nul 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\HolographicDevice" /v "Start" /t REG_DWORD /d "0" /f >nul 2>nul 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\iclsClient" /v "Start" /t REG_DWORD /d "0" /f >nul 2>nul 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\iclsProxy" /v "Start" /t REG_DWORD /d "0" /f >nul 2>nul 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\LwtNetLog" /v "Start" /t REG_DWORD /d "0" /f >nul 2>nul 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\Mellanox-Kernel" /v "Start" /t REG_DWORD /d "0" /f >nul 2>nul 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\Microsoft-Windows-AssignedAccess-Trace" /v "Start" /t REG_DWORD /d "0" /f >nul 2>nul 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\Microsoft-Windows-Setup" /v "Start" /t REG_DWORD /d "0" /f >nul 2>nul 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\NBSMBLOGGER" /v "Start" /t REG_DWORD /d "0" /f >nul 2>nul 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\PEAuthLog" /v "Start" /t REG_DWORD /d "0" /f >nul 2>nul 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\RdrLog" /v "Start" /t REG_DWORD /d "0" /f >nul 2>nul 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\ReadyBoot" /v "Start" /t REG_DWORD /d "0" /f >nul 2>nul 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\SetupPlatform" /v "Start" /t REG_DWORD /d "0" /f >nul 2>nul 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\SetupPlatformTel" /v "Start" /t REG_DWORD /d "0" /f >nul 2>nul 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\SocketHeciServer" /v "Start" /t REG_DWORD /d "0" /f >nul 2>nul 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\SpoolerLogger" /v "Start" /t REG_DWORD /d "0" /f >nul 2>nul 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\SQMLogger" /v "Start" /t REG_DWORD /d "0" /f >nul 2>nul 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\TCPIPLOGGER" /v "Start" /t REG_DWORD /d "0" /f >nul 2>nul 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\TileStore" /v "Start" /t REG_DWORD /d "0" /f >nul 2>nul 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\Tpm" /v "Start" /t REG_DWORD /d "0" /f >nul 2>nul 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\TPMProvisioningService" /v "Start" /t REG_DWORD /d "0" /f >nul 2>nul 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\UBPM" /v "Start" /t REG_DWORD /d "0" /f >nul 2>nul 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\WdiContextLog" /v "Start" /t REG_DWORD /d "0" /f >nul 2>nul 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\WFP-IPsec Trace" /v "Start" /t REG_DWORD /d "0" /f >nul 2>nul 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\WiFiDriverIHVSession" /v "Start" /t REG_DWORD /d "0" /f >nul 2>nul 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\WiFiDriverIHVSessionRepro" /v "Start" /t REG_DWORD /d "0" /f >nul 2>nul 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\WiFiSession" /v "Start" /t REG_DWORD /d "0" /f >nul 2>nul 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\WinPhoneCritical" /v "Start" /t REG_DWORD /d "0" /f >nul 2>nul 
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\WUDF" /v "LogEnable" /t REG_DWORD /d "0" /f >nul 2>nul 
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\WUDF" /v "LogLevel" /t REG_DWORD /d "0" /f >nul 2>nul 
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableThirdPartySuggestions" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsConsumerFeatures" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa\Credssp" /v "DebugLogLevel" /t REG_DWORD /d "0" /f >nul 2>nul

::Disable Trace Logs (Check which are active with 'logman query -ets')
logman delete "Circular Kernel Context Logger" -ets >nul 2>nul
logman delete "BioEnrollment" -ets >nul 2>nul
logman delete "DiagLog" -ets >nul 2>nul
logman delete "FaceCredProv" -ets >nul 2>nul
logman delete "FaceTel" -ets >nul 2>nul
logman delete "iclsClient" -ets >nul 2>nul
logman delete "iclsProxy" -ets >nul 2>nul
logman delete "Ihv" -ets >nul 2>nul
logman delete "IntelPTTEKRecertification" -ets >nul 2>nul
logman delete "IntelRST" -ets >nul 2>nul
logman delete "LwtNetLog" -ets >nul 2>nul
logman delete "Microsoft-Windows-Rdp-Graphics-RdpIdd-Trace" -ets >nul 2>nul
logman delete "ModemControl" -ets >nul 2>nul
logman delete "NetCore" -ets >nul 2>nul
logman delete "NtfsLog" -ets >nul 2>nul
logman delete "RadioMgr" -ets >nul 2>nul
logman delete "SgrmEtwSession" -ets >nul 2>nul
logman delete "TPMProvisioningService" -ets >nul 2>nul
logman delete "Ude" -ets >nul 2>nul
logman delete "WdiContextLog" -ets >nul 2>nul
logman delete "WiFiDriverIHVSession" -ets >nul 2>nul
logman delete "WiFiSession" -ets >nul 2>nul
logman delete "SleepStudyTraceSession" -ets >nul 2>nul
logman delete "UserNotPresentTraceSession" -ets >nul 2>nul

:: Disable Telemetry Services
sc stop DiagTrack >nul 2>nul
sc config DiagTrack start= disabled >nul 2>nul
sc stop dmwappushservice >nul 2>nul
sc config dmwappushservice start= disabled >nul 2>nul
sc stop diagnosticshub.standardcollector.service >nul 2>nul
sc config diagnosticshub.standardcollector.service start= disabled >nul 2>nul

:: Disable Energy Logging
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\EnergyEstimation\TaggedEnergy" /v "DisableTaggedEnergyLogging" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\EnergyEstimation\TaggedEnergy" /v "TelemetryMaxApplication" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\EnergyEstimation\TaggedEnergy" /v "TelemetryMaxTagPerApplication" /t REG_DWORD /d "0" /f >nul 2>nul

:: Disable Office Telemetry
reg add "HKLM\SOFTWARE\Microsoft\Software\Policies\Microsoft\Office\16.0\osm" /v "Enablelogging" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Microsoft\Software\Policies\Microsoft\Office\16.0\osm" /v "EnableUpload" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SOFTWARE\Microsoft\Office\Common\ClientTelemetry" /v "DisableTelemetry" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKCU\Software\Policies\microsoft\office\16.0\osm\preventedapplications" /v "accesssolution" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKCU\Software\Policies\microsoft\office\16.0\osm\preventedapplications" /v "olksolution" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKCU\Software\Policies\microsoft\office\16.0\osm\preventedapplications" /v "onenotesolution" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKCU\Software\Policies\microsoft\office\16.0\osm\preventedapplications" /v "pptsolution" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKCU\Software\Policies\microsoft\office\16.0\osm\preventedapplications" /v "projectsolution" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKCU\Software\Policies\microsoft\office\16.0\osm\preventedapplications" /v "publishersolution" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKCU\Software\Policies\microsoft\office\16.0\osm\preventedapplications" /v "visiosolution" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKCU\Software\Policies\microsoft\office\16.0\osm\preventedapplications" /v "wdsolution" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKCU\Software\Policies\microsoft\office\16.0\osm\preventedapplications" /v "xlsolution" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKCU\Software\Policies\microsoft\office\16.0\osm\preventedsolutiontypes" /v "agave" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKCU\Software\Policies\microsoft\office\16.0\osm\preventedsolutiontypes" /v "appaddins" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKCU\Software\Policies\microsoft\office\16.0\osm\preventedsolutiontypes" /v "comaddins" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKCU\Software\Policies\microsoft\office\16.0\osm\preventedsolutiontypes" /v "documentfiles" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKCU\Software\Policies\microsoft\office\16.0\osm\preventedsolutiontypes" /v "templatefiles" /t REG_DWORD /d "1" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

::Optimize Service Host Split Threshold
:SvcHostOptimization
cls
set c=[94m
set t=[0m
set w=[31m
set y=[0m
set u=[4m
set q=[0m
echo.
echo.
echo.
echo.
echo                       %w%██████%y%%c%╗%y% %w%███████%y%%c%╗%y%%w%████████%y%%c%╗%y%    %w%██████%y%%c%╗%y% %w%███████%y%%c%╗%y% %w%██████%y%%c%╗%y%  %w%██████%y%%c%╗%y% %w%███████%y%%c%╗%y%%w%██████%y%%c%╗%y% 
echo                      %w%██%y%%c%╔════╝%y% %w%██%y%%c%╔════╝%y%%c%╚══%y%%w%██%y%%c%╔══╝%y%    %w%██%y%%c%╔══%y%%w%██%y%%c%╗%y%%w%██%y%%c%╔════╝%y%%w%██%y%%c%╔════╝%y% %w%██%y%%c%╔════╝%y% %w%██%y%%c%╔════╝%y%%w%██%y%%c%╔══%y%%w%██%y%%c%╗%y%  
echo                      %w%██%y%%c%║%y%  %w%███%c%╗%y%%w%█████%y%%c%╗%y%     %w%██%y%%c%║%y%       %w%██████%y%%c%╔╝%y%%w%█████%y%%c%╗%y%  %w%██%y%%c%║%y%  %w%███%c%╗%y%%w%██%y%%c%║%y%  %w%███%c%╗%y%%w%█████%y%%c%╗%y%  %w%██%y%%c%║  %y%%w%██%y%%c%║%y% 
echo                      %w%██%y%%c%║%y%   %w%██%y%%c%║%y%%w%██%y%%c%╔══╝%y%     %w%██%y%%c%║%y%       %w%██%y%%c%╔══%y%%w%██%y%%c%╗%y%%w%██%y%%c%╔══╝%y%  %w%██%y%%c%║%y%   %w%██%y%%c%║%y%%w%██%y%%c%║%y%   %w%██%y%%c%║%y%%w%██%y%%c%╔══╝%y%  %w%██%y%%c%║  %y%%w%██%y%%c%║%y%     
echo                      %c%╚%y%%w%██████%y%%c%╔╝%y%%w%███████%y%%c%╗%y%   %w%██%y%%c%║%y%       %w%██%y%%c%║  %y%%w%██%y%%c%║%y%%w%███████%y%%c%╗%y%%c%╚%y%%w%██████%y%%c%╔╝%y%%c%╚%y%%w%██████%y%%c%╔╝%y%%w%███████%y%%c%╗%y%%w%██████%y%%c%╔╝%y%
echo                       %c%╚═════╝%y% %c%╚══════╝%y%   %c%╚═╝%y%       %c%╚═╝  ╚═╝%y%%c%╚══════╝%y% %c%╚═════╝%y%  %c%╚═════╝%y% %c%╚══════╝%y%%c%╚═════╝%y%          
echo                                                       %c%%u%Version: %Version%%q%%t%
echo.
echo.
echo %w%════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════%y%
echo.
echo.
echo.
echo.
echo.
echo                                              How much RAM does your PC have?
echo.
echo.
echo                                        	    %w%[%y% %c%%u%1%q%%t% %w%]%y% %c%8GB%t%                %w%[%y% %c%%u%2%q%%t% %w%]%y% %c%16GB%t%
echo.
echo.
echo                                        	    %w%[%y% %c%%u%3%q%%t% %w%]%y% %c%32GB%t%               %w%[%y% %c%%u%4%q%%t% %w%]%y% %c%64GB%t%
echo.
echo.
echo                                                     %w%[%y% %c%%u%5%q%%t% %w%]%y% %c%I don't know%t%
echo.
echo.
set choice=
set /p choice=
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto 8GB
if '%choice%'=='2' goto 16GB
if '%choice%'=='3' goto 32GB
if '%choice%'=='4' goto 64GB
if '%choice%'=='5' goto GraphicsOptimization

:8GB
cls
echo Optimize Service Host Split Threshold for 8GB RAM
reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v "SvcHostSplitThresholdInKB" /t REG_DWORD /d "8388608" /f >nul 2>nul
timeout /t 3 /nobreak >nul 2>nul
goto GraphicsOptimization

:16GB
cls
echo Optimize Service Host Split Threshold for 16GB RAM
reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v "SvcHostSplitThresholdInKB" /t REG_DWORD /d "16777216" /f >nul 2>nul
timeout /t 3 /nobreak >nul 2>nul
goto GraphicsOptimization

:32GB
cls
echo Optimize Service Host Split Threshold for 32GB RAM
reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v "SvcHostSplitThresholdInKB" /t REG_DWORD /d "33554432" /f >nul 2>nul
timeout /t 3 /nobreak >nul 2>nul
goto GraphicsOptimization

:64GB
cls
echo Optimize Service Host Split Threshold for 64GB RAM
reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v "SvcHostSplitThresholdInKB" /t REG_DWORD /d "67108864" /f >nul 2>nul
timeout /t 3 /nobreak >nul 2>nul
goto GraphicsOptimization

:GraphicsOptimization

cls
set c=[94m
set t=[0m
set w=[31m
set y=[0m
set u=[4m
set q=[0m
echo.
echo.
echo.
echo.
echo                       %w%██████%y%%c%╗%y% %w%███████%y%%c%╗%y%%w%████████%y%%c%╗%y%    %w%██████%y%%c%╗%y% %w%███████%y%%c%╗%y% %w%██████%y%%c%╗%y%  %w%██████%y%%c%╗%y% %w%███████%y%%c%╗%y%%w%██████%y%%c%╗%y% 
echo                      %w%██%y%%c%╔════╝%y% %w%██%y%%c%╔════╝%y%%c%╚══%y%%w%██%y%%c%╔══╝%y%    %w%██%y%%c%╔══%y%%w%██%y%%c%╗%y%%w%██%y%%c%╔════╝%y%%w%██%y%%c%╔════╝%y% %w%██%y%%c%╔════╝%y% %w%██%y%%c%╔════╝%y%%w%██%y%%c%╔══%y%%w%██%y%%c%╗%y%  
echo                      %w%██%y%%c%║%y%  %w%███%c%╗%y%%w%█████%y%%c%╗%y%     %w%██%y%%c%║%y%       %w%██████%y%%c%╔╝%y%%w%█████%y%%c%╗%y%  %w%██%y%%c%║%y%  %w%███%c%╗%y%%w%██%y%%c%║%y%  %w%███%c%╗%y%%w%█████%y%%c%╗%y%  %w%██%y%%c%║  %y%%w%██%y%%c%║%y% 
echo                      %w%██%y%%c%║%y%   %w%██%y%%c%║%y%%w%██%y%%c%╔══╝%y%     %w%██%y%%c%║%y%       %w%██%y%%c%╔══%y%%w%██%y%%c%╗%y%%w%██%y%%c%╔══╝%y%  %w%██%y%%c%║%y%   %w%██%y%%c%║%y%%w%██%y%%c%║%y%   %w%██%y%%c%║%y%%w%██%y%%c%╔══╝%y%  %w%██%y%%c%║  %y%%w%██%y%%c%║%y%     
echo                      %c%╚%y%%w%██████%y%%c%╔╝%y%%w%███████%y%%c%╗%y%   %w%██%y%%c%║%y%       %w%██%y%%c%║  %y%%w%██%y%%c%║%y%%w%███████%y%%c%╗%y%%c%╚%y%%w%██████%y%%c%╔╝%y%%c%╚%y%%w%██████%y%%c%╔╝%y%%w%███████%y%%c%╗%y%%w%██████%y%%c%╔╝%y%
echo                       %c%╚═════╝%y% %c%╚══════╝%y%   %c%╚═╝%y%       %c%╚═╝  ╚═╝%y%%c%╚══════╝%y% %c%╚═════╝%y%  %c%╚═════╝%y% %c%╚══════╝%y%%c%╚═════╝%y%          
echo                                                       %c%%u%Version: %Version%%q%%t%
echo.
echo.
echo %w%════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════%y%
echo.
echo.
echo.
echo.
echo.
echo                                                    What GPU do you use?
echo.
echo.
echo                 	      %w%[%y% %c%%u%1%q%%t% %w%]%y% %c%NVIDIA%t%               %w%[%y% %c%%u%2%q%%t% %w%]%y% %c%AMD%t%               %w%[%y% %c%%u%3%q%%t% %w%]%y% %c%IGPU%t%
echo.
echo.
echo.
echo.
echo.
echo.
echo.
set choice=
set /p choice=
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto NVIDIA
if '%choice%'=='2' goto AMD
if '%choice%'=='3' goto IGPU

:NVIDIA

cls
:: NVIDIA Inspector Profile
echo Applying NVIDIA Inspector Profile
curl -g -k -L -# -o "%temp%\nvidiaProfileInspector.zip" "https://github.com/Orbmu2k/nvidiaProfileInspector/releases/latest/download/nvidiaProfileInspector.zip" >nul 2>nul
powershell -NoProfile Expand-Archive '%temp%\nvidiaProfileInspector.zip' -DestinationPath '%temp%\NvidiaProfileInspector\' >nul 2>nul
curl -g -k -L -# -o "%temp%\NvidiaProfileInspector\ancel_nv_profile.nip" "https://github.com/ancel1x/Ancels-Performance-Batch/raw/main/bin/ancel_nv_profile.nip" >nul 2>nul
start "" /wait "%temp%\NvidiaProfileInspector\nvidiaProfileInspector.exe" -silentImport "C:\NvidiaProfileInspector\ancel_nv_profile.nip" >nul 2>nul
timeout /t 3 /nobreak >nul 2>nul

:: Enable MSI Mode for GPU
echo Enable MSI Mode
for /f %%g in ('wmic path win32_videocontroller get PNPDeviceID ^| findstr /L "VEN_"') do (
reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%g\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f  >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%g\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /t REG_DWORD /d "0" /f >nul 2>nul
)
timeout /t 1 /nobreak >nul 2>nul

:: NVIDIA Latency Tolerance
echo Set NVIDIA Latency Tolerance
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "D3PCLatency" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "F1TransitionLatency" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "LOWLATENCY" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "Node3DLowLatency" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PciLatencyTimerControl" /t REG_DWORD /d "20" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RMDeepL1EntryLatencyUsec" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RmGspcMaxFtuS" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RmGspcMinFtuS" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RmGspcPerioduS" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RMLpwrEiIdleThresholdUs" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RMLpwrGrIdleThresholdUs" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RMLpwrGrRgIdleThresholdUs" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RMLpwrMsIdleThresholdUs" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "VRDirectFlipDPCDelayUs" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "VRDirectFlipTimingMarginUs" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "VRDirectJITFlipMsHybridFlipDelayUs" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "vrrCursorMarginUs" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "vrrDeflickerMarginUs" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "vrrDeflickerMaxUs" /t REG_DWORD /d "1" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Force Contigous Memory Allocation
echo Forcing Contigous Memory Allocation
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PreferSystemMemoryContiguous" /t REG_DWORD /d "1" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Disable HDCP
echo Disable High-bandwidth Digital Content Protection
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RMHdcpKeyGlobZero" /t REG_DWORD /d "1" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Disable TCC
echo Disable TCC
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "TCCSupported" /t REG_DWORD /d "0" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Disable Tiled Display
echo Disable Tiled Display
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableTiledDisplay" /t REG_DWORD /d "0" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Disable NVIDIA Telemetry
echo Disable NVIDIA Telemetry
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "NvBackend" /f >nul 2>nul
reg add "HKLM\SOFTWARE\NVIDIA Corporation\NvControlPanel2\Client" /v "OptInOrOutPreference" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\FTS" /v "EnableRID66610" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\FTS" /v "EnableRID64640" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\FTS" /v "EnableRID44231" /t REG_DWORD /d "0" /f >nul 2>nul
schtasks /change /disable /tn "NvTmRep_CrashReport1_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}" >nul 2>nul
schtasks /change /disable /tn "NvTmRep_CrashReport2_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}" >nul 2>nul
schtasks /change /disable /tn "NvTmRep_CrashReport3_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}" >nul 2>nul
schtasks /change /disable /tn "NvTmRep_CrashReport4_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}" >nul 2>nul
schtasks /change /disable /tn "NvDriverUpdateCheckDaily_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}" >nul 2>nul
schtasks /change /disable /tn "NVIDIA GeForce Experience SelfUpdate_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}" >nul 2>nul
schtasks /change /disable /tn "NvTmMon_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}" >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: NVIDIA Control Panal Language English
reg add "HKLM\SOFTWARE\NVIDIA Corporation\NvControlPanel2\Client" /v "UserDefinedLocale" /t REG_DWORD /d "1024" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Disable NVIDIA Display Power Saving
echo Disable NVIDIA Display Power Saving
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\NVTweak" /v "DisplayPowerSaving" /t REG_DWORD /d "0" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Disable Write Combining
echo Disable Write Combining
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "DisableWriteCombining" /t REG_DWORD /d "1" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Enable DPC'S for each Core
echo Enable DPC'S for each Core
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v "RmGpsPsEnablePerCpuCoreDpc" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\NVAPI" /v "RmGpsPsEnablePerCpuCoreDpc" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\NVTweak" /v "RmGpsPsEnablePerCpuCoreDpc" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "RmGpsPsEnablePerCpuCoreDpc" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "RmGpsPsEnablePerCpuCoreDpc" /t REG_DWORD /d "1" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Enable Old Image Sharpening
echo Enable Old Image Sharpening
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "EnableGR535" /t REG_DWORD /d "0" /f >nul 2>nul

:: Video Redraw Acceleration
echo Set Driver Acceleration
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "Acceleration.Level" /t REG_DWORD /d "0" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Disable NVIDIA 3D Vision Shortcuts
echo Disable NVIDIA Shortcuts
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DesktopStereoShortcuts" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "FeatureControl" /t REG_DWORD /d "4" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Disable Filter
echo Disable Filter
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "NVDeviceSupportKFilter" /t REG_DWORD /d "0" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Increased Dedicated Video Memory
echo Increasing Dedicated Video Memory
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RmCacheLoc" /t REG_DWORD /d "0" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Set NVIDIA Driver Package Install Directory
echo Set Driver Package Install Directory
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RmDisableInst2Sys" /t REG_DWORD /d "0" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: ReAllocate DMA Buffers
echo ReAllocating DMA Buffers
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RmFbsrPagedDMA" /t REG_DWORD /d "1" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Change PCounter Permissions
echo Changing Performance Counter Permissions
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RmProfilingAdminOnly" /t REG_DWORD /d "0" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Disable DX Event Tracking
echo Disable DirectX Event Tracking
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "TrackResetEngine" /t REG_DWORD /d "0" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Disable Verifications in Block Transfer Operations
echo Disable Verifications Block Transfer Operations
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "ValidateBlitSubRects" /t REG_DWORD /d "0" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Disable NVIDIA WDDM TDR
echo Disable NVIDIA TDR
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "TdrLevel" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "TdrDelay" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "TdrDdiDelay" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "TdrDebugMode" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "TdrLimitCount" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "TdrLimitTime" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "TdrTestMode" /t REG_DWORD /d "0" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

cls
echo Finished Performance Optimizations
timeout /t 3 /nobreak >nul 2>nul
goto menuexit

:AMD

cls
:: Enable MSI Mode for GPU
echo Enable MSI Mode
for /f %%g in ('wmic path win32_videocontroller get PNPDeviceID ^| findstr /L "VEN_"') do (
reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%g\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f >nul 2>nul 
reg add "HKLM\SYSTEM\CurrentControlSet\Enum\%%g\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /t REG_DWORD /d "0" /f >nul 2>nul
)
timeout /t 1 /nobreak >nul 2>nul

:: Disable Override Referesh Rate
echo Disable Display Refresh Rate Override
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "3D_Refresh_Rate_Override_DEF" /t REG_DWORD /d "0" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Disable SnapShot
echo Disable SnapShot
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AllowSnapshot" /t REG_DWORD /d "0" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Disable Anti Aliasing
echo Disable Anti Aliasing
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AAF_NA" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AntiAlias_NA" /t REG_SZ /d "0" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "ASTT_NA" /t REG_SZ /d "0" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Disable AllowSubscription
echo Disable Subscriptions
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AllowSubscription" /t REG_DWORD /d "0" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Disable Anisotropic Filtering
echo Disable Anisotropic Filtering
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AreaAniso_NA" /t REG_SZ /d "0" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Disable AllowRSOverlay
echo Disable Radeon Overlay
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AllowRSOverlay" /t REG_SZ /d "false" /f >nul 2>nul 
timeout /t 1 /nobreak >nul 2>nul

:: Enable Adaptive DeInterlacing
echo Enable Adaptive DeInterlacing
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "Adaptive De-interlacing" /t REG_DWORD /d "1" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Disable AllowSkins
echo Disable Skins
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AllowSkins" /t REG_SZ /d "false" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Disable AutoColorDepthReduction_NA
echo Disable Automatic Color Depth Reduction
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "AutoColorDepthReduction_NA" /t REG_DWORD /d "0" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Disable Power Gating
echo Disable Power Gating
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableSAMUPowerGating" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableUVDPowerGatingDynamic" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableVCEPowerGating" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisablePowerGating" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableDrmdmaPowerGating" /t REG_DWORD /d "1" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Disable Clock Gating
echo Disable Clock Gating
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableVceSwClockGating" /t REG_DWORD /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableUvdClockGating" /t REG_DWORD /d "1" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Disable ASPM
echo Disable Active State Power Management
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableAspmL0s" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableAspmL1" /t REG_DWORD /d "0" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Disable ULPS
echo Disable Ultra Low Power States
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableUlps" /t REG_DWORD /d "0" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableUlps_NA" /t REG_SZ /d "0" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Enable De-Lag
echo Enable De-Lag
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_DeLagEnabled" /t REG_DWORD /d "1" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Disable FRT
echo Disable Frame Rate Target
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "KMD_FRTEnabled" /t REG_DWORD /d "0" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Disable DMA
echo Disable DMA
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableDMACopy" /t REG_DWORD /d "1" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Enable BlockWrite
echo Enable BlockWrite
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisableBlockWrite" /t REG_DWORD /d "0" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Disable StutterMode
echo Disable Stutter Mode
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "StutterMode" /t REG_DWORD /d "0" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Disable GPU Mem Clock Sleep State
echo Disable GPU Memory Clock Sleep State
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PP_SclkDeepSleepDisable" /t REG_DWORD /d "1" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Disable Thermal Throttling
echo Disable Thermal Throttling
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PP_ThermalAutoThrottlingEnable" /t REG_DWORD /d "0" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Setting Main3D
echo Set Main3D
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "Main3D_DEF" /t REG_SZ /d "1" /f >nul 2>nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "Main3D" /t REG_BINARY /d "3100" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Setting FlipQueueSize
echo Set FlipQueueSize
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "FlipQueueSize" /t REG_BINARY /d "3100" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Setting Shader Cache
echo Set Shader Cache Size
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "ShaderCache" /t REG_BINARY /d "3200" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Configuring TFQ
echo Configuring TFQ
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" /v "TFQ" /t REG_BINARY /d "3200" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Disable HDCP
echo Disable High-Bandwidth Digital Content Protection
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\\DAL2_DATA__2_0\DisplayPath_4\EDID_D109_78E9\Option" /v "ProtectionControl" /t REG_BINARY /d "0100000001000000" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Disable GPU Power Down
echo Disable GPU Power Down
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PP_GPUPowerDownEnabled" /t REG_DWORD /d "1" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: Disable AMD Logging
echo Disable AMD Logging
reg add "HKLM\SYSTEM\CurrentControlSet\Services\amdlog" /v "Start" /t REG_DWORD /d "4" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

:: AMD Tweaks (melodytheneko)
echo Applying Melody AMD Tweaks
for %%a in (LTRSnoopL1Latency LTRSnoopL0Latency LTRNoSnoopL1Latency LTRMaxNoSnoopLatency KMD_RpmComputeLatency
        DalUrgentLatencyNs memClockSwitchLatency PP_RTPMComputeF1Latency PP_DGBMMMaxTransitionLatencyUvd
        PP_DGBPMMaxTransitionLatencyGfx DalNBLatencyForUnderFlow
        BGM_LTRSnoopL1Latency BGM_LTRSnoopL0Latency BGM_LTRNoSnoopL1Latency BGM_LTRNoSnoopL0Latency
        BGM_LTRMaxSnoopLatencyValue BGM_LTRMaxNoSnoopLatencyValue) do (reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "%%a" /t REG_DWORD /d "1" /f >nul 2>nul
)
timeout /t 1 /nobreak >nul 2>nul

cls
echo Finished Performance Optimizations
timeout /t 3 /nobreak >nul 2>nul
goto menuexit

:IGPU

cls
:: Dedicated Segment Size
echo Set Dedicated Segment Size
reg add "HKLM\SOFTWARE\Intel\GMM" /v "DedicatedSegmentSize" /t REG_DWORD /d "512" /f >nul 2>nul
timeout /t 1 /nobreak >nul 2>nul

cls
echo Finished Performance Optimizations
timeout /t 3 /nobreak >nul 2>nul
goto menuexit

::════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
:Option3
cls

echo Completed
timeout /t 2 /nobreak > NUL
goto menuexit

::════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
:Option4
cls

echo Completed
timeout /t 2 /nobreak > NUL
goto menuexit

::════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
:PowerPlan
cls
echo Importing Bitsum Highest Performance Power Plan
timeout /t 1 /nobreak >nul 2>nul

:: Import GetRegged Power Plan
curl -g -k -L -# -o "%temp%\Bitsum-Highest-Performance.pow" "https://github.com/GetRegged/GetRegged-Performance-Batch/raw/main/bin/Bitsum-Highest-Performance.pow" >nul 2>nul
powercfg -import "%temp%\Bitsum-Highest-Performance.pow" 11111111-1111-1111-1111-111111111111 >nul 2>nul
powercfg -setactive 11111111-1111-1111-1111-111111111111 >nul 2>nul

cls
echo Completed
timeout /t 2 /nobreak > NUL

cls
set c=[94m
set t=[0m
set w=[31m
set y=[0m
set u=[4m
set q=[0m
echo.
echo.
echo.
echo.
echo                       %w%██████%y%%c%╗%y% %w%███████%y%%c%╗%y%%w%████████%y%%c%╗%y%    %w%██████%y%%c%╗%y% %w%███████%y%%c%╗%y% %w%██████%y%%c%╗%y%  %w%██████%y%%c%╗%y% %w%███████%y%%c%╗%y%%w%██████%y%%c%╗%y% 
echo                      %w%██%y%%c%╔════╝%y% %w%██%y%%c%╔════╝%y%%c%╚══%y%%w%██%y%%c%╔══╝%y%    %w%██%y%%c%╔══%y%%w%██%y%%c%╗%y%%w%██%y%%c%╔════╝%y%%w%██%y%%c%╔════╝%y% %w%██%y%%c%╔════╝%y% %w%██%y%%c%╔════╝%y%%w%██%y%%c%╔══%y%%w%██%y%%c%╗%y%  
echo                      %w%██%y%%c%║%y%  %w%███%c%╗%y%%w%█████%y%%c%╗%y%     %w%██%y%%c%║%y%       %w%██████%y%%c%╔╝%y%%w%█████%y%%c%╗%y%  %w%██%y%%c%║%y%  %w%███%c%╗%y%%w%██%y%%c%║%y%  %w%███%c%╗%y%%w%█████%y%%c%╗%y%  %w%██%y%%c%║  %y%%w%██%y%%c%║%y% 
echo                      %w%██%y%%c%║%y%   %w%██%y%%c%║%y%%w%██%y%%c%╔══╝%y%     %w%██%y%%c%║%y%       %w%██%y%%c%╔══%y%%w%██%y%%c%╗%y%%w%██%y%%c%╔══╝%y%  %w%██%y%%c%║%y%   %w%██%y%%c%║%y%%w%██%y%%c%║%y%   %w%██%y%%c%║%y%%w%██%y%%c%╔══╝%y%  %w%██%y%%c%║  %y%%w%██%y%%c%║%y%     
echo                      %c%╚%y%%w%██████%y%%c%╔╝%y%%w%███████%y%%c%╗%y%   %w%██%y%%c%║%y%       %w%██%y%%c%║  %y%%w%██%y%%c%║%y%%w%███████%y%%c%╗%y%%c%╚%y%%w%██████%y%%c%╔╝%y%%c%╚%y%%w%██████%y%%c%╔╝%y%%w%███████%y%%c%╗%y%%w%██████%y%%c%╔╝%y%
echo                       %c%╚═════╝%y% %c%╚══════╝%y%   %c%╚═╝%y%       %c%╚═╝  ╚═╝%y%%c%╚══════╝%y% %c%╚═════╝%y%  %c%╚═════╝%y% %c%╚══════╝%y%%c%╚═════╝%y%          
echo                                                       %c%%u%Version: %Version%%q%%t%
echo.
echo.
echo %w%════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════%y%
echo.
echo.
echo.
echo.
echo                                          Do you want to delete all other plans?
echo.
echo.
echo                                              %w%[%y% %c%%u%1%q%%t% %w%]%y% %c%Yes%t%               %w%[%y% %c%%u%2%q%%t% %w%]%y% %c%No%t%
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
set choice=
set /p choice=
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto DeletePlans
if '%choice%'=='2' goto menuexit

:DeletePlans
cls
echo Deleting other power plans
timeout /t 2 /nobreak > NUL

:: Delete Balanced Power Plan
powercfg -delete 381b4222-f694-41f0-9685-ff5bb260df2e >nul 2>nul

:: Delete Power Saver Power Plan
powercfg -delete a1841308-3541-4fab-bc81-f71556f20b4a >nul 2>nul

:: Delete High Performance Power Plan
powercfg -delete 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>nul

:: Delete Ultimate Performance Power Plan
powercfg -delete e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>nul

:: Delete AMD Ryzen Balanced Power Plan
powercfg -delete 9897998c-92de-4669-853f-b7cd3ecb2790 >nul 2>nul


cls
echo Completed 
timeout /t 2 /nobreak > NUL

goto menuexit

::════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
:TempTamer
cls
echo Cleaning IP cache

:: Zurücksetzen und Löschen des IP-Caches
ipconfig /flushdns >nul 2>nul
ipconfig /release >nul 2>nul
ipconfig /renew >nul 2>nul
netsh int ip reset >nul 2>nul
netsh int ipv4 reset >nul 2>nul
netsh int ipv6 reset >nul 2>nul
netsh int tcp reset >nul 2>nul
netsh winsock reset >nul 2>nul
netsh branchcache reset >nul 2>nul
netsh http flush logbuffer >nul 2>nul

echo Cleaning temporary files
timeout /t 2 /nobreak > NUL

:: Löschen von Cache und temporären Dateien
del /s /f /q "%AppData%\Discord\Cache" >nul 2>nul
del /s /f /q "%AppData%\Discord\Code Cache" >nul 2>nul
del /s /f /q "%LocalAppData%\Google\Chrome\User Data\Default\Cache" >nul 2>nul
del /s /f /q "%LocalAppData%\Microsoft\Windows\Explorer\*.db" >nul 2>nul
del /s /f /q "%LocalAppData%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>nul
del /s /f /q "%LocalAppData%\Microsoft\Windows\INetCache" >nul 2>nul
del /s /f /q "%LocalAppData%\Microsoft\Windows\INetCookies" >nul 2>nul
del /s /f /q "%LocalAppData%\Microsoft\Windows\WebCache" >nul 2>nul
del /s /f /q "%ProgramData%\Microsoft\Windows\Installer" >nul 2>nul
del /s /f /q "%ProgramData%\USOPrivate\UpdateStore" >nul 2>nul
del /s /f /q "%ProgramData%\USOShared\Logs" >nul 2>nul
del /s /f /q "%systemdrive%\$Recycle.Bin" >nul 2>nul
del /s /f /q "%temp%" >nul 2>nul
del /s /f /q "%windir%\Installer\$PatchCache$" >nul 2>nul
del /s /f /q "%windir%\Logs" >nul 2>nul
del /s /f /q "%windir%\Prefetch" >nul 2>nul
del /s /f /q "%windir%\ServiceProfiles\NetworkService\AppData\Local\Microsoft\Windows\DeliveryOptimization" >nul 2>nul
del /s /f /q "%windir%\SoftwareDistribution\Download" >nul 2>nul
del /s /f /q "%windir%\System32\SleepStudy" >nul 2>nul
del /s /f /q "%windir%\temp" >nul 2>nul

echo Cleaning temporary folders
timeout /t 2 /nobreak > NUL

:: Löschen von temporären Systemordnern
rd /s /q "%SystemDrive%\$GetCurrent" >nul 2>nul
rd /s /q "%SystemDrive%\$SysReset" >nul 2>nul
rd /s /q "%SystemDrive%\$WinREAgent" >nul 2>nul
rd /s /q "%SystemDrive%\$Windows.~BT" >nul 2>nul
rd /s /q "%SystemDrive%\$Windows.~WS" >nul 2>nul
rd /s /q "%SystemDrive%\Intel" >nul 2>nul
rd /s /q "%SystemDrive%\AMD" >nul 2>nul
rd /s /q "%SystemDrive%\OneDriveTemp" >nul 2>nul
rd /s /q "%SystemDrive%\System Volume Information" >nul 2>nul

FOR /F "tokens=1,2*" %%V IN ('bcdedit') DO SET adminTest=%%V
IF (%adminTest%)==(Access) goto noAdmin
for /F "tokens=*" %%G in ('wevtutil.exe el') DO (call :do_clear "%%G")

:do_clear
wevtutil.exe cl %1
goto :end

:noAdmin
goto :end

:end

cls
echo Completed
timeout /t 2 /nobreak > NUL

goto menuexit

::════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
:Option6
cls

echo Completed
timeout /t 2 /nobreak > NUL
goto menuexit

::════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
:menuexit
cls
set c=[94m
set t=[0m
set w=[31m
set y=[0m
set u=[4m
set q=[0m
echo.
echo.
echo.
echo.
echo                       %w%██████%y%%c%╗%y% %w%███████%y%%c%╗%y%%w%████████%y%%c%╗%y%    %w%██████%y%%c%╗%y% %w%███████%y%%c%╗%y% %w%██████%y%%c%╗%y%  %w%██████%y%%c%╗%y% %w%███████%y%%c%╗%y%%w%██████%y%%c%╗%y% 
echo                      %w%██%y%%c%╔════╝%y% %w%██%y%%c%╔════╝%y%%c%╚══%y%%w%██%y%%c%╔══╝%y%    %w%██%y%%c%╔══%y%%w%██%y%%c%╗%y%%w%██%y%%c%╔════╝%y%%w%██%y%%c%╔════╝%y% %w%██%y%%c%╔════╝%y% %w%██%y%%c%╔════╝%y%%w%██%y%%c%╔══%y%%w%██%y%%c%╗%y%  
echo                      %w%██%y%%c%║%y%  %w%███%c%╗%y%%w%█████%y%%c%╗%y%     %w%██%y%%c%║%y%       %w%██████%y%%c%╔╝%y%%w%█████%y%%c%╗%y%  %w%██%y%%c%║%y%  %w%███%c%╗%y%%w%██%y%%c%║%y%  %w%███%c%╗%y%%w%█████%y%%c%╗%y%  %w%██%y%%c%║  %y%%w%██%y%%c%║%y% 
echo                      %w%██%y%%c%║%y%   %w%██%y%%c%║%y%%w%██%y%%c%╔══╝%y%     %w%██%y%%c%║%y%       %w%██%y%%c%╔══%y%%w%██%y%%c%╗%y%%w%██%y%%c%╔══╝%y%  %w%██%y%%c%║%y%   %w%██%y%%c%║%y%%w%██%y%%c%║%y%   %w%██%y%%c%║%y%%w%██%y%%c%╔══╝%y%  %w%██%y%%c%║  %y%%w%██%y%%c%║%y%     
echo                      %c%╚%y%%w%██████%y%%c%╔╝%y%%w%███████%y%%c%╗%y%   %w%██%y%%c%║%y%       %w%██%y%%c%║  %y%%w%██%y%%c%║%y%%w%███████%y%%c%╗%y%%c%╚%y%%w%██████%y%%c%╔╝%y%%c%╚%y%%w%██████%y%%c%╔╝%y%%w%███████%y%%c%╗%y%%w%██████%y%%c%╔╝%y%
echo                       %c%╚═════╝%y% %c%╚══════╝%y%   %c%╚═╝%y%       %c%╚═╝  ╚═╝%y%%c%╚══════╝%y% %c%╚═════╝%y%  %c%╚═════╝%y% %c%╚══════╝%y%%c%╚═════╝%y%          
echo                                                       %c%%u%Version: %Version%%q%%t%
echo.
echo.
echo %w%════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════%y%
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo                                              %w%[%y% %c%%u%1%q%%t% %w%]%y% %c%Menu%t%               %w%[%y% %c%%u%2%q%%t% %w%]%y% %c%Exit%t%
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
set choice=
set /p choice=
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto Menu
if '%choice%'=='2' goto Exit

:Exit
cls 
exit
