@echo off

rem
rem Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
rem
rem Distributed under the MIT License (see accompanying LICENSE)
rem

set exit_code=0

set PATH=%PATH%;%MINGW_HOME%\bin
exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

call "%BOOST_BOOTSTRAP%" gcc
exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

:exit
exit /B %exit_code%