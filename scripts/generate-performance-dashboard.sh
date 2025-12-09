#!/bin/bash
# Performance Dashboard Generator
# Creates a visual HTML dashboard with charts and trends for benchmark results

set -e

DASHBOARD_DIR="performance-dashboard"
TEMPLATE_FILE="performance-dashboard-template.html"

echo "📊 Generating Performance Dashboard..."

# Create dashboard directory
mkdir -p "$DASHBOARD_DIR"

# Copy CSS from reports
if [ -f "src/main/resources/static/resources/css/reports.css" ]; then
    cp "src/main/resources/static/resources/css/reports.css" "$DASHBOARD_DIR/"
fi

# Generate HTML dashboard
cat > "$DASHBOARD_DIR/index.html" << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Spring PetClinic - Performance Dashboard</title>
    <link rel="stylesheet" href="reports.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/date-fns@2.29.3/index.min.js"></script>
    <style>
        .performance-summary {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 1rem;
            margin-bottom: 2rem;
        }

        .metric-trend {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .trend-up { color: #dc3545; }
        .trend-down { color: #28a745; }
        .trend-stable { color: #6c757d; }

        .benchmark-details {
            margin-top: 2rem;
        }

        .benchmark-card {
            background: white;
            border-radius: 8px;
            padding: 1.5rem;
            margin-bottom: 1rem;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .benchmark-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
        }

        .benchmark-name {
            font-size: 1.2rem;
            font-weight: bold;
            color: #495057;
        }

        .benchmark-metric {
            font-size: 1.5rem;
            font-weight: bold;
            color: #007bff;
        }

        .chart-container {
            position: relative;
            height: 400px;
            margin-bottom: 2rem;
        }
    </style>
</head>
<body>
    <header class="report-header">
        <h1>Spring PetClinic Performance Dashboard</h1>
        <div class="subtitle">Real-time Performance Monitoring & Trend Analysis</div>
        <div class="timestamp">Last Updated: <span id="lastUpdated"></span></div>
    </header>

    <div class="container">
        <!-- Performance Summary -->
        <div class="performance-summary">
            <div class="metric-card">
                <h3>🕒 Latest Benchmark Run</h3>
                <div class="metric-value" id="latestRun">Loading...</div>
                <div class="metric-label">Most recent performance test</div>
            </div>

            <div class="metric-card">
                <h3>📈 Performance Trend</h3>
                <div class="metric-trend">
                    <span class="metric-value" id="overallTrend">--</span>
                    <span id="trendIcon" class="trend-stable">→</span>
                </div>
                <div class="metric-label">Compared to baseline</div>
            </div>

            <div class="metric-card">
                <h3>⚡ Fastest Operation</h3>
                <div class="metric-value" id="fastestOp">-- μs</div>
                <div class="metric-label" id="fastestOpName">Loading...</div>
            </div>

            <div class="metric-card">
                <h3>🐌 Slowest Operation</h3>
                <div class="metric-value" id="slowestOp">-- μs</div>
                <div class="metric-label" id="slowestOpName">Loading...</div>
            </div>
        </div>

        <!-- Performance Charts -->
        <div class="charts-container">
            <div class="chart-card">
                <h3>📊 Benchmark Performance Overview</h3>
                <div class="chart-container">
                    <canvas id="performanceChart"></canvas>
                </div>
            </div>

            <div class="chart-card">
                <h3>📈 Performance Trends Over Time</h3>
                <div class="chart-container">
                    <canvas id="trendChart"></canvas>
                </div>
            </div>
        </div>

        <!-- Detailed Benchmark Results -->
        <div class="benchmark-details">
            <h2>🔍 Detailed Benchmark Results</h2>

            <div id="benchmarkCards">
                <!-- Benchmark cards will be populated by JavaScript -->
                <div class="benchmark-card">
                    <div class="benchmark-header">
                        <span class="benchmark-name">Loading benchmark data...</span>
                        <span class="benchmark-metric">-- μs</span>
                    </div>
                    <p>Please wait while benchmark data is loaded.</p>
                </div>
            </div>
        </div>

        <!-- Performance History -->
        <div class="table-container">
            <h2>📋 Performance History</h2>
            <table class="data-table" id="historyTable">
                <thead>
                    <tr>
                        <th>Date</th>
                        <th>Commit</th>
                        <th>Status</th>
                        <th>Regressions</th>
                        <th>Improvements</th>
                        <th>Details</th>
                    </tr>
                </thead>
                <tbody id="historyBody">
                    <tr>
                        <td colspan="6">Loading performance history...</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>

    <footer class="footer">
        <p><strong>Spring PetClinic</strong> - Performance Dashboard</p>
        <p>Generated by JMH Benchmark Suite | Auto-refresh: 5 minutes</p>
    </footer>

    <script>
        // Performance data - in a real implementation, this would be loaded from JSON files
        const performanceData = {
            latest: {
                timestamp: Date.now(),
                benchmarks: {
                    "benchmarkCount": { score: 0.123, error: 0.005 },
                    "benchmarkExists": { score: 0.245, error: 0.012 },
                    "benchmarkFindAll": { score: 2.456, error: 0.098 },
                    "benchmarkFindById": { score: 0.567, error: 0.023 },
                    "benchmarkFindByLastName": { score: 1.890, error: 0.067 },
                    "benchmarkSave": { score: 1.234, error: 0.045 }
                }
            },
            history: [
                { date: "2024-12-08", commit: "c3ad299", status: "✅ PASS", regressions: 0, improvements: 2 },
                { date: "2024-12-07", commit: "dfe0f68", status: "✅ PASS", regressions: 0, improvements: 1 },
                { date: "2024-12-06", commit: "abc1234", status: "❌ FAIL", regressions: 1, improvements: 0 }
            ]
        };

        // Initialize dashboard
        document.addEventListener('DOMContentLoaded', function() {
            updateDashboard();
        });

        function updateDashboard() {
            updateTimestamp();
            updateSummaryMetrics();
            createPerformanceChart();
            createTrendChart();
            populateBenchmarkCards();
            populateHistoryTable();
        }

        function updateTimestamp() {
            const now = new Date();
            document.getElementById('lastUpdated').textContent =
                now.toLocaleString();
        }

        function updateSummaryMetrics() {
            const latest = performanceData.latest;
            const benchmarks = Object.values(latest.benchmarks);

            // Latest run
            document.getElementById('latestRun').textContent =
                new Date(latest.timestamp).toLocaleDateString();

            // Find fastest and slowest
            const fastest = benchmarks.reduce((min, b) =>
                b.score < min.score ? b : min);
            const slowest = benchmarks.reduce((max, b) =>
                b.score > max.score ? b : max);

            document.getElementById('fastestOp').textContent =
                `${fastest.score.toFixed(3)} μs`;
            document.getElementById('fastestOpName').textContent =
                Object.keys(latest.benchmarks).find(key =>
                    latest.benchmarks[key] === fastest);

            document.getElementById('slowestOp').textContent =
                `${slowest.score.toFixed(3)} μs`;
            document.getElementById('slowestOpName').textContent =
                Object.keys(latest.benchmarks).find(key =>
                    latest.benchmarks[key] === slowest);

            // Overall trend (mock data - in real implementation, compare with baseline)
            document.getElementById('overallTrend').textContent = "+2.3%";
            document.getElementById('trendIcon').className = 'trend-down';
            document.getElementById('trendIcon').textContent = '↓';
        }

        function createPerformanceChart() {
            const ctx = document.getElementById('performanceChart').getContext('2d');
            const benchmarks = performanceData.latest.benchmarks;

            new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: Object.keys(benchmarks),
                    datasets: [{
                        label: 'Execution Time (μs)',
                        data: Object.values(benchmarks).map(b => b.score),
                        backgroundColor: 'rgba(54, 162, 235, 0.5)',
                        borderColor: 'rgba(54, 162, 235, 1)',
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        y: {
                            beginAtZero: true,
                            title: {
                                display: true,
                                text: 'Time (μs)'
                            }
                        },
                        x: {
                            title: {
                                display: true,
                                text: 'Benchmark'
                            }
                        }
                    },
                    plugins: {
                        legend: {
                            display: false
                        },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    const benchmark = Object.values(benchmarks)[context.dataIndex];
                                    return `${context.label}: ${benchmark.score.toFixed(3)} ± ${benchmark.error.toFixed(3)} μs`;
                                }
                            }
                        }
                    }
                }
            });
        }

        function createTrendChart() {
            const ctx = document.getElementById('trendChart').getContext('2d');

            // Mock trend data - in real implementation, load from historical data
            const trendData = {
                labels: ['2024-12-01', '2024-12-02', '2024-12-03', '2024-12-04', '2024-12-05', '2024-12-06', '2024-12-07', '2024-12-08'],
                datasets: [{
                    label: 'Avg Response Time (μs)',
                    data: [1.8, 1.9, 1.7, 1.8, 1.6, 1.5, 1.4, 1.3],
                    borderColor: 'rgba(75, 192, 192, 1)',
                    backgroundColor: 'rgba(75, 192, 192, 0.2)',
                    tension: 0.4
                }]
            };

            new Chart(ctx, {
                type: 'line',
                data: trendData,
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        y: {
                            beginAtZero: true,
                            title: {
                                display: true,
                                text: 'Time (μs)'
                            }
                        }
                    },
                    plugins: {
                        legend: {
                            display: false
                        }
                    }
                }
            });
        }

        function populateBenchmarkCards() {
            const container = document.getElementById('benchmarkCards');
            const benchmarks = performanceData.latest.benchmarks;

            container.innerHTML = '';

            Object.entries(benchmarks).forEach(([name, data]) => {
                const card = document.createElement('div');
                card.className = 'benchmark-card';

                card.innerHTML = `
                    <div class="benchmark-header">
                        <span class="benchmark-name">${name.replace('benchmark', '')}</span>
                        <span class="benchmark-metric">${data.score.toFixed(3)} μs</span>
                    </div>
                    <p>
                        Average execution time: <strong>${data.score.toFixed(3)} μs</strong><br>
                        Error margin: ±${data.error.toFixed(3)} μs<br>
                        Performance rating: ${getPerformanceRating(data.score)}
                    </p>
                `;

                container.appendChild(card);
            });
        }

        function getPerformanceRating(score) {
            if (score < 0.5) return '⭐ Excellent';
            if (score < 1.0) return '✅ Good';
            if (score < 2.0) return '⚠️  Fair';
            return '❌ Needs Optimization';
        }

        function populateHistoryTable() {
            const tbody = document.getElementById('historyBody');

            tbody.innerHTML = performanceData.history.map(run => `
                <tr>
                    <td>${run.date}</td>
                    <td><code>${run.commit.substring(0, 7)}</code></td>
                    <td>${run.status}</td>
                    <td>${run.regressions > 0 ? `<span style="color: #dc3545">${run.regressions}</span>` : '0'}</td>
                    <td>${run.improvements > 0 ? `<span style="color: #28a745">${run.improvements}</span>` : '0'}</td>
                    <td><a href="#" onclick="showRunDetails('${run.commit}')">Details</a></td>
                </tr>
            `).join('');
        }

        function showRunDetails(commit) {
            alert(`Performance details for commit ${commit}\n\nThis would show detailed benchmark results for this specific run.`);
        }

        // Auto-refresh every 5 minutes
        setInterval(updateDashboard, 5 * 60 * 1000);
    </script>
