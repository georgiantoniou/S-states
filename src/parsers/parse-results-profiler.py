import os
import pandas as pd
import json
import statistics
import csv 

# Set the parent directory where experiment directories are located
parent_directory = "/home/ganton12/data/exp5_rapl_ilo_compare"

overall_transitions = {}
overall_residency = {}
overall_rapl = {}
overall_interrupts = {}

temp_name = ""

# Iterate through subdirectories
for directory_name in os.listdir(parent_directory):
    
    directory_path = os.path.join(parent_directory, directory_name)
    
    # check if name is directory
    if not os.path.isdir(directory_path):
        continue

    #check if profiler output is in directory
    # check if name is directory
    profiler_path = os.path.join(directory_path, "profiler_1_180")
    if not os.path.isdir(profiler_path):
        continue

    temp_name=directory_name
    # Initialize an empty dictionary to store residency, transitions and power measurements
    run_transitions = {}
    run_residency = {}
    run_rapl = {}
    run_interrupts = {}

    # Process each file in the experiment directory
    for j in range(1, 6):
        profiler_files = directory_path  + "/profiler_" + str(j) + "_180"
        
        # Put file contents into a dictionary
        for profiler_file in os.listdir(profiler_files):
            prev_time, prev_meas = 0, 0
            cur_time, cur_meas = 0, 0
            with open(profiler_files + "/" + profiler_file, 'r') as file:
                counter = 0
                header = next(file) 
                counter = counter + 1
                for line in file:
                    counter = counter + 1
                    cur_time = line.split(',')[0]
                    cur_meas = line.split(',')[1]

                    if prev_time != 0:
                        break

                    prev_time = line.split(',')[0]
                    prev_meas = line.split(',')[1]
            
            if counter < 3:
                #print(profiler_file)
                continue
            # Check if it is a residency or power files
            if profiler_file.startswith("CPU") and (profiler_file.endswith(".time")):
                CPU = profiler_file.split('.')[0]
                state = profiler_file.split('.')[1]
                
                if CPU in run_residency:
                    if state in run_residency[CPU]:
                        #print(profiler_files)
                        #print(CPU)
                        #print(state)
                        run_residency[CPU][state].append((int(cur_meas)-int(prev_meas))/((int(cur_time)-int(prev_time))*1000000)) 
                    else:
                        run_residency[CPU][state] = []
                        run_residency[CPU][state].append((int(cur_meas)-int(prev_meas))/((int(cur_time)-int(prev_time))*1000000))
                else:
                    run_residency[CPU] = {}
                    run_residency[CPU][state] = []
                    run_residency[CPU][state].append((int(cur_meas)-int(prev_meas))/((int(cur_time)-int(prev_time))*1000000))
            
            elif profiler_file.startswith("CPU") and (profiler_file.endswith(".usage")):
                CPU = profiler_file.split('.')[0]
                state = profiler_file.split('.')[1]
                if CPU in run_transitions:
                    if state in run_transitions[CPU]:
                        run_transitions[CPU][state].append((int(cur_meas)-int(prev_meas)))
                    else:
                        run_transitions[CPU][state] = []
                        run_transitions[CPU][state].append((int(cur_meas)-int(prev_meas)))
                else:
                    run_transitions[CPU] = {}
                    run_transitions[CPU][state] = []
                    run_transitions[CPU][state].append((int(cur_meas)-int(prev_meas)))
            # if it is an interrupt file
            elif profiler_file.startswith("INTR"):
                intr_type = profiler_file.split('.')[1]
                if intr_type not in run_interrupts:
                    run_interrupts[intr_type] = {}
                intr_before = prev_meas.split()
                intr_after = cur_meas.split()
                # print(intr_type)
                # print(intr_before)
                # print(intr_after)
                
                for i in range(0,len(intr_before)):
                
                    if "CPU" + str(i) not in run_interrupts[intr_type]:   
                        #print(run_interrupts[intr_type].keys())
                        run_interrupts[intr_type]["CPU" + str(i)] = []

                    run_interrupts[intr_type]["CPU" + str(i)].append(int(intr_after[i]) - int(intr_before[i]))
                    
            elif "package" in profiler_file:
                if "package-0" in profiler_file:
                    if "package-0" in run_rapl:
                        run_rapl['package-0'].append((int(cur_meas)-int(prev_meas))/(int(cur_time)-int(prev_time))/1000000)
                    else:
                        
                        run_rapl['package-0'] = []
                        run_rapl['package-0'].append((int(cur_meas)-int(prev_meas))/(int(cur_time)-int(prev_time))/1000000)
                else:
                    if "package-1" in run_rapl:
                        run_rapl['package-1'].append((int(cur_meas)-int(prev_meas))/(int(cur_time)-int(prev_time))/1000000)
                    else:
                        run_rapl['package-1'] = []
                        run_rapl['package-1'].append((int(cur_meas)-int(prev_meas))/(int(cur_time)-int(prev_time))/1000000)
        
        #measure C0 residency
        for CPU in run_residency:
            C0_res = 1
            for state in run_residency[CPU]:
                if state != 'C0':
                    C0_res = C0_res - run_residency[CPU][state][(j-1)]
            if not "C0" in run_residency[CPU]: 
                run_residency[CPU]['C0'] = []
            run_residency[CPU]['C0'].append(C0_res)  
    
    avg_residency = {}
    avg_transitions = {}
    
    # Average for all run 
    for CPU in run_residency:
        avg_residency[CPU] = {}
        avg_transitions[CPU] = {}
        for state in run_residency[CPU]:
            avg_residency[CPU][state] = statistics.mean(run_residency[CPU][state])
            if state != "C0":    
                avg_transitions[CPU][state] = statistics.mean(run_transitions[CPU][state])
    
    avg_rapl = {}
    overall_rapl[directory_name] = {}
    for domain in run_rapl:
        avg_rapl[domain] = statistics.mean(run_rapl[domain])
        overall_rapl[directory_name][domain] = statistics.mean(run_rapl[domain]) 
    
    
    avg_interrupts = {}
    for intr in run_interrupts:
        avg_interrupts[intr] = {}
        for cpu in run_interrupts[intr]:
            avg_interrupts[intr][cpu] = statistics.mean(run_interrupts[intr][cpu])
    
    # Average per core , per socket 0 , per socket 1 per overall
    overall_residency[directory_name] = {}
    overall_transitions[directory_name] = {}

    overall_residency[directory_name]['all'] = {}
    overall_residency[directory_name]['0'] = {}
    overall_residency[directory_name]['1'] = {}

    overall_transitions[directory_name]['all'] = {}
    overall_transitions[directory_name]['0'] = {}
    overall_transitions[directory_name]['1'] = {}
    
    if avg_residency:
        for state in avg_residency['CPU0']:    
            overall_residency[directory_name]['all'][state] = 0
            overall_residency[directory_name]['0'][state] = 0
            overall_residency[directory_name]['1'][state] = 0

            overall_transitions[directory_name]['all'][state] = 0
            overall_transitions[directory_name]['0'][state]  = 0
            overall_transitions[directory_name]['1'][state]  = 0

            #socket 0
            for i in range(0,20):
                overall_residency[directory_name]['all'][state] = overall_residency[directory_name]['all'][state] + avg_residency['CPU' + str(i)][state]
                overall_residency[directory_name]['0'][state] = overall_residency[directory_name]['0'][state] + avg_residency['CPU' + str(i)][state]
                if state != "C0":
                    overall_transitions[directory_name]['all'][state] = overall_transitions[directory_name]['all'][state] + avg_transitions['CPU' + str(i)][state]
                    overall_transitions[directory_name]['0'][state] = overall_transitions[directory_name]['0'][state] + avg_transitions['CPU' + str(i)][state]

            #socket 1
            for i in range(20,40):
                overall_residency[directory_name]['all'][state] = overall_residency[directory_name]['all'][state] + avg_residency['CPU' + str(i)][state]
                overall_residency[directory_name]['1'][state] = overall_residency[directory_name]['1'][state] + avg_residency['CPU' + str(i)][state]
                if state != "C0":
                    overall_transitions[directory_name]['all'][state] = overall_transitions[directory_name]['all'][state] + avg_transitions['CPU' + str(i)][state]
                    overall_transitions[directory_name]['1'][state] = overall_transitions[directory_name]['1'][state] + avg_transitions['CPU' + str(i)][state]

            overall_residency[directory_name]['all'][state] = overall_residency[directory_name]['all'][state] / 40
            overall_residency[directory_name]['0'][state] = overall_residency[directory_name]['0'][state] / 20
            overall_residency[directory_name]['1'][state] = overall_residency[directory_name]['1'][state] / 20

            if state != "C0":
                overall_transitions[directory_name]['all'][state] = overall_transitions[directory_name]['all'][state] #/ 40
                overall_transitions[directory_name]['0'][state] = overall_transitions[directory_name]['0'][state] #/ 20
                overall_transitions[directory_name]['1'][state] = overall_transitions[directory_name]['1'][state] #/ 20
    
    overall_interrupts[directory_name] = {}
    for intr in avg_interrupts:
        overall_interrupts[directory_name][intr] = 0
        for cpu in avg_interrupts[intr]:
            overall_interrupts[directory_name][intr] = overall_interrupts[directory_name][intr] + avg_interrupts[intr][cpu]

   
    if avg_residency:
        # print average for specific experiment
        file_path = directory_path + '/profiler_residency.csv'

        # Writing the dictionary to a CSV file
        with open(file_path, 'w', newline='') as csv_file:
            writer = csv.writer(csv_file)
            
            # Write headers - state
            
            states = ["C0", "POLL", "C1-SKX", "C1E-SKX", "C6-SKX"]
            
            # Write labels
            headers = ["-1", "C0", "POLL", "C1-SKX", "C1E-SKX", "C6-SKX"]
            writer.writerow(headers)
            
            # Write data
            for i in range(0,40):
                row = []
                row = ["CPU" + str(i)]
                for state in states:
                    if state in avg_residency["CPU" + str(i)]: 
                        row.append(avg_residency["CPU" + str(i)][state])
                    else:
                        continue
                writer.writerow(row)   

        file_path = directory_path + '/profiler_transitions.csv'

        # Writing the dictionary to a CSV file
        with open(file_path, 'w', newline='') as csv_file:
            writer = csv.writer(csv_file)
            
            # Write headers - state
            
            states = ["POLL", "C1-SKX", "C1E-SKX", "C6-SKX"]
            
            # Write labels
            headers = ["-1", "POLL", "C1-SKX", "C1E-SKX", "C6-SKX"]
            writer.writerow(headers)
            
            # Write data
            for i in range(0,40):
                row = []
                row = ["CPU" + str(i)]
                for state in states:
                    if state in avg_residency["CPU" + str(i)]:
                        row.append(avg_transitions["CPU" + str(i)][state])
                    else:
                        continue
                writer.writerow(row)  
    
    
    if avg_interrupts:
        
        file_path = directory_path + '/profiler_interrupts_.csv'
        
        # Writing the dictionary to a CSV file
        with open(file_path, 'w', newline='') as csv_file:
            writer = csv.writer(csv_file)
            
            # Write headers - state
            
            headers = [-1]
            # Write labels
            for state in avg_interrupts:
                headers.append(state)
            writer.writerow(headers)
            
            # Write data
            for i in range(0,40):
                row = []
                row = ["CPU" + str(i)]
                for state in headers:
                    if state == -1:
                        continue
                    id = "CPU" + str(i)
                    if id in avg_interrupts[state]:
                        row.append(avg_interrupts[state]["CPU" + str(i)])
                    else:
                        row.append("0")
                writer.writerow(row) 
    
    file_path = directory_path + '/profiler_rapl.csv'

    # Writing the dictionary to a CSV file
    with open(file_path, 'w', newline='') as csv_file:
        writer = csv.writer(csv_file)
        
        # Write headers - state
        
        states = ["package-0", "package-1"]
        
        # Write labels
        headers = ["package-0", "package-1"]
        writer.writerow(headers)
        
        # Write data
        for i in range(0,len(run_rapl[states[0]])):
            row = []
            for domain in run_rapl:
                row.append(run_rapl[domain][i])
            writer.writerow(row)  

