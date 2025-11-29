@echo off
echo Starting Spring PetClinic Application...
echo.
echo This may take a few minutes on first run as dependencies are downloaded.
echo.
echo Once you see "Started PetClinicApplication", open your browser to:
echo http://localhost:8080
echo.
echo Press Ctrl+C to stop the application.
echo.

.\mvnw.cmd spring-boot:run -Dspring-javaformat.skip=true

pause

