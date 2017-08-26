# datasciencecoursera
We can divide the script in five sections:
  Previous section. Load required libraries
  Section 1: Load train and test data. After loading the data are merged with rbind function.
  Section 2: f function is created in order to compute the mean and sd from the merged data. It's necessary to run f 
              prior to any analysis
  Section 3: Subjects and activities are mixed into index vector. Index vector is used for naming the rows of the merged dataset
  Section 4: With the variables names from features.txt and colnames function are assigned the variables names
  Section 5: Duplicated columns are eliminated. With the help of dplyr package is done the resume_data matrix which contains for each subject 
              and activity the average per variable
  
