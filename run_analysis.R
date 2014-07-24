# Set working directory in correct folder where files are located
# Then read 'test' and 'train' files in seperate variables 
directory <- getwd()
folder1 <- "test"
test_dir <- paste(directory, folder1, sep = "/")
dir <- setwd(test_dir)
sub_test <- read.table("subject_test.txt")
X_test <- read.table("X_test.txt")
Y_test <- read.table("Y_test.txt")

folder2 <- "train"
train_dir <- paste(directory, folder2, sep = "/")
dir <- setwd(train_dir)
sub_train <- read.table("subject_train.txt")
X_train <- read.table("X_train.txt")
Y_train <- read.table("Y_train.txt")

## 1. Merging the training and test sets to create one data set

# After looking at dimensions of these variables it is clear how to bind them together
train <- cbind(X_train, Y_train, sub_train)
test <- cbind(X_test, Y_test, sub_test)
test_train_df <- rbind(train, test)

## 2. Extracting only the measurements on the mean and sd for each measurement

# Looking in the features.txt for the corresponding columns for sd and mean
# According to features_info.txt the measured mean and sd are mean() and std()
# Not including the additional vectors (col 555-561) because they are averages of signals
# and only used to obtain the angle between two vectors.

# Read the features.txt file and extract rows that have mean() and std()
feat <- read.table("features.txt")
toMatch <- c("mean", "std")
mean_std_rows <- grep(paste(toMatch, collapse="|"), feat$V2, ignore.case=FALSE)

# Extract measurements of total data set by extracting rows mean_df and std_df
Y_tr_tst <- rbind(Y_train, Y_test)
sub_tr_tst <- rbind(sub_train, sub_test)
Y_sub <- cbind(Y_tr_tst, sub_tr_tst)
mean_std_df <- test_train_df[mean_std_rows]
ms_total_df <- cbind(mean_std_df, Y_sub)

## 3. Uses descriptice activity names to name the activities in the data set

# Use the mean and std table 
# The activity labels are in variable: Y_train and Y_test (column nr 80)
labels <- ms_total_df[80]
# Replace label numbers by activity names and save them in a new variable (ac6)
ac1 <- lapply(labels, function(x){replace(x, x==1,"WALKING")})
ac2 <- lapply(ac1, function(x){replace(x, x==2,"WALKING_UPSTAIRS")})
ac3 <- lapply(ac2, function(x){replace(x, x==3,"WALKING_DOWNSTAIRS")})
ac4 <- lapply(ac3, function(x){replace(x, x==4,"SITTING")})
ac5 <- lapply(ac4, function(x){replace(x, x==5,"STANDING")})
ac6 <- lapply(ac5, function(x){replace(x, x==6,"LAYING")})

# Add new list with activities to dataframe
act_df <- cbind(ms_total_df, ac6)

# Delete original column with activities by label numbers
act_final <- act_df[-80]

## 4. Appropriately label the data set with descriptive variable names
# Get the columns names from features.txt that belong to the mean and std data
col_feat <- feat[mean_std_rows, ]
# Transform the names to a vector variable
col_vect <- as.vector(col_feat$V2)
# Add two column titles (subject and activity) to this vector
col_all <- c(col_vect, "Subject", "Activity")
# Assign this new vector with all column names to previous data set
colnames(act_final) <- col_all
# The variable "act_final" is the data set with new assigned column names

## 5. Create a second, independent tidy data set with the average of each 
## variable for each activity and each subject

# So I want a tidy data set that is sorted by activity and gives me all 30 subjects
# for each activity and all average measurements of mean() and std() for each 
# of these subjects. So the data set will be 6(activities)x30(subject)=180 rows long 
# and 81 columns wide (activity, subject & average of 79 variables on mean() and std())

