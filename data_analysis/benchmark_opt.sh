#!/bin/bash

# Predefined set of iteration numbers
ITERATIONS_SET=(100000000 200000000 400000000 800000000)
NUM_RUNS=10
PROCESSORS=(1 2 4 8)
TARGETS=(montecarlo montecarlo_opt1 montecarlo_opt2 montecarlo_opt3)

# Debug flag (set to 1 to enable debug mode)
DEBUG=0

# Check for debug flag as a script argument
if [[ "$1" == "--debug" ]]; then
  DEBUG=1
fi

# Function to extract the calculated value
extract_value() {
    echo "$1" | grep -m 1 -oP 'approximately \K[0-9.]+'
}

# Debug print function
debug_print() {
    if [ "$DEBUG" -eq 1 ]; then
        echo "$1"
    fi
}

OUTPUT_FILE="scaling_results.csv"
echo "Target,Processors,Run Number,Iterations,Total Runtime,User Time,System Time,Calculated Value" > "$OUTPUT_FILE"

for target in "${TARGETS[@]}"; do
    for proc in "${PROCESSORS[@]}"; do
        for iterations in "${ITERATIONS_SET[@]}"; do
            for run in $(seq 1 $NUM_RUNS); do
                if [ "$target" == "montecarlo" ] && [ "$proc" -eq 1 ]; then
                    # Run serial montecarlo
                    time_output=$( { time ../src/$target $iterations; } 2>&1 )
                else
                    # Run parallel montecarlo with mpirun
                    time_output=$( { time mpirun -np $proc ../src/$target $iterations; } 2>&1 )
                fi

                # Extract time and calculated value
                real_time=$(echo "$time_output" | grep -oP 'real\s+\K.*')
                user_time=$(echo "$time_output" | grep -oP 'user\s+\K.*')
                sys_time=$(echo "$time_output" | grep -oP 'sys\s+\K.*')
                calculated_value=$(extract_value "$time_output")

                # Debug output
                debug_print "Debug - Captured Output:"
                debug_print "$time_output"
                debug_print "End of Debug Output"
                debug_print "--------------------------------"

                if [ "$target" == "montecarlo" ]; then
                    debug_print "Appending to file: $target,1,$runs,$iterations,$real_time,$user_time,$sys_time,$calculated_value"
                    # Append to file
                    echo "$target,1,$run,$iterations,$real_time,$user_time,$sys_time,$calculated_value" >> "$OUTPUT_FILE"
                else
                    # Append to file
                    echo "$target,$proc,$run,$iterations,$real_time,$user_time,$sys_time,$calculated_value" >> "$OUTPUT_FILE"
                fi
            done
        done
    done
done