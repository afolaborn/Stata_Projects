/*********************************************************************
         This do file perform descriptive statstics on data
*********************************************************************/
clear
*change director cd
cd "D:\Afo_Agin2008-2020\AWIGEN\20_Analysis\01_Descriptive_Analysis"

/********Open and review the datasets for duplicates****/
use "01b_Agincourt_AWIGEN_Data_Stuart.dta", clear
duplicates report study_id

use "01d_Agincourt_AWIGEN_Status.dta", clear
duplicates report awi_number
keep awi_number hivfinalresult
rename awi_number study_id
rename hivfinalresult hiv_Status
compress
save "01d_Agincourt_AWIGEN_Status#2.dta", replace 

use "01a_Agincourt_AWIGEN_Data_Redcap.dta", clear
duplicates report awi_number
rename awi_number study_id

keep study_id employment alcohol_yesno alcohol_current_yesno  vendor_meals ///
smokelesstobacco_yesno amount_bedrooms amount_rooms

compress
save 01a_Agincourt_AWIGEN_Data_RedcapX.dta, replace 

/***************Merge the two datasets*****************/
use "01b_Agincourt_AWIGEN_Data_Stuart.dta", clear
merge 1:1 study_id using "01a_Agincourt_AWIGEN_Data_RedcapX.dta"

keep  study_id sex age ethnicity marital_status highest_level_of_education ///
employment household_size current_smoker tobacco_use smokeless_tobacco_use ///
snuff_use chewing_tobacco alcohol_yesno alcohol_current_yesno fruit_servings ///
servings_veg slices_bread sugardrinks sitting_hours hours_sleep_week  ///
number_of_pregnancies tb diabetes bmi standing_height_mm weight_kg vendor_meals ///
amount_bedrooms amount_rooms

save 01c_Agincourt_AWIGEN_Data_Merged.dta, replace 

/***************Merge with  the HIV status datasets*****************/
use "01c_Agincourt_AWIGEN_Data_Merged.dta", clear 
merge 1:1 study_id using "01d_Agincourt_AWIGEN_Status#2.dta"

drop if _merge==2

/**Keep command retains the variables of interest
keep study_id site_id site age sex ethnicity number_of_pregnancies /*
*/ marital_status highest_level_of_education household_size diabetes bmi_cat bmi weight_kg standing_height_mm
*/

save "Agincourt_Descriptive_Stats.dta", replace

use "Agincourt_Descriptive_Stats.dta", clear

***Creating a log file to store all the result and command
cap log close
log using "01_Summary_Stats.log", replace

set linesize 240
*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
*************************************************************************
***Labelling and Recoding the Variables (of interest) and their values
************************************************************************* 
*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


/******************************************************************************
**********************I**SOCIO-DEMOGRAPHIC VARIABLES **************************
*******************************************************************************/


**#########################################################################
**********[1] SEX
**#########################################################################

label variable sex "Gender"
label define SexLab 0 "Female" 1 "Male" 
label values sex SexLab
tab sex, miss

capture drop Sex_Recode
recode sex (1=1 "Male") (0=2 "Female"), gen(Sex_Recode)
label variable Sex_Recode "Sex2"
tab Sex_Recode

/* 
     Gender |      Freq.     Percent        Cum.
------------+-----------------------------------
     Female |      1,438       57.84       57.84
       Male |      1,048       42.16      100.00
------------+-----------------------------------
      Total |      2,486      100.00				*/


**#########################################################################
**********[2] AGE
**#########################################################################
label variable age "Age at data collection"
summarize age

/*  Variable |       Obs        Mean    Std. Dev.       Min        Max
-------------+--------------------------------------------------------
         age |      2486      58.679    10.98504         40         81    */	
  
	  
**Recoding or Grouping Age
capture drop AgeGroup
recode age (0/39=0 "<40") (40/60=1 "40-60") (61/100=2 ">60") , gen(AgeGroup)
label variable AgeGroup "Age Group"
tab AgeGroup

