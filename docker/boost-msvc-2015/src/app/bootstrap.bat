@echo off

rem
rem Copyright (c) 2019 Marat Abrarov (abrarov@gmail.com)
rem
rem Distributed under the MIT License (see accompanying LICENSE)
rem

set exit_code=0

call "%MSVC_BUILD_DIR%\%MSVC_CMD_BOOTSTRAP%" %MSVC_CMD_BOOTSTRAP_OPTIONS%
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

call "%BOOST_BOOTSTRAP%"
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

:exit
exit /B %exit_code%
