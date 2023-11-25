# *****************************************************************************
# Lab 2: Exploratory Data Analysis ----
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
#       coursework marks 12.
#
# License: GNU GPL-3.0-or-later
# See LICENSE file for licensing information.
# *****************************************************************************

# STEP 1. Install and use renv ----
# **Initialization: Install and use renv ----
# The renv package helps you create reproducible environments for your R
# projects. This is helpful when working in teams because it makes your R
# projects more isolated, portable and reproducible.

# Further reading:
#   Summary: https://rstudio.github.io/renv/
#   More detailed article: https://rstudio.github.io/renv/articles/renv.html

# Install renv:
if (!is.element("renv", installed.packages()[, 1])) {
  install.packages("renv", dependencies = TRUE)
}
require("renv")

# Use renv::init() to initialize renv in a new or existing project.

# The prompt received after executing renv::init() is as shown below:
# This project already has a lockfile. What would you like to do?

# 1: Restore the project from the lockfile.
# 2: Discard the lockfile and re-initialize the project.
# 3: Activate the project without snapshotting or installing any packages.
# 4: Abort project initialization.

# Select option 1 to restore the project from the lockfile
renv::init()

# This will set up a project library, containing all the packages you are
# currently using. The packages (and all the metadata needed to reinstall
# them) are recorded into a lockfile, renv.lock, and a .Rprofile ensures that
# the library is used every time you open that project.

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
# renv::snapshot() to record the packages and their
# sources in the lockfile.

# Later, if you need to share your code with someone else or run your code on
# a new machine, your collaborator (or you) can call renv::restore() to
# reinstall the specific package versions recorded in the lockfile.

# Execute the following code to reinstall the specific package versions
# recorded in the lockfile:
renv::restore()

# One of the packages required to use R in VS Code is the "languageserver"
# package. It can be installed manually as follows if you are not using the
# renv::restore() command.
if (!is.element("languageserver", installed.packages()[, 1])) {
  install.packages("languageserver", dependencies = TRUE)
}
require("languageserver")

# Loading Datasets ----
## STEP 2: Download sample datasets ----
# Create a folder called "data" and store the following 2 files inside the
# "data" folder:
## Link 1 (save the file as "iris.data"):
# https://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data
## Link 2 ("crop.data.csv"):
# https://cdn.scribbr.com/wp-content/uploads/2020/03/crop.data_.anova_.zip
# Extract the "crop.data.csv" file into the data folder

## STEP 3. Load the downloaded sample datasets ----
# Load the datasets
iris_dataset <- read.csv("data/iris.data", header = FALSE,
                         stringsAsFactors = TRUE)

# The following code (optional) can be used to name the attributes in the
# iris_dataset:

# names(iris_dataset) <- c("sepal length in cm", "sepal width in cm",
#                          "petal length in cm", "petal width in cm", "class")

if (!is.element("readr", installed.packages()[, 1])) {
  install.packages("readr", dependencies = TRUE)
}
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


View(hospital_dataset)

## STEP 4. Load sample datasets that are provided as part of a package ----
if (!is.element("mlbench", installed.packages()[, 1])) {
  install.packages("mlbench", dependencies = TRUE)
}
require("mlbench")

# Dimensions ----
## STEP 5. Preview the Loaded Datasets ----
# Dimensions refer to the number of observations (rows) and the number of
# attributes/variables/features (columns). Execute the following commands to
# display the dimensions of your datasets:

dim(hospital_dataset)


# Data Types ----
## STEP 6. Identify the Data Types ----
# Knowing the data types will help you to identify the most appropriate
# visualization types and algorithms that can be applied. It can also help you
# to identify the need to convert from categorical data (factors) to integers
# or vice versa where necessary. Execute the following command to identify the
# data types:
sapply(hospital_dataset, class)


# Descriptive Statistics ----

# You must first understand your data before you can use it to design
# prediction models and to make generalizable inferences. It is not until you
# take the time to truly understand your dataset that you can fully comprehend
# the context of the results you achieve. This understanding can be done using
# descriptive statistics such as:

# 1. Measures of frequency
# (e.g., count, percent)

# 2. Measures of central tendency
# (e.g., mean, median, mode)
# Further reading: https://www.scribbr.com/statistics/central-tendency/