# Summarize average by activity per subject in a tidy data set
df_noLab <- act_df[-80]
df_means <- ddply(df_noLab, V1.2~V1.1,summarise,
               'Time.Body.Accel.Mean.X'=mean(V1), 'Time.Body.Accel.Mean.Y'=mean(V2),
               'Time.Body.Accel.Mean.Z'=mean(V3),'Time.Body.Accel.Std.X'=mean(V4),
               'Time.Body.Accel.Std.Y'=mean(V5),'Time.Body.Accel.Std.Z'=mean(V6),
               'Time.Gravity.Accel.Mean.X'=mean(V41),'Time.Gravity.Accel.Mean.Y'=mean(V42),
               'Time.Gravity.Accel.Mean.Z'=mean(V43), 'Time.Gravity.Accel.Std.X'=mean(V44),
               'Time.Gravity.Accel.Std.Y'=mean(V45),'Time.Gravity.Accel.Std.Z'=mean(V46),
               'Time.Body.Accel.Jerk.Mean.X'=mean(V81),'Time.Body.Accel.Jerk.Mean.Y'=mean(V82),
               'Time.Body.Accel.Jerk.Mean.Z'=mean(V83),'Time.Body.Accel.Jerk.Std.X'=mean(V84),
               'Time.Body.Accel.Jerk.Std.Y'=mean(V85),'Time.Body.Accel.Jerk.Std.Z'=mean(V86),
               'Time.Body.Gyroscope.Mean.X'=mean(V121),'Time.Body.Gyroscope.Mean.Y'=mean(V122),
               'Time.Body.Gyroscope.Mean.Z'=mean(V123),'Time.Body.Gyroscope.Std.X'=mean(V124),
               'Time.Body.Gyroscope.Std.Y'=mean(V125),'Time.Body.Gyroscope.Std.Z'=mean(V126),
               'Time.Body.Gyroscope.Jerk.Mean.X'=mean(V161), 'Time.Body.Gyroscope.Jerk.Mean.Y'=mean(V162),
               'Time.Body.Gyroscope.Jerk.Mean.Z'=mean(V163), 'Time.Body.Gyroscope.Jerk.Std.X'=mean(V164),
               'Time.Body.Gyroscope.Jerk.Std.Y'=mean(V165), 'Time.Body.Gyroscope.Jerk.Std.Z'=mean(V166),
               'Time.Body.Accel.Magnitude.Mean'=mean(V201), 'Time.Body.Accel.Magnitude.Std'=mean(V202),
               'Time.Gravity.Accel.Magnitude.Mean'=mean(V214), 'Time.Gravity.Accel.Magnitude.Std'=mean(V215),
               'Time.Body.Accel.Jerk.Magnitude.Mean'=mean(V227), 'Time.Body.Accel.Jerk.Magnitude.Std'=mean(V228),
               'Time.Body.Gyroscope.Magnitude.Mean'=mean(V240), 'Time.Body.Gyroscope.Magnitude.Std'=mean(V241),
               'Time.Body.Gyroscope.Jerk.Magnitude.Mean'=mean(V253), 'Time.Body.Gyroscope.Jerk.Magnitude.Std'=mean(V254),
               'Freq.Body.Accel.Mean.X'=mean(V266), 'Freq.Body.Accel.Mean.Y'=mean(V267),
               'Freq.Body.Accel.Mean.Z'=mean(V268), 'Freq.Body.Accel.Std.X'=mean(V269),
               'Freq.Body.Accel.Std.Y'=mean(V270), 'Freq.Body.Accel.Std.Z'=mean(V271),
               'Freq.Body.Accel.Mean.Freq.X'=mean(V294), 'Freq.Body.Accel.Mean.Freq.Y'=mean(V295),
               'Freq.Body.Accel.Mean.Freq.Z'=mean(V296), 'Freq.Body.Accel.Jerk.Mean.X'=mean(V345),
               'Freq.Body.Accel.Jerk.Mean.Y'=mean(V346), 'Freq.Body.Accel.Jerk.Mean.Z'=mean(V347),
               'Freq.Body.Accel.Jerk.Std.X'=mean(V348), 'Freq.Body.Accel.Jerk.Std.Y'=mean(V349),
               'Freq.Body.Accel.Jerk.Std.Z'=mean(V350), 'Freq.Body.Accel.Jerk.Mean.Freq.X'=mean(V373),
               'Freq.Body.Accel.Jerk.Mean.Freq.Y'=mean(V374), 'Freq.Body.Accel.Jerk.Mean.Freq.Z'=mean(V375),
               'Freq.Body.Gyroscope.Mean.X'=mean(V424), 'Freq.Body.Gyroscope.Mean.Y'=mean(V425),
               'Freq.Body.Gyroscope.Mean.Z'=mean(V426), 'Freq.Body.Gyroscope.Std.X'=mean(V427),
               'Freq.Body.Gyroscope.Std.Y'=mean(V428), 'Freq.Body.Gyroscope.Std.Z'=mean(V429),
               'Freq.Body.Gyroscope.Mean.Freq.X'=mean(V452), 'Freq.Body.Gyroscope.Mean.Freq.Y'=mean(V453),
               'Freq.Body.Gyroscope.Mean.Freq.Z'=mean(V454), 'Freq.Body.Accel.Magnitude.Mean'=mean(V503),
               'Freq.Body.Accel.Magnitude.Std'=mean(V504), 'Freq.Body.Accel.Magnitude.Mean.Freq'=mean(V513),
               'Freq.Body.Accel.Jerk.Magnitude.Mean'=mean(V516), 'Freq.Body.Accel.Jerk.Magnitude.Std'=mean(V517),
               'Freq.Body.Body.Accel.Magnitude.Mean.Freq'=mean(V526), 'Freq.Body.Body.Gyroscope.Magnitude.Mean'=mean(V529),
               'Freq.Body.Body.Gyroscope.Magnitude.Std'=mean(V530), 'Freq.Body.Body.Gyroscope.Magnitude.Mean.Freq'=mean(V539),
               'Freq.Body.Body.Gyroscope.Jerk.Magnitude.Mean'=mean(V542),'Freq.Body.Body.Gyroscope.Jerk.Magnitude.Mean'=mean(V543),
               'Freq.Body.Body.Gyroscope.Jerk.Magnitude.Mean.Freq'=mean(V552)
               )

# Name first two columns
colnames(df_means)[1] <- "Activity"
colnames(df_means)[2] <- "Subject"
tidy_data <- df_means

# Write this new data set to a txt file
new_file <- write.table(tidy_data, file="tidydata_Saba.txt", row.names=FALSE)