/**** SPLYTP Outcomes ****/
/**** Prepared by: Renate Le Marsney ****/
/**** Date initialised: 06/10/2020 ****/
/**** Purpose: Generation of SPLYTP Outcomes****/


/** Consort Diagram - includes checks of for inconsistencies **/

// Eligibility
label define scn_pt_eligibility_calc_ 1 "Eligible" 0 "Ineligible"
label values scn_pt_eligibility_calc scn_pt_eligibility_calc

// Reason for implentation/ finalisation of consent 
* Based on category for no implentation/ finalisation of consent
gen ex_social_issue=1 if scn_non_consent_reason___5==1 | scn_non_consent_reason___6==1 | scn_non_consent_reason___7==1
label variable ex_social_issue "Experiencing social issues"

gen ex_medical_decision=1 if scn_non_consent_reason___18==1 | scn_non_consent_reason___19==1
label variable ex_medical_decision "Due to Medical or investigator direction"

gen ex_no_fluid=1 if scn_non_consent_reason___20==1 
label variable ex_no_fluid "Due to Study treatment no longer required"

gen ex_parent_issue=1 if scn_non_consent_reason___9==1 | scn_non_consent_reason___10==1 | scn_non_consent_reason___11==1 | scn_non_consent_reason___13==1 
label variable ex_parent_issue "Due to Parental distress/lack of understanding"

gen ex_palliative=1 if scn_non_consent_reason___8==1
label variable ex_palliative "Experiencing social issues"

gen ex_missed_resourcing=1 if scn_non_consent_reason___21==1 | scn_non_consent_reason___22==1
label variable ex_missed_resourcing "Missed due to resourcing"

gen ex_missed_covid=1 if scn_non_consent_reason___25==1 | scn_non_consent_reason___26==1
label variable ex_missed_covid "Missed due to covid 19"

gen ex_missed_not_considered=1 if scn_non_consent_reason___27==1
label variable ex_missed_not_considered "Missed due inclusion/randomisation not considered"

gen ex_missed_unknown=1 if scn_non_consent_reason___3==1
label variable ex_missed_unknown "Missed due to reasons unknown"

gen ex_other=1 if scn_non_consent_reason___4==1 | scn_non_consent_reason___12==1 | scn_non_consent_reason___16==1 | scn_non_consent_reason___17==1
label variable ex_other "For other reasons"

* Based on text for other reason for no implentation/ finalisation of consent (needs to be revised based on additional other text)
* Check text reasons for no implentation/ finalisation of consent where other reason is checked for eligible patients
br record_id scn_non_consent_other if scn_pt_eligibility_calc==1 & scn_non_consent_reason___24==1 

replace ex_missed_resourcing=1 if scn_non_consent_other=="Run in phase of study" | ///
scn_non_consent_other=="No intensivist on shift as holiday roster? Missed, no reason given. " | ///
scn_non_consent_other=="Run in phase of study" | ///
scn_non_consent_other=="Bedside nurse 'tried to enroll online' but could not(?). When queried morning after night shift, nurse wasn't aware that we can enroll manually. " | ///
scn_non_consent_other=="Run  in  phase of study.  Missed after hours" | ///
scn_non_consent_other=="Run in phase of study. After hours admission" | ///
scn_non_consent_other=="Run in phase of study.  After hours admission" | ///
scn_non_consent_other=="Missed at admission, when followed up at 7am (started fluids at 3am) - being bottle fed and about to stop fluids. " | ///
scn_non_consent_other=="Presumed that staff forgot / patient also on RESPOND (metabolic arm) study in PICU - if staff were confused by double-enrollment?" | ///
scn_non_consent_other=="Form started (presumably overnight) by clinical staff, ticked 'over 4 hours' making patient inelligible for randomisation. Potentially misunderstood form?"

replace ex_medical_decision=1 if scn_non_consent_other=="Run in phase. decision made not to include pts who have been on the unit for >24hrs. Awaiting ethics ammendment" | ///
scn_non_consent_other=="Metabolic patient" | ///
scn_non_consent_other=="Treating dr advised pt on feeds shortly following admission therefore not included" | ///
scn_non_consent_other=="Sai said considered & excluded as on fluids >4hrs at different hospital, but this is not an exclusion critiera" | ///
scn_non_consent_other=="Excluded post randomisation for cerebral oedema.  Patient progressing to brain death. D/W Sai, not appropriate to approach for consent"