# 3. Measures of distribution/dispersion/spread/scatter/variability
# (e.g., range, quartiles, interquartile range, standard deviation, variance,
# kurtosis, skewness)
# Further reading: https://www.scribbr.com/statistics/variability/
# Further reading:
#   https://digitaschools.com/descriptive-statistics-skewness-and-kurtosis/
# Further reading: https://www.scribbr.com/statistics/skewness/

# 4. Measures of relationship
# (e.g., covariance, correlation, ANOVA)

# Further reading: https://www.k2analytics.co.in/covariance-and-correlation/
# Further reading: https://www.scribbr.com/statistics/one-way-anova/
# Further reading: https://www.scribbr.com/statistics/two-way-anova/

# Understanding your data can lead to:
# (i)	  Data cleaning: Removing bad data or imputing missing data.
# (ii)	Data transformation: Reduce the skewness by applying the same function
#       to all the observations.
# (iii)	Data modelling: You may notice properties of the data such as
#       distributions or data types that suggest the use (or not) of
#       specific algorithms.

## Measures of Frequency ----

### STEP 7. Identify the number of instances that belong to each class. ----
# It is more sensible to count categorical variables (factors or dimensions)
# than numeric variables, e.g., counting the number of male and female
# participants instead of counting the frequency of each participant’s height.


student_performance_dataset_class_group_freq <- student_performance_dataset$class_group
cbind(frequency = table(student_performance_dataset_class_group_freq),
      percentage = prop.table(table(student_performance_dataset_class_group_freq)) * 100)


student_performance_dataset_gender_freq <- student_performance_dataset$gender
cbind(frequency = table(student_performance_dataset_gender_freq),
      percentage = prop.table(table(student_performance_dataset_gender_freq)) * 100)

student_performance_dataset_YOB_freq <- student_performance_dataset$YOB
cbind(frequency = table(student_performance_dataset_YOB_freq),
      percentage = prop.table(table(student_performance_dataset_YOB_freq)) * 100)

student_performance_dataset_regret_choosing_bi_freq <- student_performance_dataset$regret_choosing_bi
cbind(frequency = table(student_performance_dataset_regret_choosing_bi_freq),
      percentage = prop.table(table(student_performance_dataset_regret_choosing_bi_freq)) * 100)

student_performance_dataset_drop_bi_now_freq <- student_performance_dataset$drop_bi_now
cbind(frequency = table(student_performance_dataset_drop_bi_now_freq),
      percentage = prop.table(table(student_performance_dataset_drop_bi_now_freq)) * 100)


student_performance_dataset_motivator_freq <- student_performance_dataset$motivator
cbind(frequency = table(student_performance_dataset_motivator_freq),
      percentage = prop.table(table(student_performance_dataset_motivator_freq)) * 100)



student_performance_dataset_read_content_before_lecture_freq <- student_performance_dataset$read_content_before_lecture
cbind(frequency = table(student_performance_dataset_read_content_before_lecture_freq),
      percentage = prop.table(table(student_performance_dataset_read_content_before_lecture_freq)) * 100)

student_performance_dataset_anticipate_test_questions_freq <- student_performance_dataset$anticipate_test_questions
cbind(frequency = table(student_performance_dataset_anticipate_test_questions_freq),
      percentage = prop.table(table(student_performance_dataset_anticipate_test_questions_freq)) * 100)

student_performance_dataset_answer_rhetorical_questions_freq <- student_performance_dataset$answer_rhetorical_questions
cbind(frequency = table(student_performance_dataset_answer_rhetorical_questions_freq),
      percentage = prop.table(table(student_performance_dataset_answer_rhetorical_questions_freq)) * 100)

student_performance_dataset_find_terms_I_do_not_know_freq <- student_performance_dataset$find_terms_I_do_not_know
cbind(frequency = table(student_performance_dataset_find_terms_I_do_not_know_freq),
      percentage = prop.table(table(student_performance_dataset_find_terms_I_do_not_know_freq)) * 100)

student_performance_dataset_copy_new_terms_in_reading_notebook_freq <- student_performance_dataset$copy_new_terms_in_reading_notebook
cbind(frequency = table(student_performance_dataset_copy_new_terms_in_reading_notebook_freq),
      percentage = prop.table(table(student_performance_dataset_copy_new_terms_in_reading_notebook_freq)) * 100)

