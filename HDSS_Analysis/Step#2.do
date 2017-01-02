**Create a working directory******************
cd "C:\HDSS_Data_Tutorial"

use "Indivduals_Residences.dta", clear

****** CONSISTENCY CHECK *******

**1****Check if StartDate=EndDate

count if(StartDate==EndDate)
* 48 cases

list Id StartDate EndDate StartEvent EndEvent DupTag if(StartDate==EndDate)

***Resolution
replace EndDate=EndDate+(6*60*60*1000) if(EndDate==StartDate) 

list Id StartDate EndDate StartEvent EndEvent DupTag if(StartDate==EndDate)


**2 Check if StartDate==EndDate[_n-1] (end date of the previous recod
sort Id StartDate EndDate
count if(StartDate==EndDate[_n-1]) & (Id==Id[_n-1])


set linesize 240
list Id StartDate EndDate StartEvent EndEvent DupTag if(StartDate==EndDate[_n-1]) & (Id==Id[_n-1])

list Id StartDate EndDate StartEvent EndEvent DupTag  if Id == "CTKXN"

help _n

capture drop Nth_Records
generate Nth_Records = _n
browse

list Id DoB Sex StartDate EndDate StartEvent EndEvent Nth_Records if Id == "CTKXN"

capture drop Nth_Records_byId
by Id: gen Nth_Records_byId = _n

list Id StartDate EndDate StartEvent EndEvent Nth_Records_byId if Id == "CTKXN"

* StartDate==EndDate[_n-1]
* Id==Id[_n-1])

***Resolution
replace StartDate=StartDate+(3*60*60*1000) if(StartDate==EndDate[_n-1]) & (Id==Id[_n-1])

list Id StartDate EndDate StartEvent EndEvent Nth_Records_byId if Id == "CTKXN"


****3 Check those who were enumerated before they were born
count if DoB>StartDate


list Id DoB StartDate EndDate StartEvent EndEvent DupTag if DoB>StartDate

drop if DoB>StartDate

save "Indivduals_Residences_Clean.dta", replace


