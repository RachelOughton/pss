# Joint, estimate 0.15

    Code
      candidates(df = fm_data, propscores = eg_j_est015, seeds = 3 * (1:10),
      smd_cols = c("risk_ass", "category", "sus_age_bin"), smd_order = 2)
    Message
      There are 1 NA values in the category column. These rows will be lost.
      There are 1 NA values in the sus_age_bin column. These rows will be lost.
    Output
      # A tibble: 10 x 10
          seed n_int n_comp SMD_risk_ass SMD_category SMD_sus_age_bin
         <dbl> <int>  <int>        <dbl>        <dbl>           <dbl>
       1     3   314     94      0.0269        0.0762          0.0953
       2     6   314    102      0.00452       0.141           0.0614
       3     9   314    100      0.0357        0.0481          0.120 
       4    12   314     96      0.00990       0.0911          0.168 
       5    15   314     98      0.0230        0.130           0.251 
       6    18   314    101      0.0448        0.136           0.154 
       7    21   314    108      0.119         0.0830          0.144 
       8    24   314    104      0.0817        0.0390          0.0418
       9    27   314    100      0.0581        0.158           0.145 
      10    30   314    118      0.0560        0.117           0.149 
      # i 4 more variables: SMD_category.risk_ass <dbl>,
      #   SMD_risk_ass.sus_age_bin <dbl>, SMD_category.sus_age_bin <dbl>,
      #   max_SMD <dbl>

---

    Code
      candidates(df = fm_data, propscores = eg_j_est015, seeds = 3 * (1:10),
      smd_cols = c("risk_ass", "category", "sus_age_bin"), smd_order = 2, sampling = "downsample")
    Message
      There are 1 NA values in the category column. These rows will be lost.
      There are 1 NA values in the sus_age_bin column. These rows will be lost.
    Output
      # A tibble: 10 x 10
          seed n_int n_comp SMD_risk_ass SMD_category SMD_sus_age_bin
         <dbl> <int>  <int>        <dbl>        <dbl>           <dbl>
       1     3   313    104     0.0838         0.182           0.105 
       2     6   313    112     0.0141         0.109           0.131 
       3     9   313     89     0.0859         0.0912          0.201 
       4    12   313    106     0.0512         0.200           0.137 
       5    15   313    101     0.000208       0.0692          0.0879
       6    18   313    111     0.101          0.176           0.184 
       7    21   313     99     0.100          0.0522          0.130 
       8    24   313    117     0.0780         0.234           0.147 
       9    27   313     99     0.0541         0.118           0.126 
      10    30   313    112     0.0141         0.0644          0.163 
      # i 4 more variables: SMD_category.risk_ass <dbl>,
      #   SMD_risk_ass.sus_age_bin <dbl>, SMD_category.sus_age_bin <dbl>,
      #   max_SMD <dbl>

# Marginal, rescale to 1.25

    Code
      candidates(df = fm_data, propscores = eg_m_resc125, seeds = 3 * (1:10),
      smd_cols = c("risk_ass", "category", "sus_age_bin"), smd_order = 2)
    Message
      There are 1 NA values in the category column. These rows will be lost.
      There are 1 NA values in the sus_age_bin column. These rows will be lost.
    Output
      # A tibble: 10 x 10
          seed n_int n_comp SMD_risk_ass SMD_category SMD_sus_age_bin
         <dbl> <int>  <int>        <dbl>        <dbl>           <dbl>
       1     3   314    255      0.00407       0.106           0.0769
       2     6   314    264      0.0777        0.0733          0.0922
       3     9   314    243      0.0731        0.0335          0.0828
       4    12   314    264      0.0435        0.0836          0.102 
       5    15   314    252      0.0946        0.0414          0.182 
       6    18   314    263      0.0412        0.0738          0.102 
       7    21   314    273      0.0475        0.0583          0.102 
       8    24   314    271      0.0140        0.0487          0.0634
       9    27   314    266      0.01000       0.0130          0.124 
      10    30   314    275      0.113         0.0566          0.0930
      # i 4 more variables: SMD_category.risk_ass <dbl>,
      #   SMD_risk_ass.sus_age_bin <dbl>, SMD_category.sus_age_bin <dbl>,
      #   max_SMD <dbl>

