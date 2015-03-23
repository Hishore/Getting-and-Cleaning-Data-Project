#Set up environment
library(dplyr)
wd<-"C:/Users/Carolyn/Desktop/ÕÒ¹¤×÷2015/Coursera Data Science Johns Hopkins University/Getting and Cleaning Data/UCI HAR Dataset"
setwd(wd)

#Load data and merge data
test<-read.table("./test/X_test.txt")
subjectTest<-read.table("./test/subject_test.txt")
activityTest<-read.table("./test/y_test.txt")
train<-read.table("./train/X_train.txt")
subjectTrain<-read.table("./train/subject_train.txt")
activityTrain<-read.table("./train/y_train.txt")
testData<-cbind(test, subjectTest, activityTest)
trainData<-cbind(train, subjectTrain, activityTrain)
Merged<-rbind(testData, trainData)

#Add column names and extract the mean and standard deviation columns
features<-read.table("./features.txt")
char<-as.character(features[,2])
colnames(Merged)<-c(char, "subject", "activity")
mean<-sapply(char, function(x) grepl("mean()",x, fixed=TRUE))
std<-sapply(char, function(x) grepl("std()",x, fixed=TRUE))
sum<-mean | std
data<-Merged[,sum]

#Uses descriptive activity names to name the activities and create tidy dataset
label<-read.table("./activity_labels.txt")
data2<-merge(data,label,by.x = "activity", by.y = "V1", all=TRUE)
cleanData<-data2 %>% select(-activity) %>% rename(activity = V2)
tidyData<-summarise_each(group_by(cleanData,subject,activity), funs(mean))

#Create txt file of the tidy dataset
write.table(tidyData, file = "./TidyData.txt", row.name = FALSE)