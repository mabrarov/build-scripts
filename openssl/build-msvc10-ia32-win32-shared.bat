@echo off
rem -------------------------------------
set MSVS2010_DIR=%ProgramFiles(x86)%\Microsoft Visual Studio 10.0
set PERL_DIR=C:\Perl64
set OPENSSL_SRC_DIR=%~dp0openssl-1.0.2h
set OPENSSL_INSTALL_DIR=%~dp0..\openssl-1.0.2h-x86-vs2010-shared
rem -------------------------------------

echo Microsoft Visual Studio 2010 directory: %MSVS2010_DIR%
echo Perl directory           : %PERL_DIR%
echo OpenSSL source directory : %OPENSSL_SRC_DIR%
echo OpenSSL install directory: %OPENSSL_INSTALL_DIR%

call "%MSVS2010_DIR%\VC\vcvarsall.bat" x86
if errorlevel 1 goto error_exit

set PATH=%PATH%;%PERL_DIR%\bin

echo Changing current directory to the OpenSSL source one...
cd /d "%OPENSSL_SRC_DIR%"

echo Building release shared version...
perl "%OPENSSL_SRC_DIR%\Configure" VC-WIN32 no-asm --prefix="%OPENSSL_INSTALL_DIR%"
if errorlevel 1 goto error_exit

call "%OPENSSL_SRC_DIR%\ms\do_ms.bat"
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
