---
title: "Getting and Cleaning Data Project - README"
author: "Nigel Wilson"
date: "23 August 2015"
output:
  word_document: default
  html_document:
    keep_md: yes
---

### Overview of R Script

In summary the code does the following:

1) Creates 2 data sets - one for the test data ("d_merge_test") then one for the
  train data ("d_merge_train")

2) Repeats the following for each of the two types (train and test)

    a) Match activity labels with the activity index to give descriptive
    output for the file. Ensure ordering is retained.

    b) Use rowMeans and rowSds to calculate the mean and SD for each of
    the 128 readings

    c) Append the means, SDs and subject ID into one master test/train file

    d) Add all the 561 vectors with time and freq data with
    the correct headings. [NB - It is unclear if this was required. Have kept for
    reference just in case.]

    e) Cleans up the data file and the stored data sets

3) Combines the "d_merge_test" and "d_merge_train" data into one output file
"d_merge_all".

4) Groups the data by subject (the person), data_type (test vs train) and
label_name (activity name) and calculates the mean of every other column (ie all the measurements).

5) Makes the data tall and thin by switching the columns (ie the measurements) into a column named "Measurement" with the results being displayed under "Mean"

6) Creates the output txt file in the root directory


## More detailed code description can be found in the script