student_performance_dataset_take_quizzes_and_use_results_freq <- student_performance_dataset$take_quizzes_and_use_results
cbind(frequency = table(student_performance_dataset_take_quizzes_and_use_results_freq),
      percentage = prop.table(table(student_performance_dataset_take_quizzes_and_use_results_freq)) * 100)

student_performance_dataset_reorganise_course_outline_freq <- student_performance_dataset$reorganise_course_outline
cbind(frequency = table(student_performance_dataset_reorganise_course_outline_freq),
      percentage = prop.table(table(student_performance_dataset_reorganise_course_outline_freq)) * 100)

student_performance_dataset_write_down_important_points_freq <- student_performance_dataset$write_down_important_points
cbind(frequency = table(student_performance_dataset_write_down_important_points_freq),
      percentage = prop.table(table(student_performance_dataset_write_down_important_points_freq)) * 100)

student_performance_dataset_space_out_revision_freq <- student_performance_dataset$space_out_revision
cbind(frequency = table(student_performance_dataset_space_out_revision_freq),
      percentage = prop.table(table(student_performance_dataset_space_out_revision_freq)) * 100)

student_performance_dataset_studying_in_study_group_freq <- student_performance_dataset$studying_in_study_group
cbind(frequency = table(student_performance_dataset_studying_in_study_group_freq),
      percentage = prop.table(table(student_performance_dataset_studying_in_study_group_freq)) * 100)


student_performance_dataset_schedule_appointments_freq <- student_performance_dataset$schedule_appointments
cbind(frequency = table(student_performance_dataset_schedule_appointments_freq),
      percentage = prop.table(table(student_performance_dataset_schedule_appointments_freq)) * 100)

student_performance_dataset_goal_oriented_freq <- student_performance_dataset$goal_oriented
cbind(frequency = table(student_performance_dataset_goal_oriented_freq),
      percentage = prop.table(table(student_performance_dataset_goal_oriented_freq)) * 100)

student_performance_dataset_spaced_repetition_freq <- student_performance_dataset$spaced_repetition
cbind(frequency = table(student_performance_dataset_spaced_repetition_freq),
      percentage = prop.table(table(student_performance_dataset_spaced_repetition_freq)) * 100)

student_performance_dataset_testing_and_active_recall_freq <- student_performance_dataset$testing_and_active_recall
cbind(frequency = table(student_performance_dataset_testing_and_active_recall_freq),
      percentage = prop.table(table(student_performance_dataset_testing_and_active_recall_freq)) * 100)

student_performance_dataset_interleaving_freq <- student_performance_dataset$interleaving
cbind(frequency = table(student_performance_dataset_interleaving_freq),
      percentage = prop.table(table(student_performance_dataset_interleaving_freq)) * 100)

student_performance_dataset_categorizing_freq <- student_performance_dataset$categorizing
cbind(frequency = table(student_performance_dataset_categorizing_freq),
      percentage = prop.table(table(student_performance_dataset_categorizing_freq)) * 100)

student_performance_dataset_retrospective_timetable_freq <- student_performance_dataset$retrospective_timetable
cbind(frequency = table(student_performance_dataset_retrospective_timetable_freq),
      percentage = prop.table(table(student_performance_dataset_retrospective_timetable_freq)) * 100)

student_performance_dataset_cornell_notes_freq <- student_performance_dataset$cornell_notes
cbind(frequency = table(student_performance_dataset_cornell_notes_freq),
      percentage = prop.table(table(student_performance_dataset_cornell_notes_freq)) * 100)

student_performance_dataset_sq3r_freq <- student_performance_dataset$sq3r
cbind(frequency = table(student_performance_dataset_sq3r_freq),
      percentage = prop.table(table(student_performance_dataset_sq3r_freq)) * 100)

student_performance_dataset_commute_freq <- student_performance_dataset$commute
cbind(frequency = table(student_performance_dataset_commute_freq),
      percentage = prop.table(table(student_performance_dataset_commute_freq)) * 100)


student_performance_dataset_study_time_freq <- student_performance_dataset$study_time
cbind(frequency = table(student_performance_dataset_study_time_freq),
      percentage = prop.table(table(student_performance_dataset_study_time_freq)) * 100)