replace ex_other=1 if scn_non_consent_other=="Reg thought that included participants was only maintenance fluids not bolus's. Sai followed up to clarify with them. " | ///
scn_non_consent_other=="Refusal last time (for all research)" | ///
scn_non_consent_other=="Patient did not meet inclusion criteria post enrolment.  Inc criteria changed in error to reflect this. Patient then became ineligible so consent not pursued. " | ///
scn_non_consent_other=="Patient met exclusion criteria post enrolment. Exclusion criteria changed in error to reflect this. Patient then became ineligible so consent not pursued." | ///
scn_non_consent_other=="Wrong Patient details entered in error. This patient met exclusion criteria so was never eligible therefore consent never attempted"

// Re randomised with 28 days of previous randomidation (this is a post-randomisation exclusion)

* First randomisation date 
by scn_hosp_id (scn_rand_dt), sort: gen double first_rand_dt = scn_rand_dt[1] if scn_rand_dt~=.
format first_rand_dt %tCMonth_dd,_CCYY_HH:MM

* Days from first randomisation to subsequent randomisations
gen first_rand_days = (scn_rand_dt - first_rand_dt)/(1000*60*60*24) if first_rand_dt~=scn_rand_dt
tab first_rand_days

* Randomised within 28 days of first randomisation 
gen first_rand_28=0
replace first_rand_28=1 if first_rand_days<=28
label variable first_rand_28 "re randomisation within 28 days of first randomisation"
label define first_rand_28_ 1 "Yes" 0 "No"
label values first_rand_28 first_rand_28_
tab first_rand_28, m

* Days between randomisations outside 28 days from first randomisation
sort scn_hosp_id scn_rand_dt
gen re_rand_days=(scn_rand_dt[_n]-scn_rand_dt[_n-1])/(1000*60*60*24) if scn_hosp_id[_n]==scn_hosp_id[_n-1] & first_rand_28==0
tab re_rand_days

* Re randomisated within 28 days of first or subsequent randomisations
gen re_rand_28=0
replace re_rand_28=1 if re_rand_days<=28 | first_rand_28==1
label variable re_rand_28 "re randomisation within 28 days of first or subsequent"
label define re_rand_28_ 1 "Yes" 0 "No"
label values re_rand_28 re_rand_28_
tab re_rand_28, m

br scn_hosp_id scn_rand_dt scn_pt_status_calc first_rand_dt first_rand_days first_rand_28 re_rand_days re_rand_28

// Randomisation allocation  
generate rand_allocation=1 if scn_rand_manual_alloc==1 | scn_rand_elec_alloc==1
replace rand_allocation=2 if scn_rand_manual_alloc==2| scn_rand_elec_alloc==2
replace rand_allocation=3 if scn_rand_manual_alloc==3 | scn_rand_elec_alloc==3
label variable rand_allocation "Randomisation allocation"
label define rand_allocation_ 1 "0.9% Sodium Chloride (NaCl) Solution" 2 "Plasma-Lyte 148" 3 "Compound Sodium Lactate (CSL) Solution"
label values rand_allocation rand_allocation_

tab rand_allocation scn_rand_elec_alloc, m
tab rand_allocation scn_rand_manual_alloc, m

// Patient Status after screening, randomisation and consent
label define scn_pt_status_calc_ 0 "Sreened only" 1 "Not for inclusion in study" 2 "Randomised and consented"
label values scn_pt_status_calc scn_pt_status_calc_

