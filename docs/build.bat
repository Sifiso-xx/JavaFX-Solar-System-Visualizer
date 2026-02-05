REM Mr. A. Maganlal
REM Computer Science 2A 2025
REM Batch file for Practical Assignment 06

@echo off
cls
setlocal enabledelayedexpansion

REM ---- CONFIGURE JAVA PATH ----
set JAVA_HOME="C:\jdk-21"
set PATH=%JAVA_HOME%\bin;%PATH%

REM ---- CONFIGURE JAVAFX PATH ----
set USE_JAVAFX=true
set JAVAFX_HOME="C:\javafx-sdk-21"
set JAVAFX_MODULES=javafx.base,javafx.controls,javafx.fxml,javafx.graphics,javafx.media
set JAVAFX_ARGS=
if %USE_JAVAFX%==true (
    set JAVAFX_ARGS=--module-path %JAVAFX_HOME%\lib --add-modules %JAVAFX_MODULES%
)

echo JavaFX Enabled: %USE_JAVAFX%
echo JavaFX Args: %JAVAFX_ARGS%

set ERRMSG=

:VERSION
echo ~~~ Checking Java Version ~~~
javac -version
IF /I "%ERRORLEVEL%" NEQ "0" (
    set ERRMSG="Error checking javac version"
    GOTO ERROR
)
java -version
IF /I "%ERRORLEVEL%" NEQ "0" (
    set ERRMSG="Error checking java version"
    GOTO ERROR
)

pause

REM ---- CHANGE TO PROJECT ROOT ----
cd ..

REM ---- DIRECTORY VARIABLES ----
set PRAC_BIN=.\bin
set PRAC_DOC=.\docs
set PRAC_JDC=JavaDoc
set PRAC_LIB=.\lib\*
set PRAC_SRC=.\src

:CLEAN
echo ~~~ Cleaning project ~~~
if exist %PRAC_BIN%\ (
    del /S /Q %PRAC_BIN%\*.class
)
if exist %PRAC_DOC%\%PRAC_JDC%\ (
    rmdir /S /Q %PRAC_DOC%\%PRAC_JDC%
)

:COMPILE
echo ~~~ Compiling project ~~~
javac %JAVAFX_ARGS% -sourcepath %PRAC_SRC% -cp %PRAC_BIN%;%PRAC_LIB% -d %PRAC_BIN% %PRAC_SRC%\Main.java
IF /I "%ERRORLEVEL%" NEQ "0" (
    set ERRMSG="Error compiling project"
    GOTO ERROR
)

:JAVADOC
echo ~~~ Generating JavaDoc ~~~
javadoc %JAVAFX_ARGS% -sourcepath %PRAC_SRC% -classpath %PRAC_BIN%;%PRAC_LIB% -d %PRAC_DOC%\%PRAC_JDC% -use -version -author -subpackages acsse
IF /I "%ERRORLEVEL%" NEQ "0" (
    echo ~~! Warning: Error generating JavaDoc !~~
)

:RUN
echo ~~~ Running project ~~~
java %JAVAFX_ARGS% -cp %PRAC_BIN%;%PRAC_LIB% Main %*
IF /I "%ERRORLEVEL%" NEQ "0" (
    set ERRMSG="Error running project"
    GOTO ERROR
)
GOTO END

:ERROR
echo ~~! FATAL ERROR !~~
echo %ERRMSG%
GOTO END

:END
echo ~~~ Done ~~~
cd %PRAC_DOC%
pause
