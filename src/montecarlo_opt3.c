#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <math.h>
#include <mpi.h>

// Generates a random double between min and max
double randomCoordinate(double min, double max) {
    // Using direct calculation for efficiency
    return min + (rand() / (RAND_MAX / (max - min)));
}

// Computes the value of the function f(x) = e^(-x^2)
double fxResolvedAtX(double x) {
    // Simplified to use the exponential function directly
    return exp(-x * x);
}

int main(int argc, char** argv) {
    // Define the range for x and y
    double x_min = 0.0;
    double x_max = 2.0;
    double y_min = 0.0;
    double y_max = 3.0;

    // Use unsigned long long for a larger range of iteration values
    unsigned long long iterations = 1000000;
    char* endPtr;

    // Check for command line argument for the number of iterations
    if (argc > 1) {
        unsigned long long input_iterations = strtoull(argv[1], &endPtr, 10);
        // Ensure the entire string was converted and the number is positive
        if (*endPtr == '\0' && input_iterations > 0) {
            iterations = input_iterations;
        } else {
            fprintf(stderr, "Invalid number of iterations. Using default value: %llu\n", iterations);
        }
    }

    // Use unsigned long long to avoid overflow during counting
    unsigned long long count_under_curve = 0;

    // Pre-calculate the area of the rectangle
    double area_rect = (x_max - x_min) * (y_max - y_min);

    int my_rank, numprocs;
    unsigned long long local_iteration_start, chunk_size, local_count_under_curve = 0;

    MPI_Init(NULL, NULL);
    MPI_Comm_size(MPI_COMM_WORLD, &numprocs);
    MPI_Comm_rank(MPI_COMM_WORLD, &my_rank);

    // Use the rank 0 process to generate a random seed
    unsigned int seed;
    if (my_rank == 0) {
        seed = (unsigned int)time(NULL);
    }

    // Broadcast the seed to all processes
    MPI_Bcast(&seed, 1, MPI_UNSIGNED, 0, MPI_COMM_WORLD);

    // Use the received seed to initialize the random number generator for each process
    srand(seed + my_rank);

    chunk_size = iterations / numprocs;
    local_iteration_start = chunk_size * my_rank;

    // Main Monte Carlo loop
    for (unsigned long long i = local_iteration_start; i < local_iteration_start + chunk_size; i++) {
        double sample_x = randomCoordinate(x_min, x_max);
        double sample_y = randomCoordinate(y_min, y_max);

        // Count if the y-value is under the curve
        if (sample_y <= fxResolvedAtX(sample_x)) {
            local_count_under_curve++;
        }
    }

    // Batched communication to reduce overhead
    MPI_Allreduce(&local_count_under_curve, &count_under_curve, 1, MPI_UNSIGNED_LONG_LONG, MPI_SUM, MPI_COMM_WORLD);

    // Calculate the percentage of points under the curve
    double percent_under_curve = (double)count_under_curve / iterations;

    // Calculate the final integral value
    double integration_result = area_rect * percent_under_curve;

    // Output the results
    if (my_rank == 0) {
        printf("\nIntegral of e^(-x^2) from %f to %f is approximately %f, calculated over %llu iterations\n", x_min, x_max, integration_result, iterations);
    }

    MPI_Finalize();

    return 0;
}
