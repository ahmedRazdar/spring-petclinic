@echo off
echo ========================================
echo Spring PetClinic Docker Deployment
echo ========================================
echo.
echo This will:
echo 1. Build the Docker image
echo 2. Start MySQL database
echo 3. Start the PetClinic application
echo.
echo Press Ctrl+C to stop all services
echo.
pause

echo.
echo Building and starting services...
docker compose up --build

pause

