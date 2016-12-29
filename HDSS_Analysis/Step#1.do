**1 clear all open records
clear


**2**Set memory if necessary
set memory 100m

**3**Create a working directory******************
cd "C:\HDSS_Data_Tutorial"

**4** Open the indivdual records 
use "Individuals.dta", clear 

**5*View the records
browse

***6**Count the number of records in Individuals
count

***7  Check for missing values
codebook Id

***8 Labelling the variables
label variable Id "Identifier"
label variable Gender "Sex"
label variable DoB "Date of Birth"
label variable DoD "Date of Death"
label variable Refugee "Nationality"

***9 Dropping the varibles that we are not going to use
drop MotherId MotherStatus FatherID FatherStatus

*******10a***Recoding***Gender*****************
codebook Gender
****F- Female ****M-Male

**** Convert Gender from text to number using encode & put converted values in XGender
encode Gender, generate(XGender)

set more off

codebook Gender
codebook XGender

recode XGender (2=1 "Male") (1=2 "Female"), generate(Sex)
codebook Sex

label variable Sex "Sex"



*******10b***Recoding***Refugee*****************
codebook Refugee

/* M-Post-92 Arrival   N-South African
   O-Other             Q-Query
   X-Unknown           Y-Pre-93 Refugee		*/
   
encode Refugee, gen(XRefugee)

codebook XRefugee

recode XRefugee (2=1 "South African") (1 5 =2 "Mozambican") (3=3 Other) (4=.) , generate(Nationality)

codebook Nationality

label variable Nationality "Nationality"

drop Gender XGender XRefugee Refugee

browse

browse, nolabel


***11 Saving the Individuals dataset to accommodate the changes
save "Individuals_Edit.dta", replace


***************** Residences Dataset ************************
use "Residences.dta", clear

browse

drop Residence Location

/****Checking the indentifiers for duplicate *****/
codebook Id


/****Checking the indentifiers for duplicate *****/
duplicates report Id

/*
Note:
1- One record per indivdual
2 - Two records per individual
4 - Four record per indivdual
****/


***Tagging the duplicates, quadruplicates records
***
duplicates tag Id, generate(DupTag)

tabulate DupTag

browse if  DupTag==1

sort Id

sort Id StartDate EndDate

browse if  DupTag==1


***** InitiatingEventType Processing
codebook InitiatingEventType

*A- Enumeration **B-Birth ***M-In-Migration

***Convert text to number
encode InitiatingEventType, generate(StEvent)
codebook StEvent

***recode StEvent & create a new variable StartEvent
recode StEvent (1=0 "ENU") (2=1 "BTH") (3=2 "IMG"), generate(StartEvent) 

label variable StartEvent "Start Event"
codebook StartEvent

***** TerminatingEventType Processing
codebook TerminatingEventType
**C-Current **D-Death  ***O-Out-Migration

encode TerminatingEventType, gen(EdEvent)
codebook EdEvent
recode EdEvent (3=3 "OMG") (2=4 "DTH") (1=5 "CUR"), gen(EndEvent) 

label variable EndEvent "End Event"

codebook EndEvent

drop InitiatingEventType TerminatingEventType StEvent EdEvent

save "Residences_Edit.dta", replace


/*****Merge the two datasets *******/
use "Individuals_Edit.dta", clear
list if Id == "BKNXW"

use "Residences_Edit.dta", clear
list if Id == "BKNXW"


***Merging Type 1
use "Individuals_Edit.dta", clear
merge 1:m Id using "Residences_Edit.dta"

/***Merging Type 2
use "Residences_Edit.dta", clear
merge m:1 Id using "Individuals_Edi2.dta"
*/  

help merge

set linesize 240

list if Id == "BKNXW"

br if Id == "BKNXW"

br if _merge ==2

drop  if _merge ==2

drop _merge

save "Indivduals_Residences.dta", replace




