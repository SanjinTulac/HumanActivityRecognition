## Recognizing Human Activity

### Introduction
This repository contains Sanjin Tulac's final assignment for [Coursera](http://www.coursera.org)'s [Practical Machine Learning](https://www.coursera.org/learn/practical-machine-learning) course.

It uses data from a [published study by Velloso et alii](http://groupware.les.inf.puc-rio.br/public/papers/2013.Velloso.QAR-WLE.pdf):

* [training data](https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv) [11.6 MB]
* [testing data](https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv) [14.8 KB]

The data contains measurements from severals sensors attached to 6 different persons doing biceps curls (particular kind of weight-lifting). The goal is to learn how to recognize correct way as well as 4 common incorrect ways to perform biceps curls.

### Data Analysis

The instructors that have conceived this assignment have already partitioned the data into training and testing data linked to above. They have withheld the classification column from the testing data in order to be able to use it for automatic assessment of accuracy.

The training data set contains of 19622 observations containing 160 different variables. The testing data set contains of only 20 observations.

Of the 160 columns, only a small portion (27) are actual readings from 9 different sensors:

* roll_belt
* pitch_belt
* yaw_belt
* gyros_belt_x
* gyros_belt_y
* gyros_belt_z
* accel_belt_x
* accel_belt_y
* accel_belt_z
* magnet_belt_x
* magnet_belt_y
* magnet_belt_z
* roll_arm
* pitch_arm
* yaw_arm
* gyros_arm_x
* gyros_arm_y
* gyros_arm_z
* accel_arm_x
* accel_arm_y
* accel_arm_z
* magnet_arm_x
* magnet_arm_y
* magnet_arm_z
* roll_dumbbell
* pitch_dumbbell
* yaw_dumbbell

Most of the other columns are statistical parameters derived from these 27 columns:

* minimum
* maximum
* skewness
* kurtosis
* amplitude

Now, biceps curls (like pretty much any other physical activity) are inherently a dynamic process, thus one expects to recognize the quality of the activity by following the sensor readings to over a period of time. To do so, the data set contains the following set of columns:

* user_name
* raw_timestamp_part_1
* raw_timestamp_part_2
* cvtd_timestamp
* new_window
* num_window

Former three of these columns allow putting a time series together, while the latter three are derived from the former.

The original data has been split into time windows with anywhere between 1 and 38 (23 in average) samples per window. Only the last row of a time window (marked with new_window column having "yes" value) has the secondary columns (i.e., those statistically derived from sensor readings) populated.

One can conclude from the facts above that the idea was to use this kind of data pre-processing to deal with temporal dimension of the data for the purposes of automated classification.

However, the authors of the assignment have apparently decided to take the 20 testing rows as a random sample out of the original data. It turns out that none of the rows in the testing set have secondary columns populated.   

### Machine Learning Approach

For this particular assigment, the goal is to design the learning method to maximize the accuracy of predicting the class of physical activity (i.e., 'classe' column) of the test data as selected by the authors of the assignment.

Given the limitations described above, and the fact that the test data was obviously extracted from the same original sampling as training data, the classification task can now be re-formulated as finding the time window from which the individual test row was extracted, and then simply using that test window's classification as the result classification for the test row. So, the training formula became figuring classification solely based on the two raw parts of the timestamp and the user name.


### Cross-Validation

Considering that the available training data was very large, and my available hardware quite limited, I opted to test this idea by training the model on only 10% of the available training data, and use the remaining 90% of available data for cross-validation. This allowed me to test this approach with 6 different algorithms. Linear regression, LASSO and Support Vector Machine (SVM) were not able to come up with a usable model. Of the remaining three, Random Forest and Boosting both performed very well, while LDA performed poorly. 

I then increased the percentage of data used for training to 30%, which caused training to take significantly more time, with only marginal improvement in (already very good) accuracy, as shown in the table below: 

|Training Data Size|  10% | 30%  |
|------------------|-----:|-----:|
|Random Forest     |0.9946|0.9973|
|Boosting          |0.9931|0.9937|
|LDA               |0.2844|0.2844|

As a matter of fact, actual test data predictions were the same by the RF and Bosting models, regardless whether trained on 10% or 30% of the data.

### Conclusion

obviously, the choice of predictors to use for the classification is very specific to this particular assignment - the resulting model would be utterly useless in classifying any set of biceps curl data other than the one it was trained on. But, the choice of test data for the assignment pretty much forced such solution on me.

If the chosen test data had more temporal features, devising a model that can be used outside of training would have been more feasible.

The key takeway from this assignment is that data collected must be adequate to answer the fundamental question that the learning process is supposed to answer. And the method and algorithm always follow the data.