/*Age Group |      Freq.     Percent        Cum.
------------+-----------------------------------
      40-60 |      1,465       58.93       58.93
        >60 |      1,021       41.07      100.00
------------+-----------------------------------
      Total |      2,486      100.00					*/
  
		  
**#########################################################################
**********[3] ETHNICITY
**#########################################################################		 

label variable ethnicity "Ethnicity"
label define ethnicity_lab 1 "Zulu" 2 "Xhosa" 3 "Ndebele" 4 "Sotho" 5 "Venda" 6 "Tsonga" 7 "Tswana" 8 "BaPedi" 9 "Zimbabwean" 10 "Other" 11 "Unknown" 12 "Swati" 
label values ethnicity ethnicity_lab
tab ethnicity, missing
	  
**Recoding or Grouping ethnicity
capture drop ethnicity_recode
recode ethnicity (1=4 "Zulu") (2 3 5 7 9 10=13 "Other") (4=2 "Sotho") (6=1 "Tsonga") (8=5 "BaPedi")(12=3 "Swati") (11=.) , gen(ethnicity_recode)
label variable ethnicity_recode "Ethnicity_R"
tab ethnicity_recode sex, m


**#########################################################################
**********[4] marital_status
**#########################################################################	

label variable marital_status "Marital Status"
label define marital_status_labx 1 "Married" 2 "Living together" 3 "Never married or co-habited" 4 "Divorced" 5 "Separated" 6 "Widow" 
label values marital_status marital_status_labx
tab marital_status, missing

capture drop marital_status_recode
recode marital_status (1/2=0 "Married & Living together") (3=1 "Never married or co-habited") (4=2 "Divorced") (6=3 "Widow") , gen(marital_status_recode)
label variable marital_status_recode "Marital Status_R"
tab marital_status_recode, missing
				  
**#########################################################################
*********[5] highest_level_of_education
**#########################################################################	
label variable highest_level_of_education "Education"
label define highest_level_of_education_lab 0 "No formal education" 1 "Primary" 2 "Secondary" 3 "Tertiary" 
label values highest_level_of_education highest_level_of_education_lab
tab highest_level_of_education, miss

**#########################################################################
*********[6] employment  
**#########################################################################	
label variable employment "Employment"
label define employment_lab 0 "Self employed" 1 "Formal full-time employment by someone else" 2 "Part-time employment by someone else" 3 "Informal employment" 4 "Unemployed" 
label values employment employment_lab
tab employment, miss

								  *Proportion of missing
di (394/2486)*100
*15.85%

*Excluding those age >60 reduces the proportion to 3.26%
. tab employment if Age==1, m

*Proportion of missing
di (81/2486)*100
*3.26%

**#########################################################################
*********[7] household_size  --to work on this later 
**#########################################################################	
******household_size (value missing)
label variable household_size "household_size"

******bed (ommitted)
label variable household_size "8.1 How many people besides you are in your household?"

******amount_rooms (Not applicable)
label variable household_size "8.1 How many people besides you are in your household?"



/******************************************************************************
*************************II**BEHAVIOUR VARIABLES *******************************
*******************************************************************************/

**##########################################################################
***SMOKING
**[1a] current_smoker
**##########################################################################
*A current_smoker   --branch logic is not applicable           
label variable current_smoker "Current Smoker"
label define current_smoker_label 1 "Yes" 0 "No" 
label value current_smoker current_smoker_label

tab current_smoker, missing
	  
**##########################################################################
**[1b] tobacco_use
**##########################################################################
 *B tobacco_use   --branch logic is not applicable  
label variable tobacco_use "Ever Smoked"
label define tobacco_use_lab 1 "Yes" 0 "No" 
label values tobacco_use tobacco_use_lab
tab tobacco_use, miss

**##########################################################################
**[1c] Smoking_Status
**##########################################################################
*Smoking_Status
/**Merging the 2 [A] current_smoker & [B] tobacco_use variables 
 to create variable Smoking_Status with  the following categories
 *Never Smoked, Past Smoker, Current Smoker   */
 
tab tobacco_use current_smoker, miss

