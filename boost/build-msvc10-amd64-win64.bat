@echo off

rem -------------------------------------
set VS2010_DIR=%ProgramFiles%\Microsoft Visual Studio 10.0
rem -------------------------------------

rem -------------------------------------
echo Microsoft Visual Studio 2010 directory: %VS2010_DIR%
rem -------------------------------------

rem -------------------------------------
call "%VS2010_DIR%\VC\vcvarsall.bat" x86_amd64
if errorlevel 1 goto exit
rem -------------------------------------

rem -------------------------------------
set BOOST_ROOT_DIR=%~dp0
set B2_BIN=%~dp0b2.exe
set INSTALL_DIR=%~dp0..\boost-1.60.0-x64-vs2010
rem -------------------------------------

rem -------------------------------------
echo Boost root directory    : %BOOST_ROOT_DIR%
echo Boost.Build executable  : %B2_BIN%
echo Install directory       : %INSTALL_DIR%
rem -------------------------------------

cd /d "%BOOST_ROOT_DIR%"
"%B2_BIN%" -j2 --toolset=msvc-10.0 address-model=64 debug release link=static runtime-link=static threading=multi install --prefix="%INSTALL_DIR%"
"%B2_BIN%" -j2 --toolset=msvc-10.0 address-model=64 debug release link=static runtime-link=shared threading=multi install --prefix="%INSTALL_DIR%"
"%B2_BIN%" -j2 --toolset=msvc-10.0 address-model=64 debug release link=shared threading=multi install --prefix="%INSTALL_DIR%"

:exit