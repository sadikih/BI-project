# *****************************************************************************
# Lab 3: Data Imputation ----
#
# Course Code: BBT4206
# Course Name: Business Intelligence II
# Semester Duration: 21st August 2023 to 28th November 2023
#
# Lecturer: Allan Omondi
# Contact: aomondi_at_strathmore_dot_edu
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

if (!is.element("languageserver", installed.packages()[, 1])) {
  install.packages("languageserver", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}
require("languageserver")

# Introduction ----
# Data imputation, also known as missing data imputation, is a technique used
# in data analysis and statistics to fill in missing values in a dataset.
# Missing data can occur due to various reasons, such as equipment malfunction,
# human error, or non-response in surveys.

# Imputing missing data is important because many statistical analysis methods
# and Machine Learning algorithms require complete datasets to produce accurate
# and reliable results. By filling in the missing values, data imputation helps
# to preserve the integrity and usefulness of the dataset.

## Data Imputation Methods ----

### 1. Mean/Median Imputation ----

# This method involves replacing missing values with the mean or median value
# of the available data for that variable. It is a simple and quick approach
# but does not consider any relationships between variables.

# Unlike the recorded values, mean-imputed values do not include natural
# variance. Therefore, they are less “scattered” and would technically minimize
# the standard error in a linear regression. We would perceive our estimates to
# be more accurate than they actually are in real-life.

### 2. Regression Imputation ----
# In this approach, missing values are estimated by regressing the variable
# with missing values on other variables that are known. The estimated values
# are then used to fill in the missing values.

### 3. Multiple Imputation ----
# Multiple imputation involves creating several plausible imputations for each
# missing value based on statistical models that capture the relationships
# between variables. This technique recognizes the uncertainty associated with
# imputing missing values.

### 4. Machine Learning-Based Imputation ----
# Machine learning algorithms can be used to predict missing values based on
# the patterns and relationships present in the available data. Techniques such
# as K-Nearest Neighbours (KNN) imputation or decision tree-based imputation can
# be employed.

### 5. Hot Deck Imputation ----
# This method involves finding similar cases (referred to as donors) that have
# complete data and using their values to impute missing values in other cases
# (referred to as recipients).

### 6. Multiple Imputation by Chained Equations (MICE) ----
# MICE is flexible and can handle different variable types at once (e.g.,
# continuous, binary, ordinal etc.). For each variable containing missing
# values, we can use the remaining information in the data to train a model
# that predicts what could have been recorded to fill in the blanks.
# To account for the statistical uncertainty in the imputations, the MICE
# procedure goes through several rounds and computes replacements for missing
# values in each round. As the name suggests, we thus fill in the missing
# values multiple times and create several complete datasets before we pool the
# results to arrive at more realistic results.

## Types of Missing Data ----
### 1. Missing Not At Random (MNAR) ----
# Locations of missing values in the dataset depend on the missing values
# themselves. For example, students submitting a course evaluation tend to
# report positive or neutral responses and skip questions that will result in a
# negative response. Such students may systematically leave the following
# question blank because they are uncomfortable giving a bad rating for their
# lecturer: “Classes started and ended on time”.

### 2. Missing At Random (MAR) ----
# Locations of missing values in the dataset depend on some other observed
# data. In the case of course evaluations, students who are not certain about a
# response may feel unable to give accurate responses on a numeric scale, for
# example, the question "I developed my oral and writing skills " may be
# difficult to measure on a scale of 1-5. Subsequently, if such questions are
# optional, they rarely get a response because it depends on another unobserved
# mechanism: in this case, the individual need for more precise
# self-assessments.

### 3. Missing Completely At Random (MCAR) ----
# In this case, the locations of missing values in the dataset are purely
# random and they do not depend on any other data.

# In all the above cases, removing the entire response  because one question
# has missing data may distort the results.

# If the data are MAR or MNAR, imputing missing values is advisable.

# STEP 1. Load the Required Dataset ----
# The dataset we will use (for educational purposes) is the US National Health
# and Nutrition Examination Study (NHANES) dataset created from 1999 to 2004.

# Documentation of NHANES:
#   https://cran.r-project.org/package=NHANES or
#   https://cran.r-project.org/web/packages/NHANES/NHANES.pdf or
#   http://www.cdc.gov/nchs/nhanes.htm

# This requires the "NHANES" package available in R

# STEP 1. Install and Load the Required Packages ----
# The following packages should be installed and loaded before proceeding to the
# subsequent steps.

## NHANES ----
if (!is.element("NHANES", installed.packages()[, 1])) {
  install.packages("NHANES", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}
require("NHANES")

## dplyr ----
if (!is.element("dplyr", installed.packages()[, 1])) {
  install.packages("dplyr", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}
require("dplyr")

## naniar ----
# Documentation:
#   https://cran.r-project.org/package=naniar or
#   https://www.rdocumentation.org/packages/naniar/versions/1.0.0
if (!is.element("naniar", installed.packages()[, 1])) {
  install.packages("naniar", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}
require("naniar")

## ggplot2 ----
# We require the "ggplot2" package to create more appealing visualizations
if (!is.element("ggplot2", installed.packages()[, 1])) {
  install.packages("ggplot2", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}
require("ggplot2")

## MICE ----
# We use the MICE package to perform data imputation
if (!is.element("mice", installed.packages()[, 1])) {
  install.packages("mice", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}
require("mice")

## Amelia ----
if (!is.element("Amelia", installed.packages()[, 1])) {
  install.packages("Amelia", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}
require("Amelia")

# STEP 2. Customize the Visualizations, Tables, and Colour Scheme ----
# We select only the following features to be included in the dataset:

library(readr)
hospital_dataset <- read_csv("data/dataset.csv")
View(hospital_dataset)


hospital_dataset <- hospital_dataset %>% 
  select(Disease,Symptom_1,Symptom_2,Symptom_3,Symptom_4,Symptom_5,Symptom_6,Symptom_7,Symptom_8,Symptom_9,Symptom_10,Symptom_11,Symptom_12,Symptom_13,Symptom_14,Symptom_15,Symptom_16,Symptom_17)
### Subset of rows ----
# We then the 70 random observations to be included in the dataset
rand_ind <- sample(seq_len(nrow(hospital_dataset)), 70)
hospital_dataset <- hospital_dataset[rand_ind, ]

# STEP 3. Create a subset of the variables/features ----
# Are there missing values in the dataset?
any_na(hospital_dataset)

# How many?
n_miss(hospital_dataset)

# What is the percentage of missing data in the entire dataset?
prop_miss(hospital_dataset)

# How many missing values does each variable have?
hospital_dataset %>% is.na() %>% colSums()

# What is the number and percentage of missing values grouped by
# each variable?
miss_var_summary(hospital_dataset)

# What is the number and percentage of missing values grouped by
# each observation?
miss_case_summary(hospital_dataset)

# Which variables contain the most missing values?
gg_miss_var(hospital_dataset)

# Where are missing values located (the shaded regions in the plot)?
vis_miss(hospital_dataset) + theme(axis.text.x = element_text(angle = 80))

# Which combinations of variables are missing together?
gg_miss_upset(hospital_dataset)

# Create a heatmap of "missingness" broken down by "EXAM"
# First, confirm that the "EXAM" variable is a categorical variable
is.factor(hospital_dataset$Symptom_1)
# Second, create the visualization
gg_miss_fct(hospital_dataset, fct = Symptom_1)

# We can also create a heatmap of "missingness" broken down by "Total_coursework"
# First, confirm that the "Total_coursework" variable is a categorical variable
is.factor(hospital_dataset$Disease)
# Second, create the visualization
gg_miss_fct(hospital_dataset, fct = Disease)

# STEP 4. Use the MICE package to perform data imputation ----
# We can use the dplyr::mutate() function inside the dplyr package to add new
# variables that are functions of existing variables

# In this case, it is used to create a new variable called,
# "Weighted_Score"
# Further reading:
#   https://en.wikipedia.org/wiki/Mean_arterial_pressure




# We finally begin to make use of Multivariate Imputation by Chained
# Equations (MICE). We use 11 multiple imputations.

# To arrive at good predictions for each variable containing missing values, we
# save the variables that are at least "somewhat correlated" (r > 0.3).
somewhat_correlated_variables <- quickpred(hospital_dataset, mincor = 0.3) # nolint

# m = 11 Specifies that the imputation (filling in the missing data) will be
#         performed 11 times (multiple times) to create several complete
#         datasets before we pool the results to arrive at a more realistic
#         final result. The larger the value of "m" and the larger the dataset,
#         the longer the data imputation will take.
# seed = 7 Specifies that number 7 will be used to offset the random number
#         generator used by mice. This is so that we get the same results
#         each time we run MICE.
# meth = "pmm" Specifies the imputation method. "pmm" stands for "Predictive
#         Mean Matching" and it can be used for numeric data.
#         Other methods include:
#         1. "logreg": logistic regression imputation; used
#            for binary categorical data
#         2. "polyreg": Polytomous Regression Imputation for unordered
#            categorical data with more than 2 categories, and
#         3. "polr": Proportional Odds model for ordered categorical
#            data with more than 2 categories.
hospital_dataset_mice <- mice(hospital_dataset, m = 11, method = "pmm",
                            seed = 7,
                            predictorMatrix = somewhat_correlated_variables)

# We can use multiple scatter plots (a.k.a. strip-plots) to visualize how
# random the imputed data is in each of the 11 datasets.


# Strip plot for YOB (Coursework_plus_Exam) vs. Total_project
# Assuming you have the student_performance_dataset available



## Impute the missing data ----
# We then create imputed data for the final dataset using the mice::complete()
# function in the mice package to fill in the missing data.
hospital_dataset_imputed <- mice::complete(hospital_dataset_mice, 1)

# STEP 5. Confirm the "missingness" in the Imputed Dataset ----
# A textual confirmation that the dataset has no more missing values in any
# feature:
miss_var_summary(hospital_dataset_imputed)

# A visual confirmation that the dataset has no more missing values in any
# feature:
Amelia::missmap(hospital_dataset_imputed)

#########################
# Are there missing values in the dataset?
any_na(hospital_dataset_imputed)

# How many?
n_miss(hospital_dataset_imputed)

# What is the percentage of missing data in the entire dataset?
prop_miss(hospital_dataset_imputed)

# How many missing values does each variable have?
hospital_dataset_imputed %>% is.na() %>% colSums()

# What is the number and percentage of missing values grouped by
# each variable?
miss_var_summary(hospital_dataset_imputed)

# What is the number and percentage of missing values grouped by
# each observation?
miss_case_summary(hospital_dataset_imputed)

# Which variables contain the most missing values?
gg_miss_var(hospital_dataset_imputed)

# We require the "ggplot2" package to create more appealing visualizations

# Where are missing values located (the shaded regions in the plot)?
vis_miss(hospital_dataset_imputed) + theme(axis.text.x = element_text(angle = 80))

# Which combinations of variables are missing together?

# Note: The following command should give you an error stating that at least 2
# variables should have missing data for the plot to be created.
gg_miss_upset(hospital_dataset_imputed)

# Create a heatmap of "missingness" broken down by "EXAM"
# First, confirm that the "EXAM" variable is a categorical variable
is.factor(hospital_dataset_imputed$Disease)
# Second, create the visualization
gg_miss_fct(hospital_dataset_imputed, fct = Disease)

# We can also create a heatmap of "missingness" broken down by "Total_coursework"
# First, confirm that the "Total_coursework" variable is a categorical variable
is.factor(hospital_dataset_imputed$Symptom_1)
# Second, create the visualization
gg_miss_fct(hospital_dataset_imputed, fct = Symptom_1)

