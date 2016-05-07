@echo off

rem -------------------------------------
set INTEL_COMPILER_DIR=%ProgramFiles(x86)%\IntelSWTools\compilers_and_libraries
rem -------------------------------------

rem -------------------------------------
echo Intel Parallel Studio XE 2016 directory: %INTEL_COMPILER_DIR%
rem -------------------------------------

rem -------------------------------------
call "%INTEL_COMPILER_DIR%\windows\bin\ipsxe-comp-vars.bat" intel64 vs2015
if errorlevel 1 goto error_exit
rem -------------------------------------

rem -------------------------------------
set BOOST_ROOT_DIR=%~dp0
set B2_BIN=%~dp0b2.exe
set INSTALL_DIR=%~dp0..\boost-1.60.0-x64-intel2016
rem -------------------------------------

rem -------------------------------------
echo Boost root directory    : %BOOST_ROOT_DIR%
echo Boost.Build executable  : %B2_BIN%
echo Install directory       : %INSTALL_DIR%
rem -------------------------------------

cd /d "%BOOST_ROOT_DIR%"
"%B2_BIN%" -j2 --toolset=intel-16.0-vc14 cxxflags="/Qstd=c++11" address-model=64 debug release link=static runtime-link=static threading=multi install --prefix="%INSTALL_DIR%"
if errorlevel 1 goto error_exit

"%B2_BIN%" -j2 --toolset=intel-16.0-vc14 cxxflags="/Qstd=c++11" address-model=64 debug release link=static runtime-link=shared threading=multi install --prefix="%INSTALL_DIR%"
if errorlevel 1 goto error_exit

"%B2_BIN%" -j2 --toolset=intel-16.0-vc14 cxxflags="/Qstd=c++11" address-model=64 debug release link=shared threading=multi install --prefix="%INSTALL_DIR%"
if errorlevel 1 goto error_exit

goto exit

:error_exit

echo Failed to build!
goto exit

:exit