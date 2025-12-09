# PowerShell script to pull Docker image from Docker Hub
# Replace YOUR_USERNAME with your actual Docker Hub username

$dockerHubUsername = "YOUR_USERNAME"  # <-- CHANGE THIS to your Docker Hub username

Write-Host "Pulling image from Docker Hub..." -ForegroundColor Green
docker pull "${dockerHubUsername}/spring-petclinic:latest"

Write-Host "`nVerifying image..." -ForegroundColor Green
docker images | Select-String "spring-petclinic"

Write-Host "`nDone! Check Docker Desktop -> Images tab to see the image." -ForegroundColor Green






