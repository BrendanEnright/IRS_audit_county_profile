# Profiles of Counties with Higher Audit Rates from 2012 to 2016

This repository contains files related to a student project created in Spring of 2026 which investigates county-level patterns in IRS audit rates from 2012-2016 and their relationship to the observed demographic population, employment concentration in specific industries, and past voting records for those geographic regions. The project originated as an attempt to examine the connection between the Earned Income Tax Credit (EITC) disparities and racial/ethnic minorities (as identified by existing literature), but evolved into a broader analysis of how demographics, socio-economic factors, and political leanings may correspond to audit risk across counties within the United States. 

The repository includes data preparation workflows, statistical analysis, data visualizations, and hypothesis testing for the following research question.

## Research Question 

Comparing available data from IRS records, United States Census surveys, and voter records from 2012 to 2016, are counties with higher audit rates more likely to have:
* higher proportions of individuals identifying as Black, Hispanic, Asian American, Hawaiian-Pacific Islander, or Native American;
* employment concentration within specific industries; 
* lower median household income; and 
* demonstrated partisan voting patterns?

### Hypotheses
* H<sub>0</sub> (Null Hypothesis) - Counties with higher observed audit rates from 2012 to 2016 will not be associated with higher proportions of racial and ethnic minority residents, higher levels of employment in certain industries, lower median income household levels, and higher levels of support for a particular political party. 
* H<sub>1</sub> (Alternative Hypothesis) - Counties with higher observed audit rates from 2012 to 2016 will be associated with higher proportions of racial and ethnic minority residents, higher levels of employment in certain industries, lower median income household levels, and higher levels of support for a particular political party.

## Data Sources
To perform the analysis, data was retrieved from three sources:
1. United States Census Bureau Data - https://data.census.gov/
2. IRS Audit Data - compiled by Kim Bloomquist from IRS reports from 2012 to 2016 - https://www.taxnotes.com/special-reports/audits/regional-bias-irs-audit-selection/2019/03/01/2957w 
3. National Neighborhood Data Archive - dataset created by a research team from the University of Michigan Institute for Social Research - https://www.icpsr.umich.edu/web/ICPSR/studies/38528/versions/V6

### File Structure
The File structure of this repository is laid out below:
```
IRS_audit_county_profile/
│
├── IRS_Audit_County_Profile.Rproj
├── Data/
│   ├── Processed/
│   |   └── dataset_complete.csv
|   └── Raw/
│       ├── AuditRateData_2016.csv
│       └── VoterAndPartisanIndexData.sav
├── R_Scripts/
│   ├── 01_clean_data.R
│   ├── 02_analysis.R
│   └── 03_visualization.R
├── Result_documentation/
│   ├── 640-Final Producet - Enright.pdf
├── .gitignore
├── LICENSE
├── README.md 
```

## Data Replication Instructions
To replicate the data cleaning, analysis, and visualization workflow for this project, follow the steps below.

### 1. Data Cleaning

- Open the script `01_clean_data.r` located in the repository folder.
- Run the script in your R development environment.
- The script will:
  - restructure and clean the raw datasets,
  - prepare variables for analysis, and
  - save local copies of the cleaned datasets for later analysis.

### 2. Statistical Analysis

- Open the script `02_analysis.r` from the repository folder.
- Run the script to:
  - generate statistical models from the cleaned dataset,
  - perform stepwise regression testing, and
  - conduct ordinal linear regression analysis on the final dataset.

### 3. Data Visualization

- Open the script `03_visualization.r` in your development environment.
- Run the script to:
  - generate visualizations of a few key variables and model outputs,
  - produce figures for interpretation and review, and
  - summarize major trends identified in the analysis.

## Project Deliverables

To review a write-up of the project and review a list of sources, visit this link: 
