## Working for binning functions

df_bin = quantile_bin(
  df = eg_data,
  cols = c("suspect_age", "victim_age"),
  nbins = 4
)

df_bin |> group_by(victim_age_binned) |> summarise(
  min_vic = min(victim_age), max_vic = max(victim_age),
  n=n()
)

df_bin |> group_by(suspect_age_binned) |> summarise(
  min_sus = min(suspect_age), max_sus = max(suspect_age),
  n=n()
)


df_bin2 = quantile_bin(
  df = eg_data,
  cols = c("suspect_age", "victim_age"),
  nbins = c(3,4)
)

df_bin2 |> group_by(victim_age_bin) |> summarise(
  min_vic = min(victim_age), max_vic = max(victim_age),
  n=n()
)

df_bin2 |> group_by(suspect_age_bin) |> summarise(
  min_sus = min(suspect_age), max_sus = max(suspect_age),
  n=n()
)

df_bin3 = breaks_bin(
  df = eg_data,
  col = "nprev_sus",
  breaks = c(1, 2),
  labels = c("Zero", "One", "Two plus")
)

df_bin3 |> group_by(nprev_sus_binned) |> summarise(m1 = min(nprev_sus), m2 = max(nprev_sus), n=n())

