# 🚀 Spring PetClinic Performance Monitoring

This document describes the comprehensive performance monitoring system implemented for the Spring PetClinic project.

## 📊 Overview

The performance monitoring system includes:

- **JMH Micro-Benchmarks**: In-memory performance testing
- **Integration Benchmarks**: Database and Spring context testing
- **Performance Regression Detection**: Automated performance gates
- **Visual Dashboard**: Charts and trends for performance metrics
- **CI/CD Integration**: Automated benchmark execution and reporting

## 🏃 Benchmark Types

### 1. Micro-Benchmarks (`OwnerRepositoryBenchmark`)
- **Location**: `src/test/java/.../performance/micro/OwnerRepositoryBenchmark.java`
- **Purpose**: Measure individual operation performance without external dependencies
- **Operations**:
  - `benchmarkCount()` - Collection size operations
  - `benchmarkExists()` - Existence checks
  - `benchmarkFindById()` - ID-based lookups
  - `benchmarkFindByLastName()` - Pattern matching
  - `benchmarkSave()` - Object creation
  - `benchmarkFindAll()` - Bulk retrieval

### 2. Integration Benchmarks (`OwnerServiceBenchmark`)
- **Location**: `src/test/java/.../performance/integration/OwnerServiceBenchmark.java`
- **Purpose**: Measure real-world performance with database and Spring context
- **Operations**:
  - `benchmarkFindOwnerById()` - Service layer ID lookups
  - `benchmarkFindOwnerByLastName()` - Service layer searches
  - `benchmarkFindAllOwners()` - Full owner list retrieval
  - `benchmarkSaveOwner()` - Owner creation with validation
  - `benchmarkUpdateOwner()` - Owner updates
  - `benchmarkDeleteOwner()` - Owner deletion

## 🔧 Running Benchmarks

### Local Execution

#### Micro-Benchmarks (Fast, no database required)
```bash
# Run via Maven exec
./mvnw exec:java -Dexec.mainClass="org.openjdk.jmh.Main" \
  -Dexec.args=".*OwnerRepositoryBenchmark.*"

# Run via main method
./mvnw exec:java -Dexec.mainClass="org.springframework.samples.petclinic.performance.micro.OwnerRepositoryBenchmark"
```

#### Integration Benchmarks (Requires database)
```bash
# Run as integration test
./mvnw test -Dtest=OwnerServiceBenchmarkIT

# Run via main method (if implemented)
./mvnw exec:java -Dexec.mainClass="org.springframework.samples.petclinic.performance.integration.OwnerServiceBenchmarkIT"
```

### CI/CD Execution

Benchmarks run automatically on:
- **Push to main branch**
- **Pull requests**
- **Manual workflow dispatch**

Results are available as GitHub Actions artifacts:
- `jmh-benchmark-results` - Raw benchmark output
- `jmh-raw-output` - JMH text results
- `performance-dashboard` - Visual dashboard

## 📈 Performance Regression Detection

### Automated Gates
- **Regression Threshold**: 10% performance degradation
- **Improvement Threshold**: 5% performance improvement
- **Build Failure**: Regressions > 10% fail the build

### Baseline Management
```bash
# Check current baseline
cat benchmark-results/performance-baseline.json

# Update baseline (after confirming improvements)
UPDATE_BASELINE=true ./scripts/performance-regression-check.sh
```

### Regression Analysis
The system compares current results against stored baselines and reports:
- ✅ **Improvements**: Performance gains above threshold
- ❌ **Regressions**: Performance losses above threshold
- ✅ **Stable**: Performance within acceptable range

## 📊 Visual Dashboard

### Features
- **Real-time Metrics**: Live performance statistics
- **Interactive Charts**: Chart.js visualizations
- **Performance Trends**: Historical performance tracking
- **Regression Alerts**: Automatic detection notifications
- **Benchmark Details**: Detailed per-operation metrics

### Accessing the Dashboard
```bash
# Generate locally
./scripts/generate-performance-dashboard.sh

# View in browser
# Open: performance-dashboard/index.html
```

### Dashboard Sections
1. **Performance Summary** - Key metrics and trends
2. **Benchmark Charts** - Visual performance comparisons
3. **Trend Analysis** - Performance over time
4. **Detailed Results** - Per-benchmark breakdowns
5. **Performance History** - Historical run data

## 🛠️ Configuration

### JMH Configuration
```xml
<!-- In pom.xml -->
<plugin>
  <groupId>org.openjdk.jmh</groupId>
  <artifactId>jmh-core</artifactId>
  <version>1.37</version>
</plugin>
```