# print overall statistics in file  
temp_name=directory_name
if temp_name in overall_residency and "all" in overall_residency[temp_name]:
    file_path = parent_directory + '/merged_profiler_residency.csv'

    # Writing the dictionary to a CSV file
    with open(file_path, 'w', newline='') as csv_file:
        writer = csv.writer(csv_file)
        
        # Write headers - state
        
        states = ["C0", "POLL", "C1-SKX", "C1E-SKX", "C6-SKX"]
        
        # Write labels
        headers = ["-1","-1","-1", "C0", "POLL", "C1-SKX", "C1E-SKX", "C6-SKX"]
        writer.writerow(headers)
        

        # Write data
        for experiment, domains in overall_residency.items():
            row = []
            for domain in domains:
                if domain == "all":
                    row = ["-1",experiment,domain]
                else:
                    row = ["-1","-1",domain]
                for state in states:
                    if state in overall_residency[experiment][domain]:
                        row.append(overall_residency[experiment][domain][state])
                    else:
                        continue
                writer.writerow(row)     
            

    file_path = parent_directory + '/merged_profiler_transitions.csv'

    # Writing the dictionary to a CSV file
    with open(file_path, 'w', newline='') as csv_file:
        writer = csv.writer(csv_file)
        
        # Write headers - state
        
        states = ["POLL", "C1-SKX", "C1E-SKX", "C6-SKX"]
        
        # Write labels
        headers = ["-1","-1","-1", "POLL", "C1-SKX", "C1E-SKX", "C6-SKX"]
        writer.writerow(headers)
        

        # Write data
        for experiment, domains in overall_transitions.items():
            row = []
            for domain in domains:
                if domain == "all":
                    row = ["-1",experiment,domain]
                else:
                    row = ["-1","-1",domain]
                for state in states:
                    if state in overall_transitions[experiment][domain]:
                        row.append(overall_transitions[experiment][domain][state])
                    else:
                        continue
                writer.writerow(row)


