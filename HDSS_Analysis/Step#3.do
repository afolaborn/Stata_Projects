********Converting dataset from wide to  long format

**Create a working directory******************
cd "C:\HDSS_Data_Tutorial"

use "Indivduals_Residences_Clean.dta", clear

list Id DoB StartEvent EndEvent StartDate EndDate if Id=="BKNXW"

***Create a dataset file with only the end  events   
**Start with the end event. Keep the relavant variables 
keep Id DoB DoD Sex Nationality EndEvent EndDate 

***Create a variable or column with 1 to indicate people coming from this file
generate file=1

list  Id DoB EndEvent EndDate file if Id=="BKNXW"

***Renaming the relavant variables
rename EndEvent EventCode
rename EndDate EventDate

**view the records
 list  Id DoB EventCode EventDate file if Id=="BKNXW"

**sort the values by Id and EventDate and save
sort Id EventDate
save "EndEvent_Dataset.dta", replace

***Create new file with only the start events
**Use the same clean dataser
use Indivduals_Residences_Clean.dta, clear

keep Id DoB DoD Sex Nationality StartEvent StartDate
gen file=2
rename StartEvent EventCode
rename StartDate EventDate

**Order the values by Id and EventDate and save
sort  Id EventDate 
save "StartEvent_Dataset.dta", replace

**list files 1
use EndEvent_Dataset.dta, clear 
list Id DoB EventCode EventDate file if Id=="BKNXW" & file==1


use StartEvent_Dataset.dta, clear 
list Id DoB EventCode EventDate file if Id=="BKNXW" & file==2

****Append the two files (Starting and ending events) to have EHA format
use "StartEvent_Dataset.dta", clear
count // 20,508
append using "EndEvent_Dataset.dta"
count // 41,016

**view records
list Id DoB EventCode EventDate file if Id=="BKNXW"

***Label the values of variable EventCode
label define eventlab 0 "ENU" 1 "BTH" 2 "IMG" 3 "OMG" 4 "DTH" 5 "CUR", modify
lab value EventCode eventlab

**remove  variable file
drop file

**Labelling the generated variables
lab variable EventDate "EventDate"

sort Id EventDate 

list Id DoB EventCode EventDate if Id=="BKNXW"


tabulate   EventCode

*/
save Short_to_Long_Dataset.dta, replace
