# Correct Command to Start the Application

## The Issue
The command failed because Maven couldn't parse the combined `clean spring-boot:run` syntax with the skip parameters.

## ✅ Solution: Run These Commands Separately

### Step 1: Clean (optional, but recommended)
```powershell
.\mvnw.cmd clean
```

### Step 2: Run the Application
Use **ONE** of these commands:

#### Option A: Simple Run (Recommended)
```powershell
.\mvnw.cmd spring-boot:run
```

#### Option B: Skip Formatting Checks
```powershell
.\mvnw.cmd spring-boot:run -Dspring-javaformat.skip=true
```

#### Option C: Skip All Checks
```powershell
.\mvnw.cmd spring-boot:run -Dspring-javaformat.skip=true -Dmaven.checkstyle.skip=true -DskipTests
```

## 🔧 Alternative: Build First, Then Run JAR

If the above doesn't work, try building first:

```powershell
# Step 1: Build (skip tests and formatting)
.\mvnw.cmd package -DskipTests -Dspring-javaformat.skip=true -Dmaven.checkstyle.skip=true

# Step 2: Run the JAR
java -jar target\spring-petclinic-4.0.0-SNAPSHOT.jar
```

## 📝 What to Expect

1. **First Run**: Maven will download dependencies (2-5 minutes)
2. **Compilation**: You'll see compilation messages
3. **Startup**: Look for "Started PetClinicApplication"
4. **Access**: Open http://localhost:8080

## ⚠️ If You Still Get Formatting Errors

If you see formatting errors, run this first:
```powershell
.\mvnw.cmd spring-javaformat:apply
```

Then run:
```powershell
.\mvnw.cmd spring-boot:run
```

## 🎯 Quickest Solution

Try this single command (simplest):
```powershell
.\mvnw.cmd spring-boot:run
```

If it fails with formatting errors, then run:
```powershell
.\mvnw.cmd spring-javaformat:apply
.\mvnw.cmd spring-boot:run
```