// Checks to run for Consort Diagram
* Check for patients with undertermined eligibility
list  record_id if scn_pt_eligibility_calc==.
* Check for patients that were enrolled but did not meet inclusion criteria
list  record_id if(scn_inc_cri_01==0 | scn_inc_cri_02==0 | scn_inc_cri_03==0 | scn_inc_cri_04==0) &  scn_pt_status_calc==2 // 8994-1110 did not meet all inclusion criteria but was enrolled - include them in did not meet inclusion criteria also?
* Check for patients that were enrolled but met at least one exclusion criteria
list  record_id if (scn_exc_cri_01==1 | scn_exc_cri_02==1 |  scn_exc_cri_03==1 |  scn_exc_cri_04==1 |  scn_exc_cri_05==1 |  scn_exc_cri_06==1 |  scn_exc_cri_07==1 |  scn_exc_cri_08==1 |  scn_exc_cri_09==1 |  scn_exc_cri_10==1 | scn_exc_cri_11==1) & scn_pt_status_calc==2 
* Check for patients not approached for consent provided informed consent
list record_id if scn_consent_type==0 & scn_consent_yn==1
* Check for patients recorded as did not proceed to randomisation but were randomised
list record_id if scn_rand_yn==0 & (scn_rand_elec_alloc!=. |  scn_rand_manual_alloc!=.) //  8994-1136 should be recorded as proceeded to randomisation, 8994-391 randomised by mistake.
* Check for patients with prospective consent but did not meet eligibilty
list  record_id if scn_consent_type==1 &  scn_pt_eligibility_calc==0
* Check for patients with consent to continue but did not meet eligibilty
list  record_id if scn_consent_type==2 &  scn_pt_eligibility_calc==0 // 8994-1110 did not meet all inclusion criteria but was enrolled - include them in eligible for consent to continue?, 8994-877 did not complete randomisation - details should be removed
* Check for patients with consent to continue but did not proceed with randomisation
list  record_id  if scn_consent_type==2 & scn_rand_yn==0 // 8994-1136 should be recorded as proceeded to randomisation, 8994-378 has comment to say they were randomised but details not recorded under randomisation
* Check for ineligble patients that were randomised
list record_id if scn_rand_yn==1 & scn_pt_eligibility_calc!=1 // 8994-1110 did not meet all inclusion criteria but was enrolled, 8994-877 did not complete randomisation, 8994-699 did not complete randomisation - details should be removed
* Check for randomised patients with no randomisation allocation
list record_id if scn_rand_yn==1 & scn_rand_manual_alloc==. & scn_rand_elec_alloc==. // 8994-298 randomised but details not recorded , 8994-877 did not complete randomisation, 8994-699 did not complete randomisation - details should be removed
* Check for randomised patients with no consent to continue or prospective consent that was not declined
list record_id if scn_rand_yn==1 & (scn_consent_type==0 | (scn_consent_type==1 & scn_consent_yn==0)) // 8994-699 did not complete randomisation - details should be removed
* Check for patients randomised but informed consent not finalised
list record_id if scn_rand_yn==1 & scn_consent_type==2 & scn_consent_yn==. // 8994-122 consent cont completed, 8994-39 verbal consent, 8994-82 verbal consent, 8994-877 did not complete randomisation or consent
* Check for patients randomised but informed consent not finalised
list record_id if scn_rand_yn==1 & scn_consent_yn==. // 894-699 did not complete randomisation or informed consent


/** Table 1: Baseline Characterisitics **/

// Age at randomisation in years
gen scn_rand_age_yr=scn_rand_age/12
label variable scn_rand_age_yr "Age at randomisation in years"

// Presenting diagnosis
gen present_diag = 1 if elective==1 & pdx>=1500 & pdx<=1599
replace present_diag = 2 if elective==1 & ((pdx>=1400 & pdx<=1411) | (pdx>=1600 & pdx<=1623) | (pdx>=1700 & pdx<=1706))
replace present_diag = 3 if elective==1 & ((pdx>=1100 & pdx<=1109) | (pdx>=1300 & pdx<=1311) | (pdx>=1800 & pdx<=1802) | (pdx>=1900 & pdx<=1999))
replace present_diag = 4 if elective==1 & present_diag==. & pdx!=.
replace present_diag = 5 if elective==0 & (pdx==256 | pdx==302| pdx==327| pdx==407| pdx==409| pdx==462| pdx==506| pdx==603| pdx==606| ///
pdx==614| pdx==813| pdx==822| pdx==829| pdx==832| pdx==837| pdx==846| pdx==860 | (udx >=700 & udx<=799))
replace present_diag = 6 if elective==0 & ((pdx>=400 & pdx<=406) | pdx==408 | (pdx>=410 & pdx<=461) | (pdx>=463 & pdx<=499)) 
replace present_diag = 7 if elective==0 & (pdx==821 | pdx==823 | pdx==824 | pdx==834 | pdx==835 | pdx==838 | pdx==821 | pdx==306)
replace present_diag = 8 if elective==0 & ((pdx>=300 & pdx<=305) | (pdx>=307 & pdx<=399))
replace present_diag = 9 if elective==0 & (pdx>=100 & pdx<=127)
replace present_diag = 10 if elective==0 & present_diag==. & pdx!=.
label variable present_diag "Presenting diagnosis"
label define present_diag_ 1 "Post-ENT Surgery" 2 "Post-general surgery " 3 "Post-other surgery" 4 "Other elective" 5 "Sepsis" 6 "Respiratory infection" 7 "Oncology" 8 "Neurological disorder" 9 "Trauma" 10 "Other non elective"
label values present_diag present_diag_

tab present_diag elective, m 

