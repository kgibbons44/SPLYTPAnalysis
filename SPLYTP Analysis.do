/**** SPLYTP Analysis ****/
/**** Prepared by: Renate Le Marsney ****/
/**** Date initialised: 06/10/2020 ****/
/**** Purpose: SPLYTP Analysis for SAP publication****/

/** Consort Diagram **/

// Number screened (Assessed for eligibility)
count

// Numbers Ineligible/eligible
tab scn_pt_eligibility_calc, m

// Number that did not meet inclusion criteria
count if scn_inc_cri_01==0 | scn_inc_cri_02==0 | scn_inc_cri_03==0 | scn_inc_cri_04==0

// Number that met one or more exclusion criteria
count if scn_exc_cri_01==1 | scn_exc_cri_02==1 |  scn_exc_cri_03==1 |  scn_exc_cri_04==1 |  scn_exc_cri_05==1 |  scn_exc_cri_06==1 |  scn_exc_cri_07==1 |  scn_exc_cri_08==1 |  scn_exc_cri_09==1 |  scn_exc_cri_10==1 | scn_exc_cri_11==1

// Number for each exclusion criteria
foreach v of varlist scn_exc_cri_?? {
tab `v' 
}

// Number who were eligible but did not proceed to randomisation or approached for consent
count if scn_pt_eligibility_calc==1 & scn_rand_yn==0 & scn_consent_type==0

// Numbers for each reason for eligible but not approached for consent (regardless of if recorded as missed / not missed)
foreach v of varlist ex_* {
	tab `v' if scn_pt_eligibility_calc==1 & scn_rand_yn==0 & scn_consent_type==0
}

// Number who were eligible and approached for prospective consent before randomisation
count if scn_pt_eligibility_calc==1 & scn_consent_type==1

// Number who were eligible and approached for prospective consent before randomisation but declined
count if scn_pt_eligibility_calc==1 & scn_rand_yn==0 & scn_consent_type==1 & scn_declined_yn==1

// Number who were eligible and proceeded with consent to continue
count if scn_pt_eligibility_calc==1 & scn_consent_type==2

// Number randomised 
count if scn_rand_yn==1

// Number who were randomised into each allocation
tab rand_allocation if scn_rand_yn==1 

// Numbers per consent type for those randomised per allocation
preserve
keep if scn_rand_yn==1
tab scn_consent_type rand_allocation 
restore

// Number excluded post randomisation per allocation 
tab rand_allocation if (scn_rand_yn==1 & scn_consent_type==2 & scn_consent_yn~=1 & scn_declined_yn~=1) | re_rand_28==1

