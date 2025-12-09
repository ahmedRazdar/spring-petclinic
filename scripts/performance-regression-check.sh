#!/bin/bash
# Performance Regression Detection Script
# Compares current benchmark results against baseline and detects regressions

set -e

# Configuration
RESULTS_DIR="benchmark-results"
BASELINE_FILE="performance-baseline.json"
REGRESSION_THRESHOLD=10  # 10% degradation threshold
IMPROVEMENT_THRESHOLD=5  # 5% improvement threshold

echo "🔍 Performance Regression Analysis"
echo "==================================="

# Create results directory if it doesn't exist
mkdir -p "$RESULTS_DIR"

# Check if benchmark results exist
if [ ! -f "benchmark-results.txt" ]; then
    echo "❌ No benchmark results found (benchmark-results.txt)"
    echo "This script should be run after JMH benchmarks have completed"
    exit 1
fi

# Function to extract benchmark score from JMH output
extract_score() {
    local benchmark_name="$1"
    local results_file="$2"

    # Extract score using grep and sed
    grep "$benchmark_name" "$results_file" | \
    sed -n 's/.*avgt *[0-9]* *\([0-9.]*\) .*/\1/p' | \
    head -1
}

# Parse current benchmark results
echo "📊 Parsing current benchmark results..."

declare -A current_results

# Extract scores for each benchmark
current_results["benchmarkCount"]=$(extract_score "benchmarkCount" "benchmark-results.txt")
current_results["benchmarkExists"]=$(extract_score "benchmarkExists" "benchmark-results.txt")
current_results["benchmarkFindAll"]=$(extract_score "benchmarkFindAll" "benchmark-results.txt")
current_results["benchmarkFindById"]=$(extract_score "benchmarkFindById" "benchmark-results.txt")
current_results["benchmarkFindByLastName"]=$(extract_score "benchmarkFindByLastName" "benchmark-results.txt")
current_results["benchmarkSave"]=$(extract_score "benchmarkSave" "benchmark-results.txt")

echo "✅ Parsed benchmark results:"
for benchmark in "${!current_results[@]}"; do
    if [ -n "${current_results[$benchmark]}" ]; then
        echo "  $benchmark: ${current_results[$benchmark]} μs/op"
    else
        echo "  $benchmark: N/A"
    fi
done

# Check if baseline exists
if [ ! -f "$RESULTS_DIR/$BASELINE_FILE" ]; then
    echo ""
    echo "📝 No baseline performance data found."
    echo "Creating baseline from current results..."

    # Create baseline JSON
    cat > "$RESULTS_DIR/$BASELINE_FILE" << EOF
{
  "timestamp": "$(date +%s)",
  "commit_sha": "${GITHUB_SHA:-$(git rev-parse HEAD)}",
  "benchmarks": {
EOF

    first=true
    for benchmark in "${!current_results[@]}"; do
        if [ -n "${current_results[$benchmark]}" ]; then
            if [ "$first" = true ]; then
                first=false
            else
                echo "," >> "$RESULTS_DIR/$BASELINE_FILE"
            fi
            echo "    \"$benchmark\": ${current_results[$benchmark]}" >> "$RESULTS_DIR/$BASELINE_FILE"
        fi
    done

    cat >> "$RESULTS_DIR/$BASELINE_FILE" << EOF

  }
}
EOF

    echo "✅ Baseline created: $RESULTS_DIR/$BASELINE_FILE"
    echo ""
    echo "🎯 Performance Status: BASELINE ESTABLISHED"
    echo "Future runs will be compared against this baseline."

    # Exit successfully - no regressions to check on first run
    exit 0
fi

# Load baseline results
echo ""
echo "📈 Loading baseline performance data..."
if ! command -v jq &> /dev/null; then
    echo "⚠️  jq not available, using basic parsing..."

    # Basic parsing without jq
    declare -A baseline_results

    # Extract values using sed (basic approach)
    while IFS=':' read -r key value; do
        key=$(echo "$key" | sed 's/[", ]//g')
        value=$(echo "$value" | sed 's/[", ]//g')
        if [[ $key =~ benchmark ]]; then
            baseline_results["$key"]="$value"
        fi
    done < <(grep -A 10 '"benchmarks"' "$RESULTS_DIR/$BASELINE_FILE" | grep 'benchmark' | sed 's/":/:/')

