# Code Book

## source data

description of the raw data is found here:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

## description of code

### 1. merge raw training and test data

- set the working directory
- read in tables with raw data:
features.txt
activity_labels.txt
subject_train.txt
x_train.txt
y_train.txt
subject_test.txt
x_test.txt
y_test.txt
- bind to create one data set

### 2. extract only thes means and standard deviations for each measurement
grep columns with appropriate names

### 3. use descriptive activity names
merge with the activityType table that includes descriptive activity names

### 4. label data set with descriptive activity names
gsub function to clean up the column names (**assuming that this is requested task**)

### 5. create new data set with the average of each variable for each activity and each subject.
aggregate function to produce new dataframe with the mean of each variable for each activity and subject
