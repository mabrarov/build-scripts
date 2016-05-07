@echo off
rem -------------------------------------
set MSVS2013_DIR=%ProgramFiles(x86)%\Microsoft Visual Studio 12.0
set PERL_DIR=C:\Program Files\Perl
set OPENSSL_SRC_DIR=%~dp0openssl-1.0.2h
set OPENSSL_INSTALL_DIR=%~dp0..\openssl-1.0.2h-x64-vs2013-shared
rem -------------------------------------

echo Microsoft Visual Studio 2013 directory: %MSVS2013_DIR%
echo Perl directory           : %PERL_DIR%
echo OpenSSL source directory : %OPENSSL_SRC_DIR%
echo OpenSSL install directory: %OPENSSL_INSTALL_DIR%

call "%MSVS2013_DIR%\VC\vcvarsall.bat" amd64
if errorlevel 1 goto error_exit

set PATH=%PATH%;%PERL_DIR%\bin

echo Changing current directory to the OpenSSL source one...
cd /d "%OPENSSL_SRC_DIR%"

echo Building release shared version...
perl "%OPENSSL_SRC_DIR%\Configure" VC-WIN64A no-asm --prefix="%OPENSSL_INSTALL_DIR%"
if errorlevel 1 goto error_exit

call "%OPENSSL_SRC_DIR%\ms\do_win64a.bat"
if errorlevel 1 goto error_exit

nmake -f "%OPENSSL_SRC_DIR%\ms\ntdll.mak" install
if errorlevel 1 goto error_exit

nmake -f "%OPENSSL_SRC_DIR%\ms\ntdll.mak" clean
if errorlevel 1 goto error_exit

goto exit

:error_exit

echo Failed to build
goto exit

:exit
