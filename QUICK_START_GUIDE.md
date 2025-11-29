# Quick Start Guide - Spring PetClinic

## ✅ Prerequisites Check
- ✅ Java 17 installed (you have OpenJDK 17.0.17)
- ✅ Maven wrapper available (mvnw.cmd)

## 🚀 Running the Application

### Method 1: Using Maven Wrapper (Recommended)
```bash
.\mvnw.cmd spring-boot:run
```

### Method 2: Build JAR and Run
```bash
# Build the application
.\mvnw.cmd clean package

# Run the JAR file
java -jar target\spring-petclinic-4.0.0-SNAPSHOT.jar
```

### Method 3: Using Gradle (if preferred)
```bash
.\gradlew.bat bootRun
```

## 🌐 Accessing the Application

Once the application starts (you'll see "Started PetClinicApplication" in the console), open your browser and navigate to:

**Main Application:**
- http://localhost:8080

**H2 Database Console (if using H2):**
- http://localhost:8080/h2-console
- JDBC URL: `jdbc:h2:mem:<uuid>` (check console for the UUID)
- Username: (leave empty or use 'sa')
- Password: (leave empty)

## 📋 Application Features

### Main Pages:
1. **Welcome Page** - http://localhost:8080/
2. **Find Owners** - http://localhost:8080/owners/find
3. **Veterinarians** - http://localhost:8080/vets.html
4. **Vets API (JSON)** - http://localhost:8080/vets

### Sample Data:
The application comes pre-loaded with sample data:
- Sample owners and pets
- Veterinarians with specialties
- Sample visits

## 🗄️ Database Configuration

### Default (H2 - In-Memory):
- No configuration needed
- Data is lost when application stops
- Good for development/testing

### MySQL:
```bash
# Start MySQL with Docker
docker compose up mysql

# Run with MySQL profile
.\mvnw.cmd spring-boot:run -Dspring-boot.run.profiles=mysql
```

### PostgreSQL:
```bash
# Start PostgreSQL with Docker
docker compose up postgres

# Run with PostgreSQL profile
.\mvnw.cmd spring-boot:run -Dspring-boot.run.profiles=postgres
```

## 🛑 Stopping the Application

Press `Ctrl + C` in the terminal where the application is running.

## 🔍 Troubleshooting

### Port 8080 Already in Use:
```bash
# Check what's using port 8080
netstat -ano | findstr :8080

# Kill the process (replace PID with actual process ID)
taskkill /PID <PID> /F
```

### Application Won't Start:
1. Check Java version: `java -version` (should be 17+)
2. Check if port 8080 is available
3. Review console logs for errors
4. Try cleaning and rebuilding: `.\mvnw.cmd clean package`

### Dependencies Not Downloading:
- Check internet connection
- Maven might be downloading dependencies (first run takes time)
- Check Maven settings if behind a proxy

## 📝 Next Steps

1. **Explore the Application:**
   - Navigate to http://localhost:8080
   - Try finding owners
   - Add a new pet
   - View veterinarians

2. **Check the Code:**
   - Review controllers in `src/main/java/org/springframework/samples/petclinic/`
   - Check templates in `src/main/resources/templates/`

3. **Read the Analysis:**
   - See `APPLICATION_ANALYSIS.md` for detailed architecture documentation

## 🎯 Quick Test

Once the app is running, try:
1. Go to http://localhost:8080
2. Click "Find owners"
3. Search for "Franklin" (sample owner)
4. View owner details and pets
5. Add a new visit for a pet

Enjoy exploring Spring PetClinic! 🐾