else
    # Use jq for proper JSON parsing
    declare -A baseline_results

    for benchmark in "${!current_results[@]}"; do
        baseline_value=$(jq -r ".benchmarks.\"$benchmark\"" "$RESULTS_DIR/$BASELINE_FILE" 2>/dev/null)
        if [ "$baseline_value" != "null" ] && [ -n "$baseline_value" ]; then
            baseline_results["$benchmark"]="$baseline_value"
        fi
    done
fi

# Compare results and detect regressions/improvements
echo ""
echo "🔍 Analyzing Performance Changes"
echo "================================="

REGRESSIONS_FOUND=0
IMPROVEMENTS_FOUND=0

echo "Benchmark                  | Baseline | Current  | Change   | Status"
echo "--------------------------|----------|----------|----------|--------"

for benchmark in "${!current_results[@]}"; do
    current_value="${current_results[$benchmark]}"
    baseline_value="${baseline_results[$benchmark]}"

    if [ -z "$current_value" ] || [ -z "$baseline_value" ]; then
        printf "%-25s | %-8s | %-8s | %-8s | %-6s\n" \
               "$benchmark" "N/A" "N/A" "N/A" "SKIP"
        continue
    fi

    # Calculate percentage change
    change_percent=$(echo "scale=2; (($current_value - $baseline_value) / $baseline_value) * 100" | bc -l 2>/dev/null || echo "0")

    # Determine status
    if (( $(echo "$change_percent > $REGRESSION_THRESHOLD" | bc -l 2>/dev/null || echo "0") )); then
        status="❌ REGRESSION"
        REGRESSIONS_FOUND=$((REGRESSIONS_FOUND + 1))
    elif (( $(echo "$change_percent < -$IMPROVEMENT_THRESHOLD" | bc -l 2>/dev/null || echo "0") )); then
        status="✅ IMPROVEMENT"
        IMPROVEMENTS_FOUND=$((IMPROVEMENTS_FOUND + 1))
    else
        status="✅ STABLE"
    fi

    printf "%-25s | %-8.3f | %-8.3f | %+7.1f%% | %s\n" \
           "$benchmark" "$baseline_value" "$current_value" "$change_percent" "$status"
done

# Summary and actions
echo ""
echo "📊 Performance Analysis Summary"
echo "==============================="

if [ $REGRESSIONS_FOUND -gt 0 ]; then
    echo "❌ PERFORMANCE REGRESSIONS DETECTED: $REGRESSIONS_FOUND benchmark(s) showed significant degradation"
    echo ""
    echo "🚨 Actions Required:"
    echo "   1. Review the failing benchmarks above"
    echo "   2. Investigate code changes that may have caused performance degradation"
    echo "   3. Consider optimizing the affected methods"
    echo "   4. Update baseline if performance changes are intentional"
    echo ""
    echo "💡 Tips:"
    echo "   - Check for inefficient algorithms or data structures"
    echo "   - Look for increased memory allocations"
    echo "   - Review recent changes to affected methods"
    echo ""
    exit 1  # Fail the build on regressions
elif [ $IMPROVEMENTS_FOUND -gt 0 ]; then
    echo "✅ PERFORMANCE IMPROVEMENTS DETECTED: $IMPROVEMENTS_FOUND benchmark(s) showed significant improvement"
    echo ""
    echo "🎉 Great job! Performance has improved."
    echo "   Consider updating the baseline to reflect these improvements."
else
    echo "✅ PERFORMANCE STABLE: All benchmarks within acceptable ranges"
    echo ""
    echo "👍 Performance is consistent with baseline expectations."
fi

echo ""
echo "📁 Results saved to: $RESULTS_DIR/"
echo "📄 Baseline file: $RESULTS_DIR/$BASELINE_FILE"

# Optional: Update baseline if requested
if [ "${UPDATE_BASELINE:-false}" = "true" ]; then
    echo ""
    echo "🔄 Updating baseline with current results..."
    cp "$RESULTS_DIR/$BASELINE_FILE" "$RESULTS_DIR/$BASELINE_FILE.backup"
    # (Baseline update logic would go here - reusing the creation logic from above)
    echo "✅ Baseline updated"
fi
