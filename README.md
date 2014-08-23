---
output:
  html_document: default
---
***

Getting and Cleaning Data - Course Project 
==============================================

***

## How to use run_analysis.R
The only requirement to run *run_analysis.R* is to have all the files under **test** and **train** directories in the same directory as *run_analysis.R*

## Input files required: 
These are the files that should be in the same directory as *run_analysis.R*:

1. X_train.txt
2. X_test.txt
3. y_train.txt
4. y_test.txt
5. feature.txt
6. subject_train.txt
7. subject_test.txt
8. activity_labels.txt

## Packages needed:
All the initial operations do not require of any additional package.

To perform the calculations required (mean and standard deviations) *run_analysis.R* needs of the following packages:

1. data.table
2. reshape2
3. sqldf


## How run_analysis.R works
1. Put together (rowwise) X_train and X_test
2. Put together (rowwise) y_train and y_test
      + Merge output file with activity_labels
3. Add column y_train-y_test to X_train-X_test
4. For the column names of X_train-X_test load "Features.txt" and remove special characters "()", "-", ",".
5. Add new column for the subject (previously put together subject_train and subject_test).
6. The data file "X" will have now everything needed to start with the calculations.

## Output results
For the first stage of the process (getting and cleaning data). 
The result is a data.frame *Xfinal* which has the following columns:

1. The first 561 columns are the different variables measured.
    + All these variables are properly labeled (no special characters to increase their legibility)
2. Columns 562 and 563 reflects the Activity Number (name: *ActNumb*) and Activity Description (name: *ActDesc*).
3. And the last column 563, is *Subject*.

For the second stage:

1. column selection, the intermediate data.frame created is *Xmeanstd* 
2. calculations (mean and std) the new data.frame created is *NewX* which is exported to a .txt file: *NewTidyFile-Mean-Std.txt*


