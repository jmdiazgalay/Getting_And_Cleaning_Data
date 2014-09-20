
########################################################################################################
############  (1) Merging the training and the test sets to create one data set.   #####################
########################################################################################################

features.Train.Test <- rbind(read.table(paste0(getwd(), "/train/X_train.txt")), 
                          read.table(paste0(getwd(), "/test/X_test.txt"))) 

    # Giving propper varible names
features <- as.character(read.table("features.txt")$V2)
   colnames(features.Train.Test) <- features

########################################################################################################
##################        (2) Selecting columns on mean and sd.                 ########################
########################################################################################################

library("gdata")
on.mean <- matchcols(features.Train.Test, with=c("mean") )
on.sd <- matchcols(features.Train.Test, with=c("std") )

mean.sd <- c(on.mean,on.sd) 

FUCI <- features.Train.Test[,on.mean]


# Adding other variables

Activity <- rbind(read.table(paste0(getwd(), "/train/y_train.txt")),
                   read.table(paste0(getwd(), "/test/y_test.txt"))) 
Subject <- rbind(read.table(paste0(getwd(), "/train/subject_train.txt")),
                   read.table(paste0(getwd(), "/test/subject_test.txt"))) 

FUCI.A <- cbind(Subject, Activity, FUCI)


########################################################################################################
#############################        (3) Renaming variables.                 ###########################
########################################################################################################

colnames(FUCI.A)[1] <- "Subject"
colnames(FUCI.A)[2] <- "Activity"


########################################################################################################
######################      (4) Conditional change on activity variable.     ###########################
########################################################################################################

FUCI.A$Activity[FUCI.A$Activity == 1] <- "WALKING"
FUCI.A$Activity[FUCI.A$Activity == 2] <- "WALKING_UPSTAIRS"
FUCI.A$Activity[FUCI.A$Activity == 3] <- "WALKING_DOWNSTAIRS"
FUCI.A$Activity[FUCI.A$Activity == 4] <- "SITTING"
FUCI.A$Activity[FUCI.A$Activity == 5] <- "STANDING"
FUCI.A$Activity[FUCI.A$Activity == 6] <- "LAYING"

########################################################################################################
############################     (5) Generating a tidy Data set.     ##################################
########################################################################################################

library(reshape2)
Tidy.FUCY <- ddply(FUCI.A, .(Activity, Subject), numcolwise(mean))
Tidy.FUCY <- Tidy.FUCY[c(2,1,3:48)]
write.table(Tidy.FUCY, "TidyData_Averages.txt", row.name=FALSE )