file_path = parent_directory + '/merged_profiler_rapl.csv'

# Writing the dictionary to a CSV file
with open(file_path, 'w', newline='') as csv_file:
    writer = csv.writer(csv_file)
    
    # Write headers - state
    
    states = ["package-0", "package-1"]
    
    # Write labels
    headers = ["-1","-1","-1", "package-0", "package-1"]
    writer.writerow(headers)
    

    # Write data
    for experiment, domains in overall_rapl.items():
        row = []
        row = ["-1","-1",experiment]
        for domain in domains: 
            row.append(overall_rapl[experiment][domain])
        writer.writerow(row)

# print overall statistics in file   
if overall_interrupts:
    for exp in overall_interrupts:
        temp_name = exp
        break
    headers=[-1]
    for state in overall_interrupts[temp_name]:
        headers.append(state)
    
    file_path = parent_directory + '/merged_profiler_interrupt.csv'

    # Writing the dictionary to a CSV file
    with open(file_path, 'w', newline='') as csv_file:
        writer = csv.writer(csv_file)
        writer.writerow(headers) 
        row = []
        # Write data
        for experiment in overall_interrupts:
            row.append(experiment)
            for state in headers:
                if state != -1:
                    if state in overall_interrupts[experiment]:
                        row.append(overall_interrupts[experiment][state])
                    else:
                        row.append("0")
            writer.writerow(row)
            row=[]    