student_performance_dataset_repeats_since_Y1_freq <- student_performance_dataset$repeats_since_Y1
cbind(frequency = table(student_performance_dataset_repeats_since_Y1_freq),
      percentage = prop.table(table(student_performance_dataset_repeats_since_Y1_freq)) * 100)

student_performance_dataset_paid_tuition_freq <- student_performance_dataset$paid_tuition
cbind(frequency = table(student_performance_dataset_paid_tuition_freq),
      percentage = prop.table(table(student_performance_dataset_paid_tuition_freq)) * 100)

student_performance_dataset_free_tuition_freq <- student_performance_dataset$free_tuition
cbind(frequency = table(student_performance_dataset_free_tuition_freq),
      percentage = prop.table(table(student_performance_dataset_free_tuition_freq)) * 100)

student_performance_dataset_extra_curricular_freq <- student_performance_dataset$extra_curricular
cbind(frequency = table(student_performance_dataset_extra_curricular_freq),
      percentage = prop.table(table(student_performance_dataset_extra_curricular_freq)) * 100)

student_performance_dataset_sports_extra_curricular_freq <- student_performance_dataset$sports_extra_curricular
cbind(frequency = table(student_performance_dataset_sports_extra_curricular_freq),
      percentage = prop.table(table(student_performance_dataset_sports_extra_curricular_freq)) * 100)

student_performance_dataset_exercise_per_week_freq <- student_performance_dataset$exercise_per_week
cbind(frequency = table(student_performance_dataset_sports_exercise_per_week_freq),
      percentage = prop.table(table(student_performance_dataset_exercise_per_week_freq)) * 100)

student_performance_dataset_meditate_freq <- student_performance_dataset$meditate
cbind(frequency = table(student_performance_dataset_meditate_freq),
      percentage = prop.table(table(student_performance_dataset_meditate_freq)) * 100)

student_performance_dataset_pray_freq <- student_performance_dataset$pray
cbind(frequency = table(student_performance_dataset_pray_freq),
      percentage = prop.table(table(student_performance_dataset_pray_freq)) * 100)



## Measures of Central Tendency ----
### STEP 8. Calculate the mode ----
# Unfortunately, R does not have an in-built function for calculating the mode.
# We, therefore, must manually create a function that can calculate the mode.


## Measures of Distribution/Dispersion/Spread/Scatter/Variability ----

### STEP 9. Measure the distribution of the data for each variable ----
summary(hospital_dataset)


### STEP 10. Measure the standard deviation of each variable ----
# Measuring the variability in the dataset is important because the amount of
# variability determines how well you can generalize results from the sample
# dataset to a new observation in the population.

# Low variability is ideal because it means that you can better predict
# information about the population based on sample data. High variability means
# that the values are less consistent, thus making it harder to make
# predictions.

# The format “dataset[rows, columns]” can be used to specify the exact rows and
# columns to be considered. “dataset[, columns]” implies all rows will be
# considered. Specifying “BostonHousing[, -4]” implies all the columns except
# column number 4. This can also be stated as
# “BostonHousing[, c(1,2,3,5,6,7,8,9,10,11,12,13,14)]”. This allows us to
# calculate the standard deviation of only columns that are numeric, thus
# leaving out the columns termed as “factors” (categorical) or those that have
# a string data type.

# The data type of "yield" should be double (not numeric) so that it can be
# calculated.
sapply(hospital_dataset[, 4], sd)


### STEP 11. Measure the variance of each variable ----
sapply(hospital_dataset[, 4], var)


### STEP 12. Measure the kurtosis of each variable ----
# The Kurtosis informs you of how often outliers occur in the results.

# There are different formulas for calculating kurtosis.
# Specifying “type = 2” allows us to use the 2nd formula which is the same
# kurtosis formula used in SPSS and SAS. More details about any function can be
# obtained by searching the R help knowledge base. The knowledge base says:

# In “type = 2” (used in SPSS and SAS):
# 1.	Kurtosis < 3 implies a low number of outliers
# 2.	Kurtosis = 3 implies a medium number of outliers
# 3.	Kurtosis > 3 implies a high number of outliers


### STEP 13. Measure the skewness of each variable ----

