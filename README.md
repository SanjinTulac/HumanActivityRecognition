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

### Machine Learning Approach #1

For this particular assigment, the goal is to design the learning method to maximize the accuracy of predicting the class of physical activity (i.e., 'classe' column) of the test data as selected by the authors of the assignment.

Given the limitations described above, and the fact that the test data was obviously extracted from the same original sampling as training data, the classification task can now be re-formulated as finding the time window from which the individual test row was extracted, and then simply using that test window's classification as the result classification for the test row. So, the training formula became figuring classification solely based on the two raw parts of the timestamp and the user name.


#### Cross-Validation Results

Considering that the available training data was very large, and my available hardware quite limited, I opted to test this idea by training the model on only 10% of the available training data, and use the remaining 90% of available data for cross-validation. This allowed me to test this approach with 6 different algorithms. Linear regression, LASSO and Support Vector Machine (SVM) were not able to come up with a usable model. Of the remaining three, Random Forest and Boosting both performed very well, while LDA performed poorly. 

I then increased the percentage of data used for training to 30%, which caused training to take significantly more time, with only marginal improvement in (already very good) accuracy, as shown in the table below: 

|Training Data Size |  10% |  30% |  70% |
|-------------------|-----:|-----:|-----:|
|Random Forest      |0.9946|0.9973|0.9981|
|Boosting           |0.9931|0.9937|0.9930|
|Classification Tree|0.9431|0.9915|0.9920|
|LDA                |0.2844|0.2844|0.2845|

As a matter of fact, actual test data predictions were the same by the RF, Bosting and Classification Tree models when trained on 30% of the available data. When trained only on 10%, RF and Boosting still gave the same result as when trained on 30% of the data, while Classification Tree's prediction differred for only 2 out of 20 test rows (in both cases predicting class C instead of B).

### Machine Learning Approach #2

Obviously, the choice of predictors used for the classification is very specific to this particular assignment - the resulting model would be utterly useless in classifying any set of biceps curl data other than the one it was trained on. But, this method of training provided 100% accuracy on the test data (verified by the quiz).

Once I knew correct classification of the test data, I was curious if I could use the 27 sensor-based predictors available in the test data to do the classification, and create a generally usable prediction model. Knowing the correct classification would allow me to compare the cross-validation and test data accuracy.

#### Cross-Validation Results

Early experimentation showed that for a generally usable prediction model, one higher percentage of available data needed to be used for training. So, I decided to use 70% of the available data for training, and 30% for cross-validation. Here are the results:

|Algorithm              | Cross-Validation | Test |
|-----------------------|-----------------:|-----:|
|Random Forest          |            0.9786|1.0000|
|Boosting               |            0.9198|1.0000|
|Support Vector Machine |            0.8556|0.8000|
|LDA                    |            0.5752|0.6000|
|Classification Tree    |            0.4969|0.5000|

### Conclusion

Even without time series, it was possible to come up with a generic model that performs almost as well as the one that works only for the original samples. Not surprisingly, it took much more training data and, consequently, CPU cycles, to train such generic model, compared to the non-generic one.

Random forest algorithm performed best, with boosting very close second. Interestingly, support vector machine performed quite well using sensor data, while it failed quite miserably when trained on three non-generic columns. On the opposite end of the spectrum, classification tree was quite well suited for for classification based on non-generic columns, it underperformed when trained on sensor data. LDA's performance was better for generuc model, although it stil could not compete with random forest and boosting.

Not too surprisingly, the best performing models took most CPU cycles to train, although they were still very fast predicting. Apparently, these extra CPU cycles were well spent.

Somewhat surprising is that the test data accuracy turned out to be mostly higher than cross-validation accuracy. However, considering that test data was merely a random sample from the same source as our training data, this is not really a surprise. Limited size of the test data only caused the accuracy to be rounded, mostly to a higher value (e.g., 97.86% to 100% for random forest). If the test data was from a separately conducted experiment, one would definitely expect accuracy to be lower than for cross-validation data.

The key takeway from this assignment is that collected data must be adequate to answer the fundamental question that the learning process is supposed to answer. The learning method and the choice of algorithm(s) always follow the data.