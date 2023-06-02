********************
*** INTRODUCTION ***
********************
// This .do-file takes the Global Gini for 2019 from the 2022 Poverty and Shared Prosperity Report merges it with the latest country Gini's the Poverty and Inequality Platform
cd "C:\Users\WB514665\OneDrive - WBG\DECDG\SDG Atlas 2022\Ch10\playground-sdg-10"


************************
*** GLOBAL 2019 GINI ***
************************
import delimited "Outputdata/GlobalGiniSeries.csv", clear
keep year gini
keep if year==2019
drop year
gen country_code="WLD"
gen country_name="World"
tempfile world
save    `world'

***************************
*** LATEST COUNTRY GINI ***
***************************
pip,  ppp_year(2017) year(last) clear
keep if reporting_level=="national" | inlist(country_code,"ARG","SUR")
keep country_code country_name gini
replace gini = 100*gini
// Append global Gini on
append using `world'
export delimited "Outputdata/CountryGini.csv", replace