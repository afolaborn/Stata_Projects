/*********************************************************************
         This do file perform descriptive statstics on data
*********************************************************************/
clear
*change director cd
cd "D:\Afo_Agin2008-2020\AWIGEN\20_Analysis\01_Descriptive_Analysis"

use "02_Agincourt_AWIGEN_Data_Recoded.dta", clear


/**Keep command retains the variables of interest
keep study_id site_id site age Sex ethnicity number_of_pregnancies /*
*/ marital_status highest_level_of_education household_size diabetes bmi_cat bmi weight_kg standing_height_mm
*/

keep if AgeGroup==1
save "03a_Agincourt_AWIGEN_Data_Recoded_Age40to60.dta", replace

use "03a_Agincourt_AWIGEN_Data_Recoded_Age40to60.dta", clear


***Creating a log file to store all the result and command
cap log close
log using "A_Summary_Stats.log", replace

set more off
******************************************************************
*************Frequency Distribution******Age 40-60****************
******************************************************************
*################# A. SOCIO-DEMOGRAPHIC ##########################
***#1a Sex 
tab Sex

/*
       Sex2 |      Freq.     Percent        Cum.
------------+-----------------------------------
       Male |        573       39.11       39.11
     Female |        892       60.89      100.00
------------+-----------------------------------
      Total |      1,465      100.00			*/

bysort Sex_Recode: summarize age if AgeGroup==1, detail

***#2a Age 
summarize age,detail

**Checking whether age is normallly distributed
histogram age, normal
**Testing for normality of age distribution
*age is not normally distributed

/*                Skewness/Kurtosis tests for Normality
                                                          ------ joint ------
    Variable |        Obs  Pr(Skewness)  Pr(Kurtosis) adj chi2(2)   Prob>chi2
-------------+---------------------------------------------------------------
         age |      1,465     0.0208        0.0000           .         0.0000
*/

*kwallis Sex, by(age)

***#2b Age by Sex
bysort Sex_Recode: summarize age
bysort Sex_Recode: summarize age, detail

set linesize 250

***#3 Ethnicty by Sex
**Frequency only
tab ethnicity_recode
bysort Sex_Recode: tab ethnicity_recode

tab ethnicity_recode Sex_Recode, chi2

***#4 marital_status_recode by Sex
tab marital_status_recode

bysort Sex_Recode: tab marital_status_recode

tab ethnicity_recode marital_status_recode, chi2

***#5 Highest Level of Education
tab highest_level_of_education 
bysort Sex_Recode:  tab highest_level_of_education

tab highest_level_of_education Sex_Recode, chi2

***#6 Rooms 
tab employment
bysort Sex_Recode: tab employment

tab employment Sex_Recode, chi2

***#7 amount_rooms 
bysort Sex_Recode: summ amount_rooms
bysort Sex_Recode: summ amount_rooms, detail

summ amount_rooms
summ amount_rooms, detail

kwallis amount_rooms, by(Sex_Recode)

***#7 amount_bedrooms 
bysort Sex_Recode: summ amount_bedrooms
bysort Sex_Recode: summ amount_bedrooms, detail

summ amount_bedrooms
summ amount_bedrooms, detail

kwallis amount_bedrooms, by(Sex_Recode)
*################# B. Behavioural ##########################
***#1 Smoking_Status
tab Smoking_Status
bysort Sex_Recode: tab Smoking_Status

tab Smoking_Status Sex_Recode, chi2

***#2 tab Alcohol_Use
tab Alcohol_Use
bysort Sex_Recode: tab Alcohol_Use

tab Alcohol_Use Sex_Recode, chi2

*################# C. Diet ##########################
***#1 slices_bread
sum slices_bread
sum slices_bread, detail
bysort Sex_Recode: sum slices_bread
bysort Sex_Recode: sum slices_bread, detail

kwallis slices_bread, by(Sex_Recode)

***#2 fruit_servings
bysort Sex_Recode: sum fruit_servings
bysort Sex_Recode: sum fruit_servings, detail

sum fruit_servings
sum fruit_servings, detail

kwallis fruit_servings, by(Sex_Recode)

***#3 servings_veg
bysort Sex_Recode: sum servings_veg
bysort Sex_Recode: sum servings_veg, detail

sum servings_veg
sum servings_veg, detail

kwallis servings_veg, by(Sex_Recode)
***#4 vendor_meals
bysort Sex_Recode: sum vendor_meals
bysort Sex_Recode: sum vendor_meals, detail

sum vendor_meals
sum vendor_meals, detail

kwallis vendor_meals, by(Sex_Recode)
***#3 sugardrinks
bysort Sex_Recode: sum sugardrinks
bysort Sex_Recode: sum sugardrinks, detail

sum sugardrinks
sum sugardrinks, detail

kwallis sugardrinks, by(Sex_Recode)
*################# C. Diet ##########################
***#1 Sitting (hours/day)
bysort Sex_Recode: sum sitting_hours
bysort Sex_Recode: sum sitting_hours, detail

sum sitting_hours
sum sitting_hours, detail

kwallis sitting_hours, by(Sex_Recode)
***#2 Sitting (hours/day)
bysort Sex_Recode: sum hours_sleep_week
bysort Sex_Recode: sum hours_sleep_week, detail

sum hours_sleep_week
sum hours_sleep_week, detail

kwallis hours_sleep_week, by(Sex_Recode)
*################# D. Clinical History ##########################
***#1 diabetes
bysort Sex_Recode: tab diabetes

tab diabetes

tab diabetes Sex_Recode, chi2

***#2 HIV Status
bysort Sex_Recode: tab HIV_Status

tab HIV_Status

tab HIV_Status Sex_Recode, chi2

*################# E. ANTHROPOMETRICS ##########################
***#1 Height (mm)
bysort Sex_Recode: summ standing_height_mm
bysort Sex_Recode: summ standing_height_mm, detail

summ standing_height_mm
summ standing_height_mm, detail

kwallis standing_height_mm, by(Sex_Recode)

***#2 weight (kg)
bysort Sex_Recode: summ weight_kg
bysort Sex_Recode: summ weight_kg, detail

summ weight_kg
summ weight_kg, detail

kwallis weight_kg, by(Sex_Recode)
***#3 bmi
bysort Sex_Recode: summ bmi
bysort Sex_Recode: summ bmi, detail

summ bmi
summ bmi, detail

kwallis bmi, by(Sex_Recode)
***#3 group
bysort Sex_Recode: tab bmi_group

tab bmi_group

tab bmi_group Sex_Recode, chi2


cap log close


