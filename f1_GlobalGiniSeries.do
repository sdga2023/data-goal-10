********************
*** INTRODUCTION ***
********************
// This .do-file takes the Global Gini series from the 2022 Poverty and Shared Prosperity Report and slightly reformats the data for the Atlas.
// It also adds some country-spefici Gini series rom the Poverty and Inequality Platform
cd "C:\Users\WB514665\OneDrive - WBG\DECDG\SDG Atlas 2022\Ch10\playground-sdg-10"

********************
*** PREPARE DATA ***
********************
import excel "Input data\FigureData_chapter2.xlsx", sheet("Figure2.10") firstrow clear
rename Year year
keep if year>=1990 & !missing(year)
ren Giniindexscale11001950201 gini
ren Giniindexscale11002020wit gini_precovid
ren D gini_covid
ren Annual ginichange
ren F ginichange_precovid
ren G ginichange_covid
drop H I J
export delimited "Output data/GlobalGiniSeries.csv", replace

