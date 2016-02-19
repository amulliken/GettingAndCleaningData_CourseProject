## Data Analysis Code Book ##

### Original Dataset ###

The original dataset was collected and is hosted by UC-Irvine: the [Human Activity Recognition Using Smartphones Data Set](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones). That data was downloaded from the following link: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The data is the result of experiments carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, the researchers captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments were video-recorded to label the data manually. The obtained dataset was randomly partitioned into two sets, where 70% of the volunteers were selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

For each record it is provided:

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

Note that the features are normalized and bounded within [-1,1]. 

Further information on this study can be found in:

Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

### Cleaning Steps ###

The R script *run_analysis.R* includes a single function (get_and_clean_UCI_data()) that executes the following data processing steps in succession:

- Loads the complete raw data sets, including data labels stored in ancillary .txt files 
- Merges the testing and training data into a single data frame
- Extracts the measurements of interest: only those measurements which represent a mean or standard deviation
- Replaces activity codes with descriptive names (e.g. "WALKING") 
- Labels the data frame data with descriptive variable names
- Writes this reduced, labeled data frame to .csv 
- Creates a second independent tidy data set with only the average of each variable for each subject/activity combination
- Writes this second independent tidy data set to .csv 

### Output Data File Description ###

The data processing generates two .csv files that are included in this package:

1. *UCI_data_tidy_prelim.csv*: the first reduced data set, a merge of the training and testing sets but values only for those features which represent a mean or standard deviation. There is one header line with columns labeled with descriptive feature (variable) names. Each subsequent row represents a data sample. The first column is the Subject number for that sample (1-30) and the second column is the Activity for that sample (text label).

2. *UCI_data_tidy_final.csv*: the second tidy data set with only the average of each variable of interest for each subject/activity combination. This file also contains one header line with the same content as above, but now only 30 Subjects x 6 Activities = 180 (averaged) data samples. 