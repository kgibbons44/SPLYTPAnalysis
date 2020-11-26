The SPLYT-P study dataset is contained within two databases; the first, a purpose-built REDCap database containing records on all screened patients (data fields include screening, inclusion and exclusion criteria, eligibility status, informed consent process, randomisation and withdrawal of consent) as well as clinical data and outcomes, and the second an extract from MetaVision (Paediatric Intensive Care Unit clinical information system) containing records on all enrolled patients (data fields include demographics, fluid administation, clinical data and outcomes). The REDCap database also contains additional forms to undertake and record details of data monitoring processes.

The SPLYT-P REDCap dataset will be exported from REDCap using the in-built functionality into Stata format; a Stata compatible dataset in comma-separated value (CSV) format (.csv) and Stata do-file (.do) are generated. The do-file is used to undertake preliminary data transformations; this file imports the data from the CSV file, labels the variables and assigns value labels to categorical variables. This do-files is not provided in this repository as it was not constructed by the authors.

The dataset from MetaVision is exported using a CSV format with data transformation occurring in Stata.

The REDCap study dataset contains one row per screened patient per repeating event. This is not the optimal format for analysis, and as such, data transformation occurs prior to analysis to result in a dataset that contains one row per patient.

The code is broken into the six sections:

Part A: Transformation of REDCap dataset (“SPLYTP REDCap Transformation.do”)

Part B: Import and labelling of MetaVision dataset ("SPLYTP MV Data.do")

Part C: Transformation of MetaVision dataset (“SPLYTP MV Transformation.do")

Part D: Merge REDCap and MetaVision datasets ("SPLYTP Data Merge.do")

Part E: Calculation of outcomes ("SPLYTP Outcomes.do")

Part F: Primary analysis as per the statistical analyis plan ("SPLYTP Analysis.do")

We have chosen to include all code, including code for assessing completeness, distribution and range, as well as the code to undertake the analyses.

The do files should be executed in the order contained in "SPLYTP SAP.do".