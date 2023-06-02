********************
*** INTRODUCTION ***
********************
// This .do-file prepares the data for the cross-country plots on the impact of COVID on inequality
cd "C:\Users\WB514665\OneDrive - WBG\DECDG\SDG Atlas 2022\Ch10\playground-sdg-10"

*************************************
*** PREPARE COVID INEQUALITY DATA ***
*************************************
// File from the 2022 Poverty and Shared Prosperity Report
use "C:\Users\WB514665\OneDrive - WBG\Research\Poverty-climate\01-Inputdata\Welfare\PSPRpovertydistributions.dta", clear
drop if coverage=="rural" & code=="ARG"
keep code welf2019 welfcovid2020 welfprecovid2020 Indicator
keep if Indicator<=4

// Calculate Gini
gen ginicovid = .
gen giniprecovid = .
levelsof code
foreach cd in `r(levels)' {
disp in red "`cd'"
qui ineqdec0 welfcovid         if code=="`cd'"
replace ginicovid = r(gini)    if code=="`cd'"
qui ineqdec0 welfprecovid      if code=="`cd'"
replace giniprecovid = r(gini) if code=="`cd'"
}

// Calculate mean
bysort code: egen meancovid2020    = mean(welfcovid2020)
bysort code: egen meanprecovid2020 = mean(welfprecovid2020)
bysort code: egen mean2019         = mean(welf2019)

// Collapse to country-level
collapse gini* mean* Indicator, by(code)

// Convert means to annual
replace mean2019         = mean2019*365
replace meancovid2020    = meancovid2020*365
replace meanprecovid2020 = meanprecovid2020*365

// Calculate Gini change
gen ginichange = ginicovid-giniprecovid
gen meanchange = (meancovid2020/meanprecovid2020-1)*100
gen logmean = log10(mean2019)
replace ginichange = 100*ginichange

tempfile coviddata
save    `coviddata'

************************
*** PREPARE IMF DATA ***
************************
import excel "Inputdata/FiscalMeasures-DatabaseJanUpdate-For-Publication-030221.xlsx", sheet("Summary.Global") clear
keep B O T
drop if _n<7
drop if _n>197
compress
destring O, replace
destring T, replace
gen totalmeasures = O+T
rename O abovetheline
rename T liquiditysupport
kountry B, from(other) stuck
rename _ISO3N iso3n
kountry iso3n, from(iso3n) to(iso3c) 
rename _ISO3C_ code
replace code="CPV" if B=="Cabo Verde"
replace code="SWZ" if B=="Eswatini"
replace code="HKG" if B=="Hong Kong SAR"
replace code="XKX" if B=="Kosovo"
replace code="LBN" if B=="Lebanon1"
replace code="MAC" if B=="Macao SAR"
replace code="FSM" if B=="Micronesia, Fed. States of"
replace code="MNE" if B=="Montenegro, Rep. of"
replace code="MKD" if B=="North Macedonia"
replace code="CIV" if B=="Côte d'Ivoire"
replace code="STP" if B=="São Tomé and Príncipe"
replace code="TLS" if B=="Timor-Leste, Dem. Rep. of"
drop if missing(code)
drop B iso3n
drop if missing(totalmeasures) & missing(abovetheline) & missing(liquidity)
order code totalmeasures abovetheline liquiditysupport
lab var code "Country code"
lab var totalmeasures "Total fiscal Measures in Response to the COVID-19 Pandemic (share of GDP, %)"
lab var abovetheline "Above the line measures (share of GDP, %)"
lab var liquiditysupport "Liquidity support (share of GDP, %)"
drop total liquidity
rename above fiscalspending

merge 1:1 code using `coviddata', nogen keep(2 3)
order fiscalspending, last
export delimited "Outputdata/Covid.csv", replace

