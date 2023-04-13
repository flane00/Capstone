# Capstone
This directory is a documentation of workflow to implement a machine learning protocol for using a regression algorithm to
 predict integrated chlorophyll using matchups from VIIRS Ocean Color predictors.
 This model is a preliminary build to include matchup VIIRS SST predictors as well, which will be a easy change.

Run conda activate capstone. Included in the config_capstone.ymL 
which was generated with line touch config_capstone.yml

The csv_out.m file is how we pulled and indexed the data from it's local directory to generate a .csv, further in that there is a depth 
binning to integration of chlorophyll profiles.

matchtable.csv is the csv from csv_out.m 

VIIRS_2_Intchl_regression_model.ipynb : this file is the machine to compare the various regressor model 
performances with the similar machine learning builds (scaling and splitting). This currently only includes 
data availabe through VIIRS ocean color netcdf files. 
-chla
-kd
-lat
-lon
-time (in year day) 

