@echo off

REM
REM Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
REM
REM Distributed under the Boost Software License, Version 1.0. (See accompanying
REM file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
REM

set PATH=%PATH%;%MINGW_HOME%\bin
if errorlevel 1 goto exit

"%B2_BIN%" -j2 --toolset=%B2_TOOLSET% address-model=%BOOST_ADDRESS_MODEL% debug release link=%BOOST_LINKAGE% runtime-link=%BOOST_RUNTIME_LINKAGE% threading=multi install --prefix="%BOOST_INSTALL_DIR%" %*

:exit