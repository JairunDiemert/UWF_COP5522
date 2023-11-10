#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <math.h>

double randomCoordinate(double min, double max) {
	double result;
	double range = (max - min);
	double div = RAND_MAX / range;
	result = min + (rand() / div);
	return result;
}

double fxResolvedAtX(double x) {
	// f(x) = e^(-x^2)
	// this function can't be integrated analytically
	double neg_x_square = ((x * x) * -1.0);
	double result = pow(M_E, neg_x_square);
	//printf("\nM_E = %f, neg_x_square = %f", M_E, neg_x_square);
	return result;
}

int main(int argc, char** argv) {
	double x_min = 0.0;
	double x_max = 2.0;
	double y_min = 0.0;
	double y_max = 3.0;
	int iterations = 1000000; // Default number of iterations

	// Check if an argument is passed for the number of iterations
	if (argc > 1) {
		int input_iterations = atoi(argv[1]); // Convert the argument to an integer
		if (input_iterations > 0) { // Check if the input is a positive number
			iterations = input_iterations;
		} else {
			fprintf(stderr, "Invalid number of iterations. Using default value: %d\n", iterations);
		}
	}

	int i;
	int count_under_curve = 0;
	srand(time(0));

	for (i = 0; i < iterations; i++) {
		double sample_x = randomCoordinate(x_min, x_max);
		double sample_y = randomCoordinate(y_min, y_max);
		double fx_at_x = fxResolvedAtX(sample_x);

		if (sample_y <= fx_at_x) {
			count_under_curve++;
		}
	}

	double area_rect = (x_max - x_min) * (y_max - y_min);
	double percent_under_curve = (double)count_under_curve / (double)iterations;
	float integration_result = area_rect * percent_under_curve;

	printf("\nIntegral of e^(-x^2) from %f to %f is approximately %f, calculated over %d iterations\n", x_min, x_max, integration_result, iterations);
	return 0;
}

