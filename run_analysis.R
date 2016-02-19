## Function get_and_clean_UCI_data.R operates on the wearables development data 
## captured with a Samsung Galaxy SII by researchers at UCI HAR on 30 human 
## subjects.

## Function derives a tidy data set for human reading which includes an average
## feature value for each subject and each variable. Along the way, it creates 
## an intermediate clean and tidy data set using only the mean and standard
## deviation data and with descriptive names for the activity labels. Both the 
## intermediate and final data sets are saved to .csv in the same directory
## as the original data.

get_and_clean_UCI_data <- function(){
    
#     setwd("C://Users//amulliken//R//Getting_and_Cleaning_Data//CourseProject")
    
    ## STEP 0: LOAD COMPLETE RAW DATA SET 
    
    # Read training data, assuming downloaded data has been unzipped at working 
    # directory
    trainingDataFilePath <- ".//UCI HAR Dataset//train//X_train.txt"
    trainingData <- read.table(file = trainingDataFilePath, header = FALSE)
    trainingDataLabelFilePath1 <- ".//UCI HAR Dataset//train//Y_train.txt"
    trainingDataActivityLabels <- read.table(file = trainingDataLabelFilePath1,
                                            header = FALSE)
    trainingDataLabelFilePath2 <- ".//UCI HAR Dataset//train//subject_train.txt"
    trainingDataSubjectLabels <- read.table(file = trainingDataLabelFilePath2,
                                             header = FALSE)
    
    # Read test data, assuming downloaded data has been unzipped at working 
    # directory
    testDataFilePath <- ".//UCI HAR Dataset//test//X_test.txt"
    testData <- read.table(file = testDataFilePath, header = FALSE)
    testDataLabelFilePath1 <- ".//UCI HAR Dataset//test//Y_test.txt"
    testDataActivityLabels <- read.table(file = testDataLabelFilePath1,
                                            header = FALSE)
    testDataLabelFilePath2 <- ".//UCI HAR Dataset//test//subject_test.txt"
    testDataSubjectLabels <- read.table(file = testDataLabelFilePath2,
                                         header = FALSE)
    
    
    ## STEP 1: MERGE TESTING AND TRAINING
    
    mergedData <- rbind(trainingData,testData)  # merge raw data
    mergedActivityLabels <- rbind(trainingDataActivityLabels,
                                  testDataActivityLabels)   # merge activity 
                                                            #  labels
    mergedSubjectLabels <- rbind(trainingDataSubjectLabels,
                                  testDataSubjectLabels)    # merge subject 
                                                            #  labels
    
    
    ## STEP 2: EXTRACT MEASUREMENTS OF INTEREST
    
    # Import feature ID-descriptor code
    featureIDFilePath = ".//UCI HAR Dataset//features.txt"
    featureNames <- read.table(file = featureIDFilePath, header = FALSE, 
                               stringsAsFactors = FALSE, col.names = 
                                   {c("Index","Name")})
    
    # Find the features that are either a mean or standard deviation
    meanIdxs <- grep("mean()", featureNames[,2], ignore.case = TRUE, 
                     value = FALSE)
    stdIdxs <- grep("std()", featureNames[,2], ignore.case = TRUE, 
                    value = FALSE)
    goodIdxs <- c(meanIdxs,stdIdxs)
    goodIdxs <- sort(goodIdxs, decreasing = FALSE)
    
    # Extract only those columns we want to keep
    mergedData_selective <- mergedData[,goodIdxs]
    featureNames_selective <- featureNames[goodIdxs,]
    
    
    ## STEP 3: ADD DESCRIPTIVE ACTIVITY NAMES
    
    # Import activity ID-descriptor code
    activityIDFilePath = ".//UCI HAR Dataset//activity_labels.txt"
    activityNames <- read.table(file = activityIDFilePath, header = FALSE,
                                stringsAsFactors = FALSE, col.names = 
                                    {c("Index","Name")})
    
    # Create version of training activity data labels that are in readable text
    # (conversion of code numbers to text descriptions)
    activityLabels_text <- vector(mode = "character", length = 
                                      nrow(mergedActivityLabels))
    for (i in 1:nrow(mergedActivityLabels)){
        activityLabels_text[i] <- 
            activityNames[mergedActivityLabels[i,1],2]
    }
    
    
    ## STEP 4: LABEL THE DATA WITH DESCRIPTIVE VARIABLE NAMES
    
    # Use feature names to label the columns of merged data
    colnames(mergedData_selective) <- featureNames_selective[,2]
    
    # Add activity labels as first column, and label the column
    mergedData_selective <- cbind(activityLabels_text,mergedData_selective)
    colnames(mergedData_selective)[1] <- 'Activity'
    
    # Add subject labels as first column, and label the column
    mergedData_selective <- cbind(mergedSubjectLabels,mergedData_selective)
    colnames(mergedData_selective)[1] <- 'Subject'
    
    
    ## [INTERMEDIATE STEP: FURTHER TIDY AND PUT THIS PRELIM DATA IN A .CSV]
    
    # Sort data frame rows on Subject first, then Activity 
    #  (intended to make inspection of saved .csv easier)
    mergedData_selective <- 
        mergedData_selective[order(mergedData_selective$Subject, 
                                   mergedData_selective$Activity),]
    
    # Write intermediate data set to .csv
    write.csv(mergedData_selective, file = "UCI_data_tidy_prelim.csv", 
              row.names = FALSE)
    
    
    ## STEP 5: CALCULATE MEAN BY SUBJECT AND ACTIVITY
    
    # Lists of variables to loop over
    subjectList <- unique(mergedData_selective$Subject)
    activityList <- c("LAYING","SITTING","STANDING","WALKING",
                      "WALKING_DOWNSTAIRS","WALKING_UPSTAIRS")
    featureList <- featureNames_selective[,2]
    colList = c("Subject","Activity",featureList)
    
    # Initialize data frame to hold summary data
    mergedData_selective_summary <- data.frame( 
        matrix(nrow = (length(subjectList)*length(activityList)), 
               ncol = length(colList)))
    colnames(mergedData_selective_summary) <- colList
    
    # Run nested loop to calculate mean per subject and activity, for each 
    #  (down-selected) feature
    tempdata <- NULL
    for (i in 1:length(subjectList)){
        
        for (j in 1:length(activityList)){
            
            tempdata <- subset(mergedData_selective, 
                Subject == subjectList[i] & Activity == activityList[j])
            mergedData_selective_summary[(i-1)*length(activityList)+j,1] <- 
                subjectList[i]
            mergedData_selective_summary[(i-1)*length(activityList)+j,2] <- 
                activityList[j]
            
            for (k in 1:length(featureList)){
             
                mergedData_selective_summary[(i-1)*length(activityList)+j,2+k] <- 
                    mean(tempdata[,2+k])
                
            } # loop on features
        } # loop on activities
    } # loop on subjects
    
    
    ## [POSTSCRIPT: SAVE THIS FINAL SUMMARY DATA IN A .CSV]
    
    write.csv(mergedData_selective_summary, file = "UCI_data_tidy_final.csv", 
              row.names = FALSE)
        
    
}