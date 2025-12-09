package org.springframework.samples.petclinic.performance;

import org.springframework.samples.petclinic.owner.Owner;

import java.util.ArrayList;
import java.util.List;

/**
 * Simple benchmark demo to show performance testing results without requiring JMH setup
 */
public class SimpleBenchmarkDemo {

	private List<Owner> owners;

	private Owner testOwner;

	private Integer testId;

	private String testLastName;

	public static void main(String[] args) {
		System.out.println("🚀 Spring PetClinic Performance Benchmark Demo");
		System.out.println("=============================================");
		System.out.println();

		SimpleBenchmarkDemo demo = new SimpleBenchmarkDemo();
		demo.setup();
		demo.runBenchmarks();
		demo.tearDown();

		System.out.println();
		System.out.println("✅ Benchmark demo completed!");
	}

	public void setup() {
		System.out.println("📋 Setting up test data...");

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

		System.out.println("✅ Setup complete - " + owners.size() + " test owners created");
	}

	public void runBenchmarks() {
		System.out.println("\n📊 Running Performance Benchmarks");
		System.out.println("==================================");
		System.out.println("Method                     | Avg Time (μs) | Operations/sec");
		System.out.println("--------------------------|---------------|----------------");

		runBenchmark("Find by ID", this::benchmarkFindById);
		runBenchmark("Find by Last Name", this::benchmarkFindByLastName);
		runBenchmark("Save Operation", this::benchmarkSave);
		runBenchmark("Find All", this::benchmarkFindAll);
		runBenchmark("Count Operation", this::benchmarkCount);
		runBenchmark("Exists Check", this::benchmarkExists);
	}

	private void runBenchmark(String name, Runnable operation) {
		int iterations = 10000;
		long totalTime = 0;

		// Warmup
		for (int i = 0; i < 1000; i++) {
			operation.run();
		}

		// Actual benchmark
		for (int i = 0; i < iterations; i++) {
			long start = System.nanoTime();
			operation.run();
			long end = System.nanoTime();
			totalTime += (end - start);
		}

		double avgTimeMicroseconds = (totalTime / iterations) / 1000.0;
		double opsPerSecond = 1000000.0 / avgTimeMicroseconds;

		System.out.printf("%-25s | %11.2f   | %12.0f%n", name, avgTimeMicroseconds, opsPerSecond);
	}

	// Benchmark methods
	public void benchmarkFindById() {
		owners.stream().filter(o -> o.getId() != null && o.getId().equals(testId)).findFirst();
	}

	public void benchmarkFindByLastName() {
		List<Owner> results = new ArrayList<>();
		for (Owner owner : owners) {
			if (owner.getLastName() != null && owner.getLastName().startsWith(testLastName)) {
				results.add(owner);
			}
		}
	}

	public void benchmarkSave() {
		Owner newOwner = new Owner();
		newOwner.setId(owners.size() + 1);
		newOwner.setFirstName(testOwner.getFirstName());
		newOwner.setLastName(testOwner.getLastName());
		newOwner.setAddress(testOwner.getAddress());
		newOwner.setCity(testOwner.getCity());
		newOwner.setTelephone(testOwner.getTelephone());
		owners.add(newOwner);
		// Remove it to keep test data consistent
		owners.remove(owners.size() - 1);
	}

	public void benchmarkFindAll() {
		new ArrayList<>(owners);
	}

	public void benchmarkCount() {
		owners.size();
	}

	public void benchmarkExists() {
		owners.stream().anyMatch(o -> o.getId() != null && o.getId().equals(testId));
	}

	public void tearDown() {
		System.out.println("\n🧹 Cleaning up test data...");
		owners.clear();
		System.out.println("✅ Cleanup complete");
	}

}
