# Monte Carlo Simulation - Serial Benchmark

## Overview

This repository contains the serial implementation of a Monte Carlo simulation used to approximate the integral of `e^(-x^2)`. The simulation samples points within a defined space to calculate the area under the curve, which is a problem not easily solved analytically.

## Makefile Usage

The included Makefile facilitates the compilation process with predefined commands and flags.

### Commands:

- `make`: Compiles the source files and creates the executable `montecarlo`.
- `make clean`: Cleans up the directory by removing object files and the executable.

### Flags:

- `-Wall`: Enables all compiler's warning messages.
- `-I.`: Includes the current directory for header file search.
- `-O0`: No optimization. It ensures that the compiled code is a direct reflection of the performance of the written code.
- `-lm`: Links the math library.

## Benchmarking Script

The `benchmark.sh` script automates the execution of the Monte Carlo simulation. It runs the program multiple times for different iteration counts to average the system's performance across various loads.

## Results

The results are captured in a `.csv` file, which can be used to graph the performance across iteration sizes. The graph illustrates the runtime scaling linearly with the number of iterations, confirming the expected behavior of the simulation.

[initial_results](./data_analysis/benchmark_graph.png)

## Repository Contents

- `montecarlo.c`: The C source file containing the Monte Carlo simulation logic.
- `montecarlo.h`: The header file for the Monte Carlo simulation functions.
- `Makefile`: Used to compile the simulation with appropriate flags.
- `benchmark.sh`: A shell script to automate the benchmarking process.
- `benchmark_results.csv`: The output file where the benchmarking results are saved.

## Running the Simulation

To run the Monte Carlo simulation:

```sh
./montecarlo [number of iterations]
```

If no argument is provided, the simulation defaults to 1,000,000 iterations.

## Automated Testing

To execute the automated benchmark script:

```sh
./benchmark.sh
```

This script will run the simulation for predefined iteration counts and save the average runtimes in the results CSV file.

## Contributing

Contributions are welcome. Please ensure to update the tests and documentation accordingly. For major changes, please open an issue first to discuss what you would like to change.

## License

Distributed under the MIT License. See `LICENSE` for more information.
