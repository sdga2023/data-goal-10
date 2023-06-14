********************
*** INTRODUCTION ***
********************
// This .do-file prepares the data for the two cards
cd "C:\Users\WB514665\OneDrive - WBG\DECDG\SDG Atlas 2022\Ch10\playground-sdg-10"

**************
*** CARD 1 ***
**************
wbopendata, indicator(SM.POP.REFG.OR) long clear
drop if missing(sm)
drop if missing(region)
drop if missing(lendingtype)
compress
keep if year>=2000
drop adm* reg* lend*
*bysort countrycode: egen max = max(sm)
gen code=countryname if inlist(countrycode,"SYR","AFG") 
collapse (sum) sm, by(year code incomelevel)

replace code = "Other low income" if missing(code) & incomelevel=="LIC"
gen order = 4 if code=="Other low income"
replace order = 5 if code=="Afghanistan"
replace order = 6 if code=="Syrian Arab Republic"
replace order = 3 if incomelevel=="LMC"
replace order = 2 if incomelevel=="UMC"
replace order = 1 if incomelevel=="HIC"
replace code = "High income" if incomelevel=="HIC"
replace code = "Upper-middle income" if incomelevel=="UMC"
replace code = "Lower-middle income" if incomelevel=="LMC"
drop incomelevel
ren sm_pop refugees
ren code area
export delimited using "Output data\Card1.csv", replace	   
	   

**************
*** CARD 2 ***
**************
wbopendata, indicator(SI.RMT.COST.OB.ZS;SI.RMT.COST.IB.ZS) long clear
drop if missing( si_rmt_cost_ob_zs) & missing( si_rmt_cost_ib_zs)
keep if year==2020
ren si*ob* ob
ren si*ib* ib
drop admin* income* lending* region
bysort regionname: egen regionmean_ob=mean(ob)
bysort regionname: egen regionmean_ib=mean(ib)
	   
drop if missing(ib)
sort regionmean_ib ib
bysort regionname (ib): gen n = _n/_N
drop ob year regionmean_ob
compress
export delimited using "Output data\Card2.csv", replace