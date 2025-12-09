@echo off
echo Running Spring PetClinic Performance Benchmarks
echo ==============================================

cd /d "%~dp0"

echo Setting up classpath...
for /f "tokens=*" %%i in ('.\mvnw dependency:build-classpath -q -Dmdep.outputFile=/dev/stdout') do set CLASSPATH=%%i

echo Classpath: %CLASSPATH%

echo.
echo Running SimpleBenchmarkDemo...
java -cp "target/classes;target/test-classes;%CLASSPATH%" org.springframework.samples.petclinic.performance.SimpleBenchmarkDemo

echo.
echo Benchmark execution completed!
pause
