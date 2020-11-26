/**** SPLYTP Data Analysis ****/
/**** Prepared by: Renate Le Marsney ****/
/**** Date initialised: 06/10/2020 ****/
/**** Purpose: Analysis of SPLYTP data for final publication. Syntax to be published with SAP****/

/* Includes the followign Do files:
1. Data import and transformation for SPLYT P REDCap data
2. Data import and transformation for SPLYT P data extracted from MV
3. Data merging of SPLYT P REDCap data and MV data
4. Coding of SPLYT P outcomes
5. Coding of SPLYT P analysis
*/

log using "201126_SPLYT-P SAP.txt", text replace

clear

// run STATA do file for SPLYT P REDCap data extract (syntax generated from REDCap for the latest data extract)
do "SPLYTP_STATA_2020-11-11_1513.do"

// run tansformation file to transform SPLYT P REDCap data extract to one line per patient
do "SPLYTP REDCap Transformation.do"

// run do file for SPLYT P MV data extract
do "SPLYTP MV Data.do"

// run tansformation file to transform MV data extract to one line per patient
do "SPLYTP MV Transformation.do"

// run merge file to merge SPLYT P REDCap and MV data
do "SPLYTP Data Merge.do"

// run outcomes file to generate outcomes from SPLYT P analysis
do "SPLYTP Outcomes.do"

// run analysis file to generate SPLYT P analysis
do "SPLYTP Analysis.do"

log close
