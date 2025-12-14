/*
 * Integration Test for Owner Repository Benchmarks
 *
 * This test runs the JMH benchmarks in a Spring Boot integration test context.
 * It provides database-backed performance measurements for Owner repository operations.
 */

package org.springframework.samples.petclinic.performance.integration;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;
import org.openjdk.jmh.results.format.ResultFormatType;
import org.openjdk.jmh.runner.Runner;
import org.openjdk.jmh.runner.RunnerException;
import org.openjdk.jmh.runner.options.Options;
import org.openjdk.jmh.runner.options.OptionsBuilder;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

import java.io.File;
import java.nio.file.Path;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
@ActiveProfiles("test")
public class OwnerRepositoryBenchmarkIT {

	@Test
	public void runOwnerRepositoryBenchmarks(@TempDir Path tempDir) throws RunnerException {
		System.out.println("🚀 Running Owner Repository Integration Benchmarks");
		System.out.println("==================================================");

		// Create results file path
		File resultsFile = new File("target/jmh-owner-repository-results.json");

		Options opt = new OptionsBuilder().include(OwnerRepositoryBenchmark.class.getSimpleName())
			.result(resultsFile.getPath())
			.resultFormat(ResultFormatType.JSON)
			.build();

		// Run benchmarks - should complete without throwing exceptions
		new Runner(opt).run();

		// Verify benchmarks completed successfully
		assertThat(resultsFile).exists();
		assertThat(resultsFile.length()).isGreaterThan(0);

		System.out.println("✅ Owner repository benchmarks completed!");
		System.out.println("📊 Results saved to: " + resultsFile.getPath());
		assertThat(resultsFile.getName()).isEqualTo("jmh-owner-repository-results.json");
	}

}
