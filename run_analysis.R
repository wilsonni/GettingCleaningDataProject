#loads package. matrixStats is to perform a rowSds calc - same as rowMeans
library(matrixStats)
library(dplyr)
library(tidyr)

##CODE TO PERFORM THE FIRST 4 STEPS OF THE COURSE PROJECT:
## a- Merges the training and the test sets to create one data set.
## b- Extracts only the measurements on the mean and standard deviation for each measurement. 
## c- Uses descriptive activity names to name the activities in the data set
## d- Appropriately labels the data set with descriptive variable names. 


##Overview of steps performed in the merge code below - these are repeated for test
## and then for train

## 1) Match activity labels with the activity index to give descriptive
##    output for the file. Ensure ordering is retained.

## 2) Use rowMeans and rowSds to calculate the mean and SD for each of 
##    the 128 readings

## 3) Append the means, SDs and subject ID into one master test file

## 4) Add all the 561 vectors with time and freq data with 
##    the correct headings. It is unclear if this was required. Have kept for 
##    reference just in case. 

###RUNS THE TEST DATA
## STEP 1) - match activity labels to index and load features list
        ##Reads the features table with the text descriptions in
        d_features = read.table("UCI HAR Dataset/features.txt")

        ##Load the files that define the variable names that will be used as headings
        ##and give them appropriate column names
        d_labels = read.table("UCI HAR Dataset/activity_labels.txt", 
                        col.names = c("label_index", "label_name"))
        
        ##Loads the test labels and then adds an appropriate column name onsistent
        ##with the dataset above for easy matching ie "label_index"
        
                d_label_test = read.table("UCI HAR Dataset/test/y_test.txt", 
                        col.names = "label_index")
        
        #adds a unique ID to allow original sorting to be retained
        ##(ie do not lose it on the merge data)
                d_label_test$ID<-seq.int(nrow(d_label_test))
        
        #merges the data to add the text label identifier (e.g. WALKING etc)
                d_merge_test = merge(d_label_test, d_labels, 
                        by = "label_index", all.x = TRUE)
        #makes sure the data is in the correct original order for subsequent binding
                d_merge_test <- d_merge_test[order(d_merge_test$ID),]

##STEP 2 - calculate the means and SD for the observations
        #Calculate the means and SDs for each of the observations sets
                body_acc_x_means <- rowMeans(read.table("UCI HAR Dataset/test/Inertial Signals/body_acc_x_test.txt"))
                body_acc_y_means <- rowMeans(read.table("UCI HAR Dataset/test/Inertial Signals/body_acc_y_test.txt"))
                body_acc_z_means <- rowMeans(read.table("UCI HAR Dataset/test/Inertial Signals/body_acc_z_test.txt"))
                
                body_gyro_x_means <- rowMeans(read.table("UCI HAR Dataset/test/Inertial Signals/body_gyro_x_test.txt"))
                body_gyro_y_means <- rowMeans(read.table("UCI HAR Dataset/test/Inertial Signals/body_gyro_y_test.txt"))
                body_gyro_z_means <- rowMeans(read.table("UCI HAR Dataset/test/Inertial Signals/body_gyro_z_test.txt"))
                
                total_acc_x_means <- rowMeans(read.table("UCI HAR Dataset/test/Inertial Signals/total_acc_x_test.txt"))
                total_acc_y_means <- rowMeans(read.table("UCI HAR Dataset/test/Inertial Signals/total_acc_y_test.txt"))
                total_acc_z_means <- rowMeans(read.table("UCI HAR Dataset/test/Inertial Signals/total_acc_z_test.txt"))        
                
                body_acc_x_sd <- rowSds(as.matrix(read.table("UCI HAR Dataset/test/Inertial Signals/body_acc_x_test.txt")))
                body_acc_y_sd <- rowSds(as.matrix(read.table("UCI HAR Dataset/test/Inertial Signals/body_acc_y_test.txt")))
                body_acc_z_sd <- rowSds(as.matrix(read.table("UCI HAR Dataset/test/Inertial Signals/body_acc_z_test.txt")))
                
                body_gyro_x_sd <- rowSds(as.matrix(read.table("UCI HAR Dataset/test/Inertial Signals/body_gyro_x_test.txt")))
                body_gyro_y_sd <- rowSds(as.matrix(read.table("UCI HAR Dataset/test/Inertial Signals/body_gyro_y_test.txt")))
                body_gyro_z_sd <- rowSds(as.matrix(read.table("UCI HAR Dataset/test/Inertial Signals/body_gyro_z_test.txt")))
                
                total_acc_x_sd <- rowSds(as.matrix(read.table("UCI HAR Dataset/test/Inertial Signals/total_acc_x_test.txt")))
                total_acc_y_sd <- rowSds(as.matrix(read.table("UCI HAR Dataset/test/Inertial Signals/total_acc_y_test.txt")))
                total_acc_z_sd <- rowSds(as.matrix(read.table("UCI HAR Dataset/test/Inertial Signals/total_acc_z_test.txt")))

