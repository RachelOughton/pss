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
