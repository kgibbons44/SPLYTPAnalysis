/**** SPLYT P MV DATA IMPORT AND LABELLING ****/
/**** Prepared by: Renate Le Marsney ****/
/**** Date initialised: 06/10/2020 ****/
/**** Purpose: Import and labelling of SPLYT P Metavision data****/

/** Import Metavision data for main data extract for SPLYT P and label values and variables **/

// Import Metavision data for main data extract for SPLYT P 
insheet using "SPLYT P MV Patient Data_18112020.csv", clear

// Format dates
foreach v of varlist scn_rand_dt bl_crea_dt icu_admit icu_disch hosp_admit hosp_disch na_base_time k_base_time ca_base_time crea_base_time chloride_base_time chloride_48_high_time {
	tostring `v', replace
	gen double _temp_ = Clock(`v',"DMYhm")
	drop `v'
	rename _temp_ `v'
	format `v' %tCMonth_dd,_CCYY_HH:MM
}
	
tostring dob, replace
gen _date_ = date(dob,"DMY")
drop dob
rename _date_ dob
format dob %dM_d,_CY
	
// Label variables
label variable record_id "REDCap record ID"
label variable scn_rand_dt "Randomisation date"
label variable dem_picu_num "ICU  number"
label variable bl_rand_fluid "Randomised fluid"
label variable bl_crea "Baseline serum creatinine"
label variable bl_crea_dt "Time creatinine at baseline recorded"
label variable patientid "Metavision patient ID"
label variable urn "Patient URN"
label variable dob "Patient DOB"
label variable icu_no "ICU  number"
label variable age_in_days "Age at ICU admission"
label variable adm_wt_kg "ICU admission weight"
label variable gender "Gender"
label variable ind_status "Indigenous status "
label variable icu_admit "ICU admission date and time"
label variable icu_disch "ICU discharge date and time"
label variable icuadmit_source "ICU admission source"
label variable outcome "Survival status at ICU discharge"
label variable hosp_admit "Hospital admision date and time"
label variable hosp_disch "Hospital discharge date and time"
label variable hospoutcome "Survival status at hospital discharge"
label variable elective "Admission to ICU following elective surgery, or a non-emergency direct admission"
label variable cc_cardio "Chronic Condition – Cardiovascular"
label variable cc_congen "Chronic Condition – Congential"
label variable cc_gastro "Chronic Condition – Gastrointestinal"
label variable cc_haem "Chronic Condition – Haemotologic or immunologic"
label variable cc_malig "Chronic Condition – Malignancy"
label variable cc_metabol "Chronic Condition – Metabolic"
label variable cc_neuro "Chronic Condition – Neurologic or Neuromuscular"
label variable cc_prem "Chronic Condition – Premature/neonatal"
label variable cc_renal "Chronic Condition – Renal or urologic"
label variable cc_resp "Chronic Condition – Respiratory"
label variable cc_transpl "Chronic Condition – Transplantation"
label variable cc_techdep "Chronic Condition – Technology dependency"
label variable cc_mentalh "Chronic Condition – Mental health"
label variable pim_3 "PIM 3 score"
label variable pdx "Priciple reason for admisison to ICU"
label variable udx "Underlying diagnosis code"
label variable gcs_t_adm "Total GCS score at admission"
label variable gcs_sedation_adm "Paralysed or sedated at the time of the total GCS score at admission"
label variable pupils_adm "Pupils fixed or dialated (>3mm) at admission"
label variable lactate_adm "Lactate at admision"
label variable lactate_a_adm "Arterial lactate at admission"
label variable lactate_oth_adm "Venous or capillary lactate at admission"
label variable map_a_adm "Arterial mean blood pressure at admission"
label variable map_niv_adm "non invasive mean blood pressure at admission"
label variable map_adm "Arterial mean blood pressure at admission"
label variable crea_adm "Creatinine at admission"
label variable pao2_adm "Arterial PaO2 at admission"
label variable fio2_bga_adm "FiO2 at time of admisison PaO2"
label variable paco2_adm "PaCO2 at admission"
label variable iv_adm "Invasive ventilation in first hour of admission"
label variable wcc_adm "White cell count at admission"
label variable platelets_adm "Platelet count at admisison"
label variable pelod_2_adm "PELOD 2 score at admission"
label variable niv_adm "Non-invasive ventilation in first hour of admission"
label variable vent_adm "Invasive or non-invasive ventilation in first hour of admission"
label variable inotrope_adm "Intopes in first hour of admisison "
label variable na_base "Sodium at baseline"
label variable na_base_time "Time sodium at baseline recorded"
label variable k_base "Potassium at baseline"
label variable k_base_time "Time potassium at baseline recorded"
label variable ca_base "Calcium at baseline"
label variable ca_base_type "Calcium type at baseline"
label variable ca_base_time "Time calcium at baseline recorded"
label variable crea_base "Creatinine at baseline"
label variable crea_base_time "Time creatinine at baseline recorded"
label variable chloride_base "Chloride at baseline"
label variable chloride_base_time "Time chloride at baseline recorded"
label variable chloride_48_high "Highest chloride in first 48 hours "
label variable chloride_48_high_time "Time of highest chloride in first 48 hours recorded"
label variable total_rand_fluid_48 "Total randomised fluid in first 48 hours"
label variable total_rand_fluid_bl_48 "Total randomised fluid as bolus in first 48 hours"
label variable total_rand_fluid_m_48 "Total randomised fluid as maintenance in first 48 hours"
label variable duration_rand_fluid_48 "Total duration of randomised fluid in first 48 hours"
label variable total_iv_fluid_48 "Total IV fluid in first 48 hours"
label variable total_iv_fluid_bl_48 "Total IV fluid as bolus in first 48 hours"
label variable total_iv_fluid_m_48 "Total IV fluid as maintenance in first 48 hours"
label variable total_iv_nacl_48 "Total NaCl in first 48 hours"
label variable total_iv_plasmalyte_48 "Total plasmalyte 148 in first 48 hours"
label variable total_iv_csl_48 "Total CSL in first 48 hours"
label variable total_iv_alb4_48 "Total albumin 4% in first 48 hours"
label variable duration_iv_fluid_48 "Total duration of IV fluid in first 48 hours"
label variable total_rand_fluid_24 "Total randomised fluid in first 24 hours"
label variable total_rand_fluid_bl_24 "Total randomised fluid as bolus in first 24 hours"
label variable total_rand_fluid_m_24 "Total randomised fluid as maintenance in first 24 hours"
label variable duration_rand_fluid_24 "Total duration of randomised fluid in first 24 hours"
label variable total_iv_fluid_24 "Total IV fluid in first 24 hours"
label variable total_iv_fluid_bl_24 "Total IV fluid as bolus in first 24 hours"
label variable total_iv_fluid_m_24 "Total IV fluid as maintenance in first 24 hours"
label variable total_iv_nacl_24 "Total NaCl in first 24 hours"
label variable total_iv_plasmalyte_24 "Total plasmalyte 148 in first 24 hours"
label variable total_iv_csl_24 "Total CSL in first 24 hours"
label variable total_iv_alb4_24 "Total albumin 4% in first 24 hours"
label variable duration_iv_fluid_24 "Total duration of IV fluid in first 24 hours"
label variable total_rand_fluid "Total randomised fluid between randomisation and ICU discharge"
label variable total_rand_fluid_bl "Total randomised fluid as bolus between randomisation and ICU discharge"
label variable total_rand_fluid_m "Total randomised fluid as maintenance between randomisation and ICU discharge"
label variable duration_rand_fluid "Total duration of randomised fluid between randomisation and ICU discharge"
label variable total_iv_fluid "Total IV fluid between randomisation and ICU discharge"
label variable total_iv_fluid_bl "Total IV fluid as bolus between randomisation and ICU discharge"
label variable total_iv_fluid_m "Total IV fluid as maintenance between randomisation and ICU discharge"
label variable total_iv_nacl "Total NaCl between randomisation and ICU discharge"
label variable total_iv_plasmalyte "Total plasmalyte 148 between randomisation and ICU discharge"
label variable total_iv_csl "Total CSL between randomisation and ICU discharge"
label variable total_iv_alb4 "Total albumin 4% between randomisation and ICU discharge"
label variable duration_iv_fluid "Total duration of IV fluid between randomisation and ICU discharge"
label variable total_iv_fluid_adm_rand "Total IV fluid between ICU admission and randomisation"
label variable total_iv_fluid_bl_adm_rand "Total IV fluid as bolus between ICU admission and randomisation"
label variable total_iv_fluid_m_adm_rand "Total IV fluid as maintenance between ICU admission and randomisation"
label variable total_iv_nacl_adm_rand "Total NaCl between ICU admission and randomisation"
label variable total_iv_plasmalyte_adm_rand "Total plasmalyte 148 between ICU admission and randomisation"
label variable total_iv_csl_adm_rand "Total CSL between ICU admission and randomisation"
label variable total_iv_alb4_adm_rand "Total albumin 4% between ICU admission and randomisation"
label variable duration_iv_fluid_adm_rand "Total duration of IV fluid between ICU admission and randomisation"
label variable total_bp_48 "Total blood product in first 48 hours"
label variable total_rbc_48 "Total red blood cells in first 48 hours"
label variable total_ffp_48 "Total fresh frozen plasma in first 48 hours"
label variable total_cryo_48 "Total cryoprecipitate in first 48 hours"
label variable total_platelets_48 "Total platelets in first 48 hours"
label variable crrt_7d "Commenced RRT in first 7 days from randomisation"
label variable max_cr_7d "Highest creatinine in first 7 days from randomisation"
label variable max_base_cr_increase_7d "Maximum increase from baseline creatinine value in first 7 days from randomisation"
label variable max_cr_increase_48_7d "Maximum increase in creatinine in 48 hour period in first 7 days from randomisation"
label variable kd_cr_aki_any_7d "Any AKI in first 7 days from randomisation"
label variable kd_cr_aki_stage_7d "Stage of AKI in first 7 days from randomisation"
label variable base_crea_p "Predicted baseline serum creatinine"
label variable max_base_cr_increase_7d_p "Maximum increase from baseline creatinine value in first 7 days from randomisation using predicted baseline values"
label variable max_cr_increase_48_7d_p "Maximum increase in creatinine in 48 hour period in first 7 days from randomisation using predicted baseline values"
label variable kd_cr_aki_any_7d_p "Any AKI in first 7 days from randomisation predicted baseline values"
label variable kd_cr_aki_stage_7d_p "Stage of AKI in first 7 days from randomisation using predicted baseline values"
label variable crrt_all "Commenced RRT in first 28 days from randomisation"
label variable max_cr_all "Highest creatinine in first 28 days from randomisation"
label variable max_cr_increase_48_all "Maximum increase in creatinine in 48 hour period in first 28 days from randomisation"
label variable kd_cr_aki_any_all "Any AKI in first 28 days from randomisation"
label variable kd_cr_aki_stage_all "Stage of AKI in first 28 days from randomisation"
label variable pd_iv_number "Number of IV fluid protocol deviations"
label variable bolus_number "Number of IV fluid protocol deviations given as bolus"
label variable maintenance_number "Number of IV fluid protocol deviations given as maintenance"

// Define value labels
label define bl_rand_fluid_ 1 "0.9% NaCl"  2 "Plamalyte 148" 3 "CSL Solution"
label define ind_status_ 0 "Not Indigenous" 1 "Indigenous"  9 "Unknown"
label define elective_ 0 "Not-elective admission"   1 "Elective admission"
label define cc_cardio_ 0 "No"  1 "Yes"
label define cc_congen_ 0 "No"  1 "Yes"
label define cc_gastro_ 0 "No"  1 "Yes"
label define cc_haem_ 0 "No"  1 "Yes"
label define cc_malig_ 0 "No"  1 "Yes"
label define cc_metabol_ 0 "No"  1 "Yes"
label define cc_neuro_ 0 "No"  1 "Yes"
label define cc_prem_ 0 "No"  1 "Yes"
label define cc_renal_ 0 "No"  1 "Yes"
label define cc_resp_ 0 "No"  1 "Yes"
label define cc_transpl_ 0 "No"  1 "Yes"
label define cc_techdep_ 0 "No"  1 "Yes"
label define cc_mentalh_ 0 "No"  1 "Yes"
label define gcs_sedation_adm_ 0 "No"  1 "Yes"
label define pupils_adm_ 0 "No"  1 "Yes"
label define iv_adm_ 0 "No"  1 "Yes"
label define niv_adm_ 0 "No"  1 "Yes"
label define vent_adm_ 0 "No"  1 "Yes"
label define inotrope_adm_ 0 "No"  1 "Yes"
label define ca_base_type_ 1 "Inonised" 2 "corrected"
label define crrt_7d_ 0 "No"  1 "Yes"
label define kd_cr_aki_any_7d_ 0 "No"  1 "Yes"
label define kd_cr_aki_stage_7d_  0 "None" 1 "Stage 1" 2 "Stage 2" 3 "Stage 3"
label define kd_cr_aki_any_7d_p_ 0 "No"  1 "Yes"
label define kd_cr_aki_stage_7d_p_  0 "None" 1 "Stage 1" 2 "Stage 2" 3 "Stage 3"
label define crrt_all_ 0 "No"  1 "Yes"
label define kd_cr_aki_any_all_ 0 "No"  1 "Yes"
label define kd_cr_aki_stage_all_ 0 "None" 1 "Stage 1" 2 "Stage 2" 3 "Stage 3"


// Label values
label values bl_rand_fluid bl_rand_fluid_
label values ind_status ind_status_
label values elective elective_
label values cc_cardio cc_cardio_
label values cc_congen cc_congen_
label values cc_gastro cc_gastro_
label values cc_haem cc_haem_
label values cc_malig cc_malig_
label values cc_metabol cc_metabol_
label values cc_neuro cc_neuro_
label values cc_prem cc_prem_
label values cc_renal cc_renal_
label values cc_resp cc_resp_
label values cc_transpl cc_transpl_
label values cc_techdep cc_techdep_
label values cc_mentalh cc_mentalh_
label values gcs_sedation_adm gcs_sedation_adm_
label values pupils_adm pupils_adm_
label values iv_adm iv_adm_
label values niv_adm niv_adm_
label values vent_adm vent_adm_
label values inotrope_adm inotrope_adm_
label values ca_base_type ca_base_type_
label values crrt_7d crrt_7d_
label values kd_cr_aki_any_7d kd_cr_aki_any_7d_
label values kd_cr_aki_stage_7d kd_cr_aki_stage_7d_
label values kd_cr_aki_any_7d_p kd_cr_aki_any_7d_p_
label values kd_cr_aki_stage_7d_p kd_cr_aki_stage_7d_p_
label values crrt_all crrt_all_
label values kd_cr_aki_any_all kd_cr_aki_any_all_
label values kd_cr_aki_stage_all kd_cr_aki_stage_all_

save "OutputData\SPLYT P MV Patient Data.dta", replace 

/** Import Metavision data for daily pelod values for SPLYT P and label values and variables **/

// Import Metavision data for main data extract for SPLYT P 
insheet using "SPLYT P MV PELOD Data_18112020.csv", clear

// Format dates
foreach v of varlist scn_rand_dt icu_admit icu_disch daystart dayend {
	tostring `v', replace
	gen double _temp_ = Clock(`v',"DMYhm")
	drop `v'
	rename _temp_ `v'
	format `v' %tCMonth_dd,_CCYY_HH:MM
	}
	
// Label variables
label variable record_id "REDCap record ID"
label variable patientid "Metavision patient ID"
label variable icu_no "ICU  number"
label variable scn_rand_dt "Randomisation date"
label variable admit_age_days "Age at ICU admission"
label variable icu_admit "ICU admission date and time"
label variable icu_disch "ICU discharge date and time"
label variable day_number "Day number from the start of randomisation to 28 days"
label variable daystart "Start date and time of each 24 hour interval from randomisation"
label variable dayend "End date and time of each 24 hour interval from randomisation"
label variable age_in_days "Age at the start of each 24 hour interval from randomisation"
label variable sbp_a_low "Lowest arterial systolic blood pressure count in 24 hour interval"
label variable sbp_niv_low "Lowest non invasive systolic blood pressure count in 24 hour interval"
label variable sbp_low "Lowest systolic blood pressure count in 24 hour interval"
label variable dbp_a_low "Lowest arterial diastolic blood pressure count in 24 hour interval"
label variable dbp_niv_low "Lowest non invasive diastolic blood pressure count in 24 hour interval"
label variable dbp_low "Lowest diastolic blood pressure count in 24 hour interval"
label variable map_a_low "Lowest arterial mean blood pressure count in 24 hour interval"
label variable map_niv_low "Lowest non invasive mean blood pressure count in 24 hour interval"
label variable map_low "Lowest mean blood pressure count in 24 hour interval"
label variable iv "Invasive ventilation in 24 hour interval"
label variable gcs_t_low "Lowest total GCS score in 24 hour interval"
label variable pupils "Pupils fixed or dialated (>3mm) in 24 hour interval"
label variable lactate_high "highest Lactate in 24 hour interval"
label variable lactate_a_high "Highest arterial lactate in 24 hour interval"
label variable lactate_oth_high "Highest venous or capillary lactate in 24 hour interval "
label variable crea_high "Highest creatinine in 24 hour interval"
label variable pao2_low "Lowest arterial PaO2 in 24 hour interval"
label variable fio2_high_bga "FiO2 at time of highest PaO2"
label variable paco2_high "Highest PaCO2 in 24 hour interval "
label variable wcc_low "Lowest white cell count in 24 hour interval"
label variable platelets_low "Lowest platelet count in 24 hour interval"
label variable pelod_2 "Lowest PELOD 2 score in 24 hour interval"

order record_id scn_rand_dt patientid icu_no admit_age_days icu_admit icu_disch daystart dayend

save "OutputData\SPLYT P MV PELOD Data.dta", replace 






