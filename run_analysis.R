#####################################################################################
## Getting and Cleaning Data Course Project
## Martín Dâvila
## 20150823
#####################################################################################
## Description of the following script
## runAnalysis.r
#####################################################################################
## This script will perform the following project steps, taken from the web page: 
## Step 1. Merges the training and the test sets to create one data set.
## Step 2. Extracts only the measurements on the mean and standard deviation 
##         for each measurement. 
## Step 3. Uses descriptive activity names to name the activities in the data set
## Step 4. Appropriately label the data set with descriptive activity names. 
## Step 5. From the dataset in step 4, creates a second, independent tidy data set
##         with the average of each variable for each activity and each subject.
#####################################################################################


# First of all we need to set the work directory, in which we find all the data sets
# for me is the following
setwd("C:/Coursera/Course Project")
getwd()


# Clean up the workspace
rm(list=ls())


# We will use of the package: plyr
# So we need to load it
library(plyr)

####################################################################################
# First point
# Merges the training and the test sets to create one data set
# Build the variables for train
x_train <- read.table("train/x_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")


# Build the variables for test
x_test <- read.table("test/x_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")


# Now we must to build the 'x' data set
x_data <- rbind(x_train, x_test)


# Now we must to build the 'y' data set
y_data <- rbind(y_train, y_test)


# Now we must to build the 'subject' data set
subject_data <- rbind(subject_train, subject_test)


####################################################################################
# Second point
# Extracts only the measurements on the mean and standard deviation
# for each measurement
features <- read.table("features.txt")


# We must to obtain only the columns with "mean" for the average 
# and "std" for the standard deviation in their names
features_mean_std <- grep("-(mean|std)\\(\\)", features[, 2])


# We subset the desired columns
x_data <- x_data[, features_mean_std]


# Then we must to correct the names for the columns
names(x_data) <- features[features_mean_std, 2]


####################################################################################
# Third point
# Uses descriptive activity names to name the activities in the data set
activities <- read.table("activity_labels.txt")


# We update the values with correct activity names
y_data[, 1] <- activities[y_data[, 1], 2]


# We correct the column name
names(y_data) <- "activity"


####################################################################################
# Fourth point
# Appropriately labels the data set with descriptive variable names
# We correct the column name
names(subject_data) <- "subject"


# We bind all the data in a single data set
all_data <- cbind(x_data, y_data, subject_data)

####################################################################################
# Fifth point
# From the data set in step 4
# creates a second, independent tidy data set
# with the average of each variable for each activity and each subject
# Activity and subject columns in a tidy data
averages_data <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))

# Finally we obtain the final tidy data table
write.table(averages_data, "averages_data.txt", row.name = FALSE)
