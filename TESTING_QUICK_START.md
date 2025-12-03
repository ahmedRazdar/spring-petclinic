# Testing Quick Start Guide

## 🚀 Quick Commands

### Run All Tests
```bash
./mvnw clean test
```

### Run Specific Test Types
```bash
# Unit tests
./mvnw test -Dtest=*UnitTest

# API/CRUD tests
./mvnw test -Dtest=*ApiTest

# Integration tests
./mvnw test -Dtest=*IntegrationTest
```

### Generate Coverage Report
```bash
./mvnw clean test jacoco:report
# Open: target/site/jacoco/index.html
```

### Run Mutation Tests
```bash
./mvnw test org.pitest:pitest-maven:mutationCoverage
# Open: target/pit-reports/index.html
```

### Run Performance Benchmarks
```bash
./mvnw clean package
java -jar target/benchmarks.jar
```

## 📁 Test Structure

```
src/test/java/org/springframework/samples/petclinic/
├── unit/              # Unit tests with mocks
│   └── owner/
│       └── OwnerServiceUnitTest.java
├── api/               # CRUD API tests
│   └── owner/
│       └── OwnerCrudApiTest.java
├── integration/       # Integration tests (existing)
├── performance/       # Performance tests
│   └── micro/
│       └── OwnerRepositoryBenchmark.java
└── [existing tests]   # Original test structure
```

## ✅ Implementation Status

- [x] Dependencies added (Mockito, PITest, JMH)
- [x] Unit test example created
- [x] CRUD API test example created
- [x] JMH benchmark example created
- [x] CI workflow updated
- [x] Documentation created

## 📝 Next Steps

1. Expand unit tests for all services
2. Add more CRUD API tests
3. Implement JMH benchmarks
4. Add system performance tests
5. Achieve 80%+ code coverage

## 📚 Full Documentation

See [TESTING_GUIDE.md](TESTING_GUIDE.md) for comprehensive documentation.

