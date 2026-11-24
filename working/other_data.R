## Seeing if it works for other packages

library(medicaldata)

install.packages('pss', repos = c('https://racheloughton.r-universe.dev', 'https://cloud.r-project.org'))
library(pss)
library(tidyverse)


## Smartpill
# Can't tell if this is randomised or not

sp = smartpill
sp$height_cat = "below 167"
sp$height_cat[sp$Height >= 167] = "167 to 178"
sp$height_cat[sp$Height >= 178] = "178 plus"
sp$height_cat = as.factor(sp$height_cat)

sp$Race2 = "One"
sp$Race2[sp$Race >1] = "Two"
sp$Race2[sp$Race > 2] = "Other"
sp$Race2 = as.factor(sp$Race2)

sp$Gender = as.factor(sp$Gender)


ps_sp = propscores(
  df = sp,
  cov_cols = c("Gender", "Race2", "height_cat"),
  arm_col = "Group",
  intervention_level = 0,
  cov_dist = "joint",
  pz1_fn = pz1_expectedN(15)
)

ps_sp |> select("Gender", "Race2", "height_cat", "count_int", "count_comp", "ratio", "PropScore")

ps_spm = propscores(
  df = sp,
  cov_cols = c("Gender", "Race2", "height_cat"),
  arm_col = "Group",
  intervention_level = 0,
  cov_dist = "marginal",
  pz1_fn = pz1_expectedN(15)
)

ps_spm


# scidesignR smoking data


library(scidesignR)
glimpse(nhefs9282)

nhef = nhefs9282 |> drop_na(smoke1982)
nhef$wt82_bin = "Under 145"
nhef$wt82_bin[nhef$wt1982 > 145] = "145 to 175"
nhef$wt82_bin[nhef$wt1992 > 175] = "Over 175"
nhef$wt82_bin = as.factor(nhef$wt82_bin)

## Joint

ps_nhef_j = propscores(
  df = nhef,
  cov_cols = c("wt82_bin", "sex", "genhealth1982", "cancer1982", "cough1982", "incomeclass"),
  arm_col = "smoke1982",
  intervention_level = 1,
  cov_dist = "joint",
  pz1_fn = pz1_estimate(0.3)
)


cand100_nhef_j = candidates(
  df = nhef,
  propscores = ps_nhef_j,
  seeds = 1:100,
  sampling = "repeat",
  smd_cols = c("wt82_bin", "sex", "genhealth1982", "cancer1982", "cough1982", "incomeclass"),
  smd_order = 2
)

cand100_nhef_j_ddi = candidates(
  df = nhef,
  propscores = ps_nhef_j,
  seeds = 1:100,
  sampling = "downsample",
  drop_int = T,
  smd_cols = c("wt82_bin", "sex", "genhealth1982", "cancer1982", "cough1982", "incomeclass"),
  smd_order = 2
)

## Choose seed 12

ms_nhef_j12_ndi = matched_sample(
  df = nhef,
  propscores = ps_nhef_j,
  seed = 12
)

ems_nhef_j12_ndi = expand_matched_df(ms_nhef_j12_ndi)



## UIS drug treatment study data

library(quantreg)

data(uis)

uis$age_bin = "Under 29"
uis$age_bin[uis$AGE>=29] = "29 to 35"
uis$age_bin[uis$AGE >= 35] = "35 plus"
uis$age_bin = as.factor(uis$age_bin)



ps_uis_j = propscores(
  df = uis,
  cov_cols = c("age_bin", )
)