// Comorbidities
gen comorbidity = 1 if cc_cardio==1 |  cc_congen==1 | cc_gastro==1 | cc_haem==1 | cc_malig==1 | cc_metabol==1 | cc_neuro==1 | cc_prem==1 | cc_renal==1 | cc_resp==1 | cc_transpl==1 | cc_techdep== 1 | cc_mentalh==1
replace comorbidity = 0 if cc_cardio==0 &  cc_congen==0 & cc_gastro==0 & cc_haem==0 & cc_malig==0 & cc_metabol==0 & cc_neuro==0 & cc_prem==0 & cc_renal==0 & cc_resp==0 & cc_transpl==0 & cc_techdep== 0 ///
& (cc_mentalh!=1 | cc_mentalh==.) //mental health recent addition
label variable comorbidity "Comorbidity"
label define comorbidity_ 1 "Yes" 0 "No"
label values comorbidity comorbidity_

tab comorbidity,m

// Admission source //checked 'home' and 'radiology' with Sai - categorise as other
gen admit_source = 1 if icuadmit_source == "Emergency"
replace admit_source = 2 if icuadmit_source == "Operating Theatre" | icuadmit_source == "PACU/Recovery"
replace admit_source = 3 if icuadmit_source == "10A Medical IPU" | icuadmit_source == "10B CardioOncologyLiverTx IPU" | icuadmit_source == "11A NeuroSciences Ortho IPU" | icuadmit_source == "11B Oncology IPU" | icuadmit_source == "5D Surgical IPU" | icuadmit_source == "9A Medical IPU" | icuadmit_source == "9B Babies" | icuadmit_source == "10A Medical IPU" 
replace admit_source = 4 if icuadmit_source == "Mater Children's Private Hospital" | icuadmit_source == "Other Hospital - DEM"  | icuadmit_source == "Other Hospital - ICU/NICU"  | icuadmit_source == "Other Hospital - OT/Recovery"  | icuadmit_source == "Other Hospital - Ward"
replace admit_source = 5 if icuadmit_source =="Home" | icuadmit_source == "Radiology" 
label variable admit_source "Admission source"
label define admit_source_ 1 "ED" 2 "Theatre/Recovery" 3 "Ward" 4 "Retrieval from other hospital" 5 "Other"
label values admit_source admit_source_

tab icuadmit_source admit_source , m 

// Corrected baseline calcium - conversion of ionised calcium to corrected calcium: ionised x 2 = corrected calcium
gen bl_ca_corr= bl_ca if  bl_ca_type==2
replace bl_ca_corr =  bl_ca *2 if  bl_ca_type==1
label variable bl_ca_corr "Corrected Calcium"


/** Table 2: Description of fluid use in randomised patients **/

// Prepare ID variable for analysis
sort scn_hosp_id
gen id=_n
replace id=id[_n-1] if scn_hosp_id==scn_hosp_id[_n-1]

// Volume of fluids pre randomisation. MV volumes admission to randomisation combined with REDCap volumes pre admission

* NaCl pre randomisation
egen total_iv_nacl_pre_rand = rowtotal(total_iv_nacl_adm_rand  bl_ns_maintenance  bl_ns_bolus)
replace total_iv_nacl_pre_rand=. if total_iv_nacl_pre_rand==0
* CSL pre randomisation
egen total_iv_csl_pre_rand = rowtotal(total_iv_csl_adm_rand  bl_csl_maintenance   bl_csl_bolus)
replace total_iv_csl_pre_rand=. if total_iv_csl_pre_rand==0
* plasmlyte 148 pre randomisation
egen total_iv_plasmalyte_pre_rand = rowtotal(total_iv_plasmalyte_adm_rand bl_plasmalyte_maintenance bl_plasmalyte_bolus)
replace total_iv_plasmalyte_pre_rand=. if total_iv_plasmalyte_pre_rand==0
* Albumin 4% pre randomisation
egen total_iv_alb4_pre_rand = rowtotal(total_iv_alb4_adm_rand  bl_alb4_maintenance  bl_alb4_bolus)
replace total_iv_alb4_pre_rand=. if total_iv_alb4_pre_rand==0
* Albumin 20% (maintenance and bolus) volume pre randomisation recorded in REDCap (recorded as text under bl_iv_fluid_oth)
gen bl_alb20_maintenance = bl_oth_maintenance if bl_iv_fluid_oth =="20% Albumin "
gen bl_alb20_bolus =  bl_oth_bolus if bl_iv_fluid_oth =="20% Albumin "
* Albumin 20% pre randomisation
egen total_iv_alb20_pre_rand = rowtotal(total_iv_alb20_adm_rand  bl_alb20_maintenance  bl_alb20_bolus)
replace total_iv_alb20_pre_rand=. if total_iv_alb20_pre_rand==0
* IV fluid pre randomisation
egen total_iv_fluid_pre_rand = rowtotal(total_iv_nacl_pre_rand total_iv_csl_pre_rand total_iv_plasmalyte_pre_rand total_iv_alb4_pre_rand total_iv_alb20_pre_rand)  
replace total_iv_fluid_pre_rand=. if total_iv_fluid_pre_rand==0
* IV fluid pre randomisation as bolus
egen total_iv_fluid_bl_pre_rand = rowtotal(total_iv_fluid_bl_adm_rand  bl_ns_bolus bl_csl_bolus bl_plasmalyte_bolus bl_alb4_bolus bl_alb20_bolus)  
replace total_iv_fluid_bl_pre_rand=. if total_iv_fluid_bl_pre_rand==0
* IV fluid pre randomisation as maintenance
egen total_iv_fluid_m_pre_rand = rowtotal(total_iv_fluid_m_adm_rand  bl_ns_maintenance bl_csl_maintenance bl_plasmalyte_maintenance bl_alb4_maintenance bl_alb20_maintenance)  
replace total_iv_fluid_m_pre_rand=. if total_iv_fluid_m_pre_rand==0

