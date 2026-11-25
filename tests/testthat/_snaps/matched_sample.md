# With replacement, not dropping

    Code
      matched_sample(df = fm_data, propscores = eg_mix_exp100, cov_cols = c(
        "category", "risk_ass", "sus_age_bin"), arm_col = "FM_equip", use_attr = F,
      intervention_level = TRUE, seed = 20, sampling = "repeat", drop_int = F)
    Message
      There are 1 NA values in the category column. These rows will be lost.
      There are 1 NA values in the sus_age_bin column. These rows will be lost.
    Output
      # A tibble: 997 x 22
         FM_equip risk_ass category       victim_age suspect_age sus_age_bin nprev_sus
       * <lgl>    <fct>    <fct>               <dbl>       <dbl> <fct>           <dbl>
       1 TRUE     MEDIUM   Violent/Sexual         28          35 33-39               0
       2 TRUE     MEDIUM   Violent/Sexual         28          35 33-39               0
       3 TRUE     MEDIUM   Violent/Sexual         28          35 33-39               0
       4 TRUE     HIGH     Violent/Sexual         35          35 33-39               3
       5 TRUE     HIGH     Violent/Sexual         34          37 33-39               0
       6 TRUE     MEDIUM   Course of con~         51          54 40+                 0
       7 TRUE     HIGH     Course of con~         60          41 40+                 1
       8 TRUE     HIGH     Course of con~         39          23 Under 29            1
       9 TRUE     HIGH     Violent/Sexual         31          28 Under 29            1
      10 TRUE     HIGH     Violent/Sexual         34          36 33-39               1
      # i 987 more rows
      # i 15 more variables: nprev_sus_bin <fct>, arm_given <tibble[,1]>, Arm <chr>,
      #   include <dbl>, p_int_risk_ass.category <dbl>,
      #   p_comp_risk_ass.category <dbl>, p_int_sus_age_bin <dbl>,
      #   p_comp_sus_age_bin <dbl>, px_int <dbl>, px_comp <dbl>, ratio <dbl>,
      #   count_comp <int>, count_int <int>, PropScore <dbl>, seed <dbl>

---

    Code
      matched_sample(df = fm_data, propscores = eg_m_resc15, cov_cols = c("category",
        "risk_ass", "sus_age_bin"), arm_col = "FM_equip", use_attr = F,
      intervention_level = TRUE, seed = 20, sampling = "repeat", drop_int = F)
    Message
      There are 1 NA values in the category column. These rows will be lost.
      There are 1 NA values in the sus_age_bin column. These rows will be lost.
      47 comparison cases are being repeated 2 times
    Output
      # A tibble: 997 x 24
         FM_equip risk_ass category       victim_age suspect_age sus_age_bin nprev_sus
       * <lgl>    <fct>    <fct>               <dbl>       <dbl> <fct>           <dbl>
       1 TRUE     MEDIUM   Violent/Sexual         28          35 33-39               0
       2 TRUE     MEDIUM   Violent/Sexual         28          35 33-39               0
       3 TRUE     MEDIUM   Violent/Sexual         28          35 33-39               0
       4 TRUE     HIGH     Violent/Sexual         35          35 33-39               3
       5 TRUE     HIGH     Violent/Sexual         34          37 33-39               0
       6 TRUE     MEDIUM   Course of con~         51          54 40+                 0
       7 TRUE     HIGH     Course of con~         60          41 40+                 1
       8 TRUE     HIGH     Course of con~         39          23 Under 29            1
       9 TRUE     HIGH     Violent/Sexual         31          28 Under 29            1
      10 TRUE     HIGH     Violent/Sexual         34          36 33-39               1
      # i 987 more rows
      # i 17 more variables: nprev_sus_bin <fct>, arm_given <tibble[,1]>, Arm <chr>,
      #   include <dbl>, p_int_risk_ass <dbl>, p_comp_risk_ass <dbl>,
      #   p_int_category <dbl>, p_comp_category <dbl>, p_int_sus_age_bin <dbl>,
      #   p_comp_sus_age_bin <dbl>, px_int <dbl>, px_comp <dbl>, ratio <dbl>,
      #   count_comp <int>, count_int <int>, PropScore <dbl>, seed <dbl>

