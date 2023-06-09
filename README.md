# Capstone
This directory is a documentation of a project workflow to implement a machine learning protocol for using a regression algorithm to
predict integrated chlorophyll using matchups from remote sensing predictors.

Data:
The remote sensing predictors for this version are all from the VIIRS Ocean Color instrument netcdfs download with the getOC.py function, (https://github.com/OceanOptics/getOC). Depth integrated Spray Glider chlorophyll fluroresence from the PEACH program (soon to be published) is the target, integrated chlorophyll. 

Notes, intentions, and background: 
It's worth noting that these regressors do not perform at this time to confidently predicted integrated chlorophyll from ocean color information alone (highest accuracy is Rsq=0.6, predictions vs testing set). Furthermore, this build is a preliminary template which does not include sea surface temperature remote sensing predictor (see bottom for list of current predictors). This is because of need for more storage to perform colocation of SST (in addition to ocean color match up), we will rebuild this project in a high performance computing cluster (in progess). The idea for and background of this project stems from references like the one below and the outcome it's completion would be a novel result in the region of this dataset. 

Sammartino, M., Buongiorno Nardelli, B., Marullo, S., & Santoleri, R. (2020). An artificial 
neural network to infer the Mediterranean 3D chlorophyll-a and temperature fields from 
remote sensing observations. Remote Sensing, 12(24), 4123. 

The diagram below describes the workflow that sets up the data set which flows into and then condensed with csv_out.m to yield matchtable.csv.
match_pixel.m is not included at this time because it is built for the unpublished data. 

<img width="809" alt="workflow_schematic" src="https://user-images.githubusercontent.com/123086430/233086804-bd519f1f-404a-436a-aee1-27a108298414.png">

config_capstone.yml: includes all environmental dependencies to run this script. 

csv_out.m: is how the data is pulled and indexed from it's local directory to generate a .csv, included in that there is a depth 
binning to integration of chlorophyll profiles.

matchtable.csv is the csv from csv_out.m (no longer included; will be 
included once data is published). 

VIIRS_2_Intchl_regression_model.ipynb : this file is the machine to compare the various regressor model 
performances with the similar machine learning builds (scaling and splitting). This currently only includes 
data availabe through VIIRS ocean color netcdf files. 
VIIRS ocean color netcdf outputs (our predictors)
-chla
-kd
-lat
-lon
-time (in year day) 

Target: Glider Integrated Chlorophyll. 