label variable total_iv_nacl_pre_rand "Total NaCl pre randomisation"
label variable total_iv_plasmalyte_pre_rand "Total plasmalyte 148 pre randomisation"
label variable total_iv_csl_pre_rand "Total CSL pre randomisation"
label variable total_iv_alb4_pre_rand "Total albumin 4% pre randomisation"
label variable total_iv_alb20_pre_rand "Total albumin 20% pre randomisation"
label variable total_iv_fluid_pre_rand "Total IV fluid pre randomisation"
label variable total_iv_fluid_bl_pre_rand "Total bolus IV fluid pre randomisation"
label variable total_iv_fluid_m_pre_rand "Total maintenance IV fluid pre randomisation"

// fluids and blood products per kg, randomisation to discharge
foreach v in rand_fluid_48 rand_fluid_bl_48 rand_fluid_m_48 iv_fluid_48 iv_fluid_bl_48 iv_fluid_m_48 iv_nacl_48 iv_plasmalyte_48 iv_csl_48 iv_alb4_48 iv_alb20_48 rand_fluid_24 rand_fluid_bl_24 rand_fluid_m_24 iv_fluid_24 iv_fluid_bl_24 iv_fluid_m_24 iv_nacl_24 iv_plasmalyte_24 iv_csl_24 iv_alb4_24 iv_alb20_24 rand_fluid rand_fluid_bl rand_fluid_m iv_fluid iv_fluid_bl iv_fluid_m iv_nacl iv_plasmalyte iv_csl iv_alb4 iv_alb20 iv_nacl_pre_rand iv_plasmalyte_pre_rand iv_csl_pre_rand iv_alb4_pre_rand iv_alb20_pre_rand iv_fluid_pre_rand iv_fluid_m_pre_rand iv_fluid_bl_pre_rand bp_48 rbc_48 ffp_48 cryo_48 platelets_48 {
* Volume/kg of fluid 
gen total_`v'_kg = total_`v'/adm_wt_kg
}

