@echo off

rem
rem Copyright (c) 2019 Marat Abrarov (abrarov@gmail.com)
rem
rem Distributed under the MIT License (see accompanying LICENSE)
rem

set PATH=%MSYS_HOME%\usr\bin;%PATH%

set exit_code=0

echo Initializing MSYS2
call "%MSYS_HOME%\msys2_shell.cmd" -no-start -defterm -c exit
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

echo Installing pacman base-devel package group (MSYS2 development tools)
pacman -S --needed --noconfirm base-devel
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

:exit
exit /B %exit_code%
