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

set PATH=%PATH%;%MSYS_HOME%\usr\bin
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

if not "--%OPENSSL_PATCH_MSYS_FILE%" == "--" (
  patch --binary -uNf -p1 -i "%OPENSSL_PATCH_MSYS_FILE%"
  set exit_code=%errorlevel%
  if %exit_code% neq 0 goto exit
)

if "%OPENSSL_LINKAGE%" == "shared" (
  perl Configure --prefix=%OPENSSL_STAGE_DIR% %OPENSSL_TOOLSET% no-asm
  set exit_code=%errorlevel%
  if %exit_code% neq 0 goto exit
) else (
  perl Configure --prefix=%OPENSSL_STAGE_DIR% %OPENSSL_TOOLSET% enable-static-engine no-asm no-shared
  set exit_code=%errorlevel%
  if %exit_code% neq 0 goto exit
)

perl util\mkfiles.pl >MINFO
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

if /i "%OPENSSL_ADDRESS_MODEL%" == "32" (
  perl util\mk1mf.pl %OPENSSL_DLL_STR% %OPENSSL_BUILD_STR_PLAIN% %OPENSSL_BUILD_STR% %OPENSSL_LINK_STR% nasm VC-WIN32 >ms\nt%OPENSSL_DLL_STR%-%OPENSSL_ARCH%.mak
  set exit_code=%errorlevel%
  if %exit_code% neq 0 goto exit
) else (
  perl ms\uplink-x86_64.pl masm > ms\uptable.asm
  set exit_code=%errorlevel%
  if %exit_code% neq 0 goto exit

  ml64 -c -Foms\uptable.obj ms\uptable.asm
  set exit_code=%errorlevel%
  if %exit_code% neq 0 goto exit

  perl util\mk1mf.pl %OPENSSL_DLL_STR% %OPENSSL_BUILD_STR_PLAIN% %OPENSSL_BUILD_STR% %OPENSSL_LINK_STR% VC-WIN64A >ms\nt%OPENSSL_DLL_STR%-%OPENSSL_ARCH%.mak
  set exit_code=%errorlevel%
  if %exit_code% neq 0 goto exit
)

perl util\mkdef.pl %OPENSSL_BUILD_STR% %OPENSSL_LINK_STR% 32 libeay > ms\libeay32%OPENSSL_RUNTIME_FULL_SUFFIX%.def
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

perl util\mkdef.pl %OPENSSL_BUILD_STR% %OPENSSL_LINK_STR% 32 ssleay > ms\ssleay32%OPENSSL_RUNTIME_FULL_SUFFIX%.def
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

nmake -f "%OPENSSL_HOME%\ms\nt%OPENSSL_DLL_STR%-%OPENSSL_ARCH%.mak" install
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

:exit
exit /B %exit_code%