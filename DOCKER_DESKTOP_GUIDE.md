# 🐳 How to Check Docker in Docker Desktop

## ✅ Quick Check Methods

### Method 1: Docker Desktop GUI (Easiest)

1. **Open Docker Desktop**
   - Look for the Docker icon in your system tray (bottom-right corner)
   - Or search for "Docker Desktop" in Windows Start menu

2. **Check Docker Desktop Status**
   - If Docker Desktop is running, you'll see the icon in the system tray
   - Click the icon to open Docker Desktop window

3. **View Running Containers**
   - In Docker Desktop, click on **"Containers"** tab (left sidebar)
   - You should see:
     - `petclinic-app` - Your Spring Boot application
     - `petclinic-mysql` - MySQL database
   - Status should show as **"Running"** with green indicator

4. **View Container Details**
   - Click on a container name to see:
     - Logs (real-time)
     - Stats (CPU, Memory usage)
     - Environment variables
     - Port mappings
     - File system

### Method 2: Command Line

#### Check if Docker is Running
```powershell
docker info
```
If Docker is running, you'll see system information. If not, you'll get an error.

#### List Running Containers
```powershell
docker ps
```

#### List All Containers (including stopped)
```powershell
docker ps -a
```

#### Check Specific Containers
```powershell
docker ps --filter "name=petclinic"
```

#### View Container Status
```powershell
docker compose ps
```

## 📊 What You Should See in Docker Desktop

### Containers Tab
- **petclinic-app**
  - Status: Running (green)
  - Port: 8080:8080
  - Image: spring-petclinic:latest
  
- **petclinic-mysql**
  - Status: Running (green)
  - Port: 3306:3306
  - Image: mysql:9.2

### Images Tab
- **spring-petclinic:latest** - Your application image
- **mysql:9.2** - Database image
- **maven:3.9-eclipse-temurin-17** - Build image (if visible)

### Volumes Tab
- **proj_backup_mysql-data** - Database persistent storage

### Networks Tab
- **proj_backup_petclinic-network** - Network connecting app and database

## 🔍 Detailed Container Information in Docker Desktop

1. **Click on `petclinic-app` container**
2. You'll see tabs:
   - **Logs**: Real-time application logs
   - **Stats**: CPU, Memory, Network usage
   - **Inspect**: Detailed container configuration
   - **Files**: Container file system
   - **Exec**: Run commands inside container

## 🚨 Troubleshooting

### Docker Desktop Not Running

**Symptoms:**
- Docker icon not in system tray
- `docker` commands fail with "Cannot connect to Docker daemon"

**Solution:**
1. Open Docker Desktop from Start menu
2. Wait for it to start (whale icon will appear in system tray)
3. Verify it's running: `docker info`

### Containers Not Showing

**Check:**
```powershell
# List all containers
docker ps -a

# Check docker-compose status
docker compose ps

# View logs
docker compose logs
```

### Container Shows as "Exited"

**Check logs:**
```powershell
docker compose logs petclinic
```

**Restart:**
```powershell
docker compose restart
# or
docker compose up -d
```

## 🎯 Quick Status Check Commands

### One-Line Status Check
```powershell
docker compose ps && docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
```

### Check if Application is Responding
```powershell
Invoke-WebRequest -Uri http://localhost:8080/actuator/health -UseBasicParsing
```

### View Real-Time Logs
```powershell
docker compose logs -f petclinic
```

## 📱 Docker Desktop Features

### Useful Actions in Docker Desktop:

1. **Start/Stop Containers**
   - Click the play/pause button next to container name

2. **View Logs**
   - Click container → Logs tab
   - Real-time log streaming

3. **View Resource Usage**
   - Click container → Stats tab
   - See CPU, Memory, Network, Disk usage

4. **Open Container Shell**
   - Click container → Exec tab
   - Run commands inside container

5. **Remove Containers**
   - Click container → Click trash icon
   - Or use: `docker compose down`

## ✅ Verification Checklist

- [ ] Docker Desktop is running (icon in system tray)
- [ ] `petclinic-app` container is running (green status)
- [ ] `petclinic-mysql` container is running (green status)
- [ ] Application accessible at http://localhost:8080
- [ ] Health check returns 200: http://localhost:8080/actuator/health

## 🎉 Quick Access

**Open Docker Desktop:**
- Right-click Docker icon in system tray → "Open Docker Desktop"
- Or search "Docker Desktop" in Start menu

**View Your Containers:**
- Docker Desktop → Containers tab
- You should see both `petclinic-app` and `petclinic-mysql` running!

