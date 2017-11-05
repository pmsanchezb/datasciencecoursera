# Practical machine learning

### Introduction

Using devices such as Jawbone Up, Nike FuelBand, and Fitbit it is now possible to collect a large amount of data about personal activity relatively inexpensively. These type of devices are part of the quantified self movement - a group of enthusiasts who take measurements about themselves regularly to improve their health, to find patterns in their behavior, or because they are tech geeks. One thing that people regularly do is quantify how much of a particular activity they do, but they rarely quantify how well they do it. In this project, your goal will be to use data from accelerometers on the belt, forearm, arm, and dumbell of 6 participants. They were asked to perform barbell lifts correctly and incorrectly in 5 different ways. More information is available from the website here: http://groupware.les.inf.puc-rio.br/har (see the section on the Weight Lifting Exercise Dataset).

#### Data

The training data for this project are available here: https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv

The test data are available here: https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv

The data for this project come from this source: http://groupware.les.inf.puc-rio.br/har. If you use the document you create for this class for any purpose please cite them as they have been very generous in allowing their data to be used for this kind of assignment.

#### Goal

The goal of your project is to predict the manner in which they did the exercise. This is the "classe" variable in the training set. You may use any of the other variables to predict with. You should create a report describing how you built your model, how you used cross validation, what you think the expected out of sample error is, and why you made the choices you did. You will also use your prediction model to predict 20 different test cases.

### Data Processing (Getting and cleaning data)



```r
options(scipen = 999)
library(data.table)
library(lubridate)
library(caret)
library(rpart)
library(gbm)
library(randomForest)
library(rattle)
library(dplyr)
```

Data is loaded into R environment. All columns are set as character by default. Aditionally the datasets are defined as data frames.


```r
setwd("C:/Users/paulomauricio/Documents/Jhon's Hopkins/Practical machine learning")
test.data  <- fread("pml-testing.csv",sep=";",colClasses = "character")
train.data <- fread("pml-training.csv",sep=";","character")
train.data <- as.data.frame(train.data)
test.data <- as.data.frame(test.data)
```

We delete white spaces and remove cells with strange values like #DIV/0. We also consider relevant to remove columns with a high percentage of NA values. In order to do so, we eliminate the columns that have 90 percent of NA values.

With the function nvz we also discard columns with low variability.


```r
train.data[] <- lapply(train.data, trimws)
sum(train.data=="#DIV/0!",na.rm = T)
```

```
## [1] 3502
```

```r
train.data[] <- lapply(train.data, gsub, pattern = "#DIV/0!",
                 replacement = NA, fixed = TRUE)
sum(train.data=="#DIV/0!",na.rm = T)
```

```
## [1] 0
```

```r
sum(train.data=="",na.rm = T)
```

```
## [1] 634128
```

```r
train.data[train.data==""] <- NA
sum(train.data=="",na.rm = T)
```

```
## [1] 0
```

```r
train.data<-train.data[,-which(colMeans(is.na(train.data)) > 0.9)]
train.data$classe <- as.factor(train.data$classe)
nzv <- nearZeroVar(train.data, saveMetrics=TRUE)
train.data <- train.data[,nzv$nzv==FALSE]
train.data <- train.data[,-c(1:3)]
```

As a final step we define again the type of the variables. This last step is important in order to reduce computational time. Aditionally, we create a training and testing set with the function createDataPartition.


```r
train.data$cvtd_timestamp<-dmy_hm(train.data$cvtd_timestamp)
train.data[,2:54] <- apply(train.data[,2:54],2,as.numeric)

preservar<- colnames(train.data)[1:dim(train.data)[2]-1]
test.data <- test.data[,preservar]

test.data$cvtd_timestamp<-dmy_hm(test.data$cvtd_timestamp)
test.data[,2:54] <- apply(test.data[,2:54],2,as.numeric)

inTrain <- createDataPartition(train.data$classe, p=0.7, list=FALSE)
myTraining <- train.data[inTrain, ]
myTesting <- train.data[-inTrain, ]
```

### Model selection and Cross Validation

For this section we analyze the accuracy of two models: i) random trees, ii) random forests. The strategy used for testing cross validation was sub-sampling. In order to do so, we contruct a loop-for strucuture. For each itearation we create a random sample without replacement which will be the basis for estimating and predicting at each iteration.


```r
set.seed(123)
# sampling
I <- 10
accuracy_fit1 <- vector("numeric",length = I)
for(i in 1:I){
  myTraining_cv <- sample_n(myTraining, dim(myTraining)[1]*0.2,replace = F)
  myTesting_cv  <- sample_n(myTesting, dim(myTesting)[1]*0.2,replace = F)
  fit1 <- train(classe ~ ., data=myTraining_cv,method="rpart")
  predictions1 <- predict(fit1,newdata = myTesting_cv[,-c(55)])
  cmtree <- confusionMatrix(predictions1, myTesting_cv$classe)
  accuracy_fit1[i] <- cmtree$overall["Accuracy"]
}

mean(accuracy_fit1)
```

