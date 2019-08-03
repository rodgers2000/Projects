library(tidyverse)
library(lubridate)

dat_UNIV = read_csv(paste0(getwd(), "/Data/UNIV_IMP.csv"))

# lets calculate ratios 
# profitability 
dat_UNIV = dat_UNIV %>% mutate(gross_margin = gp / revt, operating_margin = cfo / revt, net_profit_margin = ni / revt)
# liquidity 
dat_UNIV = dat_UNIV %>% mutate(current_ratio = act / lct, quick_ratio = (act - invt) / lct, cash_ratio = ch / lct)
# efficiency of working captital 
dat_UNIV = dat_UNIV %>% mutate(asset_turnover = revt / at, inventory_turnover = cogs / invt)
# interest 
dat_UNIV = dat_UNIV %>% mutate(ebit_interest = ebit / xint, ebitda_interest = ebitda / xint)
# leverage 
dat_UNIV = dat_UNIV %>% mutate(debt_to_book_equity = dltt / book_value, 
                               debt_to_market_cap  = dltt / market_cap, 
                               debt_to_captial = dltt / (book_value + dltt), 
                               equity_multiplier = at / book_value)
# operating returns 
dat_UNIV = dat_UNIV %>% mutate(return_on_equity = ni / book_value, return_on_assets = (ni + xint) / at)
# valuation 
dat_UNIV = dat_UNIV %>% mutate(market_to_book = market_cap / book_value, price_to_earnings = prcc_c_adj / epspx_adj)

# lets remove inf values from dividing 
dat_UNIV = dat_UNIV[is.finite(rowSums(dat_UNIV[, 9:50])), ]

# calculate changes 
dat_UNIV = dat_UNIV %>% group_by(GVKEY) %>% 
  mutate(market_cap_chg = market_cap / lag(market_cap) - 1, 
         book_value_chg = book_value / lag(book_value) - 1, 
         cfo_chg = cfo / lag(cfo) - 1, 
         gross_margin_chg = gross_margin / lag(gross_margin) - 1, 
         operating_margin_chg = operating_margin / lag(operating_margin) - 1, 
         net_profit_margin_chg = net_profit_margin / lag(net_profit_margin) - 1, 
         current_ratio_chg = current_ratio / lag(current_ratio) - 1, 
         quick_ratio_chg = quick_ratio / lag(quick_ratio) - 1, 
         cash_ratio_chg = cash_ratio / lag(cash_ratio) - 1, 
         asset_turnover_chg = asset_turnover / lag(asset_turnover) - 1, 
         inventory_turnover_chg = inventory_turnover / lag(inventory_turnover) - 1, 
         ebit_interest_chg = ebit_interest / lag(ebit_interest) - 1, 
         ebitda_interest_chg = ebitda_interest / lag(ebitda_interest) - 1, 
         debt_to_book_equity_chg = debt_to_book_equity / lag(debt_to_book_equity) - 1, 
         debt_to_market_cap_chg = debt_to_market_cap / lag(debt_to_market_cap) - 1, 
         debt_to_captial_chg = debt_to_captial / lag(debt_to_captial) - 1, 
         equity_multiplier_chg = equity_multiplier / lag(equity_multiplier) - 1, 
         return_on_equity_chg = return_on_equity / lag(return_on_equity) - 1, 
         return_on_assets_chg = return_on_assets / lag(return_on_assets) - 1, 
         market_to_book_chg = market_to_book / lag(market_to_book) - 1, 
         price_to_earnings_chg = price_to_earnings / lag(price_to_earnings) - 1)

# lets remove inf values from dividing 
dat_UNIV = dat_UNIV[is.finite(rowSums(dat_UNIV[, 9:71])), ]

# replace NA with zero for changes 
for (column in 51:ncol(dat_UNIV)) {
  dat_UNIV[is.na(dat_UNIV[, column]), column] = 0 
}

# lets return data base 
dat_RETURNS = dat_UNIV %>% select(GVKEY, datadate, tic, conm, return, return_div)

# lets rearrange our universe (ID, Y, X)
dat_UNIV = dat_UNIV[, c(1:4, 7, 5:6, 9:71)]

# lets remove inf values from dividing 
dat_UNIV = dat_UNIV[is.finite(rowSums(dat_UNIV[, 8:70])), ]

# we didnt imputate on common shares traded so we'll fill NA values with the mean 
dat_UNIV[is.na(dat_UNIV[, 7]), 7] = mean(dat_UNIV$cshtr_c, na.rm = TRUE)

# reinstate year feature and rearrange 
dat_UNIV = dat_UNIV %>% mutate(datadate = ymd(datadate), cyear = year(datadate))
dat_UNIV = dat_UNIV[, c(1:4, 71, 5, 6:70)]

# we dont want NA returns 
dat_RETURNS = dat_RETURNS %>% subset(!is.na(return) & !is.na(return_div))

write_csv(dat_UNIV, paste0(getwd(), "/Data/UNIVERSE.csv"))
write_csv(dat_RETURNS, paste0(getwd(), "/Data/RETURNS.csv"))
