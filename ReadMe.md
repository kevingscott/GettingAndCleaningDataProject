## Basic Methodology ##

The run_analysis script can be used to create an aggregated dataset that contains the means of all
columns from the UCI smart phone dataset that already contain a mean or standard deviation for a 
sensor value by subject and activity.  In order for this script to run, it should be located
in the same directory as the script

## Assumptions##

1.  The columns that contain the mean or standard deviation columns are those that contain the
	the text "std()" or "mean()" in their text
2.  The final requirement of the project was to create a dataset summarized by subject and activity. 
	I assumed that this meant to take the dataset created in steps 1-4 and summarize it, rather than
	the original data set (66 columns instead of all 561)