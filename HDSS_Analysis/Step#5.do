************  Event history nalysis  ***********

**Create a working directory******************
cd "C:\HDSS_Data_Tutorial"

use "EventHistory_Dataset.dta", clear

list Id DoB EventDate EventCode if  Id=="BKNXW"

sort Id EventDate 

***cond(_n==1, DoB, EventDate[_n-1]) 
**cond= condition 
**_n==1 - if it is the first record  ***DoB - Put DoB else put **EventDate[_n-1] the previous 

capture drop datebeg
by Id: generate double datebeg=cond(_n==1, DoB, EventDate[_n-1])


list Id DoB EventDate datebeg EventCode if  Id=="BKNXW"

***Format datebeg to appear in proper date formt
format datebeg %tc

list Id DoB EventDate datebeg EventCode if  Id=="BKNXW"

help cond

*0 = ENU 1 = BTH 2 = IMG 3 = OMG 4 = DTH 5 = CUR

**Tag outcome event of interest
generate Outcome_death = EventCode == 4 

tab Outcome_death

tab EventCode

display %20.0f 365.25 * 24 * 60 * 60 * 1000
*31557600000

help stset

***
capture drop datebeg
by Id: generate double datebeg=cond(_n==1, DoB, EventDate[_n-1])


set linesize 250
stset EventDate, id(Id) failure(Outcome_death==1) origin(time DoB) time0(datebeg) scale(31557600000)

count if datebeg>EventDate

count if datebeg==EventDate

**Tag the cases 
generate Tag1=1 if datebeg==EventDate

br Id DoB EventDate EventCode datebeg Tag1 if Tag1==1

list Id DoB EventDate EventCode datebeg Tag1 if Id == "BKJLR"

label variable  EventCode "Event"
tabulate EventCode Tag1
**Tag again to see full records per Id 

egen Tag2 = max(Tag1), by(Id)

br Id DoB EventDate EventCode datebeg Tag* if Tag2==1

***Resolution
replace EventDate=EventDate+(3*60*60*1000) if(datebeg==EventDate) 

list Id DoB EventDate EventCode datebeg Tag1 if Id == "BKJLR"

capture drop datebeg
by Id: generate double datebeg=cond(_n==1, DoB, EventDate[_n-1])

set linesize 250
stset EventDate, id(Id) failure(Outcome_death==1) origin(time DoB) time0(datebeg) scale(31557600000)


br  Id datebeg DoB  EventDate EventCode _st _d _origin _t0 _t 

count if datebeg==EventDate

sts graph, hazard

**Converting the date from long to short format
* 2"4jul2004 00:00:00" to "24jul2004"

gen double S_EventDate=EventDate
replace S_EventDate=dofc(S_EventDate)
format S_EventDate %td
