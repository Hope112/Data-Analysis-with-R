# Data-Analysis-with-R

A hands-on R workshop covering data analysis workflows.
UNCG PDS FEB 25 2026

---

## Repository Contents

| File | Description |
|------|-------------|
| `PDS_R_Data_Analysis_Session.R` | Main R script with annotated, step-by-step data analysis code |
| `employee_promotion.csv` | Dataset of employees and promotion outcomes used throughout the script |

---

## What the Script Covers

### 1. Environment Setup
- Installing and loading packages: `dplyr`, `readxl`, `haven`, `janitor`, `scales`, `ggplot2`

### 2. Importing Data
- Reading data from CSV, Excel (`.xlsx`), and SPSS (`.sav`) files

### 3. Exploring & Cleaning Data
- Checking dimensions, variable names, and data types (`glimpse`, `str`, `summary`)
- Detecting missing values and blank strings
- Cleaning variable names with `janitor::clean_names()`
- Replacing blank strings with `NA`
- Recoding binary variables into labeled factors
- Creating a performance category from numeric ratings

### 4. Frequency Tables
- One-way frequency tables with counts and percentages using `tabyl`
- Adding totals and formatting with `adorn_*` helpers

### 5. Cross-Tabulations
- Promotion rates broken down by department, education level, and gender
- Row percentages with counts in parentheses

### 6. Group Summaries
- `group_by` + `summarize` summaries by department, department × gender, and performance category
- Metrics include average training score, average rating, and promotion rate

### 7. Descriptive Statistics Table
- Department-level summary: N, mean/SD training score, average years of service, % promoted, % award won

### 8. Visualizations
- Bar chart: promotion outcomes by department (grouped, sorted)
- Box plot: training score distribution by promotion status
- Bar chart: distribution of previous-year performance ratings

### 9. Correlation Analysis
- Pearson correlation matrix for key numeric variables

### 10. Inferential Statistics
- **Chi-Square test** – association between gender and promotion
- **Independent-samples t-test** – training scores by promotion status
- **One-way ANOVA** – training scores across departments, with Tukey HSD post-hoc comparisons
- **Logistic regression** – predictors of promotion (training score, rating, awards, trainings, tenure)

### 11. AI-Assisted Coding with GitHub Copilot
- Overview of GitHub Copilot in RStudio
- Setup instructions (requires RStudio 2023.09+ and a GitHub account)
- Five practice prompts covering frequency tables, recoding, cross-tabs, summaries, and charts
- Best practices for using AI code assistance responsibly

---

## Dataset: `employee_promotion.csv`

The dataset contains HR records for employees and includes variables such as:

- `department` – employee's department
- `gender` – employee's gender
- `education` – highest education level
- `age` – employee age
- `length_of_service` – years with the company
- `no_of_trainings` – number of trainings completed in the year
- `avg_training_score` – average score across training courses
- `previous_year_rating` – performance rating from the prior year (1–5)
- `awards_won` – whether the employee won an award (0/1)
- `is_promoted` – promotion outcome (0 = not promoted, 1 = promoted)

---

## Getting Started

1. Install R and [RStudio](https://posit.co/download/rstudio-desktop/)
2. Install the required packages:
   ```r
   install.packages(c("dplyr", "readxl", "haven", "janitor", "scales", "ggplot2"))
   ```
3. Open `PDS_R_Data_Analysis_Session.R` in RStudio
4. Make sure `employee_promotion.csv` is in your working directory (or update the file path)
5. Run the script section by section

---

## Additional Resources

- [R for Data Science](https://r4ds.had.co.nz) – free online book
- [Coding in the Age of AI (YouTube playlist)](https://www.youtube.com/watch?v=dNvZsrOP5Y0&list=PLP9EKz-oSPSMxxO8KEnDGVE_xjHrKZWy4)
- [GitHub Education](https://education.github.com) – free GitHub Copilot access for students and teachers