// Numbers for each reason for excluded post randomisation per allocation
foreach v of varlist ex_* {
	tab `v' rand_allocation if scn_rand_yn==1 & scn_consent_type==2 & scn_consent_yn~=1 & scn_declined_yn~=1
	}
// Number excluded post randomisation based on re randomisation within 28 days
tab re_rand_28 rand_allocation 

// Number who used consent to continue and declined informed consent after randomisation per allocation and not excluded due to re randomisation within 28 days
tab rand_allocation if scn_declined_yn==1 & scn_consent_type==2  & scn_rand_yn==1 & re_rand_28==0

// Numbers per consent type for those that were randomised and provided informed consent per allocation and not excluded due to re randomisation within 28 days
tab scn_consent_type rand_allocation  if scn_pt_status_calc==2 & re_rand_28==0

// Numbers who were randomised and provided informed consent per allocation and not excluded due to re randomisation within 28 days // these are the same numbers for included in the primary analysis 
tab rand_allocation if scn_pt_status_calc==2 & re_rand_28==0

// Keep patients that were consented, randomised and not excluded due to re randomisation within 28 days
keep if scn_pt_status_calc==2 & re_rand_28==0


/** Table 1: Baseline Characteristics **/

// Age (years)
hist scn_rand_age_yr
tabstat scn_rand_age_yr, by(rand_allocation) stats(n mean sd min max q iqr)

// Weight
hist dem_weight
tabstat dem_weight, by(rand_allocation) stats(n mean sd min max q iqr)

// Indigenous status
tab ind_status rand_allocation, m col
tab ind_status rand_allocation, col

// Gender
tab dem_gender rand_allocation, m col
tab dem_gender rand_allocation, col

// Presenting diagnosis
tab present_diag rand_allocation, m col
tab present_diag rand_allocation, col

// Elective admission
tab elective rand_allocation, m col
tab elective rand_allocation, col

// Co-morbidities
tab comorbidity rand_allocation, m col
tab comorbidity rand_allocation, col
preserve
keep if comorbidity==1
foreach v of varlist cc_* {
	tab `v' rand_allocation, m col
	tab `v' rand_allocation, col
}
restore

// Admission source
tab admit_source rand_allocation, m col
tab admit_source rand_allocation, col

// Baseline biochemical values on admission (need to account for missing codes)
mvdecode bl_cl  bl_na  bl_k  bl_ca_corr  bl_crea, mv(99999=.\ 44444=.\ 55555=.)

* Chloride
hist bl_cl
tabstat bl_cl, by(rand_allocation) stats(n mean sd min max q iqr)

* Sodium
hist bl_na
tabstat bl_na, by(rand_allocation) stats(n mean sd min max q iqr)

* Potassium
hist bl_k
tabstat bl_k, by(rand_allocation) stats(n mean sd min max q iqr)

* Calcium
hist bl_ca_corr
tabstat bl_ca_corr, by(rand_allocation) stats(n mean sd min max q iqr)

* Serum creatinine
hist bl_crea
tabstat bl_crea, by(rand_allocation) stats(n mean sd min max q iqr)

// PIM-3
hist pim_3
tabstat pim_3, by(rand_allocation) stats(n mean sd min max q iqr)

// PELOD-2
hist pelod_2_adm
tabstat pelod_2_adm, by(rand_allocation) stats(n mean sd min max q iqr)

// Mechanical ventilation
tab vent_adm rand_allocation, m col
tab vent_adm rand_allocation, col

// Cardiovascular support
tab inotrope_adm rand_allocation, m col
tab inotrope_adm rand_allocation, col

// Fluid received prior to randomisation in hospital
* Total IV fluid: volume
hist total_iv_fluid_pre_rand_kg
tabstat total_iv_fluid_pre_rand_kg, by(rand_allocation) stats(n mean sd min max q iqr)

* Total IV fluid: volume bolus
hist total_iv_fluid_bl_pre_rand_kg
tabstat total_iv_fluid_bl_pre_rand_kg, by(rand_allocation) stats(n mean sd min max q iqr)

* Total IV fluid: volume maintenance
hist total_iv_fluid_m_pre_rand_kg
tabstat total_iv_fluid_m_pre_rand_kg, by(rand_allocation) stats(n mean sd min max q iqr)

* NaCl
hist total_iv_nacl_pre_rand_kg
tabstat total_iv_nacl_pre_rand_kg, by(rand_allocation) stats(n mean sd min max q iqr)

* Plasmalyte
hist total_iv_plasmalyte_pre_rand_kg
tabstat total_iv_plasmalyte_pre_rand_kg, by(rand_allocation) stats(n mean sd min max q iqr)

* CSL
hist total_iv_csl_pre_rand_kg
tabstat total_iv_csl_pre_rand_kg, by(rand_allocation) stats(n mean sd min max q iqr)

* Albumin 4 %
hist total_iv_alb4_pre_rand_kg
tabstat total_iv_alb4_pre_rand_kg, by(rand_allocation) stats(n mean sd min max q iqr)

* Albumin 20 %
hist total_iv_alb20_pre_rand_kg
tabstat total_iv_alb20_pre_rand_kg, by(rand_allocation) stats(n mean sd min max q iqr)

/** Table 2: Description of fluid use in randomised patients **/

// First 24 from randomisation
* Total IV fluid: duration
hist duration_iv_fluid_24
tabstat duration_iv_fluid_24, by(rand_allocation) stats(n mean sd min max q iqr)

* Total IV fluid: volume
hist total_iv_fluid_24_kg
tabstat total_iv_fluid_24_kg, by(rand_allocation) stats(n mean sd min max q iqr)

* Total IV fluid: volume bolus
hist total_iv_fluid_bl_24_kg
tabstat total_iv_fluid_bl_24_kg, by(rand_allocation) stats(n mean sd min max q iqr)

* Total IV fluid: volume maintenance
hist total_iv_fluid_m_24_kg
tabstat total_iv_fluid_m_24_kg, by(rand_allocation) stats(n mean sd min max q iqr)

* Total IV fluid: volume NaCl
hist total_iv_nacl_24_kg
tabstat total_iv_nacl_24_kg, by(rand_allocation) stats(n mean sd min max q iqr)

* Total IV fluid: volume CSL
hist total_iv_csl_24_kg
tabstat total_iv_csl_24_kg, by(rand_allocation) stats(n mean sd min max q iqr)

* Total IV fluid: volume plasmalyte
hist total_iv_plasmalyte_24_kg
tabstat total_iv_plasmalyte_24_kg, by(rand_allocation) stats(n mean sd min max q iqr)

* Total IV fluid: volume albumin 4%
hist total_iv_alb4_24_kg
tabstat total_iv_alb4_24_kg, by(rand_allocation) stats(n mean sd min max q iqr)

* Total IV fluid: volume albumin 20%
hist total_iv_alb20_24_kg
tabstat total_iv_alb20_24_kg, by(rand_allocation) stats(n mean sd min max q iqr)

* Total allocated fluid: duration
hist duration_rand_fluid_24
tabstat duration_rand_fluid_24, by(rand_allocation) stats(n mean sd min max q iqr)

* Total allocated fluid: volume
hist total_rand_fluid_24_kg
tabstat total_rand_fluid_24_kg, by(rand_allocation) stats(n mean sd min max q iqr)

* Total allocated fluid: volume bolus
hist total_rand_fluid_bl_24_kg
tabstat total_rand_fluid_bl_24_kg, by(rand_allocation) stats(n mean sd min max q iqr)

* Total allocated fluid: volume maintenance
hist total_rand_fluid_m_24_kg
tabstat total_rand_fluid_m_24_kg, by(rand_allocation) stats(n mean sd min max q iqr)

* Run the comparisons
foreach v of varlist duration_iv_fluid_24 total_iv_fluid_24_kg total_iv_fluid_bl_24_kg total_iv_fluid_m_24_kg total_iv_nacl_24_kg total_iv_csl_24_kg total_iv_plasmalyte_24_kg total_iv_alb4_24_kg total_iv_alb20_24_kg duration_rand_fluid_24 total_rand_fluid_24_kg total_rand_fluid_bl_24_kg total_rand_fluid_m_24_kg {
	
	capture noisily xi: meglm `v' b(1).rand_allocation || id:, nolog
	
	* Also include Kruskal-Wallis in case of violation of assumptions
	capture noisily dunntest `v', by(rand_allocation)
}

// First 48 from randomisation
* Total IV fluid: duration
hist duration_iv_fluid_48
tabstat duration_iv_fluid_48, by(rand_allocation) stats(n mean sd min max q iqr)

* Total IV fluid: volume
hist total_iv_fluid_48_kg
tabstat total_iv_fluid_48_kg, by(rand_allocation) stats(n mean sd min max q iqr)

* Total IV fluid: volume bolus
hist total_iv_fluid_bl_48_kg
tabstat total_iv_fluid_bl_48_kg, by(rand_allocation) stats(n mean sd min max q iqr)

* Total IV fluid: volume maintenance
hist total_iv_fluid_m_48_kg
tabstat total_iv_fluid_m_48_kg, by(rand_allocation) stats(n mean sd min max q iqr)

* Total IV fluid: volume NaCl
hist total_iv_nacl_48_kg
tabstat total_iv_nacl_48_kg, by(rand_allocation) stats(n mean sd min max q iqr)

* Total IV fluid: volume CSL
hist total_iv_csl_48_kg
tabstat total_iv_csl_48_kg, by(rand_allocation) stats(n mean sd min max q iqr)

* Total IV fluid: volume plasmalyte
hist total_iv_plasmalyte_48_kg
tabstat total_iv_plasmalyte_48_kg, by(rand_allocation) stats(n mean sd min max q iqr)

* Total IV fluid: volume albumin 4%
hist total_iv_alb4_48_kg
tabstat total_iv_alb4_48_kg, by(rand_allocation) stats(n mean sd min max q iqr)

* Total IV fluid: volume albumin 20%
hist total_iv_alb20_48_kg
tabstat total_iv_alb20_48_kg, by(rand_allocation) stats(n mean sd min max q iqr)

* Total allocated fluid: duration
hist duration_rand_fluid_48
tabstat duration_rand_fluid_48, by(rand_allocation) stats(n mean sd min max q iqr)

* Total allocated fluid: volume
hist total_rand_fluid_48_kg
tabstat total_rand_fluid_48_kg, by(rand_allocation) stats(n mean sd min max q iqr)

* Total allocated fluid: volume bolus
hist total_rand_fluid_bl_48_kg
tabstat total_rand_fluid_bl_48_kg, by(rand_allocation) stats(n mean sd min max q iqr)

* Total allocated fluid: volume maintenance
hist total_rand_fluid_m_48_kg
tabstat total_rand_fluid_m_48_kg, by(rand_allocation) stats(n mean sd min max q iqr)

* Run the comparisons
foreach v of varlist duration_iv_fluid_48 total_iv_fluid_48_kg total_iv_fluid_bl_48_kg total_iv_fluid_m_48_kg total_iv_nacl_48_kg total_iv_csl_48_kg total_iv_plasmalyte_48_kg total_iv_alb4_48_kg total_iv_alb20_48_kg duration_rand_fluid_48 total_rand_fluid_48_kg total_rand_fluid_bl_48_kg total_rand_fluid_m_48_kg {
	
	capture noisily xi: meglm `v' b(1).rand_allocation || id:, nolog
	
	* Also include Kruskal-Wallis in case of violation of assumptions
	capture noisily dunntest `v', by(rand_allocation)
}

// From randomisation until PICU discharge
* Total IV fluid: duration
hist duration_iv_fluid
tabstat duration_iv_fluid, by(rand_allocation) stats(n mean sd min max q iqr)

* Total IV fluid: volume
hist total_iv_fluid_kg
tabstat total_iv_fluid_kg, by(rand_allocation) stats(n mean sd min max q iqr)

* Total IV fluid: volume bolus
hist total_iv_fluid_bl_kg
tabstat total_iv_fluid_bl_kg, by(rand_allocation) stats(n mean sd min max q iqr)

* Total IV fluid: volume maintenance
hist total_iv_fluid_m_kg
tabstat total_iv_fluid_m_kg, by(rand_allocation) stats(n mean sd min max q iqr)

* Total IV fluid: volume NaCl
hist total_iv_nacl_kg
tabstat total_iv_nacl_kg, by(rand_allocation) stats(n mean sd min max q iqr)

* Total IV fluid: volume CSL
hist total_iv_csl_kg
tabstat total_iv_csl_kg, by(rand_allocation) stats(n mean sd min max q iqr)

* Total IV fluid: volume plasmalyte
hist total_iv_plasmalyte_kg
tabstat total_iv_plasmalyte_kg, by(rand_allocation) stats(n mean sd min max q iqr)

* Total IV fluid: volume albumin 4%
hist total_iv_alb4_kg
tabstat total_iv_alb4_kg, by(rand_allocation) stats(n mean sd min max q iqr)

* Total IV fluid: volume albumin 20%
hist total_iv_alb20_kg
tabstat total_iv_alb20_kg, by(rand_allocation) stats(n mean sd min max q iqr)

* Total allocated fluid: duration
hist duration_rand_fluid
tabstat duration_rand_fluid, by(rand_allocation) stats(n mean sd min max q iqr)

* Total allocated fluid: volume
hist total_rand_fluid_kg
tabstat total_rand_fluid_kg, by(rand_allocation) stats(n mean sd min max q iqr)

* Total allocated fluid: volume bolus
hist total_rand_fluid_bl_kg
tabstat total_rand_fluid_bl_kg, by(rand_allocation) stats(n mean sd min max q iqr)

* Total allocated fluid: volume maintenance
hist total_rand_fluid_m_kg
tabstat total_rand_fluid_m_kg, by(rand_allocation) stats(n mean sd min max q iqr)

* Run the comparisons
foreach v of varlist duration_iv_fluid total_iv_fluid_kg total_iv_fluid_bl_kg total_iv_fluid_m_kg total_iv_nacl_kg total_iv_csl_kg total_iv_plasmalyte_kg total_iv_alb4_kg total_iv_alb20_kg duration_rand_fluid total_rand_fluid_kg total_rand_fluid_bl_kg total_rand_fluid_m_kg {
	
	capture noisily xi: meglm `v' b(1).rand_allocation || id:
	
	* Also include Kruskal-Wallis in case of violation of assumptions
	capture noisily dunntest `v', by(rand_allocation)
}

/** Table 3, Table 4: Outcomes **/

// Primary outcome (ITT): >=5mmol/L increase in serum chloride level by 48 hours
tab cl_gt5_increase_itt rand_allocation, m col
tab cl_gt5_increase_itt rand_allocation, col

sort scn_hosp_id
xi: melogit cl_gt5_increase_itt b(1).rand_allocation || id:, or nolog
* Test assumptions
linktest, nolog
predict p
predict devr, dev
scatter devr p, yline(0) mlabel(record_id)
drop p devr

* Subgroup analysis: age at randomisation
tab cl_gt5_increase_itt rand_allocation if age_cat==1, m col
tab cl_gt5_increase_itt rand_allocation if age_cat==1, col
tab cl_gt5_increase_itt rand_allocation if age_cat==2, m col
tab cl_gt5_increase_itt rand_allocation if age_cat==2, col
tab cl_gt5_increase_itt rand_allocation if age_cat==3, m col
tab cl_gt5_increase_itt rand_allocation if age_cat==3, col
xi: melogit cl_gt5_increase_itt b(1).rand_allocation##b(3).age_cat || id:, or nolog
* Test assumptions 
linktest, nolog
predict p
predict devr, dev
scatter devr p, yline(0) mlabel(record_id)
drop p devr

* Subgroup analysis: elective surgery
tab cl_gt5_increase_itt rand_allocation if elective==0, m col
tab cl_gt5_increase_itt rand_allocation if elective==0, col
tab cl_gt5_increase_itt rand_allocation if elective==1, m col
tab cl_gt5_increase_itt rand_allocation if elective==1, col
xi: melogit cl_gt5_increase_itt b(1).rand_allocation##b(1).elective || id:, or nolog
* Test assumptions 
linktest, nolog
predict p
predict devr, dev
scatter devr p, yline(0) mlabel(record_id)
drop p devr

* Subgroup analysis: IVFT>24 hours
tab cl_gt5_increase_itt rand_allocation if ivft_dur_24hr==0, m col
tab cl_gt5_increase_itt rand_allocation if ivft_dur_24hr==0, col
tab cl_gt5_increase_itt rand_allocation if ivft_dur_24hr==1, m col
tab cl_gt5_increase_itt rand_allocation if ivft_dur_24hr==1, col
xi: melogit cl_gt5_increase_itt b(1).rand_allocation##b(1).ivft_dur_24hr || id:, or nolog
* Test assumptions
linktest, nolog
predict p
predict devr, dev
scatter devr p, yline(0) mlabel(record_id)
drop p devr

* Subgroup analysis: IVFT>50ml/kg in first 48 hours
tab cl_gt5_increase_itt rand_allocation if ivft_total_50==0, m col
tab cl_gt5_increase_itt rand_allocation if ivft_total_50==0, col
tab cl_gt5_increase_itt rand_allocation if ivft_total_50==1, m col
tab cl_gt5_increase_itt rand_allocation if ivft_total_50==1, col
xi: melogit cl_gt5_increase_itt b(1).rand_allocation##b(1).ivft_total_50 || id:, or nolog
* Test assumptions
linktest, nolog
predict p
predict devr, dev
scatter devr p, yline(0) mlabel(record_id)
drop p devr

// Primary outcome (per-protocol): >=5mmol/L increase in serum chloride level by 48 hours
tab cl_gt5_increase_pp rand_allocation, m col
tab cl_gt5_increase_pp rand_allocation, col
xi: melogit cl_gt5_increase_pp b(1).rand_allocation || id:, or nolog
* Test assumptions
linktest, nolog
predict p
predict devr, dev
scatter devr p, yline(0) mlabel(record_id)
drop p devr

// Secondary outcomes
* Create variable lists for remaining outcome variables
local outcomes_cont "surv_free_od surv_free_picu"
local outcomes_binary "new_onset_aki_p ae_any ae_hyponatraemia ae_hypercalcaemia ae_hypocalcaemia ae_hyperkalemia ae_hypokalemia ae_hypermagnesia ae_hyperlactaemia hosp_death"
local outcomes_surv "los_picu los_hosp"

// Analyse continuous outcomes
foreach v of varlist `outcomes_cont' {

	* Descriptive statistics
	hist `v'
	tabstat `v', by(rand_allocation) stats(n mean sd min max q iqr)
	
	capture noisily xi: meglm `v' b(1).rand_allocation || id:, nolog
	* Test assumptions
	capture noisily predict pr, xb
	capture noisily predict r, residuals
	capture noisily scatter r pr
	capture noisily drop pr r
	
	* Also include Kruskal-Wallis in case of violation of assumptions
	capture noisily dunntest `v', by(rand_allocation)
		
}

