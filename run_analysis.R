library(dplyr)
#Downloading the data
link<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
filename<-"final.zip"
if(!file.exists(filename)){
  download.file(link,filename)
}
#Checking if the unzipped dataset exists
if(!file.exists("UCI HAR Dataset")){
  unzip(filename)
}
# Loading the respective datasets
lables<-read.table("UCI HAR Dataset/features.txt",col.names = c("n","features"))
x_train<-read.table("UCI HAR Dataset/train/X_train.txt",col.names = lables$features)
y_train<-read.table("UCI HAR Dataset/train/Y_train.txt",col.names = "activity")
subject_train<-read.table("UCI HAR Dataset/train/subject_train.txt",col.names = "subjects")
x_test<-read.table("UCI HAR Dataset/test/X_test.txt",col.names = lables$features)
y_test<-read.table("UCI HAR Dataset/test/y_test.txt",col.names = "activity")
subject_test<-read.table("UCI HAR Dataset/test/subject_test.txt",col.names = "subjects")
activityName<-read.table("UCI HAR Dataset/activity_labels.txt",col.names = c('no','activityName'))
#Merging the dataset
X<-rbind(x_train,x_test)
Y<-rbind(y_train,y_test)
subject<-rbind(subject_train,subject_test)
df<-cbind(subject,Y,X)
#Gets the mean and standard deviation of every measurement
finaldata<-select(df,activity,subjects,contains("mean"),contains("std"))
#Naming variables Descriptively
names(finaldata)<-gsub("Acc", "Accelerometer", names(finaldata))
names(finaldata)<-gsub("Gyro", "Gyroscope", names(finaldata))
names(finaldata)<-gsub("BodyBody", "Body", names(finaldata))
names(finaldata)<-gsub("Mag", "Magnitude", names(finaldata))
names(finaldata)<-gsub("^t", "Time", names(finaldata))
names(finaldata)<-gsub("^f", "Frequency", names(finaldata))
names(finaldata)<-gsub("tBody", "TimeBody", names(finaldata))
names(finaldata)<-gsub("-mean()", "Mean", names(finaldata), ignore.case = TRUE)
names(finaldata)<-gsub("-std()", "STD", names(finaldata), ignore.case = TRUE)
names(finaldata)<-gsub("-freq()", "Frequency", names(finaldata), ignore.case = TRUE)
names(finaldata)<-gsub("angle", "Angle", names(finaldata))
names(finaldata)<-gsub("gravity", "Gravity", names(finaldata))
# getting the mean observation for every activity of each person
final<-finaldata%>%group_by(activity,subjects)%>%summarise_all(list(mean))
#Creating the final output
write.table(final,file = "output.txt",row.names = FALSE)