# Complete Setup Guide - Security Scans & Benchmarks

**Date:** December 8, 2024

---

## ✅ Step 1: Fix Code Formatting

The build requires Spring Java Format compliance. To fix formatting violations:

### Option A: Use Maven Plugin (Recommended)
```powershell
# Apply formatting to all files
./mvnw spring-javaformat:apply

# Verify formatting is correct
./mvnw spring-javaformat:validate
```

### Option B: Manual Fix (If Maven plugin doesn't work)
The main issue is likely **tab vs spaces indentation**. Spring Java Format uses **4 spaces** for indentation, not tabs.

Files that need formatting:
- `src/main/java/org/springframework/samples/petclinic/model/BaseEntity.java`
- `src/main/java/org/springframework/samples/petclinic/model/NamedEntity.java`
- `src/main/java/org/springframework/samples/petclinic/model/Person.java`
- `src/main/java/org/springframework/samples/petclinic/owner/Owner.java`
- `src/main/java/org/springframework/samples/petclinic/owner/OwnerRepository.java`
- `src/main/java/org/springframework/samples/petclinic/owner/Pet.java`
- `src/main/java/org/springframework/samples/petclinic/owner/PetValidator.java`
- `src/main/java/org/springframework/samples/petclinic/owner/Visit.java`
- `src/main/java/org/springframework/samples/petclinic/PetClinicApplication.java`
- `src/main/java/org/springframework/samples/petclinic/vet/VetRepository.java`
- `src/test/java/org/springframework/samples/petclinic/api/owner/OwnerCrudApiTest.java`
- `src/test/java/org/springframework/samples/petclinic/performance/micro/OwnerRepositoryBenchmark.java`
- `src/test/java/org/springframework/samples/petclinic/PostgresIntegrationTests.java`
- `src/test/java/org/springframework/samples/petclinic/unit/owner/OwnerServiceUnitTest.java`

**Quick Fix:** Most IDEs can convert tabs to spaces:
- **VS Code:** Select all → Convert Indentation to Spaces
- **IntelliJ:** File → Settings → Editor → Code Style → Java → Tabs and Indents → Use tab character: **Unchecked**

---

## ✅ Step 2: Build Benchmarks JAR

Once formatting is fixed:

```powershell
# Clean and build (with tests skipped for speed)
./mvnw -DskipTests clean package

# Verify benchmarks.jar was created
Test-Path target\benchmarks.jar

# If file exists, you should see: True
```

**Expected Output:**
- `target/benchmarks.jar` should be created (~5-10 MB)
- Build should complete with `BUILD SUCCESS`

**If formatting still fails:**
```powershell
# Temporary workaround (skip format validation)
./mvnw -DskipTests -DskipFormatValidation=true clean package
```

---

## ✅ Step 3: Run JMH Benchmarks

Once `benchmarks.jar` is built:

```powershell
# Run all benchmarks
java -jar target\benchmarks.jar

# Run specific benchmark class
java -jar target\benchmarks.jar OwnerRepositoryBenchmark

# Run with custom JMH options
java -jar target\benchmarks.jar OwnerRepositoryBenchmark -wi 5 -i 5 -f 1
```

**Expected Output:**
```
Benchmark                                    Mode  Cnt    Score   Error  Units
OwnerRepositoryBenchmark.benchmarkCount      avgt    5    0.xxx  0.xxx  us/op
OwnerRepositoryBenchmark.benchmarkExists     avgt    5    0.xxx  0.xxx  us/op
OwnerRepositoryBenchmark.benchmarkFindAll    avgt    5    0.xxx  0.xxx  us/op
OwnerRepositoryBenchmark.benchmarkFindById   avgt    5    0.xxx  0.xxx  us/op
OwnerRepositoryBenchmark.benchmarkFindByLastName avgt    5    0.xxx  0.xxx  us/op
OwnerRepositoryBenchmark.benchmarkSave       avgt    5    0.xxx  0.xxx  us/op
```

---

## ✅ Step 4: Set Up GitHub Secrets for Security Scans

### Required Secrets:

Go to: **GitHub Repository → Settings → Secrets and variables → Actions → New repository secret**

#### 1. GitGuardian API Key
- **Name:** `GITGUARDIAN_API_KEY`
- **How to get:**
  1. Sign up at https://www.gitguardian.com/
  2. Go to API section
  3. Generate API key
  4. Copy and paste as secret value

#### 2. Snyk Token
- **Name:** `SNYK_TOKEN`
- **How to get:**
  1. Sign up at https://snyk.io/
  2. Go to Account Settings → Auth Token
  3. Generate new token
  4. Copy and paste as secret value

#### 3. SonarCloud Token
- **Name:** `SONAR_TOKEN`
- **How to get:**
  1. Sign up at https://sonarcloud.io/
  2. Create a new project for this repository
  3. Go to My Account → Security → Generate Token
  4. Copy and paste as secret value

