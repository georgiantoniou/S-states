import os
import pandas as pd
import json

# Set the parent directory where experiment directories are located
parent_directory = "/home/ganton12/data/exp5_rapl_ilo_compare/"

# Initialize an empty DataFrame to store the results
index_labels=['ilo_ambtemp','ilo_average','ilo_cpuwatts','ilo_dimmwatts', 'ilo_minimum', 'ilo_peak', 'pdu','ilo_ambtemp_stdev','ilo_average_stdev','ilo_cpuwatts_stdev','ilo_dimmwatts_stdev', 'ilo_minimum_stdev', 'ilo_peak_stdev', 'pdu_stdev']
# index_labels=['ilo_ambtemp','ilo_average','ilo_cpuwatts','ilo_dimmwatts', 'ilo_minimum', 'ilo_peak','ilo_ambtemp_stdev','ilo_average_stdev','ilo_cpuwatts_stdev','ilo_dimmwatts_stdev', 'ilo_minimum_stdev', 'ilo_peak_stdev']
results_df = pd.DataFrame(index=index_labels)

# Iterate through subdirectories
for directory_name in os.listdir(parent_directory):
    directory_path = os.path.join(parent_directory, directory_name)
    
    # check if name is directory

    if not os.path.isdir(directory_path):
        continue

    # Initialize a temporary DataFrame for all experiments
    #experiment_df = pd.DataFrame()

    # Initialize temporary DataFrames for all the metrics in the current experiment
    ilo_ambtemp_df = pd.DataFrame()
    ilo_average_df = pd.DataFrame()
    ilo_cpuwatts_df = pd.DataFrame()
    ilo_dimmwatts_df = pd.DataFrame()
    ilo_minimum_df = pd.DataFrame()
    ilo_peak_df = pd.DataFrame()
    pdu_df = pd.DataFrame()

    # Process each file in the experiment directory
    for i in range(1, 6):
        ilo_ambtemp_file = f"ilo_ambtemp_{i}_180.out"
        ilo_average_file = f"ilo_average_{i}_180.out"
        ilo_cpuwatts_file = f"ilo_cpuwatts_{i}_180.out"
        ilo_dimmwatts_file = f"ilo_dimmwatts_{i}_180.out"
        ilo_minimum_file = f"ilo_minimum_{i}_180.out"
        ilo_peak_file = f"ilo_peak_{i}_180.out"
        pdu_file = f"pdu_{i}_180.out"
        
        ilo_ambtemp_file_path = os.path.join(directory_path, ilo_ambtemp_file)
        ilo_average_file_path = os.path.join(directory_path, ilo_average_file)
        ilo_cpuwatts_file_path = os.path.join(directory_path, ilo_cpuwatts_file)
        ilo_dimmwatts_file_path = os.path.join(directory_path, ilo_dimmwatts_file)
        ilo_minimum_file_path = os.path.join(directory_path, ilo_minimum_file)
        ilo_peak_file_path = os.path.join(directory_path, ilo_peak_file)
        pdu_file_path = os.path.join(directory_path, pdu_file)
        
        # Read and concatenate the data into a temporary DataFrame
        pdu_data = pd.read_csv(pdu_file_path, delimiter=' ', header=None)
        ilo_ambtemp_data = pd.read_csv(ilo_ambtemp_file_path, delimiter=' ', header=None)
        ilo_average_data = pd.read_csv(ilo_average_file_path, delimiter=' ', header=None)
        ilo_cpuwatts_data = pd.read_csv(ilo_cpuwatts_file_path, delimiter=' ', header=None)
        ilo_dimmwatts_data = pd.read_csv(ilo_dimmwatts_file_path, delimiter=' ', header=None)
        ilo_minimum_data = pd.read_csv(ilo_minimum_file_path, delimiter=' ', header=None)
        ilo_peak_data = pd.read_csv(ilo_peak_file_path, delimiter=' ', header=None)
        
        ilo_ambtemp_data[['Metric', 'Samples-' + str(i)]] = ilo_ambtemp_data[0].str.split(',', expand=True)
        ilo_ambtemp_data = ilo_ambtemp_data.drop(0, axis=1)
        ilo_ambtemp_data['Samples-' + str(i)] = ilo_ambtemp_data['Samples-' + str(i)].astype('float64')

        ilo_average_data[['Metric', 'Samples-' + str(i)]] = ilo_average_data[0].str.split(',', expand=True)
        ilo_average_data = ilo_average_data.drop(0, axis=1)
        ilo_average_data['Samples-' + str(i)] = ilo_average_data['Samples-' + str(i)].astype('float64')

        ilo_cpuwatts_data[['Metric', 'Samples-' + str(i)]] = ilo_cpuwatts_data[0].str.split(',', expand=True)
        ilo_cpuwatts_data = ilo_cpuwatts_data.drop(0, axis=1)
        ilo_cpuwatts_data['Samples-' + str(i)] = ilo_cpuwatts_data['Samples-' + str(i)].astype('float64')

        ilo_dimmwatts_data[['Metric', 'Samples-' + str(i)]] = ilo_dimmwatts_data[0].str.split(',', expand=True)
        ilo_dimmwatts_data = ilo_dimmwatts_data.drop(0, axis=1)
        ilo_dimmwatts_data['Samples-' + str(i)] = ilo_dimmwatts_data['Samples-' + str(i)].astype('float64')

        ilo_minimum_data[['Metric', 'Samples-' + str(i)]] = ilo_minimum_data[0].str.split(',', expand=True)
        ilo_minimum_data = ilo_minimum_data.drop(0, axis=1)
        ilo_minimum_data['Samples-' + str(i)] = ilo_minimum_data['Samples-' + str(i)].astype('float64')

        ilo_peak_data[['Metric', 'Samples-' + str(i)]] = ilo_peak_data[0].str.split(',', expand=True)
        ilo_peak_data = ilo_peak_data.drop(0, axis=1)
        ilo_peak_data['Samples-' + str(i)] = ilo_peak_data['Samples-' + str(i)].astype('float64')

        pdu_data[['Timestamps', 'Samples-' + str(i)]] = pdu_data[0].str.split(',', expand=True)
        pdu_data = pdu_data.drop(0, axis=1)
        pdu_data['Samples-' + str(i)] = pdu_data['Samples-' + str(i)].astype('float64')
               
        ilo_ambtemp_df = pd.concat([ilo_ambtemp_df, ilo_ambtemp_data['Samples-' + str(i)]], axis=1)
        ilo_average_df = pd.concat([ilo_average_df, ilo_average_data['Samples-' + str(i)]], axis=1)
        ilo_cpuwatts_df = pd.concat([ilo_cpuwatts_df, ilo_cpuwatts_data['Samples-' + str(i)]], axis=1)
        ilo_dimmwatts_df = pd.concat([ilo_dimmwatts_df, ilo_dimmwatts_data['Samples-' + str(i)]], axis=1)
        ilo_minimum_df = pd.concat([ilo_minimum_df, ilo_minimum_data['Samples-' + str(i)]], axis=1)
        ilo_peak_df = pd.concat([ilo_peak_df, ilo_peak_data['Samples-' + str(i)]], axis=1)
        pdu_df = pd.concat([pdu_df, pdu_data['Samples-' + str(i)]], axis=1)
       

    # Calculate Average and StDev for Ambient Temperature
        
    ilo_ambtemp_average_df = ilo_ambtemp_df.mean()
    ilo_ambtemp_stdev_df = ilo_ambtemp_df.std()
    ilo_ambtemp_df = ilo_ambtemp_df.append(ilo_ambtemp_average_df, ignore_index=True)
    ilo_ambtemp_df = ilo_ambtemp_df.append(ilo_ambtemp_stdev_df, ignore_index=True)

    # Rename the index for the last two rows
    ilo_ambtemp_df = ilo_ambtemp_df.rename(index={ilo_ambtemp_df.index[-2]: 'Average', ilo_ambtemp_df.index[-1]: 'Stdev'})
    ilo_ambtemp_df.to_csv(parent_directory + "/" + directory_name + "/ilo_ambient_temperature.csv", index=False)
    # Calculate Average and StDev for iLo Average
        
    ilo_average_average_df = ilo_average_df.mean()
    ilo_average_stdev_df = ilo_average_df.std()
    ilo_average_df = ilo_average_df.append(ilo_average_average_df, ignore_index=True)
    ilo_average_df = ilo_average_df.append(ilo_average_stdev_df, ignore_index=True)

    # Rename the index for the last two rows
    ilo_average_df = ilo_average_df.rename(index={ilo_average_df.index[-2]: 'Average', ilo_average_df.index[-1]: 'Stdev'})
    ilo_average_df.to_csv(parent_directory + "/" + directory_name + "/ilo_average_power.csv", index=False)
    # Calculate Average and StDev for iLo CPU Watts
        
    ilo_cpuwatts_average_df = ilo_cpuwatts_df.mean()
    ilo_cpuwatts_stdev_df = ilo_cpuwatts_df.std()
    ilo_cpuwatts_df = ilo_cpuwatts_df.append(ilo_cpuwatts_average_df, ignore_index=True)
    ilo_cpuwatts_df = ilo_cpuwatts_df.append(ilo_cpuwatts_stdev_df, ignore_index=True)

    # Rename the index for the last two rows
    ilo_cpuwatts_df = ilo_cpuwatts_df.rename(index={ilo_cpuwatts_df.index[-2]: 'Average', ilo_cpuwatts_df.index[-1]: 'Stdev'})
    ilo_cpuwatts_df.to_csv(parent_directory + "/" + directory_name + "/ilo_cpu_power.csv", index=False)
    # Calculate Average and StDev for iLo Dimm Watts
        
    ilo_dimmwatts_average_df = ilo_dimmwatts_df.mean()
    ilo_dimmwatts_stdev_df = ilo_dimmwatts_df.std()
    ilo_dimmwatts_df = ilo_dimmwatts_df.append(ilo_dimmwatts_average_df, ignore_index=True)
    ilo_dimmwatts_df = ilo_dimmwatts_df.append(ilo_dimmwatts_stdev_df, ignore_index=True)

    # Rename the index for the last two rows
    ilo_dimmwatts_df = ilo_dimmwatts_df.rename(index={ilo_dimmwatts_df.index[-2]: 'Average', ilo_dimmwatts_df.index[-1]: 'Stdev'})
    ilo_dimmwatts_df.to_csv(parent_directory + "/" + directory_name + "/ilo_dimm_power.csv", index=False)
    # Calculate Average and StDev for iLo Minimum
        
    ilo_minimum_average_df = ilo_minimum_df.mean()
    ilo_minimum_stdev_df = ilo_minimum_df.std()
    ilo_minimum_df = ilo_minimum_df.append(ilo_minimum_average_df, ignore_index=True)
    ilo_minimum_df = ilo_minimum_df.append(ilo_minimum_stdev_df, ignore_index=True)

    # Rename the index for the last two rows
    ilo_minimum_df = ilo_minimum_df.rename(index={ilo_minimum_df.index[-2]: 'Average', ilo_minimum_df.index[-1]: 'Stdev'})
    ilo_minimum_df.to_csv(parent_directory + "/" + directory_name + "/ilo_minimum_power.csv", index=False)
    # Calculate Average and StDev for iLo Peak
        
    ilo_peak_average_df = ilo_peak_df.mean()
    ilo_peak_stdev_df = ilo_peak_df.std()
    ilo_peak_df = ilo_peak_df.append(ilo_peak_average_df, ignore_index=True)
    ilo_peak_df = ilo_peak_df.append(ilo_peak_stdev_df, ignore_index=True)

    # Rename the index for the last two rows
    ilo_peak_df = ilo_peak_df.rename(index={ilo_peak_df.index[-2]: 'Average', ilo_peak_df.index[-1]: 'Stdev'})
    ilo_peak_df.to_csv(parent_directory + "/" + directory_name + "/ilo_peak_power.csv", index=False)
    # Calculate Average and StDev for Pdu
        
    pdu_average_df = pdu_df.mean()
    pdu_stdev_df = pdu_df.std()
    pdu_df = pdu_df.append(pdu_average_df, ignore_index=True)
    pdu_df = pdu_df.append(pdu_stdev_df, ignore_index=True)

    # Rename the index for the last two rows
    # pdu_df = pdu_df.rename(index={pdu_df.index[-2]: 'Average', pdu_df.index[-1]: 'Stdev'})
    # pdu_df.to_csv(parent_directory + "/" + directory_name + "/pdu_power.csv", index=False)

    # Calculate the average of each metric to calculate the overall results

    new_column_values = [ilo_ambtemp_average_df.mean(),ilo_average_average_df.mean(),ilo_cpuwatts_average_df.mean(),ilo_dimmwatts_average_df.mean(), ilo_minimum_average_df.mean(), ilo_peak_average_df.mean(),pdu_average_df.mean(),ilo_ambtemp_stdev_df.mean(),ilo_average_stdev_df.mean(),ilo_cpuwatts_stdev_df.mean(), ilo_dimmwatts_stdev_df.mean(),ilo_minimum_stdev_df.mean(),ilo_peak_stdev_df.mean(),pdu_stdev_df.mean()]
    # new_column_values = [ilo_ambtemp_average_df.mean(),ilo_average_average_df.mean(),ilo_cpuwatts_average_df.mean(),ilo_dimmwatts_average_df.mean(), ilo_minimum_average_df.mean(), ilo_peak_average_df.mean(),ilo_ambtemp_stdev_df.mean(),ilo_average_stdev_df.mean(),ilo_cpuwatts_stdev_df.mean(), ilo_dimmwatts_stdev_df.mean(),ilo_minimum_stdev_df.mean(),ilo_peak_stdev_df.mean()]
    results_df[directory_name] = new_column_values

# Save the merged data to a CSV file
results_df.to_csv(parent_directory + "merged_results.csv", index=True)