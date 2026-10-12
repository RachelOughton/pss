# Joint, estimate 0.15

    Code
      summary_table(df = eg_data, propscore_df = eg_j_est015, seeds = 3 * (1:10),
      smd_cols = c("risk_ass", "category", "sus_age_bin"), smd_order = 2)
    Condition
      Warning:
      Using an external vector in selections was deprecated in tidyselect 1.1.0.
      i Please use `all_of()` or `any_of()` instead.
        # Was:
        data %>% select(smd_cols)
      
        # Now:
        data %>% select(all_of(smd_cols))
      
      See <https://tidyselect.r-lib.org/reference/faq-external-vector.html>.
    Output
         seed n_int n_comp SMD_risk_ass SMD_category SMD_sus_age_bin
      1     3   314     94  0.026854155   0.07615675      0.09533943
      2     6   314    102  0.004518001   0.14075163      0.06139771
      3     9   314    100  0.035729512   0.04806793      0.12023647
      4    12   314     96  0.009903775   0.09114895      0.16842661
      5    15   314     98  0.023040026   0.13034314      0.25137817
      6    18   314    101  0.044808334   0.13633514      0.15353654
      7    21   314    108  0.119170031   0.08299058      0.14392437
      8    24   314    104  0.081688676   0.03899226      0.04179963
      9    27   314    100  0.058134154   0.15840113      0.14500867
      10   30   314    118  0.055971169   0.11661176      0.14913243
         SMD_category.risk_ass SMD_risk_ass.sus_age_bin SMD_category.sus_age_bin
      1              0.1236575                0.1258670                0.2154596
      2              0.2575572                0.2252311                0.2144640
      3              0.1720481                0.1524152                0.2509319
      4              0.1639817                0.2374718                0.2947800
      5              0.1622458                0.3054504                0.3470668
      6              0.1550893                0.2361212                0.2709662
      7              0.1545328                0.2053670                0.2642659
      8              0.2298722                0.1242607                0.2100347
      9              0.1757027                0.1976414                0.3492915
      10             0.1629946                0.1845843                0.2227039

# Marginal, rescale to 1.25

    Code
      summary_table(df = eg_data, propscore_df = eg_m_resc125, seeds = 3 * (1:10),
      smd_cols = c("risk_ass", "category", "sus_age_bin"), smd_order = 2)
    Condition
      Warning:
      Using an external vector in selections was deprecated in tidyselect 1.1.0.
      i Please use `all_of()` or `any_of()` instead.
        # Was:
        data %>% select(smd_cols)
      
        # Now:
        data %>% select(all_of(smd_cols))
      
      See <https://tidyselect.r-lib.org/reference/faq-external-vector.html>.
    Output
         seed n_int n_comp SMD_risk_ass SMD_category SMD_sus_age_bin
      1     3   314    271  0.002137366   0.07880662      0.12321196
      2     6   314    260  0.034016672   0.07145222      0.09632305
      3     9   314    262  0.038792759   0.01776858      0.09915115
      4    12   314    256  0.041655546   0.09018603      0.10928228
      5    15   314    261  0.005845250   0.10257163      0.07314550
      6    18   314    272  0.011561806   0.03736242      0.11579070
      7    21   314    273  0.023040026   0.04456020      0.16514290
      8    24   314    261  0.027892562   0.03045506      0.08562178
      9    27   314    259  0.014509962   0.04587796      0.08511775
      10   30   314    287  0.082533217   0.01676685      0.10095276
         SMD_category.risk_ass SMD_risk_ass.sus_age_bin SMD_category.sus_age_bin
      1              0.1337918                0.2766565                0.2394079
      2              0.1735660                0.2289073                0.2956460
      3              0.2381360                0.2416517                0.2359761
      4              0.2733120                0.1867496                0.2705525
      5              0.3317203                0.2478606                0.3063126
      6              0.2652390                0.2406880                0.2222438
      7              0.1626887                0.2355262                0.3027171
      8              0.1786641                0.2260419                0.2414521
      9              0.1809748                0.2779310                0.1628521
      10             0.2118804                0.2466143                0.2308721

# semi-marginal, expectedN 300

    Code
      summary_table(df = eg_data, propscore_df = eg_mix_exp300, seeds = 3 * (1:10),
      smd_cols = c("risk_ass", "category", "sus_age_bin", "suspect_age"), smd_order = 2)
    Condition
      Warning:
      Using an external vector in selections was deprecated in tidyselect 1.1.0.
      i Please use `all_of()` or `any_of()` instead.
        # Was:
        data %>% select(smd_cols)
      
        # Now:
        data %>% select(all_of(smd_cols))
      
      See <https://tidyselect.r-lib.org/reference/faq-external-vector.html>.
    Message
      The interaction SMD will not include suspect_age as it does not have class factor or character
    Output
         seed n_int n_comp SMD_risk_ass SMD_category SMD_sus_age_bin SMD_suspect_age
      1     3   314    309  0.024542045   0.07567564      0.06934031     0.009937629
      2     6   314    297  0.036929953   0.12757402      0.08413404     0.047029446
      3     9   314    286  0.059868549   0.10065002      0.11490784    -0.033070774
      4    12   314    292  0.064628644   0.15082591      0.14393851    -0.001155487
      5    15   314    297  0.007620035   0.19038060      0.09836343    -0.010084599
      6    18   314    305  0.026174319   0.05957741      0.12329980    -0.057841068
      7    21   314    299  0.003240358   0.06554184      0.09032276     0.010457368
      8    24   314    296  0.049929223   0.01090390      0.08352243     0.034418307
      9    27   314    305  0.004774726   0.05722204      0.08722132    -0.009964491
      10   30   314    326  0.069189300   0.08960828      0.12384970    -0.026830559
         SMD_category.risk_ass SMD_risk_ass.sus_age_bin SMD_category.sus_age_bin
      1              0.1543244                0.2772759                0.1336860
      2              0.2331970                0.2402098                0.2251493
      3              0.2624777                0.2665566                0.1976791
      4              0.3085345                0.2363759                0.2554107
      5              0.3163044                0.2786104                0.2618697
      6              0.3015558                0.2419910                0.1822824
      7              0.1758047                0.2304326                0.1735795
      8              0.1792616                0.2202222                0.1644759
      9              0.2157432                0.2738549                0.1799488
      10             0.2297505                0.2695518                0.1868685

