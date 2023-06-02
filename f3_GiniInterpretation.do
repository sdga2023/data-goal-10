********************
*** INTRODUCTION ***
********************
// This .do-file creates the data used to illustrate how the Gini should be interpreted
cd "C:\Users\WB514665\OneDrive - WBG\DECDG\SDG Atlas 2022\Ch10\playground-sdg-10"

************************************************************
*** CREATE LOG NORMAL DISTRIBUTIONS WITH DIFFERENT GINIS ***
************************************************************
clear
local pop = 100
set obs `pop'
gen pctl = _n*100/`pop'-50/`pop'
forvalues i=0/999 {
gen gini`i' = .
scalar sigma`i' = invnormal((`i'/1000+1)/2)*(2^(1/2))
scalar mu`i'    = -sigma`i'^2/2
replace gini`i' = exp(mu`i'+sigma`i'*invnormal(pctl/100))
qui sum gini`i'
replace gini`i'= gini`i'/`r(mean)'
}
replace gini0 = 1
reshape long gini, i(pctl) j(numb)
rename gini income
gen gini_calc=.
forvalues numb=0/999 {
qui ineqdec0 income if numb==`numb'
replace gini_cal = r(gini) if numb==`numb'
}
sort numb pctl
// Only keep the simulations with Gini's closest to 0.01 increments.
gen double closest = round(gini_calc, 0.01)
gen dif     = abs(closest-gini_calc)
bysort closest: egen mindif = min(dif)
keep if dif==mindif
drop mindif dif numb gini_calc pctl
rename closest gini
replace gini = 100*gini
replace income = 100*income
export delimited using "Outputdata/Simulation.csv", replace


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
export delimited using "Outputdata/BelarusNamibia.csv", replace