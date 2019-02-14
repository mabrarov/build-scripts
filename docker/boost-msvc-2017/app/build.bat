@echo off

rem
rem Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
rem
rem Distributed under the MIT License (see accompanying LICENSE)
rem

set exit_code=0

call "%MSVC_BUILD_DIR%\%MSVC_CMD_BOOTSTRAP%"
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

"%B2_BIN%" --toolset=%B2_TOOLSET% address-model=%BOOST_ADDRESS_MODEL% debug release link=%BOOST_LINKAGE% runtime-link=%BOOST_RUNTIME_LINKAGE% threading=multi install --prefix="%BOOST_INSTALL_DIR%" --without-python --without-mpi
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

:exit
exit /B %exit_code%