**Create the variable with blank values
cap drop Smoking_Status
gen Smoking_Status=.
***i. Never smoked category
replace Smoking_Status=0 if tobacco_use==0  
**ii. Past Smokers
replace Smoking_Status=1 if tobacco_use==1 & current_smoker==0  
**ii. Current Smokers
replace Smoking_Status=2 if tobacco_use==1 & current_smoker==1  

label variable Smoking_Status "Smoking Status"
label define Smoking_Status_label 0 "Never smoked" 1 "Past Smoker" 2 "Current Smoker"
label values Smoking_Status Smoking_Status_label
tab Smoking_Status, miss

***Two missing values.  it is ok to use the variable like this 


**#########################################################################
**[2] SNUFF USE  VARIABLES --branch logic IS  applicable 
**#########################################################################
/***For the respondent to answer this question varibale smokelesstobacco_yesno must be Yes
and most people at the site don't use smokelesstobacco_yes 
***/

tab smokeless_tobacco_use, miss

tab snuff_use , nolabel	  

tab snuff_use, miss

**############################################################################
**[3] CHEWING_TOBACCO_USE  VARIABLES --branch logic is  applicable
 **###########################################################################
/***For the respondent to answer this question varibale smokelesstobacco_yesno must be Yes
and most people at the site don't use smokelesstobacco_yes  **/

tab chewing_tobacco, m

**SUGGESTION
*It is safe for us to use Smoking_Status, it has 2 missing values.


**##########################################################################
**@@@@@@@@ALCOHOL USE
**[4a] alcohol_yesno  branch logic is NOT  applicable
 **#########################################################################
 *NB Stuart mistakenly oomitted this variable
label variable alcohol_yesno "Ever consumed alcohol"
label define alcohol_yesno_label 1 "Yes" 0 "No" 2 "Dont know" 3 "Refuse to answer" 
label values alcohol_yesno alcohol_yesno_label

tab alcohol_yesno, miss

**No missing 

**#########################################################################
**[4b] alcohol_current_yesno  branch logic is NOT  applicable
 **#########################################################################
label variable alcohol_current_yesno "Currently Consuming Alcohol" 
label define alcohol_current_yesno_label 1 "Yes" 0 "No" 2 "Dont know" 3 "Refuse to answer" 
label values alcohol_current_yesno alcohol_current_yesno_

tab alcohol_current_yesno, missing
 
 **#########################################################################
**[4c] Alcohol_Use  branch logic is NOT  applicable
 **#########################################################################
 /**Merging the 2 [A] alcohol_current_yesno & [B] alcohol_yesno variables 
 to create variable Alcohol_Use with  the following categories
Never consume, Past consumer and Current Consumer  */

tab alcohol_yesno alcohol_current_yesno, missing

**Start by  creating the variable with blank values   
cap drop Alcohol_Use
gen Alcohol_Use=.
***i. Never Consume category
replace Alcohol_Use=0 if alcohol_yesno==0  
**ii.  Past Consumer
replace Alcohol_Use=1 if alcohol_yesno==1 & alcohol_current_yesno==0  
**iii. Current Consumer
replace Alcohol_Use=2 if alcohol_yesno==1 & alcohol_current_yesno==1  

label variable Alcohol_Use "Alcohol Use" 
label define Alcohol_Use_lab 0 "Never Consume" 1 "Past Consumer" 2 "Current Consumer" 
label values Alcohol_Use Alcohol_Use_lab

tab Alcohol_Use, m 


/********************************************************************************
*************************III**DIET VARIABLES *******************************
*********************************************************************************/


 **#########################################################################
**[1] fruit_servings   branch logic is NOT  applicable
 **#########################################################################
label variable fruit_servings "Fruit_servings"

tab fruit_servings, missing
	  
*Proportion of missing	  
display (624/2486)*100
**25.1%

 **#########################################################################
**[2] servings_veg   branch logic is NOT  applicable
 **#########################################################################
label variable servings_veg "Serving vegies"
 
tab servings_veg, missing

*Proportion of missing	  
display (112/2486)*100
**4.5%

 **#########################################################################
**[3] slices_bread   branch logic is NOT  applicable
 **#########################################################################
label variable slices_bread "Slices Bread"
 
