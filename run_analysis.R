library(data.table)
library(reshape2)

##### util functions (will be used later)
get_activity_name <- function(activity_id)
{
  as.character(activity_labels$activity_name[activity_id])
}

##### -- read in Samsung data (assumes that data is in same folder)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
X_train <- read.table("UCI HAR Dataset/train/X_train.txt",row.names=NULL)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
features <- read.table("UCI HAR Dataset/features.txt")
X_test <- read.table("UCI HAR Dataset/test/X_test.txt",row.names=NULL)
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt",col.names=c("activity_id","activity_name"))

# apply feature names to columns to standardize names
colnames(X_test) <- as.character(features$V2)
colnames(X_train) <- as.character(features$V2)

# set Subject and Activity names
training_data <- X_train
training_data$Subject <- subject_train[,1]
training_data$Activity <- y_train[,1]
test_data <- X_test
test_data$Subject <- subject_test[,1]
test_data$Activity <- y_test[,1]

# make sure that rownames are unique so that rbind can be used
rownames(test_data) <- make.names(as.numeric(rownames(test_data)) + nrow(training_data))
rownames(training_data) <- make.names(as.numeric(rownames(training_data)))

# merge the data sets (Step 1 of the assignment)
full_data <- rbind(test_data,training_data)

# find the columns that don't hvae std() or mean()
colnames <- colnames(full_data)
std_cols <- colnames %like% "std\\(\\)"
mean_cols <- colnames %like% "mean\\(\\)"
meanOrSdCols <- mean_cols | std_cols

# and then create a second dataset without those columns (Step 2 in the assigment)
full_data_only_sd_or_mean <- full_data[,which(meanOrSdCols)]
full_data_only_sd_or_mean$Subject <- full_data$Subject

# use the utility function from above to set the namess of the activity (Steps 3 and 4 in the assignment)
full_data_only_sd_or_mean$Activity <- sapply(full_data$Activity,FUN=get_activity_name)

#melt and recast the data to get a per-Subject and per-Activity summary of each of the variables
full_data_melt <- melt(full_data_only_sd_or_mean,id=c("Subject","Activity"))
sub_Act_Summary <- dcast(full_data_melt,Subject+Activity ~ variable, mean)

write.table(sub_Act_Summary,file="data_by_subject_activity.csv",row.names=FALSE)
