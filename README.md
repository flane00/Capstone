# Capstone
This directory is a documentation of workflow to implement a machine learning protocol for using a regression algorithm to
predict integrated chlorophyll using matchups from VIIRS Ocean Color predictors. This project is using Spray Glider chlorophyll fluroresence from the PEACH program (soon to be published) as the target. The current build of this model is preliminary and only based on information included in the Ocean color instrument netcdf. Future versions will include matchup VIIRS SST predictors as well, which will be a easy change after the match up is complete. The idea for and background of this project comes from the reference below. 
 
 Sammartino, M., Buongiorno Nardelli, B., Marullo, S., & Santoleri, R. (2020). An artificial 
neural network to infer the Mediterranean 3D chlorophyll-a and temperature fields from 
remote sensing observations. Remote Sensing, 12(24), 4123. 

Run conda activate capstone. Included in the config_capstone.ymL 
which was generated with line touch config_capstone.yml

The csv_out.m file is how we pulled and indexed the data from it's local directory to generate a .csv, further in that there is a depth 
binning to integration of chlorophyll profiles.

matchtable.csv is the csv from csv_out.m (no longer included; will be 
included once data is published). 

VIIRS_2_Intchl_regression_model.ipynb : this file is the machine to compare the various regressor model 
performances with the similar machine learning builds (scaling and splitting). This currently only includes 
data availabe through VIIRS ocean color netcdf files. 
-chla
-kd
-lat
-lon
-time (in year day) 

