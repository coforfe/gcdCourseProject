#---------------------------------------
#----------------- Preliminary work to know details about files
#---------------------------------------
#
# All files (train and test) within the same directory.
# Get names of train and test files to count their fields
#filesNames <- dir(pattern="*test.txt|*train.txt", include.dirs=FALSE, recursive=FALSE)
#
#camposfiles <- data.frame(file=0, fields=0, lines=0)
#for( i in 1:length(filesNames)) {
#  
# cnttmp <- count.fields(filesNames[i])
# cntlines<- length(cnttmp)
# cntfields <- unique(cnttmp)
# 
# camposfiles[i,1] <- filesNames[i]
# camposfiles[i,3] <- cntlines
# 
# if(length(cntfields)>1) {
#  camposfiles[i,2] <- c('Mal') 
# } else { camposfiles[i,2] <- cntfields }
#  
#}
#camposfiles
#
#----------------------------------
# y_test and y_train includes the activity of each of the rows of X_test and X_train
#ytest <- read.table("y_test.txt", header=F, as.is=T)
#ytrain <- read.table("y_train.txt", header=F, as.is=T)
#unique(ytest)
#unique(ytrain)

#-----------------------------------------------------------
#-----------------------------------------------------------
# Work Strategy
# 1. Put together (rowwise) X_train and X_test
# 2. Put together (rowwise) y_train and y_test
# 3. Add column y_train-y_test to X_train-X_test
# 4. Modify numbers of y_train-y_test with feature names
# 5. For the column names of X_train-X_test load "Features.txt" and remove special characters "()", "-", ",".
# 6. Add new column for the subject (previously put together subject_train and subject_test).
# 7. The data file "X" will have now everything needed to start with the calculations.

#---------------------------------------
#----------------- Questions 1, 3, 4 
#---------------------------------------
# Put together X_train and X_test
Xtrain <- read.table("X_train.txt", as.is=T, header=F)
Xtest <- read.table("X_test.txt", as.is=T, header=F)
Xtmp <- rbind.data.frame(Xtrain, Xtest)

# Put together y_train and y_test. Add activity labels names
ytrain <- read.table("y_train.txt", as.is=T, header=F)
ytest <- read.table("y_test.txt", as.is=T, header=F)
ytmp <- rbind.data.frame(ytrain, ytest)
actlab <- read.table("activity_labels.txt", header=F, as.is=T)
yfinal <- merge(ytmp, actlab, by.x=1, by.y=1)
names(yfinal) <- c('ActNumb', 'ActDesc')

# Put together subject_train and subject_test, with name "Subject"
subtrain <- read.table("subject_train.txt", as.is=T, header=F)
subtest <- read.table("subject_test.txt", as.is=T, header=F)
subfinal <- rbind.data.frame(subtrain, subtest)
names(subfinal) <- c('Subject')

# Merge "X" and "y"
Xfinal <- cbind.data.frame(Xtmp, yfinal, subfinal)

# Change names of "X" ("y" already have adequate names)
featfile <- read.table("features.txt", header=F, as.is=T)
# Remove special characters
featnameA <- gsub( "-","_", featfile$V2 )
featnameB <- gsub( "\\(","", featnameA )
featnameC <- gsub( "\\)","", featnameB )
featnames <- gsub( ",","_", featnameC )

# Change names of "X", just the 561 first columns. "Features" and "Subject" have already good names.
names(Xfinal)[ 1:length(featnames) ] <- featnames

# Now "Xfinal" is ready to be processed....

#---------------------------------------
#----------------- Question 2 
#---------------------------------------
# Extracts only measurements of mean and standard deviation
# Find in names "mean" or "std"
Xmeanstd <- Xfinal[, grep("mean|std", names(Xfinal), ignore.case=TRUE) ]
names(Xmeanstd)

#---------------------------------------
#----------------- Question 5 
#---------------------------------------
# New tidy data set with the average and std of each variable for activity and subject
library(data.table)
library(reshape2)
XDT <- data.table(Xfinal)
XDTmelted <- melt(XDT, id.vars=562:564, measure.vars=1:561)

library(sqldf)
NewX <- sqldf("select variable, ActDesc, Subject, avg(value) as Mean, stdev(value) as Std from XDTmelted group by variable, ActDesc, Subject")
head(NewX)
# Export NewX to a file
write.table(NewX, file="NewTidyFile-Mean-Std.txt", row.names=FALSE)
