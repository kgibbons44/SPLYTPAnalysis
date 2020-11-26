/**** SPLYTP MV DATA TRANSFORMATION ****/
/**** Prepared by: Renate Le Marsney ****/
/**** Date initialised: 06/10/2020 ****/
/**** Purpose: Transformation of SPLYTP MV data****/

/** Transform the MV data so it's all on one row **/
/// patient data - no repeat observations
use "OutputData\SPLYT P MV Patient Data.dta", clear
describe, fullnames
sort record_id 
save "OutputData\patient0.dta", replace
/// daily pelod data - repeat observations
use "OutputData\SPLYT P MV PELOD Data.dta", clear
// Keep variables
keep record_id  daystart- pelod_2
sort record_id
save "OutputData\pelod0.dta", replace
// Reshape the data
reshape wide daystart dayend age_in_days -  pelod_2, i(record_id) j(day_number) 
sort record_id
save "OutputData\pelod0.dta", replace
/// Merge all the files together
use "OutputData\patient0.dta", clear
merge 1:1 record_id using "OutputData\pelod0.dta"
drop _merge
save "SPLYTP MV Data.dta", replace



	
	




