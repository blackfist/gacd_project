# Download the source file if it isn't present
library(data.table)
library(reshape2)
if (!file.exists("project_zipfile.zip")) {
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
                "project_zipfile.zip",
                method="curl")
}

# extract the files
if (!file.exists("UCI HAR Dataset/")) {
  unzip("project_zipfile.zip")
}

# Read in the testing and training files. Merge them together
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/Y_train.txt")
train_subjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train_merged_together <- data.frame(cbind(x_train, y_train, train_subjects))
rm(x_train, y_train, train_subjects)

x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
test_subjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test_merged_together <- data.frame(cbind(x_test, y_test, test_subjects))
rm(x_test, y_test, test_subjects)

finalMerger <- rbind(train_merged_together, test_merged_together)
rm(train_merged_together, test_merged_together)

# Now how to get the interesting features? Read from features.txt and use grep to find
# which fields have mean or std in them.
feature_list <- read.table("UCI HAR Dataset/features.txt")
interesting_columns <- grep("(-mean|-std)", feature_list$V2)
# we need the last two columns also so we'll manually add that to our interesting_columns
interesting_columns <- c(interesting_columns, 562, 563)
trimmed_data <- finalMerger[, interesting_columns]
names(trimmed_data) <- c(grep("(-mean|-std)", feature_list$V2, value = T),
                        "activityid", "subjectid")

# Now we can write that trimmed up data to a file
write.csv(trimmed_data, file="file1.csv")

# Now let's melt that dataframe by subjectid and see what the averages are for each variable
melted_data <- melt(trimmed_data, id.vars=c("activityid","subjectid"))
final_result <- dcast(melted_data, subjectid + activityid ~ variable, mean)
write.csv(final_result, file="file2.csv")
