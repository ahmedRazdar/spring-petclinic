# Fix and Run Spring PetClinic - Step by Step

## Issue Identified
The application is not starting because Maven's code formatting validation is failing.

## Solution Options

### Option 1: Fix Formatting and Run (Recommended)

1. **Apply code formatting:**
   ```powershell
   .\mvnw.cmd spring-javaformat:apply
   ```

2. **Run the application:**
   ```powershell
   .\mvnw.cmd spring-boot:run
   ```

### Option 2: Skip Validation and Run

If you want to run without fixing formatting first, you can temporarily modify the build:

1. **Edit pom.xml** - Comment out the formatting validation:
   - Find the `spring-javaformat-maven-plugin` section (around line 186)
   - Temporarily comment out the `<executions>` block

2. **Or use this command to skip checks:**
   ```powershell
   .\mvnw.cmd clean install -DskipTests -Dspring-javaformat.skip=true -Dmaven.checkstyle.skip=true
   .\mvnw.cmd spring-boot:run
   ```

### Option 3: Run Pre-built JAR (if available)

If the JAR was built previously:
```powershell
java -jar target\spring-petclinic-4.0.0-SNAPSHOT.jar
```

## Manual Steps to Run

1. **Open PowerShell or Command Prompt** in the project directory

2. **Apply formatting (if needed):**
   ```powershell
   .\mvnw.cmd spring-javaformat:apply
   ```

3. **Build the project:**
   ```powershell
   .\mvnw.cmd clean package -DskipTests
   ```

4. **Run the application:**
   ```powershell
   .\mvnw.cmd spring-boot:run
   ```

5. **Wait for startup message:**
   - Look for: `Started PetClinicApplication`
   - This may take 2-5 minutes on first run

6. **Open browser:**
   - Navigate to: http://localhost:8080

## Troubleshooting

### If port 8080 is in use:
```powershell
# Find what's using the port
netstat -ano | findstr :8080

# Kill the process (replace PID)
taskkill /PID <PID> /F
```

### If Maven wrapper doesn't work:
- Make sure you're in the project root directory
- Try: `mvnw.cmd` instead of `.\mvnw.cmd`

### If you see "BUILD FAILURE":
- Check the error message
- Common issues:
  - Code formatting violations → Run `spring-javaformat:apply`
  - Missing dependencies → Maven will download them automatically
  - Java version mismatch → Ensure Java 17 is installed

## Quick Test Command

Try this single command that should work:
```powershell
.\mvnw.cmd clean spring-boot:run -Dspring-javaformat.skip=true -Dmaven.checkstyle.skip=true -DskipTests
```

This will:
- Clean previous builds
- Skip formatting checks
- Skip style checks  
- Skip tests
- Run the application

## Expected Output

When successful, you should see:
```
...
Started PetClinicApplication in X.XXX seconds
```

Then open: **http://localhost:8080**