##STEP 3 - merge all the data together and adds the subject
        #Merge all the subjects, means and SDs into main test data set
                d_merge_test = cbind(d_merge_test, 
                        #Adds the subject
                        read.table("UCI HAR Dataset/test/subject_test.txt",
                                col.names = "subject"), 
                                     
                        #Adds the means
                        body_acc_x_means,
                        body_acc_y_means,
                        body_acc_z_means,
                             
                        body_gyro_x_means,
                        body_gyro_y_means,
                        body_gyro_z_means,                
                             
                        total_acc_x_means,
                        total_acc_y_means,
                        total_acc_z_means,               
                             
                        #Adds the SDs
                        body_acc_x_sd,
                        body_acc_y_sd,
                        body_acc_z_sd,
                     
                        body_gyro_x_sd,
                        body_gyro_y_sd,
                        body_gyro_z_sd,                
                     
                        total_acc_x_sd,
                        total_acc_y_sd,
                        total_acc_z_sd                  
        )

##STEP 4 - Adds the 561 vectors and col headings to the end of the data set

                ##Binds this to existing dataset and adds appropriate col names
                d_merge_test = cbind(d_merge_test, 
                     read.table("UCI HAR Dataset/test/X_test.txt", 
                                col.names = d_features[,2])) #reads the test set of 
                                ##data and adds in the correct headings
                ##Adds the label data_type to distinguish test vs train
                d_merge_test <- mutate(d_merge_test, data_type = "test")


