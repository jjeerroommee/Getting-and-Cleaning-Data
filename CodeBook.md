# Coursera Getting and Cleaning Data Course Project

## Original data
The dataset *dataset_2* is created from the HAR dataset published in the UCI website.

It contains the average value of 66 attributes (columns 3 to 68) for each activity and each subject (6 activities * 30 subjects = 180 lines).

The 66 attributes are a subset of the 561 attributes from the original data.
The average of each attribute is computed on all observations present in the original dataset : training set and test set are merged before mean() function is applied.

The names of the columns are transformed to make them more readable in dataset_2.
Please refer to "features_info.txt" in the original dataset to see how.


## Colums details (in order)
- activity (text) : one of the 6 possibles activities performed while the measurements were done
- subject_id (integer) : identifier of the subject who performed the activity among the 30 subjects who participated in the experiment
- from column 3 to 68 : average value for each attribute (the column's name is the attribute name). Please refer to "features.txt and "features_info.txt" in the original dataset to know more.
