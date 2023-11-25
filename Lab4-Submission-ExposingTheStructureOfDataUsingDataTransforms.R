# *****************************************************************************
# Lab 4: Exposing the Structure of Data using Data Transforms ----
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
# Data transforms can improve the accuracy of your final model when applied as
# part of the pre-processing stage. It is standard practice to apply multiple
# transforms with a suite of different machine learning algorithms. Data
# transforms can be grouped into the following 3 categories:
#   (i)	Basic data transforms:
#              a. Scaling: Divides each value by the standard deviation
#              b. Centering: Subtracts the mean from each value
#              c. Standardization: Ensures that each numeric attribute has a
#                   mean value of 0 and a standard deviation of 1. This is done
#                   by combining the scale data transform and the centre data
#                   transform.
#              d. Normalization: Ensures the numerical data are between [0, 1]
#                   (inclusive).
#   (ii)	Power transforms:
#              a. Box-Cox: reduces the skewness by shifting the distribution of
#                   an attribute and making the attribute have a more
#                   Gaussian-like distribution.
#              b. Yeo-Johnson: like Box-Cox, Yeo-Johnson reduces the skewness
#                   by shifting the distribution of an attribute and making the
#                   attribute have a more Gaussian-like distribution.
#                   The difference is that Yeo-Johnson can handle zero and
#                   negative values.
#   (iii)	Linear algebra transforms: Principal Component Analysis (PCA) and
#         Independent Component Analysis (ICA)

# The first step is to design a model of the transform using the training data.
# This results in a model of the transform that can be applied to multiple
# datasets. The preparation of the model of the transform is done using the
# preProcess() function. The model of the transform can then be applied to a
# dataset in either of the following two ways:
#   (i)	  Standalone: The model of the transform is passed to the predict()
#         function
#   (ii)	Training: The model of the transform is passed to the train()
#         function via the preProcess argument. This is done during the model
#         evaluation stage.
# Note that the preProcess() function ignores non-numeric attributes.

# STEP 1. Install and Load the Required Packages ----
## mlbench ----
if (require("mlbench")) {
  require("mlbench")
} else {
  install.packages("mlbench", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## readr ----
if (require("readr")) {
  require("readr")
} else {
  install.packages("readr", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## caret ----
if (require("caret")) {
  require("caret")
} else {
  install.packages("caret", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## e1071 ----
if (require("e1071")) {
  require("e1071")
} else {
  install.packages("e1071", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## factoextra ----
if (require("factoextra")) {
  require("factoextra")
} else {
  install.packages("factoextra", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## FactoMineR ----
if (require("FactoMineR")) {
  require("FactoMineR")
} else {
  install.packages("FactoMineR", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## STEP 2. Load the Datasets ----


### Crop Dataset ----
# Execute the following to load the downloaded Crop dataset:
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


View(hospital_dataset)

# Dimensions
dim(hospital_dataset)

# Data Types
sapply(hospital_dataset, class)
glimpse(hospital_dataset)




# Scale Data Transform ----

## STEP 3. Apply a Scale Data Transform ----
# The scale data transform is useful for scaling data that has a Gaussian
# distribution. The scale data transform works by calculating the standard
# deviation of an attribute and then divides each value by the standard
# deviation.

### Benefits of Scaling ----
#### 1. Facilitating Algorithm Convergence ----
# Many machine learning algorithms, such as gradient descent-based methods and
# support vector machines, work more efficiently and converge faster when the
# input features are on similar scales. Rescaling the data helps prevent some
# features from dominating the learning process.

#### 2. Improving Interpretability ----
# Scaling makes it easier to compare the importance of different features in a
# model. When features have different scales, it can be challenging to
# interpret their relative contributions.

#### 3. Enhancing Model Performance ----
# Some machine learning algorithms, like k-nearest neighbors and principal
# component analysis, are sensitive to the scale of the data. Scaling can lead
# to better model performance and more reliable results.

#### 4. Handling Outliers ----
# Standardizing data can help mitigate the impact of outliers. Outliers are
# data points that are significantly different from the majority of the data.
# If not properly handled, outliers can distort model predictions.

#### 5. Comparing Variables ----
# Scaling allows you to compare variables that have different units or
# measurement scales. For example, you can compare variables like age and
# income on the same scale after scaling.

# We use the "preProcess()" function in the caret package

### The Scale Basic Transform on the Boston Housing Dataset ----
# BEFORE


### The Scale Basic Transform on the Crop Dataset ----
# BEFORE
View(hospital_dataset)

summary(hospital_dataset)
hospital_dataset_enj <- as.numeric(unlist(hospital_dataset[, 49]))
hist(hospital_dataset_enj, main = names(hospital_dataset)[49])

model_of_the_transform <- preProcess(hospital_dataset, method = c("scale"))
print(model_of_the_transform)
hospital_data_scale_transform <- predict(model_of_the_transform, hospital_dataset)

# AFTER
summary(hospital_data_scale_transform)
hospital_dataset_enj <- as.numeric(unlist(hospital_data_scale_transform[, 49]))
hist(hospital_dataset_enj, main = names(hospital_data_scale_transform)[49])


# [OPTIONAL] **Deinitialization: Create a snapshot of the R environment ----
# Lastly, as a follow-up to the initialization step, record the packages
# installed and their sources in the lockfile so that other team-members can
# use renv::restore() to re-install the same package version in their local
# machine during their initialization step.
# renv::snapshot() # nolint

# References ----
## Bevans, R. (2023). Sample Crop Data Dataset for ANOVA (Version 1) [Dataset]. Scribbr. https://www.scribbr.com/wp-content/uploads//2020/03/crop.data_.anova_.zip # nolint ----

## Fisher, R. A. (1988). Iris [Dataset]. UCI Machine Learning Repository. https://archive.ics.uci.edu/dataset/53/iris # nolint ----

## National Institute of Diabetes and Digestive and Kidney Diseases. (1999). Pima Indians Diabetes Dataset [Dataset]. UCI Machine Learning Repository. https://www.kaggle.com/datasets/uciml/pima-indians-diabetes-database # nolint ----

## StatLib CMU. (1997). Boston Housing [Dataset]. StatLib Carnegie Mellon University. http://lib.stat.cmu.edu/datasets/boston_corrected.txt # nolint ----

# **Required Lab Work Submission** ----
## Part A ----
# Create a new file called
# "Lab4-Submission-ExposingTheStructureOfDataUsingDataTransforms.R".
# Provide all the code you have used to perform data transformation on the
# "BI1 Student Performance" dataset provided in class. Perform ALL the data
# transformations that have been used in the
# "Lab4-ExposingTheStructureOfDataUsingDataTransforms.R" file.

## Part B ----
# Upload *the link* to your
# "Lab4-Submission-ExposingTheStructureOfDataUsingDataTransforms.R" hosted
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

# It should have code chunks that explain the
# data transformation performed on the dataset.

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