### Benchmark Annotations
```java
@BenchmarkMode(Mode.AverageTime)
@OutputTimeUnit(TimeUnit.MICROSECONDS)
@Warmup(iterations = 3, time = 1, timeUnit = TimeUnit.SECONDS)
@Measurement(iterations = 5, time = 1, timeUnit = TimeUnit.SECONDS)
@Fork(1)
public class BenchmarkClass {
    // Benchmark methods here
}
```

### CI/CD Configuration
```yaml
# In .github/workflows/maven-build.yml
- name: Run JMH Benchmarks
  run: |
    ./mvnw exec:java -Dexec.mainClass="org.openjdk.jmh.Main" \
      -Dexec.args="-f 1 -wi 3 -i 5 -bm avgt -tu us .*Benchmark.* -o results.txt"

- name: Performance Regression Check
  run: ./scripts/performance-regression-check.sh
```

## 📋 Interpreting Results

### JMH Output Format
```
Benchmark                                                    Mode  Cnt    Score    Error   Units
BenchmarkClass.benchmarkMethod                              avgt   25    1.234 ±  0.056   μs/op
```

- **Mode**: Benchmark mode (avgt = average time)
- **Cnt**: Number of measurement iterations
- **Score**: Average execution time
- **Error**: Standard deviation
- **Units**: Time unit (μs/op = microseconds per operation)

### Performance Categories
- **⭐ Excellent**: < 0.5 μs/op
- **✅ Good**: 0.5-1.0 μs/op
- **⚠️ Fair**: 1.0-2.0 μs/op
- **❌ Needs Optimization**: > 2.0 μs/op

## 🔍 Troubleshooting

### Common Issues

1. **Benchmarks not running**
   ```bash
   # Check JMH dependencies
   ./mvnw dependency:tree | grep jmh

   # Verify compilation
   ./mvnw compile test-compile
   ```

2. **Database connection issues**
   ```bash
   # Check test database configuration
   cat src/main/resources/application.properties

   # Run with debug logging
   ./mvnw test -Dtest=BenchmarkIT -Dlogging.level.org.springframework=DEBUG
   ```

3. **Performance regression false positives**
   ```bash
   # Review baseline data
   cat benchmark-results/performance-baseline.json

   # Update baseline if needed
   UPDATE_BASELINE=true ./scripts/performance-regression-check.sh
   ```

### Debug Commands
```bash
# List available benchmarks
./mvnw exec:java -Dexec.mainClass="org.openjdk.jmh.Main" -Dexec.args="-l"

# Run with verbose output
./mvnw exec:java -Dexec.mainClass="org.openjdk.jmh.Main" \
  -Dexec.args="-v EXTRA .*Benchmark.*"

# Profile benchmark execution
./mvnw exec:java -Dexec.mainClass="org.openjdk.jmh.Main" \
  -Dexec.args="-prof gc .*Benchmark.*"
```

## 📈 Performance Optimization Tips

### Code-Level Optimizations
1. **Minimize object creation** in hot paths
2. **Use primitive types** when possible
3. **Cache frequently accessed data**
4. **Optimize collection operations**
5. **Reduce method call depth**

### Database Optimizations
1. **Use appropriate indexes**
2. **Optimize SQL queries**
3. **Implement connection pooling**
4. **Use lazy loading strategically**
5. **Cache query results**

### JVM Optimizations
1. **Tune garbage collection**
2. **Adjust heap sizes**
3. **Use appropriate JVM flags**
4. **Profile memory usage**

## 📊 Metrics and KPIs

### Key Performance Indicators
- **Response Time**: Average operation execution time
- **Throughput**: Operations per second
- **Regression Rate**: Percentage of performance regressions
- **Improvement Rate**: Percentage of performance improvements
- **Stability Score**: Consistency of performance over time

### Monitoring Thresholds
- **Critical**: > 20% performance degradation
- **Warning**: 10-20% performance degradation
- **Acceptable**: < 10% performance variation

## 🤝 Contributing

When adding new benchmarks:

1. **Follow JMH best practices**
2. **Include proper warmup and measurement phases**
3. **Add meaningful benchmark names**
4. **Document performance expectations**
5. **Update baseline after validation**

When modifying existing benchmarks:

1. **Ensure backward compatibility**
2. **Update documentation**
3. **Validate against existing baselines**
4. **Test in CI/CD environment**

---

## 📚 Additional Resources

- [JMH Documentation](https://openjdk.java.net/projects/code-tools/jmh/)
- [JMH Samples](https://hg.openjdk.java.net/code-tools/jmh/file/tip/jmh-samples/src/main/java/org/openjdk/jmh/samples/)
- [Performance Testing Best Practices](https://www.oracle.com/technetwork/articles/java/architect-perf-tests-196863.html)

---

**Last Updated:** December 2024
**Performance Monitoring Version:** 2.0
