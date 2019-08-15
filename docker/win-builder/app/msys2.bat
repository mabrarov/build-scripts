@echo off

rem
rem Copyright (c) 2019 Marat Abrarov (abrarov@gmail.com)
rem
rem Distributed under the MIT License (see accompanying LICENSE)
rem

set PATH=%MSYS_HOME%\usr\bin;%PATH%

echo Installing pacman base-devel package group (MSYS2 development tools)
pacman -S --needed --noconfirm base-devel
exit /B %errorlevel%
