## Prepare some propscore df objects

eg_j_est1 = propscore_df(
  df = eg_data,
  cov_cols = c("risk_ass", "category", "sus_age_bin"),
  arm_col = "Arm",
  intervention_level = "Intervention",
  cov_dist = "joint",
  pz1_fn = pz1_estimate(1)
)

eg_m_resc15 = propscore_df(
  df = eg_data,
  cov_cols = c("risk_ass", "category", "sus_age_bin"),
  arm_col = "Arm",
  intervention_level = "Intervention",
  cov_dist = "marginal",
  pz1_fn = pz1_rescale(1.5)
)

eg_mix_exp100 = propscore_df(
  df = eg_data,
  cov_cols = c("risk_ass", "category", "sus_age_bin"),
  arm_col = "Arm",
  intervention_level = "Intervention",
  cov_dist = list(c("risk_ass", "category")),
  pz1_fn = pz1_expectedN(100)
)

## Put into matched_sample
## Not using attributes

match_j_est1_replace = matched_sample(
  df = eg_data,
  propscore_df = eg_j_est1,
  cov_cols = c("category", "risk_ass", "sus_age_bin"),
  arm_col = "Arm",
  intervention_level = "Intervention",
  use_attr = F,
  seed = 20,
  replace = T,
  downsample = F,
  drop_int = F
)

match_j_est1_replace_dr = matched_sample(
  df = eg_data,
  propscore_df = eg_j_est1,
  cov_cols = c("category", "risk_ass", "sus_age_bin"),
  use_attr = F,
  arm_col = "Arm",
  intervention_level = "Intervention",
  seed = 20,
  replace = T,
  downsample = F,
  drop_int = T
)

match_m_resc15_down = matched_sample(
  df = eg_data,
  propscore_df = eg_m_resc15,
  cov_cols = c("category", "risk_ass", "sus_age_bin"),
  use_attr = F,
  arm_col = "Arm",
  intervention_level = "Intervention",
  seed = 20,
  replace = F,
  downsample = T,
  drop_int = F
)

match_j_est1_down_di = matched_sample(
  df = eg_data,
  propscore_df = eg_j_est1,
  cov_cols = c("category", "risk_ass", "sus_age_bin"),
  arm_col = "Arm",
  intervention_level = "Intervention",
  use_attr = F,
  seed = 20,
  replace = F,
  downsample = T,
  drop_int = T
)

## Using attributes


match_j_est1_replace = matched_sample(
  df = eg_data,
  propscore_df = eg_j_est1,
  seed = 20,
  replace = T,
  downsample = F,
  drop_int = F
)

match_j_est1_replace_dr = matched_sample(
  df = eg_data,
  propscore_df = eg_j_est1,
  seed = 20,
  replace = T,
  downsample = F,
  drop_int = T
)

match_m_resc15_down = matched_sample(
  df = eg_data,
  propscore_df = eg_m_resc15,
  seed = 20,
  replace = F,
  downsample = T,
  drop_int = F
)

match_j_est1_down_di = matched_sample(
  df = eg_data,
  propscore_df = eg_j_est1,
  seed = 20,
  replace = F,
  downsample = T,
  drop_int = T
)


## Working for dropped_df
dropped_df(match_j_est1_replace_dr, use_attr = F,  cov_cols = c("category", "risk_ass", "sus_age_bin"))

dropped_df(match_m_resc15_down, use_attr = F,  cov_cols = c("category", "risk_ass", "sus_age_bin"))

dropped_df(match_j_est1_down_di, use_attr = F,  cov_cols = c("category", "risk_ass", "sus_age_bin"))

## Using attr

dropped_df(match_j_est1_replace_dr)

dropped_df(match_m_resc15_down)

dropped_df(match_j_est1_down_di)


## expanded df

e1 = expand_matched_df(match_j_est1_replace_dr)

e2 = expand_matched_df(match_m_resc15_down)

e3 = expand_matched_df(match_j_est1_down_di)


