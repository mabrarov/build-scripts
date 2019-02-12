@echo off

rem
rem Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
rem
rem Distributed under the MIT License (see accompanying LICENSE)
rem

call "%MSVC_BUILD_DIR%\%MSVC_CMD_BOOTSTRAP%"
if errorlevel 1 goto exit

call "%BOOST_BOOTSTRAP%"

:exit