tab slices_bread, missing

*Proportion of missing	  
display (220/2486)*100
**8.8%

**#########################################################################
**[4] sugardrinks   branch logic is NOT  applicable
 **#########################################################################
label variable sugardrinks "Sugar in Drink?"
tab sugardrinks, miss

*Proportion of missing	  
display (624/2486)*100
**25.1%

* Age Restriciton
display (15/1465)*100

/********************************************************************************
*********************III**Physical Activity Variables*****************************
*********************************************************************************/

*#########################################################################
**[1] sitting_hours   This is a RedCap computed variable
*#########################################################################
label variable sitting_hours "Sitting Hours"
codebook sitting_hours

/**Proportion of missing
display (337/2486)*100
**13.56%


*Age restricition
codebook sitting_hours if Age==1
display (102/1465)*100
*6.96%


*#########################################################################
**[3] sleeping_hours   This is a RedCap computed variable
*#########################################################################
label variable hours_sleep_week "Hours Sleep"

tab hours_sleep_week, m

	  **Proportion of missing
display (60/2486)*100
**2.41

*Age restricition
display (21/1465)*100
*6.96%

*#########################################################################
**[4] hours_sleep_week   This is a RedCap computed variable
*#########################################################################
label variable hours_sleep_week "Hours Slept"
tab hours_sleep_week, m

	  	  **Proportion of missing
display (60/2486)*100
**2.41

*Age restricition
display (21/1465)*100
*6.96%

/********************************************************************************
*************************IV**Clinical History VARIABLES *******************************
*********************************************************************************/

*#########################################################################
**[1] number_of_pregnancies   
*#########################################################################
label variable number_of_pregnancies "No of Pregnancies"
tab number_of_pregnancies, m

display (1065/2486)*100
**2.41
**

*#########################################################################
**[2] TB   
*#########################################################################
label variable tb "Have TB?"
label define tb_lab 1 "Yes" 0 "No" 2 "Dont know" 
label values tb tb_lab
tab tb, miss

**Don't know is recoded as missing
replace tb=. if tb==2
tab tb, miss

**Proportion of missing
display (1/2486)*100
*0.04022

*#########################################################################
**[2] DIABETES   
*#########################################################################
label variable diabetes "Has Diabetes"
label define diabetes_lab 1 "Yes" 0 "No" 2 "Dont know"
label values diabetes diabetes_lab
tab diabetes, missing

*#########################################################################
**[3] BMI   
*#########################################################################

label variable bmi "Body Mass Index"
codebook bmi
							
**Proportion of missing
display (551/2486)*100
*22.16%

*Age restriciton 							
di (23/1465)*100
*1.57%

**Recoding or Grouping BMI
capture drop bmi_group
recode bmi (0/18.49999=0 "BMI<18.5") (18.5/24.99999=1 "BMI 18.5 to <25") (25/29.99999=2 "BMI 25 to <30") (30/100=3 ">30") , gen(bmi_group)
label variable bmi_group "BMI Group"
tab bmi_group, missing
  
*#########################################################################
**[4] HIV Status   
*#########################################################################
capture drop HIV_Status 
capture drop HIV 

encode hiv_Status, gen(HIV)
recode HIV (2=0 "No") (4=1 "Yes") (1 3=.), gen(HIV_Status)
label variable HIV_Status
tab hiv_Status HIV_Status
tab HIV_Status

drop HIV
*#########################################################################
**[5] standing_height_mm   
*########################################################################
label variable standing_height_mm "Height"
codebook standing_height_mm

display (542/2486)*100
*21.8%

*Age restriciton 							
di (15/1465)*100
*1.02%
*******standing_height_mm

*#########################################################################
**[4] weight_kg   
*#########################################################################
label variable weight_kg "Weight"
codebook weight_kg

display (550/2486)*100
*22.12%

*Age restriciton 							
di (22/1465)*100
*1.5%
*******standing_height_mm

order study_id bmi bmi age Age sex Sex ethnicity* marital_status* employment
save "02_Agincourt_AWIGEN_Data_Recoded.dta", replace 

