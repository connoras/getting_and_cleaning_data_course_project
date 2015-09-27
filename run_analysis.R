# getting and cleaning data course project
# written 2015.09.27
# updated 2015.09.27

# clean up
rm(list=ls())

## 1. Merge the training and the test sets to create one data set

# set working directory to the location where the UCI HAR Dataset was unzipped
setwd('~/Documents/UCI HAR Dataset/')

# read in data
features <- read.table('./features.txt',header=FALSE)
activityType <- read.table('./activity_labels.txt',header=FALSE)
subjectTrain <- read.table('./train/subject_train.txt',header=FALSE)
xTrain <- read.table('./train/x_train.txt',header=FALSE)
yTrain <- read.table('./train/y_train.txt',header=FALSE)
subjectTest <- read.table('./test/subject_test.txt',header=FALSE); #imports subject_test.txt
xTest <- read.table('./test/x_test.txt',header=FALSE); #imports x_test.txt
yTest <- read.table('./test/y_test.txt',header=FALSE); #imports y_test.txt

# assign column names to data
names(activityType) <- c('activityId','activityType')
names(subjectTrain) <- "subjectId"
names(xTrain) <- features[,2] 
names(yTrain) <- "activityId"
names(subjectTest) <- "subjectId"
names(xTest) <- features[,2]
names(yTest) <- "activityId"

# merge training data
trainingData <- cbind(yTrain,subjectTrain,xTrain)

# merge test data
testData <- cbind(yTest,subjectTest,xTest)

# combine training and test data to create final data set
finalData <- rbind(trainingData,testData)

## 2. Extract only the measurements on the mean and standard deviation for each measurement

# subset columns on "mean" or "std" only from finalData
finalData <- finalData[,grepl('mean',names(finalData)) | grepl('std',names(finalData)) | grepl('activity',names(finalData)) | grepl('subject',names(finalData))]

# 3. Use descriptive activity names to name the activities in the data set

# merge finalData and activityType dataframes to add descriptive activity names
finalData <- merge(finalData,activityType,by='activityId',all.x=TRUE)

# 4. Appropriately label the data set with descriptive activity names. 

# create separate object with column names
colNames <- colnames(finalData)

# clean up column names as best as possible
for (i in 1:length(colNames)) 
{
  colNames[i] <- gsub("\\()","",colNames[i])
  colNames[i] <- gsub("-std$","StdDev",colNames[i])
  colNames[i] <- gsub("-mean","Mean",colNames[i])
  colNames[i] <- gsub("^(t)","time",colNames[i])
  colNames[i] <- gsub("^(f)","freq",colNames[i])
  colNames[i] <- gsub("([Gg]ravity)","Gravity",colNames[i])
  colNames[i] <- gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",colNames[i])
  colNames[i] <- gsub("[Gg]yro","Gyro",colNames[i])
  colNames[i] <- gsub("AccMag","AccMagnitude",colNames[i])
  colNames[i] <- gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",colNames[i])
  colNames[i] <- gsub("JerkMag","JerkMagnitude",colNames[i])
  colNames[i] <- gsub("GyroMag","GyroMagnitude",colNames[i])
}

# assigning new column names to final data set
names(finalData) <- colNames

# 5. Create a second, independent tidy data set with the average of each variable for each activity and each subject

# create tidy data set in a series of steps
finalData2 <- finalData[, names(finalData) != 'activityType'] # remove activity type levels
tidyData <- aggregate(finalData2[,names(finalData2) != c('activityId','subjectId')],by=list(activityId=finalData2$activityId,subjectId=finalData2$subjectId),mean) # average of rows and columns
tidyData <- merge(tidyData,activityType,by='activityId',all.x=TRUE) # add back activity types

# Export the tidyData set 
write.table(tidyData, './tidyData.txt',quote=FALSE,row.names=FALSE, col.names=TRUE,sep='\t')
