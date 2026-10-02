@echo off
setlocal ENABLEDELAYEDEXPANSION
:: this is the window title, feel free to change it, i personally have mine set to "Server Yuri"
title Context
:: Wowwww customisable stuff yayyyyy
::This is the default display name for the user, you can change it so you dont need to enter your name every time you connect to sum
set "DISPLAYNAME=User"

::Server stuffs
:: This is the end of what is currently customisable.
:: This is where the stuff starts i guess >-<
:homepage
echo =================
echo ==== Context ====
echo =================
echo Context 0.0.1 ^| Made by Mika
echo Welcome to %title%, remember that this is a work in progress and is prone to breaking.
echo 1. Connect to a server through IP
echo 2. Connect to a saved server
echo 3. Preview your messages
echo 4. Help and info
set /p menuchoice="Enter your choice (1-4): "
echo %menuchoice%

if "%menuchoice%"=="1" goto connect
if "%menuchoice%"=="2" goto advanced
if "%menuchoice%"=="3" goto preview
if "%menuchoice%"=="4" goto info

:: connection
:connect
set /p name="Enter display name or leave blank for default: "
if NOT "%name%"=="" (
    set DISPLAYNAME=%name%
)
set /p IP="Enter server IP or back to go back: "
echo IP: %IP%
if "%IP%"=="back" goto homepage
set /p PORT="Enter server port or back to go back: "
echo Port: %PORT%
if "%PORT%"=="back" goto homepage
set /p save="Save server? (y/n): "
if "%save%"=="y" goto saver
if "%save%"=="n" goto chat

:advanced
:: i'll do this later but it should grab all the saved servers from a text file and list them to be selected from.

:preview 
echo Preview message:
echo ^<%DISPLAYNAME%^>: So  i just scratched my balls and like...
pause
cls
goto homepage

:chat
echo Joined chat. type /getmeout to exit.
echo.
powershell -NoLogo -NoProfile -File "client.ps1" -ServerIp "%IP%" -ServerPort %PORT% -DisplayName "%DISPLAYNAME%"
echo Exiting chat...
cls
goto homepage