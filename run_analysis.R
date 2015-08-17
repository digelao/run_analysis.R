# Package check
if (!require("data.table")) {
  install.packages("data.table") 
  require("data.table")}
if (!require("reshape2")) {
  install.packages("reshape2") 
  require("reshape2")}

# Load data
train.subject <- read.table("./UCI HAR Dataset/train/subject_train.txt")
train.x <- read.table("./UCI HAR Dataset/train/X_train.txt")
train.y <- read.table("./UCI HAR Dataset/train/y_train.txt")

test.subject <- read.table("./UCI HAR Dataset/test/subject_test.txt")
test.x <- read.table("./UCI HAR Dataset/test/X_test.txt")
test.y <- read.table("./UCI HAR Dataset/test/y_test.txt")

features <- read.table("./UCI HAR Dataset/features.txt")
activity.labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

# Merges the training and the test sets to create one data set.
all.x <- rbind(test.x, train.x)
names(all.x) <- features[, 2]

#Extracts only the measurements on the mean and standard deviation for each measurement.
filters <- grep("-mean|-std", names(all.x))
all.x.mean_std <- all.x[,c(filters)]

#Uses descriptive activity names to name the activities in the data set.
#activity data
all.y <- rbind(test.y, train.y)
all.y[,1]=activity.labels[all.y[,1],2]
names(all.y) <- "activity"

#Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#subject data
all.subject <- rbind(test.subject, train.subject)
names(all.subject) <- "subject"
#merge all data
all.data <-cbind(all.subject,all.y,all.x.mean_std)
# Compute the means, grouped by subject/label
melData = melt(all.data, id.var = c("subject", "activity"))
result = dcast(melData , subject + activity ~ variable, mean)

# Save the result
write.table(result, file="./tidy_data.txt")
