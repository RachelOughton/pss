## Tests for propscores


## Test it gives correct error message when arm_col is wrong in various ways


test_that("error1",{
  expect_error(
    propscores(
      df = eg_data,
      cov_cols = c("risk_ass", "category", "sus_age_bin"),
      arm_col = "Arm",
      intervention_level = "Intervention",
      cov_dist = list(c("risk_ass", "category", "victim_age")),
      pz1_fn = pz1_expectedN(300)
    )
  )
})

## Check case definitely doesn't matter

test_that("Joint, different cases", {
  expect_equal(
    propscores(
      df = eg_data,
      cov_cols = c("risk_ass", "category", "sus_age_bin"),
      arm_col = "Arm",
      intervention_level = "Intervention",
      cov_dist = "joint",
      pz1_fn = pz1_rescale(1)
    ),
    propscores(
      df = eg_data,
      cov_cols = c("risk_ass", "category", "sus_age_bin"),
      arm_col = "Arm",
      intervention_level = "Intervention",
      cov_dist = "JOINT",
      pz1_fn = pz1_rescale(1)
    )
  )})

test_that("Marginal, different cases", {
  expect_equal(
    propscores(
      df = eg_data,
      cov_cols = c("risk_ass", "category", "sus_age_bin"),
      arm_col = "Arm",
      intervention_level = "Intervention",
      cov_dist = "marginal",
      pz1_fn = pz1_rescale(1)
    ),
    propscores(
      df = eg_data,
      cov_cols = c("risk_ass", "category", "sus_age_bin"),
      arm_col = "Arm",
      intervention_level = "Intervention",
      cov_dist = "MARGINAL",
      pz1_fn = pz1_rescale(1)
    )
  )})


## Use snapshot testing for actual output, check some values are actually correct
## by calculating 'maunally' for some combinations. Use different combos for each example


test_that("Joint, rescale to 1.5", {
  eg_counts = eg_data |> dplyr::group_by(category, risk_ass, sus_age_bin, Arm) |> dplyr::summarise(n=dplyr::n())
  eg_counts = na.omit(eg_counts)
  n_int = sum(eg_counts[["n"]][eg_counts$Arm == "Intervention"])
  n_comp = sum(eg_counts[["n"]][eg_counts$Arm == "Comparison"])

  df_tcd_h_u29 = eg_counts |>
    dplyr::filter(category == "Theft / CD") |>
    dplyr::filter(risk_ass == "HIGH") |>
    dplyr::filter(sus_age_bin == "Under 29")

  df_vso_h_29 = eg_counts |>
    dplyr::filter(category == "Violent/Sexual") |>
    dplyr::filter(risk_ass == "HIGH") |>
    dplyr::filter(sus_age_bin == "29-32")


  ps_test1 =propscores(
    df = eg_data,
    cov_cols = c("risk_ass", "category", "sus_age_bin"),
    arm_col = "Arm",
    intervention_level = "Intervention",
    cov_dist = "joint",
    pz1_fn = pz1_rescale(1)
  )

  expect_snapshot(
    ps_test1
  )

  expect_equal(
    sum(ps_test1$px_int),
    1
  )
  expect_equal(
    sum(ps_test1$px_comp),
    1
  )

  ## Test some specific values

  ### Theft/CD, HIGH, Under 29
  expect_equal(
    ps_test1$px_int[
      (ps_test1$category == "Theft / CD")&
        (ps_test1$risk_ass == "HIGH")&
        (ps_test1$sus_age_bin == "Under 29")],
    df_tcd_h_u29$n[df_tcd_h_u29$Arm == "Intervention"] / n_int
  )

  # This doesn't work because there is no comparison row for this combo
  expect_equal(
    ps_test1$px_comp[
      (ps_test1$category == "Theft / CD")&
        (ps_test1$risk_ass == "HIGH")&
        (ps_test1$sus_age_bin == "Under 29")],
    df_tcd_h_u29$n[df_tcd_h_u29$Arm == "Comparison"] / n_comp
  )

  expect_equal(
    ps_test1$ratio[
      (ps_test1$category == "Theft / CD")&
        (ps_test1$risk_ass == "HIGH")&
        (ps_test1$sus_age_bin == "Under 29")],

    (df_tcd_h_u29$n[df_tcd_h_u29$Arm == "Intervention"] / n_int) /
      (df_tcd_h_u29$n[df_tcd_h_u29$Arm == "Comparison"] / n_comp)
  )

  ### Violent / sexual, HIGH, 29-32
  expect_equal(
    ps_test1$px_int[
      (ps_test1$category == "Violent/Sexual")&
        (ps_test1$risk_ass == "HIGH")&
        (ps_test1$sus_age_bin == "29-32")],
    df_vso_h_29$n[df_vso_h_29$Arm == "Intervention"] / n_int
  )

  expect_equal(
    ps_test1$px_comp[
      (ps_test1$category == "Violent/Sexual")&
        (ps_test1$risk_ass == "HIGH")&
        (ps_test1$sus_age_bin == "29-32")],
    df_vso_h_29$n[df_vso_h_29$Arm == "Comparison"] / n_comp
  )

  expect_equal(
    ps_test1$ratio[
      (ps_test1$category == "Violent/Sexual")&
        (ps_test1$risk_ass == "HIGH")&
        (ps_test1$sus_age_bin == "29-32")],

    (df_vso_h_29$n[df_vso_h_29$Arm == "Intervention"] / n_int) /
      (df_vso_h_29$n[df_vso_h_29$Arm == "Comparison"] / n_comp)
  )

  ## Test propscore. Using rescale(1) so should divide all ratios by largest ratio value

  pz1_val = 1 / max(ps_test1$ratio[!is.infinite(ps_test1$ratio)])

  expect_equal(
    ps_test1$PropScore[
      (ps_test1$category == "Theft / CD")&
        (ps_test1$risk_ass == "HIGH")&
        (ps_test1$sus_age_bin == "Under 29")],
    pz1_val * (df_tcd_h_u29$n[df_tcd_h_u29$Arm == "Intervention"] / n_int) /
      (df_tcd_h_u29$n[df_tcd_h_u29$Arm == "Comparison"] / n_comp)
  )


  expect_equal(
    ps_test1$PropScore[
      (ps_test1$category == "Violent/Sexual")&
        (ps_test1$risk_ass == "HIGH")&
        (ps_test1$sus_age_bin == "29-32")],
    pz1_val * (df_vso_h_29$n[df_vso_h_29$Arm == "Intervention"] / n_int) /
      (df_vso_h_29$n[df_vso_h_29$Arm == "Comparison"] / n_comp)
  )

  })

