#!/bin/bash

# Navigate to the src directory where the Monte Carlo executable is located
cd "$(dirname "$0")"/../src

# Define different loads as an array of iteration counts
LOADS=(1000000 10000000 100000000)
NUM_RUNS=10
OUTPUT_FILE="../data_analysis/benchmark_results.csv"

# Prepare the output file and write the header
echo "Iterations,Average Runtime (seconds)" > "$OUTPUT_FILE"

# Loop through each load
for load in "${LOADS[@]}"; do
    echo "Benchmarking with $load iterations..."
    total_time=0

    # Run the benchmark NUM_RUNS times for the current load
    for i in $(seq 1 $NUM_RUNS); do
        start_time=$(date +%s.%N)
        ./montecarlo $load
        end_time=$(date +%s.%N)
        runtime=$(echo "$end_time - $start_time" | bc -l)
        total_time=$(echo "$total_time + $runtime" | bc -l)
    done

    # Calculate the average time for the current load
    avg_time=$(echo "$total_time / $NUM_RUNS" | bc -l)
    echo "$load,$avg_time" >> "$OUTPUT_FILE"
    echo "Average runtime for $load iterations over $NUM_RUNS runs: $avg_time seconds"
    echo "-------------------------------------------------------------"
done

echo "Benchmarking finished. Results saved to $OUTPUT_FILE."