# The skewness informs you of the asymmetry of the distribution of results.
# Similar to kurtosis, there are several ways of computing the skewness.
# Using “type = 2” can be interpreted as:

# 1.	Skewness between -0.4 and 0.4 (inclusive) implies that there is no skew
# in the distribution of results; the distribution of results is symmetrical;
# it is a normal distribution.
# 2.	Skewness above 0.4 implies a positive skew; a right-skewed distribution.
# 3.	Skewness below -0.4 implies a negative skew; a left-skewed distribution.

# Note, executing:
# skewness(BostonHousing$crim, type=2) # nolint
# computes the skewness for one variable called “crim” in the BostonHousing
# dataset. However, executing the following enables you to compute the skewness
# for all the variables in the “BostonHousing” dataset except variable number 4:

# sapply(BostonHousing[,-4],  skewness, type = 2) # nolint

## Measures of Relationship ----

## STEP 14. Measure the covariance between variables ----
# Note that the covariance and the correlation are computed for numeric values
# only, not categorical values.

## STEP 15. Measure the correlation between variables ----


# Inferential Statistics ----
# Read the following article:
#   https://www.scribbr.com/statistics/inferential-statistics/
# Statistical tests (either for comparison, correlation, or regression) can be
# used to conduct *hypothesis testing*.

## Parametric versus Non-Parametric Statistical Tests ----
# If all the 3 points below are true, then
# use parametric tests, else use non-parametric tests.
# (i)	  the population that the sample comes from follows a normal distribution
#       of scores
# (ii)  the sample size is large enough to represent the population
# (iii) the variances of each group being compared are similar

## Statistical tests for comparison ----
# (i)	  t Test: parametric; compares means; uses 2 samples.
# (ii)	ANOVA: parametric; compares means; can use more than 3 samples.
# (iii)	Mood’s median: non-parametric; compares medians; can use more than 2
#       samples.
# (iv)	Wilcoxon signed-rank: non-parametric; compares distributions; uses 2
#       samples.
# (v)	  Wilcoxon rank-sum (Mann-Whitney U): non-parametric; compares sums of
#       rankings; uses 2 samples.
# (vi)	Kruskal-Wallis H: non-parametric; compares mean rankings; can use more
#       than 3 samples.

## Statistical tests for correlation ----
# (i)	  Pearson’s r: parametric; expects interval/ratio variables.
# (ii)	Spearman’s r: non-parametric; expects ordinal/interval/ratio variables.
# (iii)	Chi square test of independence: non-parametric; nominal/ordinal
#       variables.

## Statistical tests for regression ----
# (i)	  Simple linear regression: predictor is 1 interval/ratio variable;
#       outcome is 1 interval/ratio variable.
# (ii)	Multiple linear regression: predictor can be more than 2 interval/ratio
#       variables; outcome is 1 interval/ratio variable.
# (iii)	Logistic regression: predictor is 1 variable (any type); outcome is 1
#       binary variable.
# (iv)	Nominal regression: predictor can be more than 1 variable; outcome is 1
#       nominal variable.
# (v)	  Ordinal regression: predictor can be more than 1 variable; outcome is 1
#       ordinal variable.

## STEP 16. Perform ANOVA on the “crop_dataset” dataset ----
# ANOVA (Analysis of Variance) is a statistical test used to estimate how a
# quantitative dependent variable changes according to the levels of one or
# more categorical independent variables.

# The null hypothesis (H0) of the ANOVA is that
# “there is no difference in means”, and
# the alternative hypothesis (Ha) is that
# “the means are different from one another”.

# We can use the “aov()” function in R to calculate the test statistic for
# ANOVA. The test statistic is in turn used to calculate the p-value of your
# results. A p-value is a number that describes how likely you are to have
# found a particular set of observations if the null hypothesis were true. The
# smaller the p-value, the more likely you are to reject the null-hypothesis.

# The “crop_dataset” sample dataset loaded in STEP 4 contains observations from
# an imaginary study of the effects of fertilizer type and planting density on
# crop yield. In other words:

# Dependent variable:	Crop yield
# Independent variables:	Fertilizer type, planting density, and block