test_that("Marginal, estimate of 0.01", {

    ps_test2 = propscores(
      df = eg_data,
      cov_cols = c("risk_ass", "category", "sus_age_bin"),
      arm_col = "Arm",
      intervention_level = "Intervention",
      cov_dist = "marginal",
      pz1_fn = pz1_estimate(0.01)
    )
    expect_snapshot(
      ps_test2
    )

    expect_equal(
      sum(ps_test2$px_int),
      1
    )
    expect_equal(
      sum(ps_test2$px_comp),
      1
    )



    ## Choose some combinations and calculate by hand

    # Course of conduct, MEDIUM, 33-39
    # Theft / CD, MEDIUM, 33-39
    eg_notna = eg_data |>
      tidyr::drop_na(any_of(c("risk_ass", "category", "sus_age_bin")))
    tot_int = sum(eg_notna$Arm == "Intervention")
    tot_comp = sum(eg_notna$Arm == "Comparison")
 ## Marginal tables
    ra_marg = eg_notna |>
#      tidyr::drop_na(all_of("risk_ass")) |>
      dplyr::group_by(risk_ass) |>
      dplyr::summarise(
        n_int = sum(Arm == "Intervention"),
        n_comp = sum(Arm == "Comparison"),
        prop_int = n_int / tot_int,
        prop_comp = n_comp / tot_comp
      )
    cat_marg = eg_notna |>
#      tidyr::drop_na(all_of("category")) |>
      dplyr::group_by(category) |>
      dplyr::summarise(
        n_int = sum(Arm == "Intervention"),
        n_comp = sum(Arm == "Comparison"),
        prop_int = n_int / tot_int,
        prop_comp = n_comp / tot_comp
      )
    susage_marg = eg_notna |>
#      tidyr::drop_na(all_of("sus_age_bin")) |>
      dplyr::group_by(sus_age_bin) |>
      dplyr::summarise(
        n_int = sum(Arm == "Intervention"),
        n_comp = sum(Arm == "Comparison"),
        prop_int = n_int / tot_int,
        prop_comp = n_comp / tot_comp
      )

    ## Find p_int and p_comp for combinations

    ### CoC, M, 33-39
    pint_coc_m_33 = susage_marg$prop_int[susage_marg$sus_age_bin == "33-39"]*
      ra_marg$prop_int[ra_marg$risk_ass == "MEDIUM"] *
      cat_marg$prop_int[cat_marg$category == "Course of conduct"]
    pcomp_coc_m_33 = susage_marg$prop_comp[susage_marg$sus_age_bin == "33-39"]*
      ra_marg$prop_comp[ra_marg$risk_ass == "MEDIUM"] *
      cat_marg$prop_comp[cat_marg$category == "Course of conduct"]
    expect_equal(
      ps_test2$px_int[
        (ps_test2$category == "Course of conduct")&
          (ps_test2$risk_ass == "MEDIUM")&
          (ps_test2$sus_age_bin == "33-39")],
      susage_marg$prop_int[susage_marg$sus_age_bin == "33-39"]*
        ra_marg$prop_int[ra_marg$risk_ass == "MEDIUM"] *
        cat_marg$prop_int[cat_marg$category == "Course of conduct"]
    )

    expect_equal(
      ps_test2$px_comp[
        (ps_test2$category == "Course of conduct")&
          (ps_test2$risk_ass == "MEDIUM")&
          (ps_test2$sus_age_bin == "33-39")],
      pcomp_coc_m_33
    )

    expect_equal(
      pint_coc_m_33 / pcomp_coc_m_33,
      ps_test2$ratio[
        (ps_test2$category == "Course of conduct")&
          (ps_test2$risk_ass == "MEDIUM")&
          (ps_test2$sus_age_bin == "33-39")]
    )

    expect_equal(
      0.01*pint_coc_m_33 / pcomp_coc_m_33,
      ps_test2$PropScore[
        (ps_test2$category == "Course of conduct")&
          (ps_test2$risk_ass == "MEDIUM")&
          (ps_test2$sus_age_bin == "33-39")]
    )

    ### Theft / CD, M, 33-39
    pint_tcd_m_33 = susage_marg$prop_int[susage_marg$sus_age_bin == "33-39"]*
      ra_marg$prop_int[ra_marg$risk_ass == "MEDIUM"] *
      cat_marg$prop_int[cat_marg$category == "Theft / CD"]
    pcomp_tcd_m_33 = susage_marg$prop_comp[susage_marg$sus_age_bin == "33-39"]*
      ra_marg$prop_comp[ra_marg$risk_ass == "MEDIUM"] *
      cat_marg$prop_comp[cat_marg$category == "Theft / CD"]


    expect_equal(
      ps_test2$px_int[
        (ps_test2$category == "Theft / CD")&
          (ps_test2$risk_ass == "MEDIUM")&
          (ps_test2$sus_age_bin == "33-39")],
      pint_tcd_m_33
    )

    expect_equal(
      ps_test2$px_comp[
        (ps_test2$category == "Theft / CD")&
          (ps_test2$risk_ass == "MEDIUM")&
          (ps_test2$sus_age_bin == "33-39")],
      pcomp_tcd_m_33
    )

    expect_equal(
      pint_tcd_m_33 / pcomp_tcd_m_33,
      ps_test2$ratio[
        (ps_test2$category == "Theft / CD")&
          (ps_test2$risk_ass == "MEDIUM")&
          (ps_test2$sus_age_bin == "33-39")]
    )

    expect_equal(
      0.01*pint_tcd_m_33 / pcomp_tcd_m_33,
      ps_test2$PropScore[
        (ps_test2$category == "Theft / CD")&
          (ps_test2$risk_ass == "MEDIUM")&
          (ps_test2$sus_age_bin == "33-39")]
    )


    })




