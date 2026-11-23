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

nhef = nhefs9282
nhef$wt82_bin = "Under 145"
nhef$wt82_bin[nhef$wt1982 > 145] = "145 to 175"
nhef$wt82_bin[nhef$wt1992 > 175] = "Over 175"
nhef$wt82_bin = as.factor(nhef$wt82_bin)

ps_nhef_j = propscores(
  df = nhef,
  cov_cols = c("wt82_bin", "sex", "genhealth1982", "hyperhb1982", "cancer1982", "cough1982"),
  arm_col = "smoke1982",
  intervention_level = 1,
  cov_dist = "joint",
  pz1_fn = pz1_estimate(0.3)
)
