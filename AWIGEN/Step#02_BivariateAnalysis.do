/*********************************************************************
         This do file perform descriptive statstics on data
*********************************************************************/
clear
*change director cd
cd "D:\Afo_Agin2008-2020\AWIGEN\20_Analysis\01_Descriptive_Analysis"

use "03a_Agincourt_AWIGEN_Data_Recoded_Age40to60.dta", clear


***Creating a log file to store all the result and command
cap log close
log using "B_Association_Stats.log", replace

set more off

set linesize 250
sktest bmi 
/*

                    Skewness/Kurtosis tests for Normality
                                                          ------ joint ------
    Variable |        Obs  Pr(Skewness)  Pr(Kurtosis) adj chi2(2)   Prob>chi2
-------------+---------------------------------------------------------------
         bmi |      1,442     0.0000        0.0098           .         0.0000
*/

**#2a Age -spearman bmi age, stats(p)
sktest age 

spearman bmi age, stats(p)

spearman bmi age if Sex_Recode==1, stats(p)
spearman bmi age if Sex_Recode==2, stats(p)

***#2 bmi_group by ethnicity
sktest ethnicity 

kwallis bmi, by(ethnicity)

kwallis bmi if Sex_Recode==1, by(ethnicity)
kwallis bmi if Sex_Recode==2, by(ethnicity)

***#3 bmi_group by marital_status_recode
sktest marital_status_recode 

kwallis bmi, by(marital_status_recode)

kwallis bmi if Sex_Recode==1, by(marital_status_recode)
kwallis bmi if Sex_Recode==2, by(marital_status_recode)

***#4 Highest Level of Education
sktest highest_level_of_education 

kwallis bmi, by(highest_level_of_education)

kwallis bmi if Sex_Recode==1, by(highest_level_of_education)
kwallis bmi if Sex_Recode==2, by(highest_level_of_education)

***#5 Employment
sktest employment 

kwallis bmi, by(employment)

kwallis bmi if Sex_Recode==1, by(employment)
kwallis bmi if Sex_Recode==2, by(employment)


***#6 Rooms 
sktest amount_rooms 

spearman bmi amount_rooms, stats(p)

spearman bmi amount_rooms if Sex_Recode==1, stats(p)
spearman bmi amount_rooms if Sex_Recode==2, stats(p)

***#7 amount_bedrooms 
sktest amount_bedrooms 

spearman bmi amount_bedrooms, stats(p)

spearman bmi amount_bedrooms if Sex_Recode==1, stats(p)
spearman bmi amount_bedrooms if Sex_Recode==2, stats(p)

*################# B. Behavioural ##########################
***#1 Smoking_Status
sktest Smoking_Status 

kwallis bmi, by(Smoking_Status)

kwallis bmi if Sex_Recode==1, by(Smoking_Status)
kwallis bmi if Sex_Recode==2, by(Smoking_Status)

***#2 tab Alcohol_Use
sktest Alcohol_Use 

kwallis bmi, by(Alcohol_Use)

kwallis bmi if Sex_Recode==1, by(Alcohol_Use)
kwallis bmi if Sex_Recode==2, by(Alcohol_Use)

*################# C. Diet ##########################
***#1 slices_bread
sktest slices_bread 

spearman bmi slices_bread, stats(p)

spearman bmi slices_bread if Sex_Recode==1, stats(p)
spearman bmi slices_bread if Sex_Recode==2, stats(p)


***#2 fruit_servings
sktest fruit_servings 

spearman bmi fruit_servings, stats(p)

spearman bmi fruit_servings if Sex_Recode==1, stats(p)
spearman bmi fruit_servings if Sex_Recode==2, stats(p)

***#3 servings_veg
sktest servings_veg 

spearman bmi servings_veg, stats(p)

spearman bmi servings_veg if Sex_Recode==1, stats(p)
spearman bmi servings_veg if Sex_Recode==2, stats(p)

***#4 vendor_meals
sktest vendor_meals 

spearman bmi vendor_meals, stats(p)

spearman bmi vendor_meals if Sex_Recode==1, stats(p)
spearman bmi vendor_meals if Sex_Recode==2, stats(p)

***#5 sugardrinks
sktest sugardrinks 

spearman bmi sugardrinks, stats(p)

spearman bmi sugardrinks if Sex_Recode==1, stats(p)
spearman bmi sugardrinks if Sex_Recode==2, stats(p)

*################# C. Diet ##########################
***#1 Sitting (hours/day)
sktest sitting_hours 

spearman bmi sitting_hours, stats(p)

spearman bmi sitting_hours if Sex_Recode==1, stats(p)
spearman bmi sitting_hours if Sex_Recode==2, stats(p)


***#2 hours_sleep_week (hours/day)
sktest hours_sleep_week 

spearman bmi hours_sleep_week, stats(p)

spearman bmi hours_sleep_week if Sex_Recode==1, stats(p)
spearman bmi hours_sleep_week if Sex_Recode==2, stats(p)


*################# D. Clinical History ##########################
***#1 diabetes
sktest diabetes 

kwallis bmi, by(diabetes)

kwallis bmi if Sex_Recode==1, by(diabetes)
kwallis bmi if Sex_Recode==2, by(diabetes)


***#1 HIV_Status
sktest HIV_Status 

kwallis bmi, by(HIV_Status)

kwallis bmi if Sex_Recode==1, by(HIV_Status)
kwallis bmi if Sex_Recode==2, by(HIV_Status)


*################# E. ANTHROPOMETRICS ##########################
***#1 Height (mm)
sktest standing_height_mm 

spearman bmi standing_height_mm, stats(p)

spearman bmi standing_height_mm if Sex_Recode==1, stats(p)
spearman bmi standing_height_mm if Sex_Recode==2, stats(p)


***#2 weight (kg)
sktest hours_sleep_week 

spearman bmi hours_sleep_week, stats(p)

spearman bmi hours_sleep_week if Sex_Recode==1, stats(p)
spearman bmi hours_sleep_week if Sex_Recode==2, stats(p)

bysort Sex_Recode: oneway bmi_group weight_kg 

***#3 bmi
bysort Sex_Recode: summ bmi
bysort Sex_Recode: summ bmi, detail

summ bmi
summ bmi, detail

***#3 group
bysort Sex_Recode: tab bmi_group

tab bmi_group


cap log close



