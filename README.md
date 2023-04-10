# Capstone
This directory is a documentation of workflow to implement a machine learning protocol for using a regression algorithm to
 predict integrated chlorophyll using matchups from VIIRS Ocean Color predictors.
 This model is a preliminary build to include matchup VIIRS SST predictors as well, which will be a easy change.



The csv_out.m file is how we pulled and indexed the data from it's local directory to generate a .csv, further in that there is a depth 
binning to integration of chlorophyll profiles.

matchtable.csv is the csv from csv_out.m 

MLPRegressor_OC_Intchl.ipynb (which will likely have a name change to generally include a array of Machine-learniong methods, given there 
was better performance of KnnRegressor then the MLP neural network.... the preliminary goal of this project may transition to finding the 
best performing regressor model, however, this may revert at the time when SST is included. 

 
