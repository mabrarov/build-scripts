@echo off
rem -------------------------------------
set MSVS2010_DIR=%ProgramFiles(x86)%\Microsoft Visual Studio 10.0
set OPENSSL_DIR=%~dp0..\openssl-1.0.2h-x64-vs2010-shared
set QT_INSTALL_DIR=%~dp0..\qt-4.8.7-x64-vs2010-shared
rem -------------------------------------

set QTDIR=%~dp0qt-4.8.7

echo Microsoft Visual Studio 2010 directory: %MSVS2010_DIR%
echo OpenSSL directory   : %OPENSSL_DIR%
echo Qt sources directory: %QTDIR%
echo Qt install directory: %QT_INSTALL_DIR%

call "%MSVS2010_DIR%\VC\vcvarsall.bat" amd64
if errorlevel 1 goto error_exit

set PATH=%QTDIR%\bin;%OPENSSL_DIR%\bin;%QT_INSTALL_DIR%\bin;%PATH%

rem nmake /f "%~dp0%Makefile" distclean
rem if errorlevel 1 goto error_exit

rem cd /d "%QTDIR%"

"%QTDIR%\configure.exe" -platform win32-msvc2010 -debug-and-release -shared -opensource -confirm-license ^
-webkit -openssl ^
-qt-style-windowsxp -qt-style-windowsvista ^
-qt-zlib -qt-libpng -qt-libtiff -qt-libjpeg -qt-libmng -qt-sql-sqlite -no-qt3support ^
-nomake demos -nomake examples ^
-I "%OPENSSL_DIR%\include" -L "%OPENSSL_DIR%\lib" ^
-no-vcproj ^
-prefix "%QT_INSTALL_DIR%"
if errorlevel 1 goto error_exit


nmake /f "%QTDIR%\Makefile"
if errorlevel 1 goto error_exit

nmake /f "%QTDIR%\Makefile" install
if errorlevel 1 goto error_exit

nmake /f "%QTDIR%\Makefile" clean
if errorlevel 1 goto error_exit

goto exit

:error_exit

echo Failed to build
goto exit

:exit
