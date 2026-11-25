# my output looks right

    Code
      pss_check_data(df = fm_data, cov_cols = c("risk_ass", "category", "sus_age_bin"),
      arm_col = "FM_equip", intervention_level = TRUE)
    Message
      There are 1 NA values in the category column. These rows will be lost.
      There are 1 NA values in the sus_age_bin column. These rows will be lost.
    Output
      # A tibble: 997 x 10
         FM_equip risk_ass category       victim_age suspect_age sus_age_bin nprev_sus
         <lgl>    <fct>    <fct>               <dbl>       <dbl> <fct>           <dbl>
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
      # i 3 more variables: nprev_sus_bin <fct>, arm_given <tibble[,1]>, Arm <chr>

