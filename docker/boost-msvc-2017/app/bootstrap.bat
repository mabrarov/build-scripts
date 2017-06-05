@echo off

REM
REM Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
REM
REM Distributed under the Boost Software License, Version 1.0. (See accompanying
REM file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
REM

call "%MSVC_BUILD_DIR%\%MSVC_CMD_BOOTSTRAP%"
if errorlevel 1 goto exit

call "%BOOST_BOOTSTRAP%"

:exit