// Analyse binary outcomes
foreach v of varlist `outcomes_binary' {

	* Descriptive statistics
	tab `v' rand_allocation, m col
	tab `v' rand_allocation, col
	
	capture noisily xi: melogit `v' b(1).rand_allocation || id:, or nolog
	* Test assumptions
	capture noisily linktest, nolog
	capture noisily predict p
	capture noisily predict devr, dev
	capture noisily scatter devr p, yline(0) mlabel(record_id)
	capture noisily drop p devr

}

// Analyse survival outcomes
foreach v of varlist `outcomes_surv' {

	* Descriptive statistics
	hist `v'
	tabstat `v', by(rand_allocation) stats(n mean sd min max q iqr)
		
	* Primary analysis and sensitivity analyses
	stset `v'
	sts graph, by(rand_allocation)
	capture noisily xi: mestreg b(1).rand_allocation || id:, distribution(weibull)
	* Test assumptions
	predict s, surv
	gen lnls=log(-1*log(s))
	gen log_`v'=log(`v')
	scatter lnls log_`v'
	drop s lnls log_`v'

}

/** Table 5: Protocol deviations **/

// Patients with at least one protocol deviation
tab out_pds_yn, m
tab out_pds_yn

// Number of protocol deviations per patient
tab pd_number, m
tab pd_number

