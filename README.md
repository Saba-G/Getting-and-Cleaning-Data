Getting-and-Cleaning-Data
=========================

Course project - How my script works: 


READING IN THE DATA

In oder to run this script you need to download the Samsung data file (UCI HAR Dataset) and set your working directory to this file. Do not make changes in the folder structure of this UCI HAR Dataset folder (there should be a ‘train’ and ‘test’ folder within this folder).

Now you can run the run_analysis.R script.

The first thing the script does is to get your working directory and modify it to the test/train folder in order to read the data into R.


!!	IF YOU WANT TO READ THE TIDYDATA_SABA.TXT FILE INTO R, USE
‘READ.TABLE()’ AND SELECT ‘HEADER = TRUE’.



ASSIGNMENT 1

Now we can start with the first assignment of the project (‘Merge the training and test sets to create one data set’)

I first took a look at the dimensions of each data set to figure out how these could be merged together (either by columns or by rows). The next lines in the script bind these data sets together in the correct way.


ASSIGNMENT 2

The second assignment was: ‘Extract only the measurements on the mean and standard deviation for each measurement.’

I first looked for the corresponding columns for ‘mean’ and ‘sd’ in the features.txt file of the Samsung data. In the script I first read in the ‘features.txt’ data and extract only the rows that entail either “mean” or “std”. 

Then I make a new data set by using the row numbers of the previous code and subsetting these rownumbers from the total data set columns (from assignment 1).  Then I bind this new data set to the original (seperate) data sets (which hold information on the activity and subject (Y-test and Y-train,  subject_test and subject_train)).


ASSIGNMENT 3

The third assignment was: ‘Use descriptive activity names to name the activities in the data set’.

The input fort his script is the mean and std data set that I’ve made in the previous assignment (2). I first extract the column that holds the activity labels in this data set and put this in a variable named ‘labels’.
Then I replace the numbers in this column by activity names and save these in a new variable (‘ac6’).  Now I have a new list with activity names which I can bind to my existing data set. Finally I remove the original column with the activities by label numbers.


ASSIGNMENT 4

The fourth assignment was to ‘appropiately label the data set with the descriptive variable names’.

First I set the names of the mean and std data to a variable by extracting them from the feature.txt file. Then I transform the names to a vector variable. Next I add the titles “subject” and “activity” tot his vector. Finally I assign this new vector with my new column names to the previous data set (that I worked on in assignment 3).


ASSIGNMENT 5

This assignment wanted me to ‘create a second, independent tidy data set with the average of each variable for each activity and each subject.’

So what I need is a tidy data set that is sorted by activity and gives me all 30 subjects for each activity and all average measurements of ‘mean()’ and ‘std()’ for each of these subjects. So the tidy  data set will be 6(activities) by 30(subjects) = 180 rows long.  And 80 columns wide (activity, subject and all variables on mean and std).

I summarized the avarege by activity per subject in a new data set and give the columns a clearer definition (/name).  Then I rename the first two columns (activity and subject). 
So this script returns a new tidy data set. 

I write this  new data set to a txt file with ‘write.table()’, so that the file can be opened in R by using ‘read.table()’ and selecting the option 'header=TRUE’.