label variable total_rand_fluid_48_kg "Total randomised fluid in first 48 hours per kg per kg"
label variable total_rand_fluid_bl_48_kg "Total randomised fluid as bolus in first 48 hours per kg"
label variable total_rand_fluid_m_48_kg "Total randomised fluid as maintenance in first 48 hours per kg"
label variable total_iv_fluid_48_kg "Total IV fluid in first 48 hours per kg"
label variable total_iv_fluid_bl_48_kg "Total IV fluid as bolus in first 48 hours per kg"
label variable total_iv_fluid_m_48_kg "Total IV fluid as maintenance in first 48 hours per kg"
label variable total_iv_nacl_48_kg "Total NaCl in first 48 hours per kg"
label variable total_iv_plasmalyte_48_kg "Total plasmalyte 148 in first 48 hours per kg"
label variable total_iv_csl_48_kg "Total CSL in first 48 hours per kg"
label variable total_iv_alb4_48_kg "Total albumin 4% in first 48 hours per kg"
label variable total_iv_alb20_48_kg "Total albumin 20% in first 48 hours per kg"
label variable total_rand_fluid_24_kg "Total randomised fluid in first 24 hours per kg"
label variable total_rand_fluid_bl_24_kg "Total randomised fluid as bolus in first 24 hours per kg"
label variable total_rand_fluid_m_24_kg "Total randomised fluid as maintenance in first 24 hours per kg"
label variable total_iv_fluid_24_kg "Total IV fluid in first 24 hours per kg"
label variable total_iv_fluid_bl_24_kg "Total IV fluid as bolus in first 24 hours per kg"
label variable total_iv_fluid_m_24_kg "Total IV fluid as maintenance in first 24 hours per kg"
label variable total_iv_nacl_24_kg "Total NaCl in first 24 hours per kg"
label variable total_iv_plasmalyte_24_kg "Total plasmalyte 148 in first 24 hours per kg"
label variable total_iv_csl_24_kg "Total CSL in first 24 hours per kg"
label variable total_iv_alb4_24_kg "Total albumin 4% in first 24 hours per kg"
label variable total_iv_alb20_24_kg "Total albumin 20% in first 24 hours per kg"
label variable total_rand_fluid_kg "Total randomised fluid between randomisation and ICU discharge per kg"
label variable total_rand_fluid_bl_kg "Total randomised fluid as bolus between randomisation and ICU discharge per kg"
label variable total_rand_fluid_m_kg "Total randomised fluid as maintenance between randomisation and ICU discharge per kg"
label variable total_iv_fluid_kg "Total IV fluid between randomisation and ICU discharge per kg"
label variable total_iv_fluid_bl_kg "Total IV fluid as bolus between randomisation and ICU discharge per kg"
label variable total_iv_fluid_m_kg "Total IV fluid as maintenance between randomisation and ICU discharge per kg"
label variable total_iv_nacl_kg "Total NaCl between randomisation and ICU discharge per kg"
label variable total_iv_plasmalyte_kg "Total plasmalyte 148 between randomisation and ICU discharge per kg"
label variable total_iv_csl_kg "Total CSL between randomisation and ICU discharge per kg"
label variable total_iv_alb4_kg "Total albumin 4% between randomisation and ICU discharge per kg"
label variable total_iv_alb20_kg "Total albumin 20% between randomisation and ICU discharge per kg"
label variable total_iv_nacl_pre_rand_kg "Total NaCl pre randomisation per kg"
label variable total_iv_plasmalyte_pre_rand_kg "Total plasmalyte 148 pre randomisation per kg"
label variable total_iv_csl_pre_rand_kg "Total CSL pre randomisation per kg"
label variable total_iv_alb4_pre_rand_kg "Total albumin 4% pre randomisation per kg"
label variable total_iv_alb20_pre_rand_kg "Total albumin 20% pre randomisation per kg"
label variable total_iv_fluid_pre_rand_kg "Total IV fluid pre randomisation per kg"
label variable total_iv_fluid_bl_pre_rand_kg "Total IV fluid as bolus pre randomisation per kg"
label variable total_iv_fluid_m_pre_rand_kg "Total IV fluid as maintenance pre randomisation per kg"
label variable total_bp_48_kg "Total blood product in first 48 hours per kg"
label variable total_rbc_48_kg "Total red blood cells in first 48 hours per kg"
label variable total_ffp_48_kg "Total fresh frozen plasma in first 48 hours per kg"
label variable total_cryo_48_kg "Total cryoprecipitate in first 48 hours per kg"
label variable total_platelets_48_kg "Total platelets in first 48 hours per kg"

/** Table 3, Table 4: Outcomes **/

// Primary outcome: >=5mmol increase in chloride in first 48 hours from randomisation

* Baseline chloride available
gen bl_cl_yn=0
replace bl_cl_yn=1 if bl_cl~=. & bl_cl<44444
label variable bl_cl_yn "Baseline chloride available"

* Chloride value in first 48 hours available
gen chloride_48_high_yn=0
replace chloride_48_high_yn=1 if chloride_48_high~=. 
label variable chloride_48_high_yn "Chloride value in first 48 hours available"

* >=5mmol increase in chloride by 48 hours from randomisation - ITT analysis
gen cl_gt5_increase_itt=1 if chloride_48_high-bl_cl>=5 & chloride_48_high_yn==1 & bl_cl_yn==1
replace cl_gt5_increase_itt=0 if (chloride_48_high-bl_cl<5 & chloride_48_high_yn==1 & bl_cl_yn==1) | (chloride_48_high_yn==0 & bl_cl_yn==1)
label variable cl_gt5_increase_itt "Increase of >=5mmol from base cl to max cl using ITT principle"

* >=5mmol increase in chloride by 48 hours from randomisation where both base and max chloride values are available and recieved allocated fluid in first 48 hours - per protocol analysis
gen cl_gt5_increase_pp=1 if chloride_48_high-bl_cl>=5 & chloride_48_high_yn==1 & bl_cl_yn==1 & total_rand_fluid_48~=.
replace cl_gt5_increase_pp=0 if chloride_48_high-bl_cl<5 & chloride_48_high_yn==1 & bl_cl_yn==1 & total_rand_fluid_48~=.
label variable cl_gt5_increase_pp "Increase of >=5mmol from base cl to max cl using per protocol principle"

label define cl_ 1 "Yes" 0 "No"
label values bl_cl_yn chloride_48_high_yn cl_gt5_increase_itt cl_gt5_increase_pp cl_