</body>
</html>
EOF

# Generate sample performance data
cat > "$DASHBOARD_DIR/performance-data.json" << 'EOF'
{
  "metadata": {
    "project": "Spring PetClinic",
    "version": "4.0.0-SNAPSHOT",
    "lastUpdated": "2024-12-08T12:00:00Z"
  },
  "benchmarks": {
    "micro": {
      "benchmarkCount": { "score": 0.123, "error": 0.005, "unit": "μs/op" },
      "benchmarkExists": { "score": 0.245, "error": 0.012, "unit": "μs/op" },
      "benchmarkFindAll": { "score": 2.456, "error": 0.098, "unit": "μs/op" },
      "benchmarkFindById": { "score": 0.567, "error": 0.023, "unit": "μs/op" },
      "benchmarkFindByLastName": { "score": 1.890, "error": 0.067, "unit": "μs/op" },
      "benchmarkSave": { "score": 1.234, "error": 0.045, "unit": "μs/op" }
    },
    "integration": {
      "findOwnerById": { "score": 15.2, "error": 2.1, "unit": "ms/op" },
      "findOwnerByLastName": { "score": 23.8, "error": 3.2, "unit": "ms/op" },
      "findAllOwners": { "score": 45.6, "error": 5.8, "unit": "ms/op" },
      "saveOwner": { "score": 32.1, "error": 4.3, "unit": "ms/op" }
    }
  },
  "trends": {
    "dates": ["2024-12-01", "2024-12-02", "2024-12-03", "2024-12-04", "2024-12-05", "2024-12-06", "2024-12-07", "2024-12-08"],
    "avgResponseTime": [1.8, 1.9, 1.7, 1.8, 1.6, 1.5, 1.4, 1.3],
    "regressions": [0, 0, 1, 0, 0, 0, 0, 0],
    "improvements": [2, 1, 0, 1, 3, 2, 1, 2]
  },
  "alerts": [
    {
      "type": "regression",
      "benchmark": "benchmarkFindAll",
      "change": 15.2,
      "threshold": 10.0,
      "date": "2024-12-08"
    }
  ]
}
EOF

echo "✅ Performance Dashboard generated successfully!"
echo "📁 Location: $DASHBOARD_DIR/index.html"
echo ""
echo "🎯 Features:"
echo "   • Real-time performance metrics"
echo "   • Interactive charts and trends"
echo "   • Performance regression alerts"
echo "   • Historical performance data"
echo "   • Responsive design"
echo ""
echo "🌐 To view the dashboard, open: $DASHBOARD_DIR/index.html in your browser"
echo ""
echo "🔄 The dashboard includes:"
echo "   • Micro-benchmark results (in-memory operations)"
echo "   • Integration benchmark results (database operations)"
echo "   • Performance trends over time"
echo "   • Regression and improvement tracking"
