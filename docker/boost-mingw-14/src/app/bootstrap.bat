@echo off

rem
rem Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
rem
rem Distributed under the MIT License (see accompanying LICENSE)
rem

set exit_code=0

set "PATH=%MINGW_HOME%\bin;%PATH%"

call "%BOOST_BOOTSTRAP%" gcc
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

:exit
exit /B %exit_code%
