## Working for SMD_plot

stdf= summary_table(
  df = eg_data,
  propscores = eg_j_est1,
  seeds = 1:10,
  smd_cols = c("suspect_age", "category", "risk_ass", "sus_age_bin"),
  smd_order = 3,
  downsample = T,
  replace = F
)

plot_smd(stdf, smd_thresh = 0.17)

stdf100= summary_table(
  df = eg_data,
  propscores = eg_j_est1,
  seeds = 1:100,
  smd_cols = c("suspect_age", "category", "risk_ass", "sus_age_bin"),
  smd_order = 3,
  downsample = T,
  replace = F
)

plot_smd(stdf100, smd_thresh = 0.17)
