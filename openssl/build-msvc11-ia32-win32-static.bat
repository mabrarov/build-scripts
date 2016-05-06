@echo off
rem -------------------------------------
set MSVS2012_DIR=%ProgramFiles(x86)%\Microsoft Visual Studio 11.0
set PERL_DIR=C:\Program Files\Perl
set OPENSSL_SRC_DIR=%~dp0openssl-1.0.2h
set OPENSSL_INSTALL_DIR=%~dp0..\openssl-1.0.2h-x86-vs2012-static
set OPENSSL_INSTALL_LIB_DIR=%OPENSSL_INSTALL_DIR%\lib
rem -------------------------------------

echo Microsoft Visual Studio 2012 directory: %MSVS2012_DIR%
echo Perl directory           : %PERL_DIR%
echo OpenSSL source directory : %OPENSSL_SRC_DIR%
echo OpenSSL install directory: %OPENSSL_INSTALL_DIR%

call "%MSVS2012_DIR%\VC\vcvarsall.bat" x86
if errorlevel 1 goto error_exit

set PATH=%PATH%;%PERL_DIR%\bin
set LIBEAY_NAME=libeay32
set SSLEAY_NAME=ssleay32

echo Changing current directory to the OpenSSL source one...
cd /d "%OPENSSL_SRC_DIR%"

echo Building debug static version...
perl "%OPENSSL_SRC_DIR%\Configure" debug-VC-WIN32 enable-static-engine no-asm no-shared --prefix="%OPENSSL_INSTALL_DIR%"
if errorlevel 1 goto error_exit
call "%OPENSSL_SRC_DIR%\ms\do_ms.bat"
if errorlevel 1 goto error_exit
nmake -f "%OPENSSL_SRC_DIR%\ms\nt.mak" install
if errorlevel 1 goto error_exit
nmake -f "%OPENSSL_SRC_DIR%\ms\nt.mak" clean
if errorlevel 1 goto error_exit
echo Renaming debug version of libraries...
rename "%OPENSSL_INSTALL_LIB_DIR%\%LIBEAY_NAME%.lib" "%LIBEAY_NAME%d.lib"
if errorlevel 1 goto error_exit
rename "%OPENSSL_INSTALL_LIB_DIR%\%SSLEAY_NAME%.lib" "%SSLEAY_NAME%d.lib"
if errorlevel 1 goto error_exit

echo Building release static version...
perl "%OPENSSL_SRC_DIR%\Configure" VC-WIN32 enable-static-engine no-asm no-shared --prefix="%OPENSSL_INSTALL_DIR%"
if errorlevel 1 goto error_exit
call "%OPENSSL_SRC_DIR%\ms\do_ms.bat"
if errorlevel 1 goto error_exit
nmake -f "%OPENSSL_SRC_DIR%\ms\nt.mak" install
if errorlevel 1 goto error_exit
nmake -f "%OPENSSL_SRC_DIR%\ms\nt.mak" clean
if errorlevel 1 goto error_exit

goto exit

:error_exit

echo Failed to build
goto exit

:exit
