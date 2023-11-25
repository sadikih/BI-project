# *****************************************************************************
# Lab 6: Evaluation Metrics ----
#
# Course Code: BBT4206
# Course Name: Business Intelligence II
# Semester Duration: 21st August 2023 to 28th November 2023
#
# Lecturer: Allan Omondi
# Contact: aomondi [at] strathmore.edu
#
# Note: The lecture contains both theory and practice. This file forms part of
#       the practice. It has required lab work submissions that are graded for
#       coursework marks.
#
# License: GNU GPL-3.0-or-later
# See LICENSE file for licensing information.
# *****************************************************************************

# **[OPTIONAL] Initialization: Install and use renv ----
# The R Environment ("renv") package helps you create reproducible environments
# for your R projects. This is helpful when working in teams because it makes
# your R projects more isolated, portable and reproducible.

# Further reading:
#   Summary: https://rstudio.github.io/renv/
#   More detailed article: https://rstudio.github.io/renv/articles/renv.html

# "renv" It can be installed as follows:
# if (!is.element("renv", installed.packages()[, 1])) {
# install.packages("renv", dependencies = TRUE,
# repos = "https://cloud.r-project.org") # nolint
# }
# require("renv") # nolint

# Once installed, you can then use renv::init() to initialize renv in a new
# project.

# The prompt received after executing renv::init() is as shown below:
# This project already has a lockfile. What would you like to do?

# 1: Restore the project from the lockfile.
# 2: Discard the lockfile and re-initialize the project.
# 3: Activate the project without snapshotting or installing any packages.
# 4: Abort project initialization.

# Select option 1 to restore the project from the lockfile
# renv::init() # nolint

# This will set up a project library, containing all the packages you are
# currently using. The packages (and all the metadata needed to reinstall
# them) are recorded into a lockfile, renv.lock, and a .Rprofile ensures that
# the library is used every time you open the project.

# Consider a library as the location where packages are stored.
# Execute the following command to list all the libraries available in your
# computer:
.libPaths()

# One of the libraries should be a folder inside the project if you are using
# renv

# Then execute the following command to see which packages are available in
# each library:
lapply(.libPaths(), list.files)

# This can also be configured using the RStudio GUI when you click the project
# file, e.g., "BBT4206-R.Rproj" in the case of this project. Then
# navigate to the "Environments" tab and select "Use renv with this project".

# As you continue to work on your project, you can install and upgrade
# packages, using either:
# install.packages() and update.packages or
# renv::install() and renv::update()

# You can also clean up a project by removing unused packages using the
# following command: renv::clean()

# After you have confirmed that your code works as expected, use
# renv::snapshot(), AT THE END, to record the packages and their
# sources in the lockfile.

# Later, if you need to share your code with someone else or run your code on
# a new machine, your collaborator (or you) can call renv::restore() to
# reinstall the specific package versions recorded in the lockfile.

# [OPTIONAL]
# Execute the following code to reinstall the specific package versions
# recorded in the lockfile (restart R after executing the command):
# renv::restore() # nolint

# [OPTIONAL]
# If you get several errors setting up renv and you prefer not to use it, then
# you can deactivate it using the following command (restart R after executing
# the command):
# renv::deactivate() # nolint

# If renv::restore() did not install the "languageserver" package (required to
# use R for VS Code), then it can be installed manually as follows (restart R
# after executing the command):

