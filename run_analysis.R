# run_analysis.R
#setwd("~/Documents/Git/Github/tidydata/")


# Find out which columns to extract
feature_name <- read.table("UCI HAR Dataset/features.txt")
# Extract only mean and std of measurements
m <- grep("mean",feature_name[,2],ignore.case = TRUE)
s <- grep("std",feature_name[,2],ignore.case = TRUE)
req_col <- sort(c(m,s))

## Read relevant data and group the train and test set
# Read feature vectors
train <- read.table("UCI HAR Dataset/train/X_train.txt")[,req_col]
test  <- read.table("UCI HAR Dataset/test/X_test.txt")[,req_col] 
fv <- rbind(train,test)
names(fv) <- feature_name$V2[req_col]

# Read subject identifier
train <- read.table("UCI HAR Dataset/train/subject_train.txt")
test <- read.table("UCI HAR Dataset/test/subject_test.txt")
subject <- rbind(train,test)
names(subject) <- "subject"

# Read activity label
train <- read.table("UCI HAR Dataset/train/y_train.txt")
test <- read.table("UCI HAR Dataset/test/y_test.txt")
a <- rbind(train,test)
names(a) <- "activity"
a$activity <- factor(a$activity,levels = 1:6,
                     labels = c("WALKING","WALKING UPSTAIRS","WALKING DOWNSTAIRS",
                                "SITTING","STANDING","LAYING"))

# combine all columns to get data that maps to mean and std of measurements
data1 <- cbind(subject,a,fv)


# Form data 2 that contains average data for each variable for each activity and each subject
library(dplyr)
by_id_activity <- group_by(data1,subject,activity)
data2 <- summarize_each(by_id_activity,funs(mean))

    
# Write data2 to text file
write.table(data2,"tidydata.txt",row.name=FALSE)