---

    Code
      matched_sample(df = fm_data, propscores = eg_m_resc15, seed = 20, sampling = "repeat",
        drop_int = F)
    Message
      There are 1 NA values in the category column. These rows will be lost.
      There are 1 NA values in the sus_age_bin column. These rows will be lost.
      47 comparison cases are being repeated 2 times
    Output
      # A tibble: 997 x 24
         FM_equip risk_ass category       victim_age suspect_age sus_age_bin nprev_sus
       * <lgl>    <fct>    <fct>               <dbl>       <dbl> <fct>           <dbl>
       1 TRUE     MEDIUM   Violent/Sexual         28          35 33-39               0
       2 TRUE     MEDIUM   Violent/Sexual         28          35 33-39               0
       3 TRUE     MEDIUM   Violent/Sexual         28          35 33-39               0
       4 TRUE     HIGH     Violent/Sexual         35          35 33-39               3
       5 TRUE     HIGH     Violent/Sexual         34          37 33-39               0
       6 TRUE     MEDIUM   Course of con~         51          54 40+                 0
       7 TRUE     HIGH     Course of con~         60          41 40+                 1
       8 TRUE     HIGH     Course of con~         39          23 Under 29            1
       9 TRUE     HIGH     Violent/Sexual         31          28 Under 29            1
      10 TRUE     HIGH     Violent/Sexual         34          36 33-39               1
      # i 987 more rows
      # i 17 more variables: nprev_sus_bin <fct>, arm_given <tibble[,1]>, Arm <chr>,
      #   include <dbl>, p_int_risk_ass <dbl>, p_comp_risk_ass <dbl>,
      #   p_int_category <dbl>, p_comp_category <dbl>, p_int_sus_age_bin <dbl>,
      #   p_comp_sus_age_bin <dbl>, px_int <dbl>, px_comp <dbl>, ratio <dbl>,
      #   count_comp <int>, count_int <int>, PropScore <dbl>, seed <dbl>

# downsampling, dropping

    Code
      matched_sample(df = fm_data, propscores = eg_m_resc15, cov_cols = c("category",
        "risk_ass", "sus_age_bin"), arm_col = "FM_equip", intervention_level = TRUE,
      use_attr = F, seed = 20, sampling = "downsample", drop_int = T)
    Message
      There are 1 NA values in the category column. These rows will be lost.
      There are 1 NA values in the sus_age_bin column. These rows will be lost.
      27 intervention cases have beeen downsampled
    Output
      # A tibble: 997 x 24
         FM_equip risk_ass category       victim_age suspect_age sus_age_bin nprev_sus
       * <lgl>    <fct>    <fct>               <dbl>       <dbl> <fct>           <dbl>
       1 TRUE     MEDIUM   Violent/Sexual         28          35 33-39               0
       2 TRUE     MEDIUM   Violent/Sexual         28          35 33-39               0
       3 TRUE     MEDIUM   Violent/Sexual         28          35 33-39               0
       4 TRUE     HIGH     Violent/Sexual         35          35 33-39               3
       5 TRUE     HIGH     Violent/Sexual         34          37 33-39               0
       6 TRUE     MEDIUM   Course of con~         51          54 40+                 0
       7 TRUE     HIGH     Course of con~         60          41 40+                 1
       8 TRUE     HIGH     Course of con~         39          23 Under 29            1
       9 TRUE     HIGH     Violent/Sexual         31          28 Under 29            1
      10 TRUE     HIGH     Violent/Sexual         34          36 33-39               1
      # i 987 more rows
      # i 17 more variables: nprev_sus_bin <fct>, arm_given <tibble[,1]>, Arm <chr>,
      #   include <dbl>, p_int_risk_ass <dbl>, p_comp_risk_ass <dbl>,
      #   p_int_category <dbl>, p_comp_category <dbl>, p_int_sus_age_bin <dbl>,
      #   p_comp_sus_age_bin <dbl>, px_int <dbl>, px_comp <dbl>, ratio <dbl>,
      #   count_comp <int>, count_int <int>, PropScore <dbl>, seed <dbl>

