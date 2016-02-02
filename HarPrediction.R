# Learning how to detect the quality of dumb bell lifting in real time

library(caret)
library(e1071)

# Reset the environment for reproducible results
rm(list=ls())
set.seed(42313)

# Load training, validation and test data
trainingAndValidationData = read.csv("pml-training.csv")
testingData = read.csv("pml-testing.csv")

trainingPartition = createDataPartition(trainingAndValidationData$classe, p = 0.7, list = FALSE)

trainingData = trainingAndValidationData[trainingPartition, ]
validationData = trainingAndValidationData[-trainingPartition, ]

# Simplified models based on user name + time stamp are fastest and most accurate!

#glm - Error in train.default(x, y, weights = w, ...) : Stopping
# glmModel = train(classe ~ user_name + raw_timestamp_part_1 + raw_timestamp_part_2, trainingData, method = "glm")
# glmValidationPrediction = predict(glmModel, newdata = validationData)
# glmConfusionMatrix = confusionMatrix(glmValidationPrediction, validationData$classe)

# Classification Tree
rpartModel = train(classe ~ user_name + raw_timestamp_part_1 + raw_timestamp_part_2, trainingData, method = "rpart")
rpartValidationPrediction = predict(rpartModel, newdata = validationData)
rpartConfusionMatrix = confusionMatrix(rpartValidationPrediction, validationData$classe)
rpartTestPrediction = predict(rpartModel, newdata = testingData)

# lda
ldaModel = train(classe ~ user_name + raw_timestamp_part_1 + raw_timestamp_part_2, trainingData, method = "lda")
ldaValidationPrediction = predict(ldaModel, newdata = validationData)
ldaConfusionMatrix = confusionMatrix(ldaValidationPrediction, validationData$classe)
ldaTestPrediction = predict(ldaModel, newdata = testingData)

# Random forest
rfModel = train(classe ~ user_name + raw_timestamp_part_1 + raw_timestamp_part_2, trainingData, method = "rf")
rfValidationPrediction = predict(rfModel, newdata = validationData)
rfConfusionMatrix = confusionMatrix(rfValidationPrediction, validationData$classe)
rfTestPrediction = predict(rfModel, newdata = testingData)

# GBM (Boosting)
gbmModel = train(classe ~ user_name + raw_timestamp_part_1 + raw_timestamp_part_2, trainingData, method = "gbm")
gbmValidationPrediction = predict(gbmModel, newdata = validationData)
gbmConfusionMatrix = confusionMatrix(gbmValidationPrediction, validationData$classe)
gbmTestPrediction = predict(gbmModel, newdata = testingData)

# Support vector machine (SVM) - generates 1964 predictions instead of 17658!
svmModel = svm(classe ~ user_name + raw_timestamp_part_1 + raw_timestamp_part_2, data = trainingData)
svmValidationPrediction = predict(svmModel, newData = validationData)
#simplestSvmConfusionMatrix = confusionMatrix(simplestSvmValidationPrediction, validationData$classe)
svmTestPrediction = predict(svmModel, newdata = testingData)

#lasso: Error: wrong model type for classification
#lassoModel = train(classe ~ user_name + raw_timestamp_part_1 + raw_timestamp_part_2, trainingData, method="lasso")

# Models based on all direct sensor predictors take much more time to compute, and are not as accurate, but they can be applied in more general case
rpartComplexModel = train(classe ~ 
  roll_belt 
+ pitch_belt
+ yaw_belt
+ gyros_belt_x
+ gyros_belt_y
+ gyros_belt_z
+ accel_belt_x
+ accel_belt_y
+ accel_belt_z
+ magnet_belt_x
+ magnet_belt_y
+ magnet_belt_z
+ roll_arm
+ pitch_arm
+ yaw_arm
+ gyros_arm_x
+ gyros_arm_y
+ gyros_arm_z
+ accel_arm_x
+ accel_arm_y
+ accel_arm_z
+ magnet_arm_x
+ magnet_arm_y
+ magnet_arm_z
+ roll_dumbbell
+ pitch_dumbbell
+ yaw_dumbbell,
trainingData, method = "rpart")
rpartComplexValidationPrediction = predict(rpartComplexModel, newdata = validationData)
rpartComplexConfusionMatrix = confusionMatrix(rpartComplexValidationPrediction, validationData$classe)
rpartComplexTestPrediction = predict(rpartComplexModel, newdata = testingData)
rpartComplexTestConfusionMatrix = confusionMatrix(rpartComplexTestPrediction, rfTestPrediction)

