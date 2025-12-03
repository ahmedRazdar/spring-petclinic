# Comprehensive Testing Guide for Spring PetClinic

## 📚 Table of Contents

1. [Overview](#overview)
2. [Testing Types](#testing-types)
3. [Running Tests](#running-tests)
4. [Test Examples](#test-examples)
5. [Best Practices](#best-practices)
6. [CI/CD Integration](#cicd-integration)

---

## Overview

This project implements comprehensive testing using multiple testing strategies and tools:

| Testing Type | Tool | Purpose |
|-------------|------|---------|
| Unit Tests | JUnit 5 + Mockito | Test individual components in isolation |
| CRUD API Tests | JUnit 5 + Real DB | Test API endpoints with database |
| Integration Tests | JUnit + Testcontainers | Test with real databases |
| Code Coverage | JaCoCo + CodeCov | Measure test coverage |
| Mutation Tests | PITest | Test quality assessment |
| Micro Performance | JMH | Benchmark critical methods |
| System Performance | JMeter/Gatling | Load/Stress testing |

---

## Testing Types

### 1. Unit Tests (JUnit 5 + Mockito)

**Purpose:** Test individual components in isolation with mocked dependencies.

**Location:** `src/test/java/.../unit/`

**Example:**
```java
@ExtendWith(MockitoExtension.class)
class OwnerServiceUnitTest {
    @Mock
    private OwnerRepository repository;
    
    @Test
    void shouldFindOwnerById() {
        // Test implementation
    }
}
```

**Run:**
```bash
./mvnw test -Dtest=*UnitTest
```

### 2. CRUD API Tests (JUnit 5 + Real DB)

**Purpose:** Test full CRUD operations through API endpoints with real database.

**Location:** `src/test/java/.../api/`

**Example:**
```java
@SpringBootTest
@AutoConfigureWebMvc
@Transactional
class OwnerCrudApiTest {
    @Autowired
    private MockMvc mockMvc;
    
    @Test
    void shouldCreateNewOwner() {
        // Test implementation
    }
}
```

**Run:**
```bash
./mvnw test -Dtest=*ApiTest
```

### 3. Integration Tests (JUnit + Real DB)

**Purpose:** Test application with real databases using Testcontainers.

**Location:** `src/test/java/.../integration/`

**Existing Tests:**
- `PetClinicIntegrationTests` - H2 database
- `MySqlIntegrationTests` - MySQL with Testcontainers
- `PostgresIntegrationTests` - PostgreSQL with Docker Compose

**Run:**
```bash
./mvnw test -Dtest=*IntegrationTest
```

### 4. Code Coverage (JaCoCo)

**Purpose:** Measure how much of your code is covered by tests.

**Generate Report:**
```bash
./mvnw clean test jacoco:report
```

**View Report:**
Open `target/site/jacoco/index.html` in browser.

**Coverage Goals:**
- Line Coverage: > 80%
- Branch Coverage: > 75%
- Method Coverage: > 80%

### 5. Mutation Testing (PITest)

**Purpose:** Assess test quality by introducing mutations and checking if tests catch them.

**Run:**
```bash
./mvnw test org.pitest:pitest-maven:mutationCoverage
```

**View Report:**
Open `target/pit-reports/index.html` in browser.

**Interpretation:**
- **Killed:** Mutation was caught by tests ✅
- **Survived:** Mutation wasn't caught ❌ (improve tests)
- **No Coverage:** Code not executed by tests

### 6. Micro Performance (JMH)

**Purpose:** Benchmark critical methods to measure and optimize performance.

**Location:** `src/test/java/.../performance/micro/`

**Run:**
```bash
# Build benchmarks
./mvnw clean package

# Run benchmarks
java -jar target/benchmarks.jar
```

**Or via Maven:**
```bash
./mvnw exec:java -Dexec.mainClass="org.openjdk.jmh.Main" \
  -Dexec.args=".*Benchmark.*"
```

### 7. System Performance Tests

**Purpose:** Test application under load (Load, Stress, Spike, Soak tests).

**Tools:**
- **JMeter** - Load testing
- **Gatling** - Performance testing
- **Apache Bench (ab)** - Simple load testing

**Example JMeter Test:**
```bash
# Run JMeter test plan
jmeter -n -t src/test/jmeter/petclinic_test_plan.jmx -l results.jtl
```

**Types:**
- **Load Test:** Normal expected load
- **Stress Test:** Beyond normal capacity
- **Spike Test:** Sudden load increases
- **Soak Test:** Sustained load over time

---

## Running Tests

### Run All Tests
```bash
./mvnw clean test
```

### Run Specific Test Type
```bash
# Unit tests only
./mvnw test -Dtest=*UnitTest

# API tests only
./mvnw test -Dtest=*ApiTest

# Integration tests only
./mvnw test -Dtest=*IntegrationTest
```

### Run with Coverage
```bash
./mvnw clean test jacoco:report
```

### Run Mutation Tests
```bash
./mvnw test org.pitest:pitest-maven:mutationCoverage
```

### Run Performance Benchmarks
```bash
./mvnw clean package
java -jar target/benchmarks.jar
```

---

## Test Examples

### Unit Test Example

See: `src/test/java/.../unit/owner/OwnerServiceUnitTest.java`

**Key Points:**
- Use `@Mock` for dependencies
- Use `@InjectMocks` for class under test
- Verify interactions with `verify()`
- Use AssertJ for fluent assertions

### CRUD API Test Example

See: `src/test/java/.../api/owner/OwnerCrudApiTest.java`

**Key Points:**
- Use `@SpringBootTest` for full context
- Use `MockMvc` for HTTP testing
- Use `@Transactional` for test isolation
- Test all CRUD operations

### Integration Test Example

See existing: `src/test/java/.../PetClinicIntegrationTests.java`

**Key Points:**
- Use Testcontainers for real databases
- Test end-to-end scenarios
- Verify database state

---

## Best Practices

### 1. Test Structure (AAA Pattern)

```java
@Test
void shouldDoSomething() {
    // Arrange - Set up test data
    Owner owner = new Owner();
    owner.setFirstName("John");
    
    // Act - Execute the code
    Owner saved = repository.save(owner);
    
    // Assert - Verify results
    assertThat(saved.getId()).isNotNull();
}
```

### 2. Test Naming

Use descriptive names:
- ✅ `shouldReturnOwnerWhenIdExists()`
- ❌ `test1()`

### 3. Test Isolation

- Each test should be independent
- Use `@BeforeEach` for setup
- Use `@AfterEach` for cleanup
- Use `@Transactional` for database tests

### 4. Mocking Guidelines

- Mock external dependencies (databases, APIs)
- Don't mock the class under test
- Verify important interactions
- Use `@Mock` and `@InjectMocks`

### 5. Assertions

Prefer AssertJ over JUnit assertions:
```java
// ✅ Good
assertThat(result).isNotNull();
assertThat(list).hasSize(3);

// ❌ Less readable
assertNotNull(result);
assertEquals(3, list.size());
```

### 6. Test Coverage

- Aim for 80%+ line coverage
- Focus on business logic
- Don't test getters/setters
- Test edge cases and error scenarios

---

## TDD (Test-Driven Development)

### Process

1. **Red:** Write a failing test
2. **Green:** Write minimal code to pass
3. **Refactor:** Improve code while keeping tests green

### Example TDD Cycle

```java
// 1. Write failing test
@Test
void shouldCalculatePetAge() {
    Pet pet = new Pet();
    pet.setBirthDate(LocalDate.now().minusYears(5));
    assertThat(pet.getAge()).isEqualTo(5);
}

// 2. Implement minimal code
public int getAge() {
    return Period.between(birthDate, LocalDate.now()).getYears();
}

// 3. Refactor if needed
```

---

## CI/CD Integration

### Current CI Workflow

The CI workflow runs:
1. **Format & Compile** - Code formatting and compilation
2. **Test & Coverage** - All tests with coverage
3. **Build Docker** - Docker image build

### Adding Test Reports

Test results are automatically uploaded as artifacts:
- Test reports: `target/surefire-reports/`
- Coverage reports: `target/site/jacoco/`

### Viewing Results

1. Go to GitHub Actions
2. Click on a workflow run
3. Download artifacts to view reports

---

## Performance Testing Guide

### Load Testing Scenarios

1. **Normal Load:** 100 concurrent users
2. **Peak Load:** 500 concurrent users
3. **Stress Test:** 1000+ concurrent users

### Key Metrics

- **Response Time:** < 200ms (p95)
- **Throughput:** Requests per second
- **Error Rate:** < 1%
- **Resource Usage:** CPU, Memory, Database connections

### Tools Setup

**JMeter:**
```bash
# Install JMeter
brew install jmeter  # macOS
# or download from https://jmeter.apache.org/

# Run test plan
jmeter -n -t test-plan.jmx -l results.jtl
```

**Gatling:**
```bash
# Add to pom.xml (if using Maven)
# Run via Maven plugin
./mvnw gatling:test
```

---

## Troubleshooting

### Tests Failing

1. Check database connection
2. Verify test data setup
3. Check for timing issues (use `@Timeout`)
4. Review test isolation

### Coverage Low

1. Add tests for untested code paths
2. Focus on business logic first
3. Use mutation testing to find gaps

### Performance Issues

1. Run benchmarks to identify bottlenecks
2. Profile with JProfiler or VisualVM
3. Optimize based on benchmark results

---

## Next Steps

1. ✅ Add missing dependencies
2. ✅ Create example tests
3. ⏳ Expand test coverage
4. ⏳ Add more performance tests
5. ⏳ Set up CI/CD test reporting
6. ⏳ Create load test scenarios

---

## Resources

- [JUnit 5 Documentation](https://junit.org/junit5/docs/current/user-guide/)
- [Mockito Documentation](https://javadoc.io/doc/org.mockito/mockito-core/latest/org/mockito/Mockito.html)
- [PITest Documentation](https://pitest.org/)
- [JMH Documentation](https://github.com/openjdk/jmh)
- [JaCoCo Documentation](https://www.jacoco.org/jacoco/trunk/doc/)

---

**Happy Testing! 🧪**

