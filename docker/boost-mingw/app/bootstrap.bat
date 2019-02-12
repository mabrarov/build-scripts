@echo off

rem
rem Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
rem
rem Distributed under the MIT License (see accompanying LICENSE)
rem

set PATH=%PATH%;%MINGW_HOME%\bin
if errorlevel 1 goto exit

call "%BOOST_BOOTSTRAP%" gcc

:exit