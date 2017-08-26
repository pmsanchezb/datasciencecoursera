###########################
# ------------------------
#   Week 4 Peer assignment
# ------------------------
###########################

library(data.table)
library(dplyr)
library(reshape2)

# ------------------------
# 1. Merges the training and the test sets to create one data set
# ------------------------
# Reading train data
setwd("C:/Users/paulomauricio/Documents/Jhon's Hopkins/Getting and cleaning data/week4/UCI HAR Dataset/train")
x_train  <- fread("X_train.txt")

# Reading test data
setwd("C:/Users/paulomauricio/Documents/Jhon's Hopkins/Getting and cleaning data/week4/UCI HAR Dataset/test")
x_test  <- fread("X_test.txt")

# Merging data
merge_x  <- as.data.table(rbind(x_test,x_train))

# ------------------------
# 2. Extracts only the measurements on the mean and standard
#    deviation for each measurement
# ------------------------

f <- function(x,...){
  list(mean(x),sqrt(var(x)))
}

merge_x.2  <- apply(merge_x, 2, f,na.rm=TRUE)

# ------------------------------------------------------------
#  3. Uses descriptive activity names to name the activities 
#     in the data set
# ------------------------------------------------------------

setwd("C:/Users/paulomauricio/Documents/Jhon's Hopkins/Getting and cleaning data/week4/UCI HAR Dataset")
activity_labels <- fread("activity_labels.txt")
features        <- fread("features.txt")
# 30 subjects
# 6 activities
activities <- activity_labels$V2

index <- list()
for(j in 1:30){
        index[[j]] <- paste(j,activities)
}
index <- as.vector(unlist(index))

merge_x$vs <- rep(index,dim(merge_x)[1]/length(index))
table(merge_x$vs)

# ------------------------------------------------------------
#  4. Appropriately labels the data set with descriptive variable names.
# ------------------------------------------------------------

nams <- c(features$V2,"Subject-Activity")
colnames(merge_x) <- nams

# ------------------------------------------------------------
#  5. From the data set in step 4, creates a second, independent 
#     tidy data set with the average of each variable for each activity
#     and each subject.
# ------------------------------------------------------------
positions <- which(!duplicated(colnames(merge_x))==T)
merge_x <- merge_x[,positions,with = F]
resume_table <- merge_x %>% group_by(`Subject-Activity`) %>% summarise_all(mean,na.rm=T)

write.table(resume_table,row.names = F,file = "C:/Users/paulomauricio/Documents/Jhon's Hopkins/Getting and cleaning data/week4/UCI HAR Dataset/resume_table.txt",sep=",",quote = T)
