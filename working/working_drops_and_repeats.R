## Working for dropped cases and repeat cases

eg_j_exp300 <- propscores(
 df = eg_data,
   cov_cols = c("risk_ass", "category", "sus_age_bin"),
   arm_col = "Arm",
   intervention_level = "Intervention",
   cov_dist = "joint",
   pz1_fn = pz1_expectedN(300)
)

match_j_exp300_rep <- matched_sample(
   df = eg_data,
   propscores = eg_j_exp300,
   seed = 20,
   sampling = "repeat",
   drop_int = FALSE
)

match_j_exp300_down <- matched_sample(
  df = eg_data,
  propscores = eg_j_exp300,
  seed = 20,
  sampling = "downsample",
  drop_int = TRUE
)

dropped_cases(match_j_exp300_rep)

dropped_cases(match_j_exp300_down)


repeat_cases(match_j_exp300_rep)

repeat_cases(match_j_exp300_down)
