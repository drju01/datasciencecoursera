INSTRUCTIONS - run_analysis.R

In order to run the script make sure you set your working directory (setwd()) to original location with test and training datasets 
(ie. "UCI HAR Dataset" directory).

The R script run_analysis.R works as follows:
 - verifies that your working directory is "UCI HAR Dataset"
 - loads necessary packages (and installs them first if necessary)
 - reads dictionary datasets first (ie. features.txt and activity_labels.txt)
 - iterates over "test" and "train" directories performing the following actions:
    - reads main dataset as one field dataset and splits it into separate fields
    - sets column names in line with "features" vector
    - adds "SetType" column (to distinguish "test" and "train" datasets)
    - reads and merges activity and activity_labels datasets and appends activity label to the main dataset
       ("Activity" column)
    - reads subject dataset and appends "Subject" column to the main dataset
    - stores data.table in list
 - after "test" and "train" datasets have been adjusted, the script unions them 
 - next, all the unnecessary columns are removed (ie. other than std() or mean() related masures and main descriptive attributes)
 - the dataset is reshaped, all measure names and corrsponding measure values are normalized into 2 columns (melt)
 - -XYZ suffix is added to measure names without axis information
 - measure name column is split into 3 attributes, ie. Signal, Measure and Axis
 - average of each measure value is calculated across Subject, Activity, SetType, Signal, Measure, Axis
 - resulting dataset is saved to xy_avg.txt


DATA DICTIONARY - xy_avg.txt

* Subject
	- 1-30, identifies the subject who performed the activity
* Activity 
	- activty peformed by subject - one of:
		- WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING
* SetType
	- either "test" or "train", identifies the dataset type 
* Signal
	- signal type as described in "Human Activity Recognition Using Smartphones Dataset":
		- "fBodyAcc"             "fBodyAccJerk"         "fBodyAccMag"         
		"fBodyBodyAccJerkMag"  "fBodyBodyGyroJerkMag" "fBodyBodyGyroMag"    
		"fBodyGyro"            "tBodyAcc"             "tBodyAccJerk"        
		"tBodyAccJerkMag"      "tBodyAccMag"          "tBodyGyro"           
		"tBodyGyroJerk"        "tBodyGyroJerkMag"     "tBodyGyroMag"        
		"tGravityAcc"          "tGravityAccMag"  
* Measure
	- either std (standard deviation) or mean
* Axis
	- X,Y,Z or XYZ to identify the axis of measurement
* MeasureValue
	- value of the Measure (std or mean)
