# Week 4 Getting and Cleaning Data
We can divide the script in five sections: <br />
  Previous section. Load required libraries<br />
  Section 1: Load train and test data. After loading the data are merged with rbind function. <br />
  Section 2: f function is created in order to compute the mean and sd from the merged data. It's necessary to run f 
              prior to any analysis <br />
  Section 3: Subjects and activities are mixed into index vector. Index vector is used for naming the rows of the merged dataset<br />
  Section 4: With the variables names from features.txt and colnames function are assigned the variables names <br />
  Section 5: Duplicated columns are eliminated. With the help of dplyr package is done the resume_data matrix which contains for each subject and activity the average per variable <br />
  
