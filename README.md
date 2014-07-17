# Getting and Cleaning Data class project

## How to make it do stuff
Just run the script run_analysis.R. It will handle everything for you.

## What does run_analysis.R do?
First it will check to see if you've got the raw data in the folder already. If not, then it will download the raw data and save it as
a file named project_zipfile.zip. Then the script will unzip the zip file to make the individual files accessible.

Then the script reads the x and y variables from the test and train folders and merges them together along with the activity codes
and subject ids.

Next the script will select only those columns that are named with "-mean" or "-std" as listed in the file *features.txt*. This new, 
reduced dataset is then saved to a file called *file1.csv*.

Finally the script melts the dataset and calculates the mean for each combination of subjectID and activityID. The melted and aggregated
data set is saved in a file called *file2.csv*.
