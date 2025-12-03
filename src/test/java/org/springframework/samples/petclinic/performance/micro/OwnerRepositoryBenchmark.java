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
import org.springframework.samples.petclinic.owner.OwnerRepository;

import java.util.concurrent.TimeUnit;

/**
 * JMH benchmarks for OwnerRepository operations.
 * Measures micro-performance of critical database operations.
 */
@BenchmarkMode(Mode.AverageTime)
@OutputTimeUnit(TimeUnit.MICROSECONDS)
@State(Scope.Benchmark)
@Warmup(iterations = 3, time = 1, timeUnit = TimeUnit.SECONDS)
@Measurement(iterations = 5, time = 1, timeUnit = TimeUnit.SECONDS)
@Fork(1)
public class OwnerRepositoryBenchmark {

	// Note: In a real benchmark, you would inject the repository
	// This is a template showing the structure

	@Setup
	public void setup() {
		// Initialize test data
		// This runs once before all benchmark iterations
	}

	@TearDown
	public void tearDown() {
		// Cleanup after benchmarks
		// This runs once after all benchmark iterations
	}

	@Benchmark
	public void benchmarkFindById() {
		// Benchmark finding owner by ID
		// Example:
		// ownerRepository.findById(1);
	}

	@Benchmark
	public void benchmarkFindByLastName() {
		// Benchmark finding owners by last name
		// Example:
		// ownerRepository.findByLastNameStartingWith("Doe", pageable);
	}

	@Benchmark
	public void benchmarkSave() {
		// Benchmark saving an owner
		// Example:
		// Owner owner = new Owner();
		// owner.setFirstName("Test");
		// ownerRepository.save(owner);
	}

	@Benchmark
	public void benchmarkFindAll() {
		// Benchmark finding all owners
		// Example:
		// ownerRepository.findAll();
	}

	/**
	 * Main method to run benchmarks.
	 * Can be executed directly or via Maven.
	 */
	public static void main(String[] args) throws RunnerException {
		Options opt = new OptionsBuilder()
			.include(OwnerRepositoryBenchmark.class.getSimpleName())
			.forks(1)
			.build();

		new Runner(opt).run();
	}

}