// Number in each PD categories
preserve
keep record_id pdf_yn* pdf_details* pdf_description* 
reshape long pdf_yn pdf_details pdf_description, i(record_id) j(pd_number), //reshape pds to long

drop if pdf_yn==.

tab pdf_details, m
tab pdf_details

restore

// Number of maintence and bolus changes per allocation
preserve
collapse (sum) pd_iv_number bolus_number maintenance_number, by(rand_allocation)
gen bolus_number_perc = (bolus_number/pd_iv_number)*100
gen maintenance_number_perc = (maintenance_number/pd_iv_number)*100
table rand_allocation, c(max pd_iv_number max bolus_number max maintenance_number max bolus_number_perc max maintenance_number_perc)
restore


/** Supplementary Table: Blood products used in first 48 hours **/

// Volume of total blood products
hist total_bp_48_kg
tabstat total_bp_48_kg, by(rand_allocation) stats(n mean sd min max q iqr)

// Volume of blood product: cryoprecipitate
hist total_cryo_48_kg
tabstat total_cryo_48_kg, by(rand_allocation) stats(n mean sd min max q iqr)

// Volume of blood product: FFP
hist total_ffp_48_kg
tabstat total_ffp_48_kg, by(rand_allocation) stats(n mean sd min max q iqr)

// Volume of blood product: RBC
hist total_rbc_48_kg
tabstat total_rbc_48_kg, by(rand_allocation) stats(n mean sd min max q iqr)

// Volume of blood product: platelets
hist total_platelets_48_kg
tabstat total_platelets_48_kg, by(rand_allocation) stats(n mean sd min max q iqr)

