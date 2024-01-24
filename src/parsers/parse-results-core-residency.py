import os
import pandas as pd
import json
import statistics
import csv 

# Set the parent directory where experiment directories are located
parent_directory = "/home/ganton12/data/exp6_simpletime_pcu_congestion"

# Initialize an empty DataFrame to store the results
#index_labels=['ilo_ambtemp','ilo_average','ilo_cpuwatts','ilo_dimmwatts', 'ilo_minimum', 'ilo_peak', 'pdu','ilo_ambtemp_stdev','ilo_average_stdev','ilo_cpuwatts_stdev','ilo_dimmwatts_stdev', 'ilo_minimum_stdev', 'ilo_peak_stdev', 'pdu_stdev']
# index_labels=['ilo_ambtemp','ilo_average','ilo_cpuwatts','ilo_dimmwatts', 'ilo_minimum', 'ilo_peak','ilo_ambtemp_stdev','ilo_average_stdev','ilo_cpuwatts_stdev','ilo_dimmwatts_stdev', 'ilo_minimum_stdev', 'ilo_peak_stdev']
#results_df = pd.DataFrame(index=index_labels)

overall_results_avg = {}
overall_results_stdev = {}

# Iterate through subdirectories
for directory_name in os.listdir(parent_directory):
    directory_path = os.path.join(parent_directory, directory_name)
    
    # check if name is directory
    if not os.path.isdir(directory_path):
        continue

    # Initialize an empty dictionary to store the data
    data_dict = {}
    # Process each file in the experiment directory
    for j in range(1, 6):
        turbostat_file = f"turbostat_{j}_120.out"
        turbostat_file_path = os.path.join(directory_path, turbostat_file)

        #check if file exists if not break and go to the next directory
        if not os.path.isfile(turbostat_file_path):
            break

        # Open the turbostat output file for reading
        with open(turbostat_file_path, 'r') as file:

            # Read all lines from the file
            lines = file.readlines()

        # Extract header and data rows
        header = lines[0].split()
        data_rows = [line.split() for line in lines[1:]]
        
        # Iterate over data rows
        for row in data_rows:

            if "Package" in row:
                continue

            # Extract core and data values
            if row[2] == "-":
                core = -1
            else:
                core = int(row[2])

            data_values = {header[i]: float(row[i]) for i in range(3, len(row))}

            # Check if the core already exists in the dictionary
            #print(str(j) + " " + str(core))
            if (j,core) in data_dict:
                # Append new values to the existing dictionary
                existing_values = data_dict[(j,core)]
                for key, value in data_values.items():
                    existing_values[key].append(value)
            else:
                # Create a new entry with the current values
                data_dict[(j,core)] = {key: [value] for key, value in data_values.items()}

    #print(data_dict)
    if not data_dict:
        continue
    # Calculate averages for each metric and core
    averages_dict = {}
    std_devs_dict = {}
    #print(data_dict)
    for (file_name, core), values in data_dict.items():
        averages_dict[(file_name, core)] = {key: value for key, value in values.items()}
        #averages_dict[(file_name, core)] = {key: statistics.mean(value) for key, value in values.items()}
        #print(str(file_name) + " " + str(core))
        #print(values)
        #std_devs_dict[(file_name, core)] = {key: statistics.stdev(value) for key, value in values.items()}
        std_devs_dict[(file_name, core)] = {key: value for key, value in values.items()}
    
    # Calculate overall averages and standard deviations across all files
    overall_averages_dict = {}
    overall_std_devs_dict = {}
    for core_file_tuple, values in averages_dict.items():
        core, file_name = core_file_tuple[1], core_file_tuple[0]

        if core in overall_averages_dict:
            for key, value in values.items():
                overall_averages_dict[core][key].append(value)
        else:
            overall_averages_dict[core] = {key: [value] for key, value in values.items()}

    for core_file_tuple, values in std_devs_dict.items():
        core, file_name = core_file_tuple[1], core_file_tuple[0]

        if core in overall_std_devs_dict:
            for key, value in values.items():
                overall_std_devs_dict[core][key].append(value)
        else:
            overall_std_devs_dict[core] = {key: [value] for key, value in values.items()}

    
    # Calculate overall averages and standard deviations for all files
    
       
    overall_averages = {core: {key: statistics.mean(item for value_item in value for item in value_item) for key, value in values.items()} for core, values in overall_averages_dict.items()}
    overall_std_devs = {core: {key: statistics.stdev(item for value_item in value for item in value_item) for key, value in values.items()} for core, values in overall_averages_dict.items()}

    # Write the experiment output in it's directory 
    file_path = directory_path + '/turbostat_residency_avg.csv'

    print(file_path)
    # Writing the dictionary to a CSV file
    with open(file_path, 'w', newline='') as csv_file:
        writer = csv.writer(csv_file)
        
        # Write headers
       
        headers_1 = ['Core'] + list(overall_averages[0].keys())
        headers_2 = ['Core'] + list(overall_averages[1].keys())
        
      
        writer.writerow(headers_1)
        
       
        # Write data
        for core, metrics in overall_averages.items():
            if core == -1 or core == 0 or core == 20:
                row = [core] + [metrics[header] for header in headers_1[1:]]
            else:
                row = [core] + [metrics[header] for header in headers_2[1:]]
            writer.writerow(row)

    # Write the experiment output in it's directory 
    file_path = directory_path + '/turbostat_residency_stdev.csv'

    # Writing the dictionary to a CSV file
    with open(file_path, 'w', newline='') as csv_file:
        writer = csv.writer(csv_file)
        
        # Write headers
       
        headers_1 = ['Core'] + list(overall_std_devs[0].keys())
        headers_2 = ['Core'] + list(overall_std_devs[1].keys())

        writer.writerow(headers_1)
        
        # Write data
        for core, metrics in overall_std_devs.items():
            if core == -1 or core == 0 or core == 20:
                row = [core] + [metrics[header] for header in headers_1[1:]]
            else:
                row = [core] + [metrics[header] for header in headers_2[1:]]
            writer.writerow(row)

    overall_results_avg[directory_name] = overall_averages[-1]
    overall_results_stdev[directory_name] = overall_std_devs[-1]

    #print(overall_averages)
    #print(overall_std_devs)

# Write the data for all the experiments in a file under data root directory

# Extract all unique keys from all experiments
all_keys = set(key for metrics in overall_results_avg.values() for key in metrics.keys())

file_path = parent_directory + '/merged_turbostat_residency_avg.csv'

# Writing the dictionary to a CSV file
with open(file_path, 'w', newline='') as csv_file:
    writer = csv.writer(csv_file)
    
    # Write headers
    headers = ['Experiment'] + list(all_keys)
    writer.writerow(headers)

    # Write data
    for experiment, metrics in overall_results_avg.items():
        row = [experiment] + [metrics.get(key,0) for key in all_keys]
        writer.writerow(row)



file_path = parent_directory + '/merged_turbostat_residency_stdev.csv'

# Writing the dictionary to a CSV file
with open(file_path, 'w', newline='') as csv_file:
    writer = csv.writer(csv_file)
    
    # Write headers
    
    headers = ['Experiment'] + list(all_keys)
    writer.writerow(headers)
    
    # Write data
    for experiment, metrics in overall_results_stdev.items():
        row = [experiment] + [metrics.get(key,0) for key in all_keys]
        writer.writerow(row)

