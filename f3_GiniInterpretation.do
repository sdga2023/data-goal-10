********************
*** INTRODUCTION ***
********************
// This .do-file creates the data used to illustrate how the Gini should be interpreted
cd "C:\Users\WB514665\OneDrive - WBG\DECDG\SDG Atlas 2022\Ch10\playground-sdg-10"

********************************
*** TWO COUNTRY CASE STUDIES ***
********************************
pip, country(BLR NAM) year(last) popsh(0.005(0.01)0.995) server(dev) identity(INT) ppp_year(2017) clear
keep country_code poverty_line
rename poverty_line consumption
ineqdec0 consumption if country_code=="BLR"
ineqdec0 consumption if country_code=="NAM"
bysort country_code: egen mean = mean(consumption)
gen consumption_relative = consumption/mean*100
// Scale to annual figures
replace consumption = consumption*365
drop mean
sort country_code consumption
export delimited using "Output data/BelarusNamibia.csv", replace