#### 4. Codecov Token (if not already set)
- **Name:** `CODECOV_TOKEN`
- **How to get:**
  1. Sign up at https://codecov.io/
  2. Add your repository
  3. Get token from repository settings
  4. Copy and paste as secret value

#### 5. Docker Hub Credentials (if not already set)
- **Name:** `DOCKERHUB_USERNAME`
- **Value:** Your Docker Hub username

- **Name:** `DOCKERHUB_PASSWORD`
- **Value:** Your Docker Hub password or access token

---

## ✅ Step 5: Verify CI/CD Pipeline

After setting up secrets and pushing changes:

1. **Go to GitHub Actions tab**
2. **Check workflow runs:**
   - `compile` job should pass
   - `test` job should pass
   - `security-scan` job should run (may show warnings if secrets not set)
   - `docker-build` job should run (if tests pass)

3. **Check Security Scan Results:**
   - Go to **Security** tab in GitHub
   - Check **Code scanning alerts** for Trivy results
   - Check workflow artifacts for detailed reports

4. **Review Security Scan Artifacts:**
   - Download `trivy-results.sarif` from workflow artifacts
   - Check GitGuardian, Snyk, and SonarCloud logs in workflow output

---

## ✅ Step 6: Run Security Scans Locally (Optional)

### GitGuardian (Secret Scanning)
```powershell
# Install ggshield
pip install ggshield

# Set API key
$env:GITGUARDIAN_API_KEY = "your-api-key"

# Scan repository
ggshield secret scan repo .
```

### Snyk (Dependency Scanning)
```powershell
# Install Snyk CLI
npm install -g snyk

# Authenticate
snyk auth

# Test for vulnerabilities
snyk test --severity-threshold=high

# Monitor project
snyk monitor
```

### Trivy (Filesystem Scanning)
```powershell
# Download Trivy from: https://github.com/aquasecurity/trivy/releases
# Or use Chocolatey: choco install trivy

# Scan filesystem
trivy fs --format table .

# Generate SARIF report
trivy fs --format sarif --output trivy-results.sarif .

# Scan Docker image (if built)
trivy image spring-petclinic:latest
```

### SonarCloud (Code Quality)
```powershell
# Requires SonarCloud project setup first
$env:SONAR_TOKEN = "your-token"

# Run SonarCloud analysis
./mvnw -DskipTests sonar:sonar `
  -Dsonar.login=$env:SONAR_TOKEN `
  -Dsonar.projectKey=your-project-key `
  -Dsonar.organization=your-org
```

---

## 🔧 Troubleshooting

### Issue: Build fails with format validation errors
**Solution:**
```powershell
# Apply formatting
./mvnw spring-javaformat:apply

# Or skip temporarily
./mvnw -DskipFormatValidation=true clean package
```

### Issue: benchmarks.jar not created
**Solution:**
1. Check Maven shade plugin is configured in `pom.xml` ✅ (already configured)
2. Ensure build completes successfully: `./mvnw clean package`
3. Check `target/` directory exists after build

### Issue: Security scans fail in CI/CD
**Solution:**
1. Verify secrets are set correctly in GitHub
2. Check secret names match exactly (case-sensitive)
3. Review workflow logs for specific error messages
4. Ensure `continue-on-error: true` is set (already configured)

### Issue: Java version mismatch
**Solution:**
- Required: Java 17+
- Check version: `java -version`
- Update JAVA_HOME if needed

---

## 📊 Verification Checklist

- [ ] Code formatting fixed (`spring-javaformat:apply` run successfully)
- [ ] Build completes without errors (`./mvnw clean package`)
- [ ] `target/benchmarks.jar` exists
- [ ] Benchmarks run successfully (`java -jar target/benchmarks.jar`)
- [ ] GitHub secrets configured (GITGUARDIAN_API_KEY, SNYK_TOKEN, SONAR_TOKEN)
- [ ] CI/CD pipeline runs successfully
- [ ] Security scan job completes (check workflow artifacts)
- [ ] Trivy results visible in GitHub Security tab

---

## 📝 Quick Reference Commands

```powershell
# Format code
./mvnw spring-javaformat:apply

# Build with tests
./mvnw clean package

# Build without tests
./mvnw -DskipTests clean package

# Build skipping format validation
./mvnw -DskipTests -DskipFormatValidation=true clean package

# Run benchmarks
java -jar target\benchmarks.jar OwnerRepositoryBenchmark

# Run all tests
./mvnw test

# Generate coverage report
./mvnw jacoco:report

# Run mutation tests
./mvnw org.pitest:pitest-maven:mutationCoverage
```

---

**Status:** All configurations verified ✅  
**Next Steps:** Fix formatting → Build benchmarks → Set up GitHub secrets → Test CI/CD