```
## [1] 0.5291419
```

Now, let's see the results in the complete dataset.


```r
fit1 <- train(classe ~ ., data=myTraining_cv,method="rpart")
predictions1 <- predict(fit1,newdata = myTesting_cv[,-c(55)])
cmtree <- confusionMatrix(predictions1, myTesting_cv$classe)
cmtree
```

```
## Confusion Matrix and Statistics
## 
##           Reference
## Prediction   A   B   C   D   E
##          A 293  89  90  84  27
##          B   4  90   5  32  31
##          C  29  73 106  73  50
##          D   0   0   0   0   0
##          E   4   0   0   0  97
## 
## Overall Statistics
##                                                
##                Accuracy : 0.4979               
##                  95% CI : (0.4689, 0.5268)     
##     No Information Rate : 0.2804               
##     P-Value [Acc > NIR] : < 0.00000000000000022
##                                                
##                   Kappa : 0.3468               
##  Mcnemar's Test P-Value : NA                   
## 
## Statistics by Class:
## 
##                      Class: A Class: B Class: C Class: D Class: E
## Sensitivity            0.8879  0.35714  0.52736   0.0000  0.47317
## Specificity            0.6576  0.92216  0.76947   1.0000  0.99588
## Pos Pred Value         0.5026  0.55556  0.32024      NaN  0.96040
## Neg Pred Value         0.9377  0.84039  0.88771   0.8394  0.89963
## Prevalence             0.2804  0.21410  0.17077   0.1606  0.17417
## Detection Rate         0.2489  0.07647  0.09006   0.0000  0.08241
## Detection Prevalence   0.4953  0.13764  0.28122   0.0000  0.08581
## Balanced Accuracy      0.7727  0.63965  0.64842   0.5000  0.73453
```

Let's compare the previous results from random trees against random forests.


```r
I <- 10
accuracy_fit2 <- vector("numeric",length = I)
for(i in 1:I){
  myTraining_cv <- sample_n(myTraining, dim(myTraining)[1]*0.1,replace = F)
  myTesting_cv  <- sample_n(myTesting, dim(myTesting)[1]*0.1,replace = F)
  fit2 <- train(classe ~ ., data=myTraining_cv,method="rf")
  predictions2 <- predict(fit2,newdata = myTesting_cv[,-c(55)])
  cmtree <- confusionMatrix(predictions2, myTesting_cv$classe)
  accuracy_fit2[i] <- cmtree$overall["Accuracy"]
}

mean(accuracy_fit2)
```

```
## [1] 0.9540816
```

The same analysis dor the entire dataset:


```r
fit2 <- randomForest(classe ~ ., data=myTraining,method = "rf")
prediction2 <- predict(fit2, myTesting[,-c(55)], type = "class")
cmrf <- confusionMatrix(prediction2, myTesting$classe)
cmrf
```

```
## Confusion Matrix and Statistics
## 
##           Reference
## Prediction    A    B    C    D    E
##          A 1674    1    0    0    0
##          B    0 1138    2    0    0
##          C    0    0 1024    1    0
##          D    0    0    0  962    0
##          E    0    0    0    1 1082
## 
## Overall Statistics
##                                                
##                Accuracy : 0.9992               
##                  95% CI : (0.998, 0.9997)      
##     No Information Rate : 0.2845               
##     P-Value [Acc > NIR] : < 0.00000000000000022
##                                                
##                   Kappa : 0.9989               
##  Mcnemar's Test P-Value : NA                   
## 
## Statistics by Class:
## 
##                      Class: A Class: B Class: C Class: D Class: E
## Sensitivity            1.0000   0.9991   0.9981   0.9979   1.0000
## Specificity            0.9998   0.9996   0.9998   1.0000   0.9998
## Pos Pred Value         0.9994   0.9982   0.9990   1.0000   0.9991
## Neg Pred Value         1.0000   0.9998   0.9996   0.9996   1.0000
## Prevalence             0.2845   0.1935   0.1743   0.1638   0.1839
## Detection Rate         0.2845   0.1934   0.1740   0.1635   0.1839
## Detection Prevalence   0.2846   0.1937   0.1742   0.1635   0.1840
## Balanced Accuracy      0.9999   0.9994   0.9989   0.9990   0.9999
```

We can easily see that the random forest model is much more better in terms of prediction. So, we decided to use random forests as our best methodology.

### Out-of-Sample

```r
PredTest <- predict(fit2, newdata=test.data)
PredTest
```

```
##  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 
##  B  A  B  A  A  E  D  B  A  A  B  C  B  A  E  E  A  B  B  B 
## Levels: A B C D E
```
Random Forests gave an Accuracy in the myTesting dataset of 95.45%, which was more accurate that what I got from the random Trees. The expected out-of-sample error is 100-95.45 = 4.55%. Although, the random forest is quite good in predicting there are a variety of models unexplored.
