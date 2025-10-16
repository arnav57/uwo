#####################################################################################################
#### AISE 4430 - Lab 2 Code
#####################################################################################################
#### Author: 
#### 	Arnav Goyal
####
#### Description:
####	This script accepts a TCP file transfer pcapng file exported as a CSV
####	Each packet in this CSV is either the desired TCP, or something else which we dont care abt
####	Once we have these TCP packets only we can plot this window value over time
####################################################################################################


########################### IMPORTS ###########################
import os, sys, re
import matplotlib.pyplot as plt
from matplotlib.ticker import MaxNLocator
import pandas as pd


#### Read in the CSV and parse it into a df, also only consider host -> sender packets
def read_and_create_df(csv_filename:str, sender_ip:str, host_ip:str):

	## read in csv
	csv_path = os.path.abspath(f"task4v2/{csv_filename}")
	print(f"Reading in CSV From {csv_path}... \n")
	df_raw   = pd.read_csv(csv_path, index_col="No.")

	## filter df to only obtain sender to host packets this is the cwnd (limit of how much data TX can send to avoid congestion)
	## we can also get the rwnd which is how much data the receiver can handle to avoid congestion by flipping this expression below
	df_s2h   = df_raw[(df_raw["Protocol"] == "TCP")]
	
	return df_s2h

#### Iterate over csv and create a new column for window values and frame-time values
def create_window_col(df, window_col_name:str):

	## create temp list
	win_vals = []

	for info_string in df[window_col_name]:
		win_pattern = r'.*Win=(\d+).*'
		found = re.search(win_pattern, info_string)

		if found:
			win_vals.append(found.group(1))
		else:
			win_vals.append(-1) # if data isnt present create an obviously wrong value

	df["Window"] = win_vals

	df['FrameTime'] = df['Time'].diff().fillna(0)

	return df



#### Plot the window value over time from the df
def plot_window(df, hostname:str):
	time_vals   =  df['Time']
	window_vals =  df['Window']

	plt.figure()
	plt.step(time_vals, window_vals, color='orange')
	plt.gca().yaxis.set_major_locator(MaxNLocator(nbins=10))
	plt.xlabel("Frametime [s]")
	plt.ylabel("Congestion Window Size [B]")
	plt.title(f"Window Size [B] over time [s] - {hostname}-eth0 capture")

	plt.savefig(f"{hostname}_window.png")
	plt.close()


data = {
	## filename : sender-ip
	"h1.csv" : {"hostname":"h1", "ip":"10.0.0.1"},
	"h3.csv" : {"hostname":"h3", "ip":"10.0.0.3"}
}

for filename in data.keys():
	df = read_and_create_df(filename, data[filename]["ip"], "10.0.0.2")
	df = create_window_col(df, "Info")
	print(df.head(10))
	plot_window(df, data[filename]["hostname"])


