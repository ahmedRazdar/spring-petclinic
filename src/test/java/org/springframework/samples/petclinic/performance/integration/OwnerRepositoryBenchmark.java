/*
 * Spring Boot Integration Benchmark
 *
 * This benchmark tests OwnerService operations with full Spring context
 * and database interactions for realistic performance measurements.
 *
 * Run with: ./mvnw test -Dtest=OwnerServiceBenchmarkIT
 */

package org.springframework.samples.petclinic.performance.integration;

import org.junit.jupiter.api.BeforeEach;
import org.openjdk.jmh.annotations.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.data.domain.Pageable;
import org.springframework.samples.petclinic.owner.Owner;
import org.springframework.samples.petclinic.owner.OwnerRepository;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.concurrent.TimeUnit;

/**
 * Integration benchmarks for Owner repository operations with database interactions.
 * Measures real-world performance including Spring context and DB interactions. Tests JPA
 * repository methods within full Spring Boot context.
 */
@SpringBootTest
@ActiveProfiles("test")
@State(Scope.Benchmark)
@BenchmarkMode(Mode.AverageTime)
@OutputTimeUnit(TimeUnit.MILLISECONDS)
@Warmup(iterations = 2, time = 2, timeUnit = TimeUnit.SECONDS)
@Measurement(iterations = 3, time = 2, timeUnit = TimeUnit.SECONDS)
@Fork(1)
@Transactional
public class OwnerRepositoryBenchmark {

	@Autowired
	private OwnerRepository ownerRepository;

	private Owner testOwner;

	private Integer testOwnerId;

	private String testLastName;

	@Setup(Level.Iteration)
	public void setup() {
		// Clean up any existing test data
		ownerRepository.deleteAll();

		// Create test data
		testLastName = "BenchmarkTest";

		for (int i = 1; i <= 50; i++) {
			Owner owner = new Owner();
			owner.setFirstName("Benchmark" + i);
			owner.setLastName(testLastName + i);
			owner.setAddress("Benchmark Address " + i);
			owner.setCity("Benchmark City " + i);
			owner.setTelephone("1234567890");

			Owner saved = ownerRepository.save(owner);
			if (i == 25) {
				testOwnerId = saved.getId();
				testOwner = saved;
			}
		}
	}

	@TearDown(Level.Iteration)
	public void tearDown() {
		// Clean up test data
		ownerRepository.deleteAll();
	}

	@Benchmark
	public Owner benchmarkFindById() {
		return ownerRepository.findById(testOwnerId).orElse(null);
	}

	@Benchmark
	public List<Owner> benchmarkFindByLastNameStartingWith() {
		return ownerRepository
			.findByLastNameStartingWith(testLastName + "2", org.springframework.data.domain.Pageable.unpaged())
			.getContent();
	}

	@Benchmark
	public List<Owner> benchmarkFindAll() {
		return (List<Owner>) ownerRepository.findAll();
	}

	@Benchmark
	public Owner benchmarkSave() {
		Owner newOwner = new Owner();
		newOwner.setFirstName("NewBenchmark");
		newOwner.setLastName("NewBenchmarkLast");
		newOwner.setAddress("New Benchmark Address");
		newOwner.setCity("New Benchmark City");
		newOwner.setTelephone("0987654321");

		return ownerRepository.save(newOwner);
	}

	@Benchmark
	public void benchmarkUpdate() {
		testOwner.setCity("Updated Benchmark City");
		ownerRepository.save(testOwner);
	}

	@Benchmark
	public void benchmarkDelete() {
		Owner ownerToDelete = new Owner();
		ownerToDelete.setFirstName("DeleteBenchmark");
		ownerToDelete.setLastName("DeleteBenchmarkLast");
		ownerToDelete.setAddress("Delete Benchmark Address");
		ownerToDelete.setCity("Delete Benchmark City");
		ownerToDelete.setTelephone("1111111111");

		Owner saved = ownerRepository.save(ownerToDelete);
		ownerRepository.deleteById(saved.getId());
	}

}