svmComplexModel = svm(classe ~ 
                        roll_belt 
                      + pitch_belt
                      + yaw_belt
                      + gyros_belt_x
                      + gyros_belt_y
                      + gyros_belt_z
                      + accel_belt_x
                      + accel_belt_y
                      + accel_belt_z
                      + magnet_belt_x
                      + magnet_belt_y
                      + magnet_belt_z
                      + roll_arm
                      + pitch_arm
                      + yaw_arm
                      + gyros_arm_x
                      + gyros_arm_y
                      + gyros_arm_z
                      + accel_arm_x
                      + accel_arm_y
                      + accel_arm_z
                      + magnet_arm_x
                      + magnet_arm_y
                      + magnet_arm_z
                      + roll_dumbbell
                      + pitch_dumbbell
                      + yaw_dumbbell,
                      trainingData)
svmComplexValidationPrediction = predict(svmComplexModel, newdata = validationData)
svmComplexConfusionMatrix = confusionMatrix(svmComplexValidationPrediction, validationData$classe)
svmComplexTestPrediction = predict(svmComplexModel, newdata = testingData)
svmComplexTestConfusionMatrix = confusionMatrix(svmComplexTestPrediction, rfTestPrediction)

rfComplexModel = train(classe ~ 
                            roll_belt 
                          + pitch_belt
                          + yaw_belt
                          + gyros_belt_x
                          + gyros_belt_y
                          + gyros_belt_z
                          + accel_belt_x
                          + accel_belt_y
                          + accel_belt_z
                          + magnet_belt_x
                          + magnet_belt_y
                          + magnet_belt_z
                          + roll_arm
                          + pitch_arm
                          + yaw_arm
                          + gyros_arm_x
                          + gyros_arm_y
                          + gyros_arm_z
                          + accel_arm_x
                          + accel_arm_y
                          + accel_arm_z
                          + magnet_arm_x
                          + magnet_arm_y
                          + magnet_arm_z
                          + roll_dumbbell
                          + pitch_dumbbell
                          + yaw_dumbbell,
                          trainingData, method = "rf")
rfComplexValidationPrediction = predict(rfComplexModel, newdata = validationData)
rfComplexConfusionMatrix = confusionMatrix(rfComplexValidationPrediction, validationData$classe)
rfComplexTestPrediction = predict(rfComplexModel, newdata = testingData)
rfComplexTestConfusionMatrix = confusionMatrix(rfComplexTestPrediction, rfTestPrediction)

gbmComplexModel = train(classe ~ 
                          roll_belt 
                        + pitch_belt
                        + yaw_belt
                        + gyros_belt_x
                        + gyros_belt_y
                        + gyros_belt_z
                        + accel_belt_x
                        + accel_belt_y
                        + accel_belt_z
                        + magnet_belt_x
                        + magnet_belt_y
                        + magnet_belt_z
                        + roll_arm
                        + pitch_arm
                        + yaw_arm
                        + gyros_arm_x
                        + gyros_arm_y
                        + gyros_arm_z
                        + accel_arm_x
                        + accel_arm_y
                        + accel_arm_z
                        + magnet_arm_x
                        + magnet_arm_y
                        + magnet_arm_z
                        + roll_dumbbell
                        + pitch_dumbbell
                        + yaw_dumbbell,
                        trainingData, method = "gbm")
gbmComplexValidationPrediction = predict(gbmComplexModel, newdata = validationData)
gbmComplexConfusionMatrix = confusionMatrix(gbmComplexValidationPrediction, validationData$classe)
gbmComplexTestPrediction = predict(gbmComplexModel, newdata = testingData)
gbmComplexTestConfusionMatrix = confusionMatrix(gbmComplexTestPrediction, rfTestPrediction)

ldaComplexModel = train(classe ~ 
                   roll_belt 
                 + pitch_belt
                 + yaw_belt
                 + gyros_belt_x
                 + gyros_belt_y
                 + gyros_belt_z
                 + accel_belt_x
                 + accel_belt_y
                 + accel_belt_z
                 + magnet_belt_x
                 + magnet_belt_y
                 + magnet_belt_z
                 + roll_arm
                 + pitch_arm
                 + yaw_arm
                 + gyros_arm_x
                 + gyros_arm_y
                 + gyros_arm_z
                 + accel_arm_x
                 + accel_arm_y
                 + accel_arm_z
                 + magnet_arm_x
                 + magnet_arm_y
                 + magnet_arm_z
                 + roll_dumbbell
                 + pitch_dumbbell
                 + yaw_dumbbell,
                 trainingData, method = "lda")
ldaComplexValidationPrediction = predict(ldaComplexModel, newdata = validationData)
ldaComplexConfusionMatrix = confusionMatrix(ldaComplexValidationPrediction, validationData$classe)
ldaComplexTestPrediction = predict(ldaComplexModel, newdata = testingData)
ldaComplexTestConfusionMatrix = confusionMatrix(ldaComplexTestPrediction, rfTestPrediction)