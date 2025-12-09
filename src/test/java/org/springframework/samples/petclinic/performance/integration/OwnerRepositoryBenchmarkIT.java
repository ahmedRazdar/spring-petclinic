/*
 * Integration Test for Owner Repository Benchmarks
 *
 * This test runs the JMH benchmarks in a Spring Boot integration test context.
 * It provides database-backed performance measurements for Owner repository operations.
 */

package org.springframework.samples.petclinic.performance.integration;

import org.junit.jupiter.api.Test;
import org.openjdk.jmh.results.format.ResultFormatType;
import org.openjdk.jmh.runner.Runner;
import org.openjdk.jmh.runner.RunnerException;
import org.openjdk.jmh.runner.options.Options;
import org.openjdk.jmh.runner.options.OptionsBuilder;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

@SpringBootTest
@ActiveProfiles("test")
public class OwnerRepositoryBenchmarkIT {

	@Test
	public void runOwnerRepositoryBenchmarks() throws RunnerException {
		System.out.println("🚀 Running Owner Repository Integration Benchmarks");
		System.out.println("==================================================");

		Options opt = new OptionsBuilder().include(OwnerRepositoryBenchmark.class.getSimpleName())
			.result("target/jmh-owner-repository-results.json")
			.resultFormat(ResultFormatType.JSON)
			.build();

		new Runner(opt).run();

		System.out.println("✅ Owner repository benchmarks completed!");
		System.out.println("📊 Results saved to: target/jmh-owner-repository-results.json");
	}

}