###RUNS THE TRAIN DATA
###Please note this is essentially the same code as above but replace test
###with train

        ##Loads the test labels and then adds an appropriate column name onsistent
        ##with the dataset above for easy matching ie "label_index"
        
                d_label_train = read.table("UCI HAR Dataset/train/y_train.txt", 
                                  col.names = "label_index")
        
        #adds a unique ID to allow original sorting to be retained
        ##(ie do not lose it on the merge data)
        d_label_train$ID<-seq.int(nrow(d_label_train))
        
        #merges the data to add the text label identifier (e.g. WALKING etc)
        d_merge_train = merge(d_label_train, d_labels, 
                             by = "label_index", all.x = TRUE)
        #makes sure the data is in the correct original order for subsequent binding
        d_merge_train <- d_merge_train[order(d_merge_train$ID),]
        
        ##STEP 2 - calculate the means and SD for the observations
        #Calculate the means and SDs for each of the observations sets
        body_acc_x_means <- rowMeans(read.table("UCI HAR Dataset/train/Inertial Signals/body_acc_x_train.txt"))
        body_acc_y_means <- rowMeans(read.table("UCI HAR Dataset/train/Inertial Signals/body_acc_y_train.txt"))
        body_acc_z_means <- rowMeans(read.table("UCI HAR Dataset/train/Inertial Signals/body_acc_z_train.txt"))
        
        body_gyro_x_means <- rowMeans(read.table("UCI HAR Dataset/train/Inertial Signals/body_gyro_x_train.txt"))
        body_gyro_y_means <- rowMeans(read.table("UCI HAR Dataset/train/Inertial Signals/body_gyro_y_train.txt"))
        body_gyro_z_means <- rowMeans(read.table("UCI HAR Dataset/train/Inertial Signals/body_gyro_z_train.txt"))
        
        total_acc_x_means <- rowMeans(read.table("UCI HAR Dataset/train/Inertial Signals/total_acc_x_train.txt"))
        total_acc_y_means <- rowMeans(read.table("UCI HAR Dataset/train/Inertial Signals/total_acc_y_train.txt"))
        total_acc_z_means <- rowMeans(read.table("UCI HAR Dataset/train/Inertial Signals/total_acc_z_train.txt"))        
        
        body_acc_x_sd <- rowSds(as.matrix(read.table("UCI HAR Dataset/train/Inertial Signals/body_acc_x_train.txt")))
        body_acc_y_sd <- rowSds(as.matrix(read.table("UCI HAR Dataset/train/Inertial Signals/body_acc_y_train.txt")))
        body_acc_z_sd <- rowSds(as.matrix(read.table("UCI HAR Dataset/train/Inertial Signals/body_acc_z_train.txt")))
        
        body_gyro_x_sd <- rowSds(as.matrix(read.table("UCI HAR Dataset/train/Inertial Signals/body_gyro_x_train.txt")))
        body_gyro_y_sd <- rowSds(as.matrix(read.table("UCI HAR Dataset/train/Inertial Signals/body_gyro_y_train.txt")))
        body_gyro_z_sd <- rowSds(as.matrix(read.table("UCI HAR Dataset/train/Inertial Signals/body_gyro_z_train.txt")))
        
        total_acc_x_sd <- rowSds(as.matrix(read.table("UCI HAR Dataset/train/Inertial Signals/total_acc_x_train.txt")))
        total_acc_y_sd <- rowSds(as.matrix(read.table("UCI HAR Dataset/train/Inertial Signals/total_acc_y_train.txt")))
        total_acc_z_sd <- rowSds(as.matrix(read.table("UCI HAR Dataset/train/Inertial Signals/total_acc_z_train.txt")))
        
        ##STEP 3 - merge all the data together and add the subject
        #Merge all the subjects, means and SDs into main train data set
        d_merge_train = cbind(d_merge_train, 
                             #Adds the subject
                             read.table("UCI HAR Dataset/train/subject_train.txt",
                                        col.names = "subject"), 
                             
                             #Adds the means
                             body_acc_x_means,
                             body_acc_y_means,
                             body_acc_z_means,
                             
                             body_gyro_x_means,
                             body_gyro_y_means,
                             body_gyro_z_means,                
                             
                             total_acc_x_means,
                             total_acc_y_means,
                             total_acc_z_means,               
                             
                             #Adds the SDs
                             body_acc_x_sd,
                             body_acc_y_sd,
                             body_acc_z_sd,
                             
                             body_gyro_x_sd,
                             body_gyro_y_sd,
                             body_gyro_z_sd,                
                             
                             total_acc_x_sd,
                             total_acc_y_sd,
                             total_acc_z_sd                  
        )
        
        ##STEP 4 - Adds the 561 vectors and col headings to the end of the data set
        
        ##Binds this to existing dataset and adds appropriate col names
        d_merge_train = cbind(d_merge_train, 
                             read.table("UCI HAR Dataset/train/X_train.txt", 
                                        col.names = d_features[,2])) #reads the train set of 
        ##data and adds in the correct headings
        ##Adds the label data_type to distinguish train vs train
        d_merge_train <- mutate(d_merge_train, data_type = "train")

##Combines the test and train data together
        d_merge_all <-rbind(d_merge_test, d_merge_train)
        
##removes unecessary data sets
        rm(d_features, d_label_test, d_label_train, d_labels, d_merge_test, d_merge_train)

##Cleans up data - removes unnecessary columns (eg the index ones)
        d_merge_all$ID <- NULL
        d_merge_all$label_index <- NULL

##CODE TO PERFORM THE LAST STEP OF THE COURSE PROJECT:
## e- From the data set in step 4, creates a second, independent tidy data set 
## with the average of each variable for each activity and each subject.

## The following creates a table with the following headings:
## 1- Subject (ie the person)
## 2- Activity name (ie the descriptive text name)
## 3- Data type (test vs train) (arguably not needed, but I thought helpful)
## 4- Variable name
## 5- Mean

## creates a grouped table by activity, subject and data type
## for all other columns it calcs the mean - ie for every measurement
        d_simple<-d_merge_all %>% 
                group_by(label_name, subject, data_type) %>% 
                        summarise_each(funs(mean))

##makes the data set tal and thin by bringing the col names as "Measurement"
## and the means under "Mean"
        d_simple <- gather(d_simple, "Measurement", "Mean", 4:582)

## creates the output table for loading to Coursera
        write.table(d_simple, file= "tidy_data.txt", row.names = FALSE)

