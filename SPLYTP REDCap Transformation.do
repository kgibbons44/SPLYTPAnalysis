/**** SPLYTP REDCAP DATA TRANSFORMATION ****/
/**** Prepared by: Renate Le Marsney ****/
/**** Date initialised: 06/02/2020 ****/
/**** Purpose: Transformation of SPLYTP REDCap data****/

/** Transform the redcap data so it's all on one row **/
describe, fullnames
sort record_id redcap_event_name
save "OutputData\SPLYTP0.dta", replace
/// Keep event: screening_arm_1  - no repeat observations
use "OutputData\SPLYTP0.dta", clear
keep if ( redcap_event_name == "screening_arm_1" )
// Keep variables
keep record_id redcap_event_name redcap_repeat_instance scn_dt - withdrawal_of_consen_v_0
sort record_id
save "OutputData\scn0.dta", replace
/// Keep event: study crfs  - no repeat observations
use "OutputData\SPLYTP0.dta", clear
keep if ( redcap_event_name == "study_crfs_arm_1" )
// Keep variables
keep record_id redcap_event_name redcap_repeat_instance dem_gender - outcomes_complete
sort record_id
save "OutputData\crf0.dta", replace
/// Keep event: reporting_pds_arm_1  - repeat observations
use "OutputData\SPLYTP0.dta", clear
keep if ( redcap_event_name == "reporting_pds_arm_1" )
// Keep variables
keep record_id redcap_event_name redcap_repeat_instance pdf_yn - protocol_deviations__v_2
// Reshape the data
reshape wide pdf_yn - protocol_deviations__v_2, i(record_id) j(redcap_repeat_instance) 
sort record_id
save "OutputData\pd0.dta", replace
/// Keep event: reporting_aes_arm_1  - repeat observations -- add in this section when some aes have been entered (remove *)
use "OutputData\SPLYTP0.dta", clear
keep if ( redcap_event_name == "reporting_aes_arm_1" )
// Keep variables
keep record_id redcap_event_name redcap_repeat_instance ae_yn - adverse_events_manag_v_3
// Reshape the data
reshape wide ae_yn - adverse_events_manag_v_3, i(record_id) j(redcap_repeat_instance) 
sort record_id
save "OutputData\ae0.dta", replace
/// Merge all the files together
use "OutputData\scn0.dta", clear
merge 1:1 record_id using "OutputData\crf0.dta"
drop _merge
merge 1:1 record_id using "OutputData\pd0.dta"
drop _merge
merge 1:1 record_id using "OutputData\ae0.dta"
drop _merge
// Drop variables that are no longer in use
drop bl_boluses_total bl_boluses_type___0 bl_boluses_type___1 bl_boluses_type___2 bl_boluses_type___3 bl_boluses_type___4 bl_boluses_oth bl_cl_fluid_yn bl_cl_fluid_dt bl_cl_fluid
save "SPLYTP REDCap Data.dta", replace



 