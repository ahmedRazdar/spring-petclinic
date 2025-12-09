/*
 * Integration Test for OwnerService Benchmarks
 *
 * This test runs the JMH benchmarks in a Spring Boot integration test context.
 * It provides database-backed performance measurements for OwnerService operations.
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
public class OwnerServiceBenchmarkIT {

    @Test
    public void runOwnerServiceBenchmarks() throws RunnerException {
        System.out.println("🚀 Running OwnerService Integration Benchmarks");
        System.out.println("==============================================");

        Options opt = new OptionsBuilder()
                .include(OwnerServiceBenchmark.class.getSimpleName())
                .result("target/jmh-owner-service-results.json")
                .resultFormat(ResultFormatType.JSON)
                .build();

        new Runner(opt).run();

        System.out.println("✅ OwnerService benchmarks completed!");
        System.out.println("📊 Results saved to: target/jmh-owner-service-results.json");
    }
}
