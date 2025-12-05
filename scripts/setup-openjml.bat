@echo off
REM Setup script for OpenJML (Windows)
REM Downloads and configures OpenJML for JML verification

set OPENJML_VERSION=21-0.18
set OPENJML_DIR=tools\openjml
set OPENJML_URL=https://github.com/OpenJML/OpenJML/releases/download/v%OPENJML_VERSION%/openjml.zip

echo Setting up OpenJML %OPENJML_VERSION%...

REM Create tools directory if it doesn't exist
if not exist "tools" mkdir tools

REM Check if OpenJML is already installed
if exist "%OPENJML_DIR%\openjml.jar" (
    echo OpenJML is already installed at %OPENJML_DIR%
    exit /b 0
)

REM Download OpenJML
echo Downloading OpenJML from %OPENJML_URL%...
cd tools

REM Try to download using PowerShell
powershell -Command "Invoke-WebRequest -Uri '%OPENJML_URL%' -OutFile 'openjml.zip'"
if errorlevel 1 (
    echo Error: Failed to download OpenJML. Please download manually from:
    echo %OPENJML_URL%
    exit /b 1
)

REM Extract OpenJML
echo Extracting OpenJML...
powershell -Command "Expand-Archive -Path 'openjml.zip' -DestinationPath 'openjml' -Force"
if errorlevel 1 (
    echo Error: Failed to extract OpenJML
    del openjml.zip
    exit /b 1
)

REM Clean up zip file
del openjml.zip

REM Verify installation
if exist "openjml\openjml.jar" (
    echo OpenJML successfully installed at %OPENJML_DIR%
    echo You can now run JML verification using:
    echo   scripts\verify-jml.bat
) else (
    echo Error: OpenJML installation verification failed
    exit /b 1
)

cd ..