tab cl_gt5_increase_itt, m
tab cl_gt5_increase_pp, m

// Subgroups

* age at randomisation
gen age_cat=1 if scn_rand_age<=6 & ~missing(scn_rand_age)
replace age_cat=2 if scn_rand_age>6 & scn_rand_age<=60
replace age_cat=3 if scn_rand_age>60 & ~missing(scn_rand_age)
label define age_cat 1 "<=6m" 2 ">6-<=60m" 3 ">60m"
label values age_cat age_cat
tab age_cat, m

* IVFT>24 hours
gen ivft_dur_24hr=1 if duration_iv_fluid>24 & ~missing(duration_iv_fluid)
replace ivft_dur_24hr=0 if duration_iv_fluid<=24 & ~missing(duration_iv_fluid)
label define ivft_dur_24hr_ 0 "<=24" 1 ">24" 
label values ivft_dur_24hr ivft_dur_24hr_
tab ivft_dur_24hr, m

* IVFT>50ml/kg in first 48 hours from randomisation
gen ivft_total_50=1 if total_iv_fluid_48_kg>50 & ~missing(total_iv_fluid_48_kg)
replace ivft_total_50=0 if total_iv_fluid_48_kg<=50 & ~missing(total_iv_fluid_48_kg)
label define ivft_total_50_ 0 "<=50" 1 ">50" 
label values ivft_total_50 ivft_total_50_
tab ivft_total_50, m

// Secondary outcomes: 

