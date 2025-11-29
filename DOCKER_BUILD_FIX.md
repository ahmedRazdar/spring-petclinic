# Docker Build Fix - ErrorProne Issue

## Problem
The Docker build fails due to ErrorProne Java module compatibility issues during compilation.

## Solution Options

### Option 1: Build Locally, Then Docker (Recommended - Fastest)

This avoids the ErrorProne issue entirely:

1. **Build the JAR locally** (this works because you already have it running):
   ```powershell
   .\mvnw.cmd clean package -DskipTests
   ```

2. **Build Docker image using pre-built JAR**:
   ```powershell
   docker build -f Dockerfile.local -t spring-petclinic:latest .
   ```

3. **Update docker-compose.yml** to use the local image:
   ```yaml
   petclinic:
     image: spring-petclinic:latest
     # Remove build section, just use the image
   ```

4. **Start services**:
   ```powershell
   docker compose up -d
   ```

### Option 2: Fix Dockerfile to Bypass ErrorProne

The current Dockerfile tries to bypass ErrorProne but it's still being invoked. We need to completely disable it.

**Update Dockerfile** to skip ErrorProne entirely:
```dockerfile
# In the build stage, add this before compilation:
RUN mvn clean resources:resources -B
RUN mvn compiler:compile -B \
    -Dmaven.compiler.fork=true \
    -Dmaven.compiler.executable=/usr/bin/javac \
    -Dmaven.compiler.compilerArgs="-XDcompilePolicy=simple" \
    -Dmaven.compiler.useIncrementalCompilation=false
RUN mvn jar:jar spring-boot:repackage -DskipTests -B
```

### Option 3: Use Dockerfile.simple

I've created `Dockerfile.simple` that uses a step-by-step approach. Update docker-compose.yml:
```yaml
petclinic:
  build:
    context: .
    dockerfile: Dockerfile.simple
```

## Quick Start (Recommended)

Since your local build works, use Option 1:

```powershell
# 1. Build JAR locally
.\mvnw.cmd clean package -DskipTests

# 2. Build Docker image
docker build -f Dockerfile.local -t spring-petclinic:latest .

# 3. Start everything
docker compose up -d
```

## Verify

```powershell
# Check containers
docker compose ps

# Check logs
docker compose logs petclinic

# Access application
# http://localhost:8080
```

