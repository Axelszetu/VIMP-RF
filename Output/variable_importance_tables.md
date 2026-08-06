# Variable importance results

## Raw values

Table: Raw variable importance measures

|                                 | Effects| Permutation| Minimal.depth| ATE.RF| ATE.logreg|
|:--------------------------------|-------:|-----------:|-------------:|------:|----------:|
|sex                              |   1.000|       0.061|           3.7|  0.026|      0.152|
|diag12sl_atrial_fibrillation     |   0.976|       0.010|           3.7|  0.243|      0.300|
|diag12sl_atrial_flutter          |   0.951|       0.000|           8.5|  0.169|      0.350|
|diag12sl_first_degree_av_block   |   0.927|       0.000|           5.5|  0.000|      0.000|
|diag12sl_sec_deg_avblock_type_i  |   0.902|       0.000|           8.5|  0.171|      0.341|
|diag12sl_sec_deg_avblock_type_ii |   0.878|       0.000|           8.5|  0.000|      0.000|
|diag12sl_third_degree_av_block   |   0.854|       0.000|           8.5|  0.000|      0.000|
|diag12sl_lbbb                    |   0.829|       0.000|           7.4|  0.000|      0.000|
|diag12sl_rbbb                    |   0.805|      -0.010|           7.1| -0.070|     -0.476|
|diag12sl_left_ant_fascic_block   |   0.780|       0.000|           8.5| -0.060|     -0.256|
|diag12sl_left_post_fascic_block  |   0.756|       0.000|           8.5|  0.000|      0.000|
|diag12sl_bifascicular_block      |   0.732|       0.000|           8.5|  0.000|      0.000|
|diag12sl_early_repolarization    |   0.707|       0.000|           7.8|  0.000|      0.000|
|diagmanual_qwave                 |   0.683|       0.000|           5.7|  0.034|      0.303|
|diagmanual_stdep                 |   0.659|       0.000|           7.1|  0.021|      0.070|
|diagmanual_stele                 |   0.634|       0.000|           6.9| -0.042|     -0.474|
|diagmanual_lvh                   |   0.610|       0.041|           5.5|  0.037|      0.000|
|qtcprol_all                      |   0.585|      -0.020|           5.0|  0.110|      0.346|
|statin_hyperlipidemia            |   0.561|       0.051|           3.7|  0.164|      0.153|
|diabetes_med                     |   0.537|       0.010|           5.0| -0.010|     -0.143|
|vasodilator                      |   0.512|      -0.010|           5.9|  0.098|      0.331|
|digoxin                          |   0.488|       0.000|           8.5|  0.000|      0.176|
|antiarrhythmics                  |   0.463|       0.000|           8.5|  0.000|     -0.680|
|betablocker                      |   0.439|       0.020|           5.4|  0.035|      0.090|
|ca_channel_blocker               |   0.415|       0.000|           5.1|  0.067|      0.246|
|other_qt_prolong                 |   0.390|       0.020|           5.2|  0.074|      0.233|
|cancer                           |   0.366|       0.000|           8.5|  0.000|      0.000|
|cardiomp                         |   0.341|       0.000|           8.5|  0.000|      0.000|
|cerebro_vasc                     |   0.317|      -0.010|           4.8| -0.127|     -0.249|
|cong_hd                          |   0.293|       0.000|           8.5|  0.003|      0.313|
|copd                             |   0.268|       0.000|           8.0|  0.000|     -0.670|
|hf                               |   0.244|       0.000|           8.5| -0.029|     -0.259|
|ihd                              |   0.220|       0.000|           6.4|  0.000|      0.000|
|liver                            |   0.195|       0.000|           8.5|  0.021|      0.297|
|peri_vasc                        |   0.171|       0.000|           7.6|  0.000|      0.320|
|prev_mi                          |   0.146|       0.000|           8.5|  0.000|      0.000|
|renal                            |   0.122|       0.000|           8.5|  0.003|      0.000|
|valve_hd                         |   0.098|       0.000|           7.8|  0.000|      0.000|
|other_arrhythm                   |   0.073|       0.000|           8.5|  0.005|      0.303|
|other_card                       |   0.049|       0.000|           8.2|  0.050|      0.340|
|afib_aflu                        |   0.024|       0.000|           6.7|  0.049|     -0.018|
|hypertension                     |   0.000|       0.020|           4.5|  0.000|      0.000|

## Ranks

Rank 1 indicates the variable ranked as most important.

Table: Ranks of variable importance measures

|                                 | Effects| Permutation| Minimal depth| ATE RF| ATE logreg|
|:--------------------------------|-------:|-----------:|-------------:|------:|----------:|
|sex                              |       1|           1|             6|     19|         25|
|diag12sl_atrial_fibrillation     |       2|           7|             8|      5|         13|
|diag12sl_atrial_flutter          |       3|          14|            32|      2|         11|
|diag12sl_first_degree_av_block   |       4|          10|            12|     20|         15|
|diag12sl_sec_deg_avblock_type_i  |       5|          18|            40|     13|         26|
|diag12sl_sec_deg_avblock_type_ii |       6|          18|            38|     32|         34|
|diag12sl_third_degree_av_block   |       7|          18|            40|     29|          8|
|diag12sl_lbbb                    |       8|          10|            24|     32|         34|
|diag12sl_rbbb                    |       9|          10|            10|      7|          2|
|diag12sl_left_ant_fascic_block   |      10|          37|            29|      6|         12|
|diag12sl_left_post_fascic_block  |      11|          18|            35|     15|         29|
|diag12sl_bifascicular_block      |      12|          18|            37|     18|          7|
|diag12sl_early_repolarization    |      13|          31|            30|     22|         10|
|diagmanual_qwave                 |      14|           3|             4|     38|         41|
|diagmanual_stdep                 |      15|          37|            15|     12|         18|
|diagmanual_stele                 |      16|           6|            14|     25|         30|
|diagmanual_lvh                   |      17|          37|            16|      1|          1|
|qtcprol_all                      |      18|          10|             7|     23|         27|
|statin_hyperlipidemia            |      19|           2|             5|     10|         21|
|diabetes_med                     |      20|          41|             3|     14|         17|
|vasodilator                      |      21|          31|            18|     24|         32|
|digoxin                          |      22|          37|            26|     11|         14|
|antiarrhythmics                  |      23|          13|            26|      9|         19|
|betablocker                      |      24|           4|             8|     35|         23|
|ca_channel_blocker               |      25|           4|             2|      3|         16|
|other_qt_prolong                 |      26|          42|            11|     17|         28|
|cancer                           |      27|          31|            21|     39|         31|
|cardiomp                         |      28|          31|            34|     21|          6|
|cerebro_vasc                     |      29|          37|            13|     37|         39|
|cong_hd                          |      30|          24|            40|     34|         20|
|copd                             |      31|          31|            23|     16|          4|
|hf                               |      32|          31|            32|      8|          3|
|ihd                              |      33|          40|            19|     26|          9|
|liver                            |      34|          24|            36|     41|         38|
|peri_vasc                        |      35|          24|            18|      4|          5|
|prev_mi                          |      36|          14|            20|     32|         34|
|renal                            |      37|          24|            40|     27|         24|
|valve_hd                         |      38|          24|            28|     28|         22|
|other_arrhythm                   |      39|          24|            27|     40|         42|
|other_card                       |      40|          24|            33|     42|         40|
|afib_aflu                        |      41|          10|            22|     36|         37|
|hypertension                     |      42|          31|             2|     32|         34|
