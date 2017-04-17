#### 1. Merge the training and the test sets to create one data set. ####

## Read in all test data
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt",
                           col.names = "subject")
X_col_Names <- read.table("./UCI HAR Dataset/features.txt")
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt",
                     col.names = X_col_Names$V2)
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", 
                     col.names = "activity")

## Reading in Inertial Signals data: commented out as not needed for the subsequent steps
# body_acc_x_test <- read.table("./UCI HAR Dataset/test/Inertial Signals/body_acc_x_test.txt")
# body_acc_y_test <- read.table("./UCI HAR Dataset/test/Inertial Signals/body_acc_y_test.txt")
# body_acc_z_test <- read.table("./UCI HAR Dataset/test/Inertial Signals/body_acc_z_test.txt")
# total_acc_x_test <- read.table("./UCI HAR Dataset/test/Inertial Signals/total_acc_x_test.txt")
# total_acc_y_test <- read.table("./UCI HAR Dataset/test/Inertial Signals/total_acc_y_test.txt")
# total_acc_z_test <- read.table("./UCI HAR Dataset/test/Inertial Signals/total_acc_z_test.txt")
# body_gyro_x_test <- read.table("./UCI HAR Dataset/test/Inertial Signals/body_gyro_x_test.txt")
# body_gyro_y_test <- read.table("./UCI HAR Dataset/test/Inertial Signals/body_gyro_y_test.txt")
# body_gyro_z_test <- read.table("./UCI HAR Dataset/test/Inertial Signals/body_gyro_z_test.txt")

## Merge test data files column-wise
test_data <- data.frame(subject_test, X_test, y_test
                        # , 
                        # body_acc_x_test, body_acc_y_test, body_acc_z_test, 
                        # total_acc_x_test, total_acc_y_test, total_acc_z_test,
                        # body_gyro_x_test, body_gyro_y_test, body_gyro_z_test
                        )

## Read in all train data
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", 
                            col.names = "subject")
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt",
                      col.names = X_col_Names$V2)
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", 
                      col.names = "activity")

# body_acc_x_train <- read.table("./UCI HAR Dataset/train/Inertial Signals/body_acc_x_train.txt")
# body_acc_y_train <- read.table("./UCI HAR Dataset/train/Inertial Signals/body_acc_y_train.txt")
# body_acc_z_train <- read.table("./UCI HAR Dataset/train/Inertial Signals/body_acc_z_train.txt")
# total_acc_x_train <- read.table("./UCI HAR Dataset/train/Inertial Signals/total_acc_x_train.txt")
# total_acc_y_train <- read.table("./UCI HAR Dataset/train/Inertial Signals/total_acc_y_train.txt")
# total_acc_z_train <- read.table("./UCI HAR Dataset/train/Inertial Signals/total_acc_z_train.txt")
# body_gyro_x_train <- read.table("./UCI HAR Dataset/train/Inertial Signals/body_gyro_x_train.txt")
# body_gyro_y_train <- read.table("./UCI HAR Dataset/train/Inertial Signals/body_gyro_y_train.txt")
# body_gyro_z_train <- read.table("./UCI HAR Dataset/train/Inertial Signals/body_gyro_z_train.txt")

## Merge train data files column-wise
train_data <- data.frame(subject_train, X_train, y_train
                        # , 
                        # body_acc_x_train, body_acc_y_train, body_acc_z_train, 
                        # total_acc_x_train, total_acc_y_train, total_acc_z_train,
                        # body_gyro_x_train, body_gyro_y_train, body_gyro_z_train
                        )

## Merge test and train data files row-wise and write data to file
tidy_data <- rbind(train_data, test_data)
write.table(tidy_data, "./UCI HAR Dataset/tidy_data.txt")


#### 2. Extract only the measurements on the mean and standard deviation ####
#### for each measurement. ####

## Select all columns with "mean" or "std" in name (and "subject" and "test_label")
selected_data <- tidy_data[, grep("subject|activity|mean|std", colnames(tidy_data))]


#### 3. Use descriptive activity names to name the activities in the data ####
#### set. ####
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
selected_data$activity <- factor(selected_data$activity, labels = activity_labels$V2)

#### 4. Appropriately label the data set with descriptive variable names. ####
## already accomplished in step 1 by assigning the appropriate column names

#### 5. From the data set in step 4, create a second, independent tidy data #### 
#### set with the average of each variable for each activity and each ####
#### subject. ####
library(dplyr)
selected_data <- tbl_df(selected_data)
selected_data_grouped <- group_by(selected_data, subject, activity)
mean_data_grouped <- summarise_each(selected_data_grouped, funs(mean), 
                                    tBodyAcc.mean...X:fBodyBodyGyroJerkMag.meanFreq..)
write.table(mean_data_grouped, "./UCI HAR Dataset/mean_data_grouped.txt", row.names = FALSE)
