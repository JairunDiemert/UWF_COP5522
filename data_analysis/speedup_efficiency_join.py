import csv

# Function to convert time string to seconds
def time_to_seconds(time_str):
    minutes, seconds = time_str.split('m')
    return float(minutes) * 60 + float(seconds.rstrip('s'))

# Function to calculate speed up and efficiency
def calculate_metrics(serial_time, parallel_time, processors):
    speed_up = serial_time / parallel_time
    efficiency = speed_up / processors
    return speed_up, efficiency

# Process CSV file
def process_scaling_csv(file_path, output_path):
    with open(file_path, 'r') as infile, open(output_path, 'w', newline='') as outfile:
        reader = csv.DictReader(infile)
        fieldnames = reader.fieldnames + ['Speed Up', 'Efficiency']
        writer = csv.DictWriter(outfile, fieldnames=fieldnames)
        writer.writeheader()

        # Storing serial times for each target and iteration count
        serial_times = {}

        # First pass: Collect serial runtimes for each target and iteration count
        for row in reader:
            target = row['Target']
            iterations = row['Iterations']
            processors = int(row['Processors'])

            if target != 'montecarlo' and processors == 1:  # Consider only non-original montecarlo runs
                key = (target, iterations)
                if key not in serial_times:
                    serial_times[key] = []
                serial_times[key].append(time_to_seconds(row['Total Runtime']))

        # Calculate average serial times for each target and iteration count
        for key in serial_times:
            serial_times[key] = sum(serial_times[key]) / len(serial_times[key])

        # Reset reader to start of file for second pass
        infile.seek(0)
        next(reader, None)  # Skip header

        # Second pass: Calculate speed up and efficiency
        for row in reader:
            target = row['Target']
            iterations = row['Iterations']
            processors = int(row['Processors'])
            key = (target, iterations)

            parallel_time = time_to_seconds(row['Total Runtime'])

            if processors > 1 or (target != 'montecarlo' and processors == 1):
                if key in serial_times:
                    serial_time = serial_times[key]
                    speed_up, efficiency = calculate_metrics(serial_time, parallel_time, processors)
                    row['Speed Up'] = speed_up
                    row['Efficiency'] = efficiency
                else:
                    row['Speed Up'] = ''
                    row['Efficiency'] = ''
            else:
                row['Speed Up'] = ''
                row['Efficiency'] = ''

            writer.writerow(row)

# File path
scaling_file = 'scaling_results.csv'
processed_scaling_file = 'processed_scaling_results.csv'

# Process the file
process_scaling_csv(scaling_file, processed_scaling_file)
