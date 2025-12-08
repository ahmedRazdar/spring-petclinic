/*
 * JMH Micro-Benchmark Example
 * 
 * This demonstrates micro-performance testing using JMH.
 * 
 * To run:
 * 1. mvn clean package
 * 2. java -jar target/benchmarks.jar
 * 
 * Or use: mvn exec:java -Dexec.mainClass="org.openjdk.jmh.Main" -Dexec.args=".*OwnerRepositoryBenchmark.*"
 */

package org.springframework.samples.petclinic.performance.micro;

import org.openjdk.jmh.annotations.*;
import org.openjdk.jmh.runner.Runner;
import org.openjdk.jmh.runner.RunnerException;
import org.openjdk.jmh.runner.options.Options;
import org.openjdk.jmh.runner.options.OptionsBuilder;
import org.springframework.samples.petclinic.owner.Owner;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.concurrent.TimeUnit;

/**
 * JMH benchmarks for OwnerRepository operations.
 * Measures micro-performance of critical operations using in-memory data structures.
 * 
 * Note: This benchmark uses in-memory collections to measure basic operation performance
 * without requiring a full Spring context or database connection.
 */
@BenchmarkMode(Mode.AverageTime)
@OutputTimeUnit(TimeUnit.MICROSECONDS)
@State(Scope.Benchmark)
@Warmup(iterations = 3, time = 1, timeUnit = TimeUnit.SECONDS)
@Measurement(iterations = 5, time = 1, timeUnit = TimeUnit.SECONDS)
@Fork(1)
public class OwnerRepositoryBenchmark {

    private List<Owner> owners;

    private Owner testOwner;

    private Integer testId;

    private String testLastName;

    @Setup
    public void setup() {
        // Initialize test data
        owners = new ArrayList<>();
        testId = 1;
        testLastName = "Davis";

        // Create test owners
        for (int i = 1; i <= 100; i++) {
            Owner owner = new Owner();
            owner.setId(i);
            owner.setFirstName("First" + i);
            owner.setLastName("Last" + i);
            owner.setAddress("Address " + i);
            owner.setCity("City " + i);
            owner.setTelephone("1234567890");
            owners.add(owner);
        }

        // Add some owners with same last name prefix
        for (int i = 1; i <= 10; i++) {
            Owner owner = new Owner();
            owner.setId(100 + i);
            owner.setFirstName("Test" + i);
            owner.setLastName("Davis" + i);
            owner.setAddress("Test Address " + i);
            owner.setCity("Test City " + i);
            owner.setTelephone("1234567890");
            owners.add(owner);
        }

        // Create a test owner for save operations
        testOwner = new Owner();
        testOwner.setFirstName("Benchmark");
        testOwner.setLastName("Test");
        testOwner.setAddress("Benchmark Address");
        testOwner.setCity("Benchmark City");
        testOwner.setTelephone("1234567890");
    }

    @TearDown
    public void tearDown() {
        // Cleanup after benchmarks
        owners.clear();
    }

    @Benchmark
    public Optional<Owner> benchmarkFindById() {
        // Benchmark finding owner by ID (simulating repository.findById)
        return owners.stream().filter(o -> o.getId() != null && o.getId().equals(testId)).findFirst();
    }

    @Benchmark
    public List<Owner> benchmarkFindByLastName() {
        // Benchmark finding owners by last name (simulating repository.findByLastNameStartingWith)
        List<Owner> results = new ArrayList<>();
        for (Owner owner : owners) {
            if (owner.getLastName() != null && owner.getLastName().startsWith(testLastName)) {
                results.add(owner);
            }
        }
        return results;
    }

    @Benchmark
    public Owner benchmarkSave() {
        // Benchmark saving an owner (simulating repository.save)
        // Create a new owner and add to list
        Owner newOwner = new Owner();
        newOwner.setId(owners.size() + 1);
        newOwner.setFirstName(testOwner.getFirstName());
        newOwner.setLastName(testOwner.getLastName());
        newOwner.setAddress(testOwner.getAddress());
        newOwner.setCity(testOwner.getCity());
        newOwner.setTelephone(testOwner.getTelephone());
        owners.add(newOwner);
        return newOwner;
    }

    @Benchmark
    public List<Owner> benchmarkFindAll() {
        // Benchmark finding all owners (simulating repository.findAll)
        return new ArrayList<>(owners);
    }

    @Benchmark
    public int benchmarkCount() {
        // Benchmark counting owners (simulating repository.count)
        return owners.size();
    }

    @Benchmark
    public boolean benchmarkExists() {
        // Benchmark checking if owner exists (simulating repository.existsById)
        return owners.stream().anyMatch(o -> o.getId() != null && o.getId().equals(testId));
    }

    /**
     * Main method to run benchmarks. Can be executed directly or via Maven.
     */
    public static void main(String[] args) throws RunnerException {
        Options opt = new OptionsBuilder().include(OwnerRepositoryBenchmark.class.getSimpleName()).forks(1).build();

        new Runner(opt).run();
    }

}

