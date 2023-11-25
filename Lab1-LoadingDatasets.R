# *****************************************************************************
# Lab 1: Loading Datasets ----
# Sadiki Hamisi.

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


library(readr)
stock_ror_dataset <- read_csv(
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

