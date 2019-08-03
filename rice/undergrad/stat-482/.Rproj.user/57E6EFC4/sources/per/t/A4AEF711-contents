library(readr)
library(tidyverse)
library(readxl)
library(lubridate)

dat_WRDS <- read_csv("Data/WRDS.csv")
dat_CPI <- read_excel("Data/CPI.xlsx")

# our universe is NYSE, AMEX, NASDAQ
dat_UNIV = dat_WRDS %>% subset(exchg == 11 | exchg == 12 | exchg == 14)

# filter out years where companies change fiscal policy
dat_UNIV = dat_UNIV %>% mutate(datadate = mdy(datadate), cyear = year(datadate))
dat_UNIV = dat_UNIV %>% subset(cyear != lag(cyear, 1) | GVKEY != lag(GVKEY, 1))

# now we can adjust prices, dividends and earnings 
dat_UNIV = dat_UNIV %>% mutate(prcc_c_adj = prcc_c / abs(adjex_c), 
                               dvpsx_c_adj = dvpsx_c / abs(adjex_c), 
                               epspx_adj = epspx /abs(adjex_c))

# lets calcualte returns before imputation 
dat_UNIV = dat_UNIV %>% group_by(GVKEY) %>% 
  mutate(return = (prcc_c_adj / lag(prcc_c_adj)) - 1, 
         return_div = ((prcc_c_adj + dvpsx_c_adj) / lag(prcc_c_adj)) - 1) %>% 
  ungroup()

# lets get book value, market cap and cfo 
dat_UNIV = dat_UNIV %>% mutate(market_cap = abs(prcc_c) * csho, book_value = seq, cfo = ib + dpc)

# adjust negative values 
dat_UNIV = dat_UNIV %>% mutate(revt = if_else(revt < 0, 0, revt), 
                               cogs = if_else(cogs < 0, 0, cogs), 
                               bkvlps = if_else(bkvlps < 0, 0, bkvlps), 
                               ch = if_else(ch < 0, 0, ch), 
                               dpc = if_else(dpc < 0, 0, dpc), 
                               seq = if_else(seq < 0, 0, seq), 
                               xint = if_else(xint < 0, 0, xint), 
                               book_value = if_else(book_value < 0, 0, book_value))

# we dont want NA prices and 0 adjustment factors 
dat_UNIV = dat_UNIV %>% subset(!is.na(prcc_c), adjex_c != 0)

dat_UNIV = dat_UNIV %>% subset(is.finite(prcc_c_adj))

# lets tidy data for imputation and get rid of features we dont need 
dat_UNIV = dat_UNIV %>% select(-c(fyear, indfmt, consol, popsrc, datafmt, curcd, prcc_c, dvpsx_c, costat, adjex_c, seq, ib, dpc, csho))
features_to_not_adjust = c("GVKEY", "datadate", "tic", "conm", "exchg", "dvpsx_c_adj", "cshtr_c", "return", "return_div")
dat_HOLD = dat_UNIV %>% select(features_to_not_adjust) %>% select(-dvpsx_c_adj)
dat_MJR = dat_UNIV %>% select(-one_of(features_to_not_adjust))

# adjust prices to 2016 before imputation 
dat_MJR = inner_join(dat_MJR, dat_CPI, by = c("cyear" = "Year"))
dat_MJR = dat_MJR %>% select(-cyear) 

for (column in 1:ncol(dat_MJR)) {
  dat_MJR[, column] = dat_MJR[, column] * 240 / dat_MJR$CPI
}

# IMPUTATION!!! get a dictionary 
dat_MJR = dat_MJR %>% select(-CPI) 
library(imputeR)
dat_IMP = impute(dat_MJR, "lassoR")

# adjust negative values 
dat_HOLD2 = dat_IMP$imp %>% as.data.frame() %>% mutate(
                                   revt = if_else(revt < 0, 0, revt), 
                                   act = if_else(act < 0 , 0, act), 
                                   dltt = if_else(dltt < 0, 0, dltt), 
                                   invt = if_else(invt < 0, 0, invt), 
                                   lct = if_else(lct < 0, 0, lct), 
                                   lse = if_else(lse < 0, 0, lse), 
                                   lt = if_else(lt < 0, 0, lt), 
                                   rect = if_else(rect < 0, 0, rect), 
                                   xint = if_else(xint < 0, 0, xint), 
                                   market_cap = if_else(market_cap < 0, 0, market_cap), 
                                   book_value = if_else(book_value < 0, 0, book_value), 
                                   cogs = if_else(cogs < 0, 0, cogs), 
                                   bkvlps = if_else(bkvlps < 0, 0, bkvlps), 
                                   ch = if_else(ch < 0, 0, ch), 
                                   xint = if_else(xint < 0, 0, xint), 
                                   book_value = if_else(book_value < 0, 0, book_value))

write_csv(cbind(dat_HOLD, dat_HOLD2), paste0(getwd(), "/Data/UNIV_IMP.csv"))
