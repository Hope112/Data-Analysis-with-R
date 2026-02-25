#------------------------------
# Setting Up Your Environment
#------------------------------

#Ways to install packages:
# install.packages("dplyr")
# install.packages(c("readxl", "haven", "janitor", "scales", "ggplot2", "psych"))

# Load packages
library(dplyr)    # Data manipulation
library(readxl)   # Import Excel files
library(haven)    # Import SPSS files
library(janitor)  # Frequency tables and data cleaning
library(scales)   # Formatting percentages

#-------------------
# Importing Data
#-------------------

#Data can be imported from the file tab in RStudio, or you can use code like this:

# From CSV
# df <- read.csv("data_file.csv")
# From Excel
# df <- read_excel("data_file.xlsx")
# From SPSS
# df <- read_sav("data_file.sav")

df <- read.csv("employee_promotion.csv")

# Sample
head(df)

#--------------------------------
# Exploring and cleaning the data
#--------------------------------

# eyeball the data
# How many rows (employees) and columns (variables)?
nrow(df)
ncol(df)
dim(df)

# Variable names and types
glimpse(df)
str(df)

# Summary statistics for all variables
summary(df)

# Check for missing data
colSums(is.na(df))

# Check for blank strings
colSums(df == "", na.rm = TRUE)


# --------------------
# 1.4 Cleaning Data
# --------------------

# Clean up variable names (lowercase, underscores, no special characters)
df <- df %>%
  clean_names()

names(df)

# Replace blank strings with NA in the education column
df <- df %>%
  mutate(education = na_if(education, ""))

# Verify the fix
colSums(is.na(df))
?is.na

# Recode binary variables
df <- df %>%
  mutate(
    is_promoted_label = factor(is_promoted, 
                               levels = c(0, 1), 
                               labels = c("Not Promoted", "Promoted")),
    awards_won_label  = factor(awards_won, 
                               levels = c(0, 1), 
                               labels = c("No Award", "Award Won"))
  )

# Create a performance category from previous_year_rating
df <- df %>%
  mutate(
    performance_cat = case_when(
      previous_year_rating <= 2 ~ "Low",
      previous_year_rating == 3 ~ "Average",
      previous_year_rating >= 4 ~ "High"
    ),
    performance_cat = factor(performance_cat, 
                             levels = c("Low", "Average", "High"))
  )

# Check the recoded variables
df %>%
  select(is_promoted, is_promoted_label, previous_year_rating, performance_cat) %>%
  head(10)


# ------------------------
# Frequency Tables 
# ------------------------

# Frequency table with counts and percentages
df %>%
  tabyl(department)

# Table with percentages and totals
df %>%
  tabyl(department) %>%
  adorn_pct_formatting(digits = 2) %>%
  adorn_totals("row")

# Frequency table for a recoded variable
df %>%
  tabyl(education) %>%
  adorn_pct_formatting(digits = 1)

# Promotion rate as a frequency table
df %>%
  tabyl(is_promoted_label) %>%
  adorn_pct_formatting(digits = 1)


# -------------------------
# Cross-Tabulations
# -------------------------

# Promotion rate by department
df %>%
  tabyl(department, is_promoted_label) %>%
  adorn_percentages("row") %>%
  adorn_pct_formatting(digits = 1) %>%
  adorn_ns()

# Promotion rate by education level
df %>%
  filter(!is.na(education)) %>%
  tabyl(education, is_promoted_label) %>%
  adorn_percentages("row") %>%
  adorn_pct_formatting(digits = 1) %>%
  adorn_ns()

# Promotion by gender
df %>%
  tabyl(gender, is_promoted_label) %>%
  adorn_percentages("row") %>%
  adorn_pct_formatting(digits = 1) %>%
  adorn_ns()


# ------------------
# Group Summaries
# ------------------

# Mean training score and promotion rate by department
df %>%
  group_by(department) %>%
  summarize(
    n = n(),
    avg_training_score = round(mean(avg_training_score, na.rm = TRUE), 1),
    avg_rating = round(mean(previous_year_rating, na.rm = TRUE), 2),
    pct_promoted = scales::percent(mean(is_promoted), accuracy = 0.1),
    .groups = "drop"
  )

# Summary by department AND gender
df %>%
  group_by(department, gender) %>%
  summarize(
    n = n(),
    avg_training_score = round(mean(avg_training_score, na.rm = TRUE), 1),
    pct_promoted = scales::percent(mean(is_promoted), accuracy = 0.1),
    .groups = "drop"
  )

# Summary by performance category
df %>%
  filter(!is.na(performance_cat)) %>%
  group_by(performance_cat) %>%
  summarize(
    n = n(),
    avg_training_score = round(mean(avg_training_score, na.rm = TRUE), 1),
    pct_promoted = scales::percent(mean(is_promoted), accuracy = 0.1),
    pct_award = scales::percent(mean(awards_won), accuracy = 0.1),
    .groups = "drop"
  )


# ----------------
# Summary Table
# ----------------

