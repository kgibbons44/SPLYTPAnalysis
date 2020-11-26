/**** SPLYTP DATA Merge ****/
/**** Prepared by: Renate Le Marsney ****/
/**** Date initialised: 06/10/2020 ****/
/**** Purpose: Merge of SPLYTP REDCap and MV data****/

/** Merge REDCap and MV data so it's all on one row **/
/// REDCap data  - no repeat observations
use "SPLYTP REDCap Data.dta", clear
describe, fullnames
sort record_id 
save "OutputData\redcap0.dta", replace
/// MV data - no repeat observations
use "SPLYTP MV Data.dta", clear
describe, fullnames
sort record_id 
// Keep variables that are not in the REDCap data file
keep record_id   patientid -  pelod_228
sort record_id
save "OutputData\mv0.dta", replace
/// Merge all the files together
use "OutputData\redcap0.dta", clear
merge 1:1 record_id using "OutputData\mv0.dta"
drop _merge
save "SPLYTP Data.dta", replace