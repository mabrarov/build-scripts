@echo off

rem
rem Copyright (c) 2022 Marat Abrarov (abrarov@gmail.com)
rem
rem Distributed under the MIT License (see accompanying LICENSE)
rem

set exit_code=0

if not "--%BOOST_PATCH_FILE%" == "--" (
  setlocal
  set "PATH=%MSYS_HOME%\usr\bin;%PATH%"

  patch -uNf -p0 -i "%BOOST_PATCH_FILE%"
  set exit_code=%errorlevel%
  if %exit_code% neq 0 (
    if %exit_code% neq 1 (
      endlocal
      goto exit
    )
  )

  endlocal

  rem Reset errorlevel to zero
  cmd /c "exit /b 0"
)

call "%MSVC_BUILD_DIR%\%MSVC_CMD_BOOTSTRAP%"
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

call "%BOOST_BOOTSTRAP%"
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

:exit
exit /B %exit_code%
