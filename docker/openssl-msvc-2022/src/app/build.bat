@echo off

rem
rem Copyright (c) 2025 Marat Abrarov (abrarov@gmail.com)
rem
rem Distributed under the MIT License (see accompanying LICENSE)
rem

set exit_code=0

set "PATH=%STRAWBERRY_PERL_HOME%\perl\bin;%PATH%"

call "%MSVC_BUILD_DIR%\%MSVC_CMD_BOOTSTRAP%"
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

if not "--%OPENSSL_PATCH_FILE%" == "--" (
  "%MSYS_HOME%\usr\bin\patch.exe" -uNf -p0 -i "%OPENSSL_PATCH_FILE%"
  set exit_code=%errorlevel%
  if %exit_code% neq 0 goto exit
)

perl Configure --prefix="%OPENSSL_STAGE_DIR%" "%OPENSSL_TOOLSET%" enable-static-engine no-asm
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

perl util\mkfiles.pl > MINFO
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

if /i "%OPENSSL_ADDRESS_MODEL%" == "32" (
  perl util\mk1mf.pl %OPENSSL_DLL_STR% %OPENSSL_BUILD_STR_PLAIN% %OPENSSL_BUILD_STR% %OPENSSL_LINK_STR% no-asm "%OPENSSL_BASE_TOOLSET%" > "ms\nt%OPENSSL_DLL_STR%-%OPENSSL_ARCH%.mak"
  set exit_code=%errorlevel%
  if %exit_code% neq 0 goto exit
) else (
  perl ms\uplink-x86_64.pl masm > ms\uptable.asm
  set exit_code=%errorlevel%
  if %exit_code% neq 0 goto exit

  ml64 -c -Foms\uptable.obj ms\uptable.asm
  set exit_code=%errorlevel%
  if %exit_code% neq 0 goto exit

  perl util\mk1mf.pl %OPENSSL_DLL_STR% %OPENSSL_BUILD_STR_PLAIN% %OPENSSL_BUILD_STR% %OPENSSL_LINK_STR% "%OPENSSL_BASE_TOOLSET%" > "ms\nt%OPENSSL_DLL_STR%-%OPENSSL_ARCH%.mak"
  set exit_code=%errorlevel%
  if %exit_code% neq 0 goto exit
)

perl util\mkdef.pl %OPENSSL_BUILD_STR% %OPENSSL_LINK_STR% 32 libeay > "ms\libeay32%OPENSSL_RUNTIME_FULL_SUFFIX%.def"
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

perl util\mkdef.pl %OPENSSL_BUILD_STR% %OPENSSL_LINK_STR% 32 ssleay > "ms\ssleay32%OPENSSL_RUNTIME_FULL_SUFFIX%.def"
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

set "make_file=%OPENSSL_HOME%\ms\nt%OPENSSL_DLL_STR%-%OPENSSL_ARCH%.mak"

nmake -f "%make_file%"
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

if not "--%OPENSSL_TEST%" == "--" (
  nmake -f "%make_file%" test
  set exit_code=%errorlevel%
  if %exit_code% neq 0 goto exit
)

nmake -f "%make_file%" install
set exit_code=%errorlevel%
if %exit_code% neq 0 goto exit

:exit
exit /B %exit_code%