test_that("List, expected N of 300", {
  expect_snapshot(
    propscores(
      df = eg_data,
      cov_cols = c("risk_ass", "category", "sus_age_bin"),
      arm_col = "Arm",
      intervention_level = "Intervention",
      cov_dist = list(c("risk_ass", "category")),
      pz1_fn = pz1_expectedN(300)
    )
  )})

## Tests if it works with character columns

eg_data_char = eg_data
eg_data_char$risk_ass = as.character(eg_data$risk_ass)
eg_data_char$category = as.character(eg_data$category)


test_that("Char, Joint, rescale to 1.5", {
  expect_snapshot(
    propscores(
      df = eg_data_char,
      cov_cols = c("risk_ass", "category", "sus_age_bin"),
      arm_col = "Arm",
      intervention_level = "Intervention",
      cov_dist = "joint",
      pz1_fn = pz1_rescale(1)
    )
  )})

test_that("Char, Marginal, estimate of 0.01", {
  expect_snapshot(
    propscores(
      df = eg_data_char,
      cov_cols = c("risk_ass", "category", "sus_age_bin"),
      arm_col = "Arm",
      intervention_level = "Intervention",
      cov_dist = "marginal",
      pz1_fn = pz1_estimate(0.01)
    )
  )})


test_that("Char, List, expected N of 300", {
  expect_snapshot(
    propscores(
      df = eg_data_char,
      cov_cols = c("risk_ass", "category", "sus_age_bin"),
      arm_col = "Arm",
      intervention_level = "Intervention",
      cov_dist = list(c("risk_ass", "category")),
      pz1_fn = pz1_expectedN(300)
    )
  )})

## Suggested by chatGPT

test_that("mixed covariate distributions are accepted", {
  dat <- data.frame(
    group = c("treated", "treated", "control", "control"),
    x = factor(c("A", "B", "A", "B")),
    y = factor(c("low", "high", "low", "high"))
  )

  ps <- propscores(
    df = dat,
    cov_cols = c("x", "y"),
    arm_col = "group",
    intervention_level = "treated",
    cov_dist = list("x"),
    pz1_fn = pz1_estimate(0.5)
  )

  expect_true(is.data.frame(ps))
  expect_true(all(c("x", "y", "PropScore") %in% names(ps)))
  expect_equal(nrow(ps), 4L)
})

test_that("invalid covariate groups name the missing covariate", {
  dat <- data.frame(
    Arm = factor(c("Intervention", "Comparison")),
    x = factor(c("A", "B"))
  )

  expect_error(
    .props_fun(
      df = dat,
      cov_cols = "x",
      cov_list = list("missing_variable")
    ),
    "missing_variable"
  )
})
