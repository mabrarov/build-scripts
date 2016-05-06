@echo off

rem -------------------------------------
set VS2008_DIR=%ProgramFiles%\Microsoft Visual Studio 9.0
rem -------------------------------------

rem -------------------------------------
echo Microsoft Visual Studio 2008 directory: %VS2008_DIR%
rem -------------------------------------

rem -------------------------------------
call "%VS2008_DIR%\VC\vcvarsall.bat" x86
if errorlevel 1 goto error_exit
rem -------------------------------------

rem -------------------------------------
set BOOST_ROOT_DIR=%~dp0
set B2_BIN=%~dp0b2.exe
set INSTALL_DIR=%~dp0..\boost-1.60.0-x86-vs2008
rem -------------------------------------

rem -------------------------------------
echo Boost root directory    : %BOOST_ROOT_DIR%
echo Boost.Build executable  : %B2_BIN%
echo Install directory       : %INSTALL_DIR%
rem -------------------------------------

cd /d "%BOOST_ROOT_DIR%"
"%B2_BIN%" -j2 --toolset=msvc-9.0 debug release link=static runtime-link=static threading=multi install --prefix="%INSTALL_DIR%"
if errorlevel 1 goto error_exit

"%B2_BIN%" -j2 --toolset=msvc-9.0 debug release link=static runtime-link=shared threading=multi install --prefix="%INSTALL_DIR%"
if errorlevel 1 goto error_exit

"%B2_BIN%" -j2 --toolset=msvc-9.0 debug release link=shared threading=multi install --prefix="%INSTALL_DIR%"
if errorlevel 1 goto error_exit

goto exit

:error_exit

echo Failed to build!
goto exit

:exit