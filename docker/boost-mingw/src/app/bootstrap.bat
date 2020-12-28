@echo off

rem
rem Copyright (c) 2017 Marat Abrarov (abrarov@gmail.com)
rem
rem Distributed under the MIT License (see accompanying LICENSE)
rem

set exit_code=0

if not "--%BOOST_PATCH_MSYS_FILE%" == "--" (
  set DEFAULT_PATH=%PATH%
  set exit_code=%errorlevel%
  if %exit_code% neq 0 goto exit

  set PATH=%MSYS_HOME%\usr\bin;%PATH%
  set exit_code=%errorlevel%
  if %exit_code% neq 0 goto exit

  patch -uNf -p0 -i "%BOOST_PATCH_MSYS_FILE%"
  set exit_code=%errorlevel%
  if %exit_code% neq 0 (
    if %exit_code% neq 1 goto exit
  )

  set PATH=%DEFAULT_PATH%
  set exit_code=%errorlevel%
  if %exit_code% neq 0 goto exit
)

set PATH=%MINGW_HOME%\bin;%PATH%
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

call "%BOOST_BOOTSTRAP%" gcc
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

:exit
exit /B %exit_code%
