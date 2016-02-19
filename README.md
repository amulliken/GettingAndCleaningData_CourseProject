## Analysis of UCI Activity Tracking Data ##

This package was created in fulfillment of the Course Project for [Coursera](https://www.coursera.org/) course *Getting and Cleaning Data* presented by Johns Hopkins University and completed by Adam Mulliken in March 2016.

The project focuses on a set of inertial sensor data collected and hosted by UC-Irvine: the [Human Activity Recognition Using Smartphones Data Set](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones). 
This package comprises a single R script executing the desired stages of data reduction and cleaning, as well as creating preliminary and final 'tidy' data sets in human-readable .csv format.

Note that the original raw data is not included in this package. That data can be downloaded from UC-Irvine and is available at this [link](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip). 

### Contents ###

#### run_analysis.R ####
The R script *run_analysis.R* includes a single function (get_and_clean_UCI_data()) that executes the desired data processing. The function takes no input; it presumes that the function is called with the downloaded data located in the current working directory. Similiarly the function generates no output; tidy data sets are saved as .csv to the current working directory. 

#### UCI_data_tidy_prelim.csv ####

The first reduced data set, a merge of the training and testing sets but values only for those features which represent a mean or standard deviation. There is one header line with columns labeled with descriptive feature (variable) names. Each subsequent row represents a data sample. The first column is the Subject number for that sample (1-30) and the second column is the Activity for that sample (text label).

#### UCI_data_tidy_final.csv ####

The second tidy data set with only the average of each variable of interest for each subject/activity combination. This file also contains one header line with the same content as above, but now only 30 Subjects x 6 Activities = 180 (averaged) data samples. 
    
#### CodeBook.md ####

Markdown file including a detailed description of the original data set and the data processing steps. 