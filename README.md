# Monte Carlo Simulation Project

## Overview
This project implements a Monte Carlo simulation for calculating the integral of `e^(-x^2)` from 0 to 2. The project includes a benchmarking script to evaluate the performance of the simulation across different iteration counts and a Python script to visualize the benchmark results.

## Contents
- `src/`: Source code directory containing the Monte Carlo simulation code.
- `data_analysis/`: Contains scripts and files for benchmarking and data visualization.

## Getting Started
### Prerequisites
- GCC Compiler for compiling the C program.
- Python with required packages for running the visualization script. (See `data_analysis/requirements.txt`)

### Compilation
Navigate to the `src/` directory and run the makefile to compile the Monte Carlo simulation:
```bash
cd src
make
```

### Running the Benchmark
Execute the `benchmark.sh` script to run the Monte Carlo simulation with different iteration counts and generate benchmark results:
```bash
cd ../data_analysis
./benchmark.sh
```

### Visualizing Benchmark Results
Run the Python script to generate an interactive 3D plot of the benchmark results. The plot is saved as an HTML file (`benchmark_plots.html`):
```bash
python 3d_plot.py
```

## Benchmark Results
The benchmark results are stored in `benchmark_results.csv`. Here's a preview of the data:

```csv
Run Number,Iterations (Scientific Notation),Iterations,Calculated Value,Runtime (seconds),Cumulative Average Runtime (seconds),Cumulative Average Value
1,1e1,10,0.000000,.002897400,.00289740000000000000,0
2,1e1,10,0.000000,.002490200,.00269380000000000000,0
...
```

## Interactive Plot
An interactive 3D plot of the benchmark results is available in `benchmark_plots.html`. Open this file in a web browser to view the plot.

## Google Drive (For Convenience)
The benchmark results and interactive plot are also available on Google Drive:
- [Benchmark Results](https://docs.google.com/document/d/1-tqmsfsKB2vURN7ePoM3lpCS2OgKl74kxCkrJG1NXZQ/edit#heading=h.jiz15jnvjvx2)

## License
This project is licensed under the [MIT License](LICENSE).

## Acknowledgments
- Monte Carlo simulation methodology.
- Plotly for data visualization.
