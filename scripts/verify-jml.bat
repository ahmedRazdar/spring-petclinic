@echo off
REM JML Verification Script using OpenJML (Windows)
REM Verifies JML specifications in the source code

set OPENJML_DIR=tools\openjml
set OPENJML_JAR=%OPENJML_DIR%\openjml.jar

REM Check if OpenJML is installed
if not exist "%OPENJML_JAR%" (
    echo OpenJML not found. Running setup script...
    call scripts\setup-openjml.bat
    if errorlevel 1 exit /b 1
)

echo Verifying JML specifications...
echo.

REM Build classpath using Maven
call mvnw.cmd dependency:build-classpath -q -DincludeScope=compile > classpath.tmp 2>nul
set /p CLASSPATH=<classpath.tmp
del classpath.tmp

REM Verify core files with JML annotations
set FILES=
if exist "src\main\java\org\springframework\samples\petclinic\owner\Owner.java" (
    findstr /C:"/*@" /C:"//@" "src\main\java\org\springframework\samples\petclinic\owner\Owner.java" >nul 2>&1
    if not errorlevel 1 set FILES=%FILES% "src\main\java\org\springframework\samples\petclinic\owner\Owner.java"
)

if exist "src\main\java\org\springframework\samples\petclinic\owner\Pet.java" (
    findstr /C:"/*@" /C:"//@" "src\main\java\org\springframework\samples\petclinic\owner\Pet.java" >nul 2>&1
    if not errorlevel 1 set FILES=%FILES% "src\main\java\org\springframework\samples\petclinic\owner\Pet.java"
)

if exist "src\main\java\org\springframework\samples\petclinic\owner\OwnerRepository.java" (
    findstr /C:"/*@" /C:"//@" "src\main\java\org\springframework\samples\petclinic\owner\OwnerRepository.java" >nul 2>&1
    if not errorlevel 1 set FILES=%FILES% "src\main\java\org\springframework\samples\petclinic\owner\OwnerRepository.java"
)

if exist "src\main\java\org\springframework\samples\petclinic\owner\PetValidator.java" (
    findstr /C:"/*@" /C:"//@" "src\main\java\org\springframework\samples\petclinic\owner\PetValidator.java" >nul 2>&1
    if not errorlevel 1 set FILES=%FILES% "src\main\java\org\springframework\samples\petclinic\owner\PetValidator.java"
)

if "%FILES%"=="" (
    echo No Java files with JML annotations found.
    exit /b 0
)

REM Run OpenJML verification
java -jar "%OPENJML_JAR%" -check -cp "%CLASSPATH%" %FILES%
if errorlevel 1 (
    echo.
    echo JML verification completed with warnings/errors.
    echo Review the output above for details.
    exit /b 1
)

echo.
echo JML verification completed successfully!


