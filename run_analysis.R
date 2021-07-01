## This R script creates a tidy dataset from the data provided in this dataset :
## "Human Activity Recognition Using Smartphones Data Set" (UCI)


## ----------------------------------------------------------------
## 1. Merges the training and the test sets to create one data set.

## Downloads the original HAR dataset from the UCI website
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if(!file.exists("uci_har.zip")){download.file(fileUrl, destfile = "uci_har.zip")}
if(!file.exists("UCI HAR Dataset")){unzip("uci_har.zip")}

## Binds the data from <subject_test/train> files
subjects_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
subjects_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
subjects <- rbind(subjects_train, subjects_test)

## Binds the measurements (from <X_test/train> files)
features_train <- read.table("UCI HAR Dataset/train/X_train.txt")
features_test <- read.table("UCI HAR Dataset/test/X_test.txt")
features <- rbind(features_train, features_test)

## Binds the data from <y_test.train> files
activities_train <- read.table("UCI HAR Dataset/train/y_train.txt")
activities_test <- read.table("UCI HAR Dataset/test/y_test.txt")
activities_without_names <- rbind(activities_train, activities_test)

dataset_0 <- cbind(subjects, activities_without_names, features)
## ----------------------------------------------------------------
## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
features_names <- read.table("UCI HAR Dataset/features.txt", col.names = c("id", "name"))
names(dataset_0) <- c("subject_id", "activity_id", features_names$name)
dataset_1 <- select(dataset_0, c("subject_id", "activity_id", grep("mean\\()|std\\()", features_names$name, value = TRUE)))

## ----------------------------------------------------------------
## 3. Uses descriptive activity names to name the activities in the data set 
activities_names <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("activity_id", "activity_name"))
dataset_1 <- merge(dataset_1, activities_names, all = TRUE) %>%
    rename(activity = activity_name) %>%
    relocate(activity, .after = subject_id) %>%
    mutate(activity_id = NULL)

## ----------------------------------------------------------------
## 4. Appropriately labels the data set with descriptive variable names

## replaces the t and f prefixes by more readable prefixes :
names(dataset_1) <- gsub("^f([A-Z])","frequency_\\1",names(dataset_1))
names(dataset_1) <- gsub("^t([A-Z])","time_\\1",names(dataset_1))

## removes the parenthesis :
names(dataset_1) <- gsub("\\()","",names(dataset_1))

## uses _ as separator instead of -
names(dataset_1) <- gsub("-","_",names(dataset_1))

## adds a separator between word
names(dataset_1) <- gsub("([a-z])([A-Z])", "\\1_\\2", names(dataset_1))

## uses lower characters only
names(dataset_1) <- tolower(names(dataset_1))

## ----------------------------------------------------------------
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

dataset_2 <- dataset_1 %>%
    group_by(activity, subject_id) %>%
    summarize(across(everything(), mean))

## Exports the dataset in a text file
write.table(dataset_2, "dataset_2.txt",  row.names = FALSE)