# The features (attributes) are:
# 1.	density: planting density (1 = low density, 2 = high density)
# 2.	block: planting location in the field (blocks 1, 2, 3, or 4)
# 3.	fertilizer: fertilizer type (type 1, 2, or 3)
# 4.	final crop yield (in bushels per acre)

# One-Way ANOVA can be used to test the effect of the 3 types of fertilizer on
# crop yield whereas,
# Two-Way ANOVA can be used to test the effect of the 3 types of fertilizer and


# This shows the result of each variable and the residual. The residual refers
# to all the variation that is not explained by the independent variable. The
# list below is a description of each column in the result:

# 1.  Df column: Displays the degrees of freedom for the independent variable
#           (the number of levels (categories) in the variable minus 1),
#           and the degrees of freedom for the residuals (the total
#           number of observations minus the number of variables being
#           estimated + 1, i.e., (df(Residuals)=n-(k+1)).

# 2.	Sum Sq column: Displays the sum of squares (a.k.a. the total variation
#           between the group means and the overall mean). It is better to have
#           a lower Sum Sq value for residuals.

# 3.  Mean Sq column: The mean of the sum of squares, calculated by dividing
#           the sum of squares by the degrees of freedom for each parameter.

# 4.	F value column: The test statistic from the F test. This is the mean
#           square of each independent variable divided by the mean square of
#           the residuals. The larger the F value, the more likely it is that
#           the variation caused by the independent variable is real and not
#           due to chance.

# 5.	Pr(>F) column: The p-value of the F statistic. This shows how likely it
#           is that the F value calculated from the test would have occurred if
#           the null hypothesis of “no difference among group means” were true.

# The three asterisk symbols (***) implies that the p-value is less than 0.001.
# P<0.001 can be interpreted as “the type of fertilizer used has an impact on
# the final crop yield”.

# We can also have a situation where the final crop yield depends not only on
# the type of fertilizer used but also on the planting density. A two-way ANOVA
# can then be used to confirm this. Execute the following for a two-way ANOVA
# (two independent variables):

# References ----
## Bevans, R. (2023a). ANOVA in R | A Complete Step-by-Step Guide with Examples. Scribbr. Retrieved August 24, 2023, from https://www.scribbr.com/statistics/anova-in-r/ # nolint ----

## Bevans, R. (2023b). Sample Crop Data Dataset for ANOVA (Version 1) [Dataset]. Scribbr. https://www.scribbr.com/wp-content/uploads//2020/03/crop.data_.anova_.zip # nolint ----

## Fisher, R. A. (1988). Iris [Dataset]. UCI Machine Learning Repository. https://archive.ics.uci.edu/dataset/53/iris # nolint ----

## National Institute of Diabetes and Digestive and Kidney Diseases. (1999). Pima Indians Diabetes Dataset [Dataset]. UCI Machine Learning Repository. https://www.kaggle.com/datasets/uciml/pima-indians-diabetes-database # nolint ----

## StatLib CMU. (1997). Boston Housing [Dataset]. StatLib Carnegie Mellon University. http://lib.stat.cmu.edu/datasets/boston_corrected.txt # nolint ----


# **Required Lab Work Submission** ----

# NOTE: The lab work should be done in groups of between 2 and 5 members using
#       Git and GitHub.

## Part A ----
# Create a new file called "Lab2-Submission-ExploratoryDataAnalysis.R".
# Provide all the code you have used to perform an exploratory data analysis of
# the "Class Performance Dataset" provided on the eLearning platform.

## Part B ----
# Upload *the link* to your "Lab2-Submission-ExploratoryDataAnalysis.R" hosted
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

# It should have code chunks that explain only *the most significant*
# analysis performed on the dataset.

# The emphasis should be on Explanatory Data Analysis (explains the key
# statistics performed on the dataset) as opposed to
# Exploratory Data Analysis (presents ALL the statistics performed on the
# dataset). Exploratory Data Analysis that presents ALL the possible statistics
# re-creates the problem of information overload.

## Part D ----
# Render the .Rmd (R markdown) file into its .md (markdown) version by using
# knitR in RStudio.
# Documentation of knitR: https://www.rdocumentation.org/packages/knitr/

# Upload *the link* to "Lab-Submission-Markdown.md" (not .Rmd)
# markdown file hosted on Github (do not upload the .Rmd or .md markdown files)
# through the submission link provided on eLearning.