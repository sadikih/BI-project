library(dplyr)
library(httr)
library(jsonlite)
library(readr)

# Load the hospital dataset
hospital_dataset <- read_csv(
  "data/dataset.csv",
  col_types = cols(
    Disease = col_factor(
      levels = c(
        "Hyperthyroidism", "Hypoglycemia", "Osteoarthristis", "Arthritis",
        "(vertigo) Paroymsal  Positional Vertigo", "Acne", "Urinary tract infection",
        "Psoriasis", "Impetigo", "Fungal infection", "Allergy", "GERD",
        "Chronic cholestasis", "Drug Reaction", "Peptic ulcer diseae", "AIDS",
        "Diabetes", "Gastroenteritis", "Hypertension", "Migraine",
        "Cervical spondylosis", "Paralysis (brain hemorrhage)", "Jaundice",
        "Malaria", "Chicken pox", "Dengue", "Typhoid", "hepatitis A",
        "Hepatitis B", "Hepatitis C", "Hepatitis D", "Hepatitis E",
        "Alcoholic hepatitis", "Tuberculosis", "Common Cold", "Pneumonia",
        "Dimorphic hemmorhoids(piles)", "Heart attack", "Varicose veins",
        "Hypothyroidism"
      )
    )
  )
)

# Function for getting disease predictions
get_disease_predictions <- function(Symptom_1, Symptom_2, Symptom_3, Symptom_4,
                                    Symptom_5, Symptom_6, Symptom_7, Symptom_8, Symptom_9,
                                    Symptom_10, Symptom_11, Symptom_12, Symptom_13, Symptom_14,
                                    Symptom_15, Symptom_16, Symptom_17) {
  
  # Create a data frame using the symptoms
  symptoms_data <- data.frame(
    Symptom_1 = as.factor(Symptom_1),
    Symptom_2 = as.factor(Symptom_2),
    Symptom_3 = as.factor(Symptom_3),
    Symptom_4 = as.factor(Symptom_4),
    Symptom_5 = as.factor(Symptom_5),
    Symptom_6 = as.factor(Symptom_6),
    Symptom_7 = as.factor(Symptom_7),
    Symptom_8 = as.factor(Symptom_8),
    Symptom_9 = as.factor(Symptom_9),
    Symptom_10 = as.factor(Symptom_10),
    Symptom_11 = as.factor(Symptom_11),
    Symptom_12 = as.factor(Symptom_12),
    Symptom_13 = as.factor(Symptom_13),
    Symptom_14 = as.factor(Symptom_14),
    Symptom_15 = as.factor(Symptom_15),
    Symptom_16 = as.factor(Symptom_16),
    Symptom_17 = as.factor(Symptom_17)
  )
  
  # Make a prediction based on the data frame
  predicted_disease <- predict(saved_Diseases_model_lda, symptoms_data)
  
  return(predicted_disease)
}

# Example usage of the function
result_positive <- get_disease_predictions(6, 148, 72, 35, 0, 33.6, 0.627, 50)
result_negative <- get_disease_predictions(1, 85, 66, 29, 0, 26.6, 0.351, 31)

# Display results
cat("Model's prediction for positive diabetes:", result_positive, "\n")
cat("Model's prediction for negative diabetes:", result_negative, "\n")
