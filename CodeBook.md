# CodeBook.md
## Collecting and Cleaning Data
## Week 4 Project

In this assignment, I created an R script to process data associated with wearable computing data
The script has sections to load, combine, clean, label,  and save data

##The Files
The data was provided in a zip archive which I extracted into
a directory I later renamed UCIHARDataset to facilitate access and use.  The files are
located in both the root directory and in two subdirectories named "train" and "test".

The files are:
* X_train.txt: 7352 observations of 561 features
* subject_train.txt: vector of 7352 subject ID's to map to the X_train.txt observations
* y_train.txt: vector of 7352 activity ID's to map to the X_train.txt observations
* X_test.txt: 2947 observations of 561 features
* subject_test.txt: vector of 2947 subject ID's to map to the X_test.txt observations
* y_test.txt: vector of 2947 activity ID's to map to the X_test.txt observations
* features.txt: Names of the 561 features.
* activity_labels.txt: table relating Activity ID's to Activity Names

##Processing
1.Start by gathering all the test and training data into tables on the system
2.Create merged dataframes for all data associated with Test and Tables observations
3.Create a single merged dataframe for all the data
4.Create column names useing features.txt, subject, and activity naming that make the merged data clear
5.Extract columns that contain only mean or std information based on their names
6.Add a column with the activity names corresponding to the existing activity ID's from activity_labels.txt
7.Group the resulting dataset by subject and activity, taking a mean of all readings of those groups
8.Create final file with only Subject, Activity, and Mean data

##Summary
The resulting data file new_tidy_data_means.txt contains the means of all readings grouped by subject and activity type.  There is much more detailed processing information within the script, run_analysis.R.