# Descriptive statistics table
df %>%
  group_by(department) %>%
  summarize(
    N = n(),
    `Avg Training Score` = round(mean(avg_training_score, na.rm = TRUE), 1),
    `SD Training Score`  = round(sd(avg_training_score, na.rm = TRUE), 1),
    `Avg Years of Service` = round(mean(length_of_service, na.rm = TRUE), 1),
    `% Promoted` = scales::percent(mean(is_promoted), accuracy = 0.1),
    `% Award Won` = scales::percent(mean(awards_won), accuracy = 0.1),
    .groups = "drop"
  )


# ------------------
# Visualizations
# ------------------

library(ggplot2)

# Bar chart: Promotion count by department
df %>%
  count(department, is_promoted_label) %>%
  ggplot(aes(x = reorder(department, -n), y = n, fill = is_promoted_label)) +
  geom_col(position = "dodge") +
  labs(
    title = "Promotion Outcomes by Department",
    x = "", y = "Count", fill = ""
  ) +
  scale_fill_manual(values = c("Not Promoted" = "brown", "Promoted" = "blue")) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Distribution of training scores by promotion status
ggplot(df, aes(x = is_promoted_label, y = avg_training_score, fill = is_promoted_label)) +
  geom_boxplot() +
  labs(
    title = "Training Scores by Promotion Status",
    x = "", y = "Average Training Score"
  ) +
  scale_fill_manual(values = c("Not Promoted" = "brown", "Promoted" = "blue")) +
  theme_minimal() +
  theme(legend.position = "none")

# Distribution of previous year ratings
df %>%
  filter(!is.na(previous_year_rating)) %>%
  count(previous_year_rating) %>%
  ggplot(aes(x = factor(previous_year_rating), y = n)) +
  geom_col(fill = "steelblue") +
  geom_text(aes(label = n), vjust = -0.5) +
  labs(
    title = "Distribution of Previous Year Ratings",
    x = "Rating", y = "Number of Employees"
  ) +
 
  theme_minimal()


# -------------------
# Correlation Check
# -------------------

# Correlation between numeric variables of interest
numeric_vars <- df %>%
  select(no_of_trainings, age, previous_year_rating, 
         length_of_service, avg_training_score, is_promoted) %>%
  filter(complete.cases(.))

round(cor(numeric_vars), 2)

# ------------------------
# Inferential Statistics
# ------------------------

# Chi-Square Test
# Is there a significant association between gender and promotion?
chisq_gender <- chisq.test(table(df$gender, df$is_promoted))
chisq_gender

# Independent Samples t-Test
# Do promoted vs. not promoted employees differ in training scores?
t_test_training <- t.test(avg_training_score ~ is_promoted, data = df)
t_test_training

# One-Way ANOVA
# Does average training score differ across departments?
anova_dept <- aov(avg_training_score ~ department, data = df)
summary(anova_dept)

# Post-hoc pairwise comparisons (if ANOVA is significant)
TukeyHSD(anova_dept)

# Logistic Regression
# What predicts promotion? 
logit_model <- glm(is_promoted ~ avg_training_score + previous_year_rating + 
                     awards_won + no_of_trainings + length_of_service,
                   data = df, family = binomial, na.action = na.exclude)

summary(logit_model)

# =======================================
# AI-Assisted Coding with GitHub Copilot
# =======================================

# ------------------------
# What is GitHub Copilot?
# ------------------------
#   - Autocomplete code as you type
#   - Generate code from comments describing what you want
#   - For simple questions, you can use a comment with # q: followed by your question

# Setting Up:
#   1. You need RStudio 2023.09+ and a GitHub account
#   2. Students and teachers get free access to pro: https://education.github.com
#   3. Tools > Global Options > Copilot > Enable
#   4. Sign in with GitHub
#   5. Start typing and the suggestions appear as gray text
#   6. Press Tab to accept, Esc to dismiss


# ---------------------
# Try These Prompts
# ---------------------

# Example 1: Frequency Table
# Create a frequency table of education with counts and percentages,
# excluding missing values, formatted for a report


# Example 2: Recode a Variable
# Create a new variable called age_group that categorizes age into:
# "Under 30", "30-39", "40-49", "50+"


# Example 3: Cross-Tabulation
# Create a cross-tabulation of is_promoted by gender
# Show row percentages with counts in parentheses


# Example 4: Summary Table
# For each department, calculate the number of employees, mean age,
# mean training score, and the percentage promoted. Round to 1 decimal.


# Example 5: Visualization
# Create a bar chart showing the promotion rate (%) by department,
# sorted from highest to lowest


# ---------------------------------
# Best Practices for Using Copilot
# ----------------------------------

# DO:
#   - Write specific comments about what you need
#   - Review and run the output to make sure it's correct
#   - Use it to learn syntax 

# DON'T:
#   - Accept code without checking it
#   - Assume Copilot knows your variable names
#   - Skip understanding what the code does
#   - Trust complex calculations blindly


# ======================
# Additional Resources
# ======================
# 
# For Data Analysis in R:
# - R for Data Science (free online book): https://r4ds.had.co.nz
# - Coding in the age of AI: https://www.youtube.com/watch?v=dNvZsrOP5Y0&list=PLP9EKz-oSPSMxxO8KEnDGVE_xjHrKZWy4

# For GitHub Copilot:
# - GitHub Education (free for students): https://education.github.com
