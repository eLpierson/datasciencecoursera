##1. Merge training and test to create one data set.
tr_dat <- read.table("X_train.txt") ##read x train
tr_lab <- read.table("y_train.txt") ##read y train
tr_subj <- read.table("subject_train.txt") ##read subject train
tst_dat <- read.table("X_test.txt") ##read x test
tst_lab <- read.table("y_test.txt") ##read y test
tst_subj <- read.table("subject_test.txt") ##read subject test
dat <- rbind(tr_dat, tst_dat) ##row bind train & test data
lab <- rbind(tr_lab, tst_lab) ##row bind train & test labels
subj <- rbind(tr_subj, tst_subj) ##row bind train & test subjects

##2. Extract measurements on the mean and stddev for each measurement. 
features <- read.table("features.txt") ##read features
mean_stddev <- grep("mean\\(\\)|std\\(\\)", features[, 2]) ##mean & stddev on features
dat <- dat[, mean_stddev] 
names(dat) <- gsub("\\(\\)", "", features[mean_stddev, 2]) ##remove paren
names(dat) <- gsub("mean", "Mean", names(dat)) ## mean to Mean
names(dat) <- gsub("std", "Std", names(dat)) ##std to Std
names(dat) <- gsub("-", "", names(dat)) ##remove dash 

##3. Name activities with descriptive activity names.
act_lab <- read.table("activity_labels.txt") ##read activity labels
act_lab[, 2] <- tolower(gsub("_", "", act_lab[, 2])) ##lcase labels & remove underscore
substr(act_lab[2, 2], 8, 8) <- toupper(substr(act_lab[2, 2], 8, 8)) ##ucase activity 2
substr(act_lab[3, 2], 8, 8) <- toupper(substr(act_lab[3, 2], 8, 8)) ##ucase activity 3
act_label <- act_lab[lab[, 1], 2] ##label joined train & test activity label set
lab[, 1] <- act_label ##return to orig lab dataframe using chr labels vs int labels
names(lab) <- "activity" ##name lab column

##4. Label subj variables with descriptive names. 
names(subj) <- "subject" ##name subj column
clean_set <- cbind(subj, lab, dat) ##col bind joined/transformed subj/lab/dat
write.table(clean_set, "merged_tr_tst_dat_lab_subj.txt") ##write clean set to file

##5. Create independent tidy set w/ avg of each var per activity per subject.
length_subj <- length(table(subj)) ##count unique subject labels in subj set
length_act_lab <- dim(act_lab)[1] ##count activity label dims
length_clean <- dim(clean_set)[2] ##count clean_set dims
mat <- matrix(NA, nrow=length_subj*length_act_lab, ncol=length_clean) ##matrix of NAs
DFmat <- as.data.frame(mat) ##matrix to dataframe
colnames(DFmat) <- colnames(clean_set) ##add clean_set colnames to DFmat
##colMeans per subject & activity
row <- 1
for(i in 1:length_subj) {
    for(j in 1:length_act_lab) {
        DFmat[row, 1] <- sort(unique(subj)[, 1])[i]
        DFmat[row, 2] <- act_lab[j, 2]
        varSubj <- i == clean_set$subject
        varAct <- act_lab[j, 2] == clean_set$activity
        DFmat[row, 3:length_clean] <- colMeans(clean_set[varSubj&varAct, 3:length_clean])
        row <- row + 1
    }
}
write.table(DFmat, "subj_act_avgs.txt",row.name=FALSE) ##write tidy set to file