---

    Code
      candidates(df = fm_data, propscores = eg_m_resc125, seeds = 3 * (1:10),
      smd_cols = c("risk_ass", "category", "sus_age_bin"), smd_order = 2, sampling = "downsample")
    Message
      There are 1 NA values in the category column. These rows will be lost.
      There are 1 NA values in the sus_age_bin column. These rows will be lost.
    Output
      # A tibble: 10 x 10
          seed n_int n_comp SMD_risk_ass SMD_category SMD_sus_age_bin
         <dbl> <int>  <int>        <dbl>        <dbl>           <dbl>
       1     3   310    240       0.0835      0.0994           0.0524
       2     6   306    249       0.0235      0.145            0.101 
       3     9   308    255       0.0344      0.133            0.0911
       4    12   305    256       0.0783      0.0845           0.120 
       5    15   306    251       0.0199      0.0245           0.0955
       6    18   307    259       0.0723      0.145            0.0561
       7    21   310    244       0.0198      0.0256           0.0555
       8    24   309    260       0.0229      0.0841           0.117 
       9    27   308    258       0.0176      0.0505           0.0890
      10    30   307    258       0.0322      0.00875          0.106 
      # i 4 more variables: SMD_category.risk_ass <dbl>,
      #   SMD_risk_ass.sus_age_bin <dbl>, SMD_category.sus_age_bin <dbl>,
      #   max_SMD <dbl>

# semi-marginal, expectedN 300

    Code
      candidates(df = fm_data, propscores = eg_mix_exp300, seeds = 3 * (1:10),
      smd_cols = c("risk_ass", "category", "sus_age_bin", "suspect_age"), smd_order = 2)
    Message
      There are 1 NA values in the category column. These rows will be lost.
      There are 1 NA values in the sus_age_bin column. These rows will be lost.
      The interaction SMD will not include suspect_age as it does not have class factor or character
    Output
      # A tibble: 10 x 11
          seed n_int n_comp SMD_risk_ass SMD_category SMD_sus_age_bin SMD_suspect_age
         <dbl> <int>  <int>        <dbl>        <dbl>           <dbl>           <dbl>
       1     3   314    293       0.0900       0.0602          0.0800        -0.0310 
       2     6   314    313       0.0160       0.0713          0.0517         0.0239 
       3     9   314    284       0.112        0.168           0.162         -0.0578 
       4    12   314    310       0.0200       0.0370          0.117         -0.0195 
       5    15   314    286       0.0520       0.0829          0.174         -0.110  
       6    18   314    303       0.0306       0.0156          0.135         -0.0860 
       7    21   314    284       0.0751       0.144           0.122         -0.0260 
       8    24   314    319       0.0102       0.114           0.136          0.0580 
       9    27   314    299       0.0486       0.126           0.0454         0.0376 
      10    30   314    331       0.0391       0.112           0.0505        -0.00648
      # i 4 more variables: SMD_category.risk_ass <dbl>,
      #   SMD_risk_ass.sus_age_bin <dbl>, SMD_category.sus_age_bin <dbl>,
      #   max_SMD <dbl>

---

    Code
      candidates(df = fm_data, propscores = eg_mix_exp300, seeds = 3 * (1:10),
      smd_cols = c("risk_ass", "category", "sus_age_bin", "suspect_age"), smd_order = 2,
      sampling = "downsample")
    Message
      There are 1 NA values in the category column. These rows will be lost.
      There are 1 NA values in the sus_age_bin column. These rows will be lost.
      The interaction SMD will not include suspect_age as it does not have class factor or character
    Output
      # A tibble: 10 x 11
          seed n_int n_comp SMD_risk_ass SMD_category SMD_sus_age_bin SMD_suspect_age
         <dbl> <int>  <int>        <dbl>        <dbl>           <dbl>           <dbl>
       1     3   292    270      0.0481        0.0803          0.0691          0.0426
       2     6   298    273      0.00633       0.0697          0.0807          0.0145
       3     9   295    266      0.0314        0.176           0.130           0.0159
       4    12   291    280      0.0114        0.0758          0.141          -0.0225
       5    15   293    269      0.0845        0.0887          0.142          -0.0332
       6    18   294    275      0.0633        0.171           0.114           0.0328
       7    21   296    261      0.0670        0.0440          0.0767         -0.0254
       8    24   294    277      0.00293       0.175           0.0977         -0.0160
       9    27   294    285      0.0363        0.0621          0.104          -0.0234
      10    30   298    284      0.0554        0.0646          0.0817         -0.0186
      # i 4 more variables: SMD_category.risk_ass <dbl>,
      #   SMD_risk_ass.sus_age_bin <dbl>, SMD_category.sus_age_bin <dbl>,
      #   max_SMD <dbl>