---

    Code
      matched_sample(df = fm_data, propscores = eg_m_resc15, seed = 20, sampling = "downsample",
        drop_int = T)
    Message
      There are 1 NA values in the category column. These rows will be lost.
      There are 1 NA values in the sus_age_bin column. These rows will be lost.
      27 intervention cases have beeen downsampled
    Output
      # A tibble: 997 x 24
         FM_equip risk_ass category       victim_age suspect_age sus_age_bin nprev_sus
       * <lgl>    <fct>    <fct>               <dbl>       <dbl> <fct>           <dbl>
       1 TRUE     MEDIUM   Violent/Sexual         28          35 33-39               0
       2 TRUE     MEDIUM   Violent/Sexual         28          35 33-39               0
       3 TRUE     MEDIUM   Violent/Sexual         28          35 33-39               0
       4 TRUE     HIGH     Violent/Sexual         35          35 33-39               3
       5 TRUE     HIGH     Violent/Sexual         34          37 33-39               0
       6 TRUE     MEDIUM   Course of con~         51          54 40+                 0
       7 TRUE     HIGH     Course of con~         60          41 40+                 1
       8 TRUE     HIGH     Course of con~         39          23 Under 29            1
       9 TRUE     HIGH     Violent/Sexual         31          28 Under 29            1
      10 TRUE     HIGH     Violent/Sexual         34          36 33-39               1
      # i 987 more rows
      # i 17 more variables: nprev_sus_bin <fct>, arm_given <tibble[,1]>, Arm <chr>,
      #   include <dbl>, p_int_risk_ass <dbl>, p_comp_risk_ass <dbl>,
      #   p_int_category <dbl>, p_comp_category <dbl>, p_int_sus_age_bin <dbl>,
      #   p_comp_sus_age_bin <dbl>, px_int <dbl>, px_comp <dbl>, ratio <dbl>,
      #   count_comp <int>, count_int <int>, PropScore <dbl>, seed <dbl>

# With replacement, not dropping. Upper case repeat

    Code
      matched_sample(df = fm_data, propscores = eg_mix_exp100, seed = 20, sampling = "RepEat",
        drop_int = F)
    Message
      There are 1 NA values in the category column. These rows will be lost.
      There are 1 NA values in the sus_age_bin column. These rows will be lost.
    Output
      # A tibble: 997 x 22
         FM_equip risk_ass category       victim_age suspect_age sus_age_bin nprev_sus
       * <lgl>    <fct>    <fct>               <dbl>       <dbl> <fct>           <dbl>
       1 TRUE     MEDIUM   Violent/Sexual         28          35 33-39               0
       2 TRUE     MEDIUM   Violent/Sexual         28          35 33-39               0
       3 TRUE     MEDIUM   Violent/Sexual         28          35 33-39               0
       4 TRUE     HIGH     Violent/Sexual         35          35 33-39               3
       5 TRUE     HIGH     Violent/Sexual         34          37 33-39               0
       6 TRUE     MEDIUM   Course of con~         51          54 40+                 0
       7 TRUE     HIGH     Course of con~         60          41 40+                 1
       8 TRUE     HIGH     Course of con~         39          23 Under 29            1
       9 TRUE     HIGH     Violent/Sexual         31          28 Under 29            1
      10 TRUE     HIGH     Violent/Sexual         34          36 33-39               1
      # i 987 more rows
      # i 15 more variables: nprev_sus_bin <fct>, arm_given <tibble[,1]>, Arm <chr>,
      #   include <dbl>, p_int_risk_ass.category <dbl>,
      #   p_comp_risk_ass.category <dbl>, p_int_sus_age_bin <dbl>,
      #   p_comp_sus_age_bin <dbl>, px_int <dbl>, px_comp <dbl>, ratio <dbl>,
      #   count_comp <int>, count_int <int>, PropScore <dbl>, seed <dbl>

