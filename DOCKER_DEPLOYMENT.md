# Docker Deployment Guide - Spring PetClinic

## 📦 What's Been Created

1. **Dockerfile** - Multi-stage build for the Spring Boot application
2. **.dockerignore** - Excludes unnecessary files from Docker build
3. **docker-compose.yml** - Updated with application and database services

## 🚀 Quick Start

### Option 1: Run Everything with Docker Compose (Recommended)

This will build and start the application with MySQL database:

```bash
docker-compose up --build
```

To run in detached mode (background):
```bash
docker-compose up --build -d
```

### Option 2: Build and Run Manually

#### Step 1: Build the Docker Image
```bash
docker build -t spring-petclinic:latest .
```

#### Step 2: Start MySQL Database
```bash
docker-compose up mysql -d
```

#### Step 3: Run the Application Container
```bash
docker run -d \
  --name petclinic-app \
  -p 8080:8080 \
  -e SPRING_PROFILES_ACTIVE=mysql \
  -e MYSQL_URL=jdbc:mysql://host.docker.internal:3306/petclinic \
  -e MYSQL_USER=petclinic \
  -e MYSQL_PASS=petclinic \
  --network petclinic-network \
  spring-petclinic:latest
```

## 🗄️ Database Options

### Using MySQL (Default)
```bash
docker-compose up --build
```

### Using PostgreSQL
```bash
docker-compose --profile postgres up --build
```

Then update the application environment to use PostgreSQL:
```yaml
# In docker-compose.yml, change petclinic service:
environment:
  - SPRING_PROFILES_ACTIVE=postgres
  - POSTGRES_URL=jdbc:postgresql://postgres:5432/petclinic
  - POSTGRES_USER=petclinic
  - POSTGRES_PASS=petclinic
```

### Using H2 (In-Memory - No Database Container Needed)
```bash
docker run -d \
  --name petclinic-app \
  -p 8080:8080 \
  spring-petclinic:latest
```

## 📋 Docker Compose Commands

### Start Services
```bash
docker-compose up
```

### Start in Background
```bash
docker-compose up -d
```

### Stop Services
```bash
docker-compose down
```

### Stop and Remove Volumes
```bash
docker-compose down -v
```

### View Logs
```bash
# All services
docker-compose logs

# Specific service
docker-compose logs petclinic
docker-compose logs mysql

# Follow logs
docker-compose logs -f petclinic
```

### Rebuild After Code Changes
```bash
docker-compose up --build
```

### Restart a Service
```bash
docker-compose restart petclinic
```

## 🔍 Useful Docker Commands

### List Running Containers
```bash
docker ps
```

### View Container Logs
```bash
docker logs petclinic-app
docker logs -f petclinic-app  # Follow logs
```

### Execute Commands in Container
```bash
docker exec -it petclinic-app sh
```

### Stop Container
```bash
docker stop petclinic-app
```

### Remove Container
```bash
docker rm petclinic-app
```

### Remove Image
```bash
docker rmi spring-petclinic:latest
```

### View Container Resource Usage
```bash
docker stats petclinic-app
```

## 🌐 Accessing the Application

Once containers are running:

- **Application**: http://localhost:8080
- **Health Check**: http://localhost:8080/actuator/health
- **Actuator**: http://localhost:8080/actuator

## 🏗️ Dockerfile Details

The Dockerfile uses a **multi-stage build**:

1. **Build Stage**: Uses Maven to compile and package the application
2. **Runtime Stage**: Uses a lightweight JRE image to run the application

**Benefits:**
- Smaller final image size
- Faster builds (layer caching)
- Security (non-root user)
- Health checks included

## 🔧 Troubleshooting

### Port Already in Use
```bash
# Find what's using port 8080
netstat -ano | findstr :8080

# Or change port in docker-compose.yml
ports:
  - "8081:8080"  # Host:Container
```

### Application Can't Connect to Database
- Ensure database container is running: `docker-compose ps`
- Check database health: `docker-compose logs mysql`
- Verify network connectivity: Containers must be on same network

### Build Fails
```bash
# Clean build
docker-compose down
docker system prune -f
docker-compose build --no-cache
```

### View Application Logs
```bash
docker-compose logs -f petclinic
```

### Database Connection Issues
- Wait for database to be healthy (healthcheck configured)
- Check environment variables match database credentials
- Verify network configuration

## 📊 Docker Compose Services

### petclinic
- **Image**: Built from Dockerfile
- **Port**: 8080
- **Depends on**: mysql (waits for health check)
- **Health Check**: Enabled

### mysql
- **Image**: mysql:9.2
- **Port**: 3306
- **Volume**: mysql-data (persistent storage)
- **Health Check**: Enabled

### postgres
- **Image**: postgres:18.0
- **Port**: 5432
- **Volume**: postgres-data (persistent storage)
- **Profile**: postgres (not started by default)

## 🎯 Production Considerations

For production deployment, consider:

1. **Environment Variables**: Use secrets management
2. **Resource Limits**: Add memory/CPU limits
3. **Logging**: Configure centralized logging
4. **Monitoring**: Add monitoring tools
5. **SSL/TLS**: Configure HTTPS
6. **Backup**: Set up database backups
7. **Scaling**: Use Docker Swarm or Kubernetes

## ✅ Verification Steps

1. **Check containers are running:**
   ```bash
   docker-compose ps
   ```

2. **Check application health:**
   ```bash
   curl http://localhost:8080/actuator/health
   ```

3. **Access application:**
   - Open browser: http://localhost:8080
   - Should see PetClinic welcome page

4. **Check logs:**
   ```bash
   docker-compose logs petclinic | grep "Started PetClinicApplication"
   ```

## 🎉 Success!

If you can access http://localhost:8080, your application is successfully deployed in Docker!