if (require("languageserver")) {
  require("languageserver")
} else {
  install.packages("languageserver", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

# Introduction ----
# The choice of evaluation metric depends on the specific problem,
# the characteristics of the data, and the goals of the modeling task.
# It's often a good practice to use multiple evaluation metrics to gain a more
# comprehensive understanding of a model's performance.

# There are several evaluation metrics that can be used to evaluate algorithms.
# The default metrics used are:
## (1) "Accuracy" for classification problems and
## (2) "RMSE" for regression problems

# STEP 1. Install and Load the Required Packages ----
## ggplot2 ----
if (require("ggplot2")) {
  require("ggplot2")
} else {
  install.packages("ggplot2", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## caret ----
if (require("caret")) {
  require("caret")
} else {
  install.packages("caret", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## mlbench ----
if (require("mlbench")) {
  require("mlbench")
} else {
  install.packages("mlbench", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## pROC ----
if (require("pROC")) {
  require("pROC")
} else {
  install.packages("pROC", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## dplyr ----
if (require("dplyr")) {
  require("dplyr")
} else {
  install.packages("dplyr", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

# 1. Accuracy and Cohen's Kappa ----
# Accuracy is the percentage of correctly classified instances out of all
# instances. Accuracy is more useful in binary classification problems than
# in multi-class classification problems.

# On the other hand, Cohen's Kappa is similar to Accuracy, however, it is more
# useful for classification problems that do not have an equal distribution of
# instances amongst the classes in the dataset.

# For example, instead of Red are 50 instances and Blue are 50 instances,
# the distribution can be that Red are 70 instances and Blue are 30 instances.

## 1.a. Load the dataset ----
library(dplyr)
library(readr)
hospital_dataset <- read_csv(
  "data/dataset.csv",
  col_types = cols(
    Disease = col_factor(
      levels = c(
        "Disease",
        "Hyperthyroidism", # nolint
        "Hypoglycemia",
        "Osteoarthristis",
        "Arthritis",
        "(vertigo) Paroymsal  Positional Vertigo",
        "Acne",
        "Urinary tract infection",
        "Psoriasis",
        "Impetigo",
        "Fungal infection",
        "Allergy",
        "GERD",
        "Chronic cholestasis",
        "Drug Reaction",
        "Peptic ulcer diseae",  
        "AIDS",
        "Diabetes" ,
        "Gastroenteritis",
        "Hypertension",
        "Migraine",
        "Cervical spondylosis",
        "Paralysis (brain hemorrhage)",
        "Jaundice",
        "Malaria",
        "Chicken pox",
        "Dengue",
        "Typhoid",
        "hepatitis A",
        "Hepatitis B",
        "Hepatitis C",
        "Hepatitis D",
        "Hepatitis E",
        "Alcoholic hepatitis",
        "Tuberculosis",
        "Common Cold",
        "Pneumonia",
        "Dimorphic hemmorhoids(piles)",
        "Heart attack",
        "Varicose veins",
        "Hypothyroidism",
        "Hypoglycemia",
        "Osteoarthristis",
        "Arthritis",
        "Urinary tract infection",
        "Psoriasis",
        "Fungal infection",
        "Peptic ulcer diseae",
        "Migraine",
        "Cervical spondylosis",
        "Paralysis (brain hemorrhage)",
        "Jaundice",
        "Malaria",
        "Chicken pox",
        "Common Cold",
        "Pneumonia",
        "Dimorphic hemmorhoids(piles)",
        "Heart attack"
      )
    ),
    
  )
)

## 1.b. Determine the Baseline Accuracy ----
# Identify the number of instances that belong to each class (distribution or
# class breakdown).

# The result should show that 65% tested negative and 34% tested positive
# for diabetes.

# This means that an algorithm can achieve a 65% accuracy by
# predicting that all instances belong to the class "negative".

# This in turn implies that the baseline accuracy is 65%.
View(hospital_dataset)
hospital_freq <- hospital_dataset$Disease
cbind(frequency =
        table(hospital_freq),
      percentage = prop.table(table(hospital_freq)) * 100)

## 1.c. Split the dataset ----
# Define a 75:25 train:test data split of the dataset.
# That is, 75% of the original data will be used to train the model and
# 25% of the original data will be used to test the model.
train_index <- createDataPartition(hospital_dataset$Disease,
                                   p = 0.75,
                                   list = FALSE)
hospital_dataset_train <- hospital_dataset[train_index, ]
hospital_dataset_test <- hospital_dataset[-train_index, ]

## 1.d. Train the Model ----
# We apply the 5-fold cross validation resampling method
train_control <- trainControl(method = "cv", number = 5)

# We then train a Generalized Linear Model to predict the value of Diabetes
# (whether the patient will test positive/negative for diabetes).

# `set.seed()` is a function that is used to specify a starting point for the
# random number generator to a specific value. This ensures that every time you
# run the same code, you will get the same "random" numbers.
set.seed(7)
hospital_model_rf  <-
  train(Disease ~ ., data = hospital_dataset_train, method = "rf",
        metric = "Accuracy", trControl = train_control)

## 1.e. Display the Model's Performance ----
### Option 1: Use the metric calculated by caret when training the model ----
# The results show an accuracy of approximately 77% (slightly above the baseline
# accuracy) and a Kappa of approximately 49%.
print(hospital_model_rf)

### Option 2: Compute the metric yourself using the test dataset ----
# A confusion matrix is useful for multi-class classification problems.
# Please watch the following video first: https://youtu.be/Kdsp6soqA7o

# The Confusion Matrix is a type of matrix which is used to visualize the
# predicted values against the actual Values. The row headers in the
# confusion matrix represent predicted values and column headers are used to
# represent actual values.

predictions <- predict(hospital_model_rf, newdata = hospital_dataset_test[, 1:4])

# Make sure both 'predictions' and 'iris_test[, 1:4]$Species' are factors
predictions <- as.factor(predictions)
# Convert the "Species" column to a factor in the full data frame
hospital_dataset_test$Disease <- as.factor(hospital_dataset_test$Disease)

# Set factor levels for 'predictions' and 'iris_test[, 1:4]$Species'
confusion_matrix <- confusionMatrix(predictions, hospital_dataset_test$Disease)
print(confusion_matrix)

confusion_data <- as.data.frame(as.table(confusion_matrix))

# [OPTIONAL] **Deinitialization: Create a snapshot of the R environment ----
# Lastly, as a follow-up to the initialization step, record the packages
# installed and their sources in the lockfile so that other team-members can
# use renv::restore() to re-install the same package version in their local
# machine during their initialization step.
# renv::snapshot() # nolint

# References ----

## Kuhn, M., Wing, J., Weston, S., Williams, A., Keefer, C., Engelhardt, A., Cooper, T., Mayer, Z., Kenkel, B., R Core Team, Benesty, M., Lescarbeau, R., Ziem, A., Scrucca, L., Tang, Y., Candan, C., & Hunt, T. (2023). caret: Classification and Regression Training (6.0-94) [Computer software]. https://cran.r-project.org/package=caret # nolint ----

## Leisch, F., & Dimitriadou, E. (2023). mlbench: Machine Learning Benchmark Problems (2.1-3.1) [Computer software]. https://cran.r-project.org/web/packages/mlbench/index.html # nolint ----

## National Institute of Diabetes and Digestive and Kidney Diseases. (1999). Pima Indians Diabetes Dataset [Dataset]. UCI Machine Learning Repository. https://www.kaggle.com/datasets/uciml/pima-indians-diabetes-database # nolint ----

## Robin, X., Turck, N., Hainard, A., Tiberti, N., Lisacek, F., Sanchez, J.-C., Müller, M., Siegert, S., Doering, M., & Billings, Z. (2023). pROC: Display and Analyze ROC Curves (1.18.4) [Computer software]. https://cran.r-project.org/web/packages/pROC/index.html # nolint ----

## Wickham, H., François, R., Henry, L., Müller, K., Vaughan, D., Software, P., & PBC. (2023). dplyr: A Grammar of Data Manipulation (1.1.3) [Computer software]. https://cran.r-project.org/package=dplyr # nolint ----

## Wickham, H., Chang, W., Henry, L., Pedersen, T. L., Takahashi, K., Wilke, C., Woo, K., Yutani, H., Dunnington, D., Posit, & PBC. (2023). ggplot2: Create Elegant Data Visualisations Using the Grammar of Graphics (3.4.3) [Computer software]. https://cran.r-project.org/package=ggplot2 # nolint ----

# **Required Lab Work Submission** ----
## Part A ----
# Create a new file called
# "Lab6-Submission-EvaluationMetrics.R".
# Provide all the code you have used to demonstrate the classification and
# regression evaluation metrics we have gone through in this lab.
# This should be done on any datasets of your choice except the ones used in
# this lab.

## Part B ----
# Upload *the link* to your
# "Lab6-Submission-EvaluationMetrics.R" hosted
# on Github (do not upload the .R file itself) through the submission link
# provided on eLearning.

## Part C ----
# Create a markdown file called "Lab-Submission-Markdown.Rmd"
# and place it inside the folder called "markdown". Use R Studio to ensure the
# .Rmd file is based on the "GitHub Document (Markdown)" template when it is
# being created.

# Refer to the following file in Lab 1 for an example of a .Rmd file based on
# the "GitHub Document (Markdown)" template:
#     https://github.com/course-files/BBT4206-R-Lab1of15-LoadingDatasets/blob/main/markdown/BIProject-Template.Rmd # nolint

# Include Line 1 to 14 of BIProject-Template.Rmd in your .Rmd file to make it
# displayable on GitHub when rendered into its .md version

# It should have code chunks that explain all the steps performed on the
# datasets.

## Part D ----
# Render the .Rmd (R markdown) file into its .md (markdown) version by using
# knitR in RStudio.

# You need to download and install "pandoc" to render the R markdown.
# Pandoc is a file converter that can be used to convert the following files:
#   https://pandoc.org/diagram.svgz?v=20230831075849

# Documentation:
#   https://pandoc.org/installing.html and
#   https://github.com/REditorSupport/vscode-R/wiki/R-Markdown

# By default, Rmd files are open as Markdown documents. To enable R Markdown
# features, you need to associate *.Rmd files with rmd language.
# Add an entry Item "*.Rmd" and Value "rmd" in the VS Code settings,
# "File Association" option.

# Documentation of knitR: https://www.rdocumentation.org/packages/knitr/

# Upload *the link* to "Lab-Submission-Markdown.md" (not .Rmd)
# markdown file hosted on Github (do not upload the .Rmd or .md markdown files)
# through the submission link provided on eLearning.