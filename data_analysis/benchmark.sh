#!/bin/bash

# Navigate to the src directory where the Monte Carlo executable is located
cd "$(dirname "$0")"/../src

# Define the highest order for iterations
HIGHEST_ORDER=20
NUM_RUNS=10
OUTPUT_FILE="../data_analysis/benchmark_results.csv"

# Set a timeout for each run in seconds (adjust as needed)
TIMEOUT_DURATION=300  # 5 minutes

# Prepare the output file and write the header
echo "Run Number,Iterations (Scientific Notation),Iterations,Calculated Value,Runtime (seconds),Cumulative Average Runtime (seconds),Cumulative Average Value" > "$OUTPUT_FILE"

# Function to extract the calculated value from the montecarlo output
extract_value() {
    echo "$1" | grep -oP '(?<=approximately ).*(?=, calculated)'
}

# Function to check if the default value is being used
check_default_used() {
    echo "$1" | grep -q "Using default value"
}

# Generate loads based on the highest order
for order in $(seq 1 $HIGHEST_ORDER); do
    # Convert scientific notation to real number
    load=$(printf "%.0f" $(bc -l <<< "10^$order"))
    load_sci="1e$order"  # Scientific notation format

    echo "Benchmarking with $load iterations..."
    total_time=0
    total_value=0
    valid_runs=0  # Track the number of valid runs

    # Run the benchmark NUM_RUNS times for the current load
    for i in $(seq 1 $NUM_RUNS); do
        start_time=$(date +%s.%N)

        # Run the command with a timeout
        output=$(timeout $TIMEOUT_DURATION ./montecarlo $load)
        exit_status=$?

        # Check if the default value is being used or if a timeout occurred
        if check_default_used "$output" || [ $exit_status -eq 124 ]; then
            if check_default_used "$output"; then
                echo "Montecarlo started using default value at order $order. Stopping benchmark."
            elif [ $exit_status -eq 124 ]; then
                echo "Run $i for $load iterations exceeded time limit of $TIMEOUT_DURATION seconds"
            fi
            break  # Exit the current iteration loop
        fi

        end_time=$(date +%s.%N)
        calculated_value=$(extract_value "$output")
        runtime=$(echo "$end_time - $start_time" | bc -l)
        total_time=$(echo "$total_time + $runtime" | bc -l)
        total_value=$(echo "$total_value + $calculated_value" | bc -l)
        valid_runs=$((valid_runs + 1))

        avg_time_so_far=$(echo "$total_time / $valid_runs" | bc -l)
        avg_value_so_far=$(echo "$total_value / $valid_runs" | bc -l)

        echo "$i,$load_sci,$load,$calculated_value,$runtime,$avg_time_so_far,$avg_value_so_far" >> "$OUTPUT_FILE"
    done

    if [ $valid_runs -gt 0 ]; then
        echo "Average runtime for $load iterations over $valid_runs valid runs: $(echo "$total_time / $valid_runs" | bc -l) seconds"
    else
        echo "No valid runs completed for $load iterations."
    fi
    echo "-------------------------------------------------------------"
done

echo "Benchmarking finished. Results saved to $OUTPUT_FILE"
