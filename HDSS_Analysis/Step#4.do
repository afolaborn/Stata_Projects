********Creating the data quality matrix

**Create a working directory******************
cd "C:\HDSS_Data_Tutorial"

list  Id DoB EventCode EventDate if Id=="BKNXW"

*Check for incostiencies
sort Id EventDate

count if(EventDate==EventDate[_n-1]) & (Id==Id[_n-1])


by Id: gen Prior_Event=EventCode[_n-1]

lab value Prior_Event eventlab

label variable Prior_Event "Previous event"

set linesize 250
tabulate Prior_Event EventCode, miss
	  
compress
save EventHistory_Dataset.dta, replace
