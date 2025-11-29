# 🐳 Docker Quick Start Guide

## ⚠️ Important: Stop Local Application First!

Before starting Docker, **stop your currently running application** (press `Ctrl+C` in the terminal where it's running).

Port 8080 needs to be free for the Docker container.

## 🚀 Quick Start (3 Steps)

### Step 1: Stop Local Application
Press `Ctrl+C` in the terminal where Spring PetClinic is running.

### Step 2: Build and Start with Docker Compose
```powershell
docker compose up --build
```

This will:
- Build the Docker image
- Start MySQL database
- Start the PetClinic application
- Show logs from all services

### Step 3: Access the Application
Open your browser: **http://localhost:8080**

## 📋 Alternative Commands

### Run in Background (Detached Mode)
```powershell
docker compose up --build -d
```

### View Logs
```powershell
# All services
docker compose logs

# Just the application
docker compose logs petclinic

# Follow logs (live)
docker compose logs -f petclinic
```

### Stop All Services
```powershell
docker compose down
```

### Stop and Remove Data Volumes
```powershell
docker compose down -v
```

### Restart Services
```powershell
docker compose restart
```

## 🔍 Verify It's Working

1. **Check containers are running:**
   ```powershell
   docker compose ps
   ```

2. **Check application health:**
   ```powershell
   curl http://localhost:8080/actuator/health
   ```
   Or open in browser: http://localhost:8080/actuator/health

3. **View application logs:**
   ```powershell
   docker compose logs petclinic | findstr "Started"
   ```

## 🎯 What Happens During Build

1. **Maven Build**: Downloads dependencies and compiles code (first time takes 2-5 minutes)
2. **Docker Image**: Creates application image
3. **MySQL**: Starts database container
4. **Application**: Starts Spring Boot app and connects to MySQL
5. **Health Checks**: Verifies everything is running

## 🐛 Troubleshooting

### Port 8080 Already in Use
```powershell
# Find what's using the port
netstat -ano | findstr :8080

# Kill the process (replace PID)
taskkill /PID <PID> /F
```

### Build Fails
```powershell
# Clean and rebuild
docker compose down
docker system prune -f
docker compose build --no-cache
```

### Application Can't Connect to Database
- Wait a bit longer (database needs time to initialize)
- Check logs: `docker compose logs mysql`
- Verify MySQL is healthy: `docker compose ps`

### View All Logs
```powershell
docker compose logs
```

## 📊 Container Status

Check what's running:
```powershell
docker ps
```

Should see:
- `petclinic-app` (application)
- `petclinic-mysql` (database)

## 🎉 Success Indicators

✅ You'll know it's working when:
- Browser shows PetClinic welcome page at http://localhost:8080
- `docker compose ps` shows all containers as "Up"
- Logs show "Started PetClinicApplication"

## 💡 Pro Tips

1. **First build takes time** - Maven downloads dependencies (be patient!)
2. **Use detached mode** - Add `-d` flag to run in background
3. **Check logs** - Use `docker compose logs` to debug issues
4. **Data persistence** - Database data is stored in Docker volumes

## 🛑 Stopping Everything

```powershell
docker compose down
```

This stops and removes containers but keeps data volumes.

To remove everything including data:
```powershell
docker compose down -v
```

