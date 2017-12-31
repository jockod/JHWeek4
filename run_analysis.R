# Jack Danahy
# Collecting and Cleaning Data
# Week 4 Project
# 
# This is an R script to process data associated with wearable computing data
# The script has NNN Sections to load, combine, label and clean data
#
# Part 1: Get all the data
# The data was provided in a zip archive which is now extracted into
# a directory I've renamed UCIHARDataset
#

setwd("~/Desktop/JohnsHopkins/Collecting/Week4Quiz/UCIHARDataset")

# Start by gathering all the test and training data into  tables on the system
# First the Test data

        testSubject <- read.table(file = "./test/subject_test.txt")
        testReading <- read.table(file = "./test/X_test.txt")
        testActivity <- read.table(file = "./test/y_test.txt")
        
# Create the merged Test dataframe
        testDF <- data.frame(testSubject, testActivity, testReading)

# Now the Training data
        
        trainSubject <- read.table(file = "./train/subject_train.txt")
        trainReading <- read.table(file = "./train/X_train.txt")
        trainActivity <- read.table(file = "./train/y_train.txt")

# Create the merged Training dataframe
        trainDF <- data.frame(trainSubject, trainActivity, trainReading)
        
# Combine the two dataframes into one large dataset with rbind()
        totalData <- rbind(testDF, trainDF)

# Now create column names to make the data clear
# First column is the SubjectID, second is the ActivityID, and the last series
# are the actual Readings
#
# The readings are contained in a file at the extraction root.  We load them in
# as another table, but only use the second column to create the vector
# It turns out that there are some duplicate feature names, so in order to get
# select to work correctly, I am prepending a unique label on each using a
# string that will be easy to automatically detect and remove later.
        
        namesTab <- read.table(file = "./features.txt")
        readingNames <- as.vector(paste0("XX",namesTab[,1],"XX",namesTab[,2]))
        columnNames <- c("SubjectID", "ActivityID",readingNames)

# Now apply those names to the combined data set (totalData)
        colnames(totalData) <- columnNames

# We only want columns that contain mean or std information so we look for that
# in the column names

        selData <- select(totalData, contains("SubjectID"),
                        contains("ActivityID"),contains("std()"),
                        contains("mean()"))

# Now we eliminate the XX...XX prefix used earlier.  While we are at it,
# we eliminate the ()'s as well.
        
        cleanNames <- gsub("^XX.*XX","",names(selData))
        cleanNames <- gsub("\\(\\)","",cleanNames)
        colnames(selData) <- cleanNames
        
# Now we have the right filtered data.
# We now want to assign the names for the activities after the ActivityID
# We do it in two steps.  Append it to the end, then move it after ActivityID

        actLabels <- read.table(file = "./activity_labels.txt")
        selData$ActivityName <- actLabels[selData$ActivityID,2]
        selData <- data.frame(selData[1:2],selData[ncol(selData)],
                              selData[3:(ncol(selData)-1)])

# The output file must group by subject and activity, using "proc"MEAN" label for
# eventual processing out of means
        groupData <- selData %>%
                        group_by(SubjectID, ActivityID, ActivityName) %>%
                        summarize_all(.funs = c(MEAN="mean"))

# Create final file with only Subject, Activity, and Mean data
        fnlData <- select(groupData, contains("SubjectID"),
                        contains("ActivityID"),contains("ActivityName"),
                        contains("MEAN"))

# Now output final file
        write.table(fnlData, file = "new_tidy_data_means.txt",row.name=FALSE)
        