// Survival free of organ dysfuntion
gen surv_free_od= 0
foreach var of varlist pelod_21 pelod_22 pelod_23 pelod_24 pelod_25 pelod_26 pelod_27 pelod_28 pelod_29 pelod_210 pelod_211 pelod_212 pelod_213 pelod_214 pelod_215 pelod_216 pelod_217 pelod_218 pelod_219 pelod_220 pelod_221 pelod_222 pelod_223 pelod_224 pelod_225 pelod_226 pelod_227 pelod_228 {
	replace surv_free_od = surv_free_od + (`var'==0 | `var'==.)
}
replace surv_free_od=0 if out_hosp_dc_status==0

// New onset AKI
* AKI on admission if predicted baseline creatinine > 1.5 x measured baseline creatinine
gen aki_adm = 1 if bl_crea/base_crea_p >1.5 & bl_crea~=. & base_crea_p~=.
label variable aki_adm "AKI on admission"
label define aki_adm_ 1 "Yes" 
label values aki_adm aki_adm_
tab aki_adm, m

* New onset AKI using predicted baseline values where baseline value not measured, where AKI not present on admission (those with AKI on admission are excluded)
gen new_onset_aki_p = 0 if kd_cr_aki_stage_7d_p==0 & aki_adm~=1
replace new_onset_aki_p = 1 if (kd_cr_aki_stage_7d_p==1 | kd_cr_aki_stage_7d_p==2 | kd_cr_aki_stage_7d_p==3) & aki_adm~=1
label variable new_onset_aki_p "New onset AKI using predicted baseline values"
label define new_onset_aki_p_ 1 "Yes" 0 "No"
label values new_onset_aki_p new_onset_aki_p_
tab new_onset_aki_p kd_cr_aki_stage_7d_p, m
tab new_onset_aki_p aki_adm, m

// PICU length of stay from randomisation in days
gen los_picu=(icu_disch-scn_rand_dt)/(1000*60*60*24)
label variable los_picu "PICU LOS (days)"

// Hospital length of stay from randomisation in days
gen los_hosp=(hosp_disch-scn_rand_dt)/(1000*60*60*24)
label variable los_hosp "Hospital LOS (days)"

// PICU free survival days (If deceased within 28 days assign a value of 0) 
gen surv_free_picu= 0
foreach var of varlist daystart* {
	replace surv_free_picu = surv_free_picu + (`var'==0 | `var'==.)
}
replace surv_free_picu=0 if out_hosp_dc_status==0

// Hyponatremia within 48 hours
gen ae_hyponatraemia = 0
replace ae_hyponatraemia=1 if (ae_type1 == 3 & ae_start_hours1<48) | (ae_type2 == 3 & ae_start_hours2<48) | (ae_type3 == 3 & ae_start_hours3<48) | (ae_type4 == 3 & ae_start_hours4<48) 
label variable ae_hyponatraemia "Hyponatremia within 48 hours"
label define ae_hyponatraemia_ 1 "Yes" 0 "No"
label values ae_hyponatraemia ae_hyponatraemia_

// Hypercalcemia within 48 hours
gen ae_hypercalcaemia = 0
replace ae_hypercalcaemia=1 if (ae_type1 == 4 & ae_start_hours1<48) | (ae_type2 == 4 & ae_start_hours2<48) | (ae_type3 == 4 & ae_start_hours3<48) | (ae_type4 == 4 & ae_start_hours4<48) 
label variable ae_hypercalcaemia "Hypercalcemia within 48 hours"
label define ae_hypercalcaemia_ 1 "Yes" 0 "No"
label values ae_hypercalcaemia ae_hypercalcaemia_

// Hypocalcemia within 48 hours
gen ae_hypocalcaemia = 0
replace ae_hypocalcaemia=1 if (ae_type1 == 5 & ae_start_hours1<48) | (ae_type2 == 5 & ae_start_hours2<48) | (ae_type3 == 5 & ae_start_hours3<48) | (ae_type4 == 5 & ae_start_hours4<48) 
label variable ae_hypocalcaemia "Hypocalcemia within 48 hours"
label define ae_hypocalcaemia_ 1 "Yes" 0 "No"
label values ae_hypocalcaemia ae_hypocalcaemia_

// Hyperkalemia within 48 hours
gen ae_hyperkalemia = 0
replace ae_hyperkalemia=1 if (ae_type1 == 6 & ae_start_hours1<48) | (ae_type2 == 6 & ae_start_hours2<48) | (ae_type3 == 6 & ae_start_hours3<48) | (ae_type4 == 6 & ae_start_hours4<48) 
label variable ae_hyperkalemia "Hyperkalemia within 48 hours"
label define ae_hyperkalemia_ 1 "Yes" 0 "No"
label values ae_hyperkalemia ae_hyperkalemia_

// Hypokalemia within 48 hours
gen ae_hypokalemia = 0
replace ae_hypokalemia=1 if (ae_type1 == 7 & ae_start_hours1<48) | (ae_type2 == 7 & ae_start_hours2<48) | (ae_type3 == 7 & ae_start_hours3<48) | (ae_type4 == 7 & ae_start_hours4<48) 
label variable ae_hypokalemia "Hypokalemia within 48 hours"
label define ae_hypokalemia_ 1 "Yes" 0 "No"
label values ae_hypokalemia ae_hypokalemia_

// Hypermagnesemia within 48 hours
gen ae_hypermagnesia = 0
replace ae_hypermagnesia=1 if (ae_type1 == 8 & ae_start_hours1<48) | (ae_type2 == 8 & ae_start_hours2<48) | (ae_type3 == 8 & ae_start_hours3<48) | (ae_type4 == 8 & ae_start_hours4<48) 
label variable ae_hypermagnesia "Hypermagnesemia within 48 hours"
label define ae_hypermagnesia_ 1 "Yes" 0 "No"
label values ae_hypermagnesia ae_hypermagnesia_

// Hyperlactemia within 48 hours
gen ae_hyperlactaemia = 0
replace ae_hyperlactaemia=1 if (ae_type1 == 9 & ae_start_hours1<48) | (ae_type2 == 9 & ae_start_hours2<48) | (ae_type3 == 9 & ae_start_hours3<48) | (ae_type4 == 9 & ae_start_hours4<48) 
label variable ae_hyperlactaemia "Hyperlactemia within 48 hours"
label define ae_hyperlactaemia_ 1 "Yes" 0 "No"
label values ae_hyperlactaemia ae_hyperlactaemia_

// Death in hospital
gen hosp_death = 0
replace hosp_death=1 if (ae_type1 == 1 | ae_type2 == 1 | ae_type3 == 1 | ae_type4 == 1)  
label variable hosp_death "Death in hospital"
label define hosp_death_ 1 "Yes" 0 "No"
label values hosp_death hosp_death_

// Any Adverse Event (of those specified above)
gen ae_any = 0
replace ae_any= 1 if (ae_hyponatraemia==1 | ae_hypercalcaemia==1 | ae_hypocalcaemia==1 | ae_hyperkalemia==1| ae_hypokalemia==1 | ae_hypermagnesia==1 | ae_hyperlactaemia==1 | hosp_death==1)
label variable ae_any "Any AE"
label define ae_any_ 1 "Yes" 0 "No"
label values ae_any ae_any_

/** Table 5: Protocol deviations **/

// Number of protocol deviations per patient
egen pd_number=rowtotal(pdf_yn*)

// PD categories
preserve
keep record_id pdf_yn* pdf_details* pdf_description* 
reshape long pdf_yn pdf_details pdf_description, i(record_id) j(pd_number), //reshape pds to long

* Check text reasons under 'other' to determine if any should be recategorised in REDCap
br record_id pdf_description if pdf_details==2 

restore


