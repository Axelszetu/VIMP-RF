# Variable importance results

## Raw values

Table: Raw variable importance measures

|                                 | Effects| Permutation| Minimal depth| ATE RF| ATE logreg|
|:--------------------------------|-------:|-----------:|-------------:|------:|----------:|
|sex                              |     1.0|       0.091|           3.5| -0.017|      0.025|
|diag12sl_atrial_fibrillation     |     1.0|       0.020|           4.5|  0.178|      0.226|
|diag12sl_atrial_flutter          |     1.0|       0.000|          13.5|  0.266|      0.344|
|diag12sl_first_degree_av_block   |     1.0|       0.005|           4.5|  0.106|      0.271|
|diag12sl_sec_deg_avblock_type_i  |     0.5|       0.000|          26.6|  0.140|      0.183|
|diag12sl_sec_deg_avblock_type_ii |     0.5|       0.000|          18.8|  0.000|      0.000|
|diag12sl_third_degree_av_block   |     0.5|       0.000|          26.6|  0.071|      0.456|
|diag12sl_lbbb                    |     0.5|       0.001|          12.2|  0.000|      0.000|
|diag12sl_rbbb                    |     0.0|      -0.001|           5.2| -0.001|      0.043|
|diag12sl_left_ant_fascic_block   |     0.0|      -0.001|           7.2|  0.075|     -0.113|
|diag12sl_left_post_fascic_block  |     0.0|       0.000|          19.4| -0.104|     -0.083|
|diag12sl_bifascicular_block      |     0.0|      -0.001|          14.0|  0.070|      0.455|
|diag12sl_early_repolarization    |     0.0|      -0.002|          11.6|  0.096|      0.460|
|diagmanual_qwave                 |     0.0|       0.004|           4.6| -0.041|     -0.233|
|diagmanual_stdep                 |     0.0|       0.001|           8.3|  0.057|      0.113|
|diagmanual_stele                 |     0.0|       0.002|           6.2| -0.105|      0.052|
|diagmanual_lvh                   |     0.0|       0.003|           8.0|  0.002|      0.115|
|qtcprol_all                      |     0.0|       0.003|           4.4|  0.039|      0.082|
|statin_hyperlipidemia            |     0.0|      -0.001|           5.9| -0.022|     -0.002|
|diabetes_med                     |     0.0|       0.013|           5.2|  0.125|      0.054|
|vasodilator                      |     0.0|      -0.006|           8.3|  0.003|      0.067|
|digoxin                          |     0.0|      -0.003|           8.5|  0.048|      0.091|
|antiarrhythmics                  |     0.0|       0.000|          12.1| -0.001|     -0.110|
|betablocker                      |     0.0|      -0.009|           5.3|  0.032|     -0.053|
|ca_channel_blocker               |     0.0|       0.009|           5.5|  0.010|     -0.068|
|other_qt_prolong                 |     0.0|       0.014|           5.2| -0.034|     -0.042|
|cancer                           |     0.0|      -0.004|           6.4| -0.155|     -0.096|
|cardiomp                         |     0.0|      -0.001|          19.0| -0.055|     -0.533|
|cerebro_vasc                     |     0.0|       0.002|           6.5| -0.062|     -0.146|
|cong_hd                          |     0.0|       0.000|          26.6| -0.131|     -0.083|
|copd                             |     0.0|       0.000|           8.7| -0.116|     -0.175|
|hf                               |     0.0|       0.002|          12.0|  0.182|      0.094|
|ihd                              |     0.0|       0.005|           3.1|  0.035|     -0.017|
|liver                            |     0.0|       0.001|          12.7| -0.223|     -0.128|
|peri_vasc                        |     0.0|       0.000|           8.7|  0.052|     -0.035|
|prev_mi                          |     0.0|       0.000|           8.6|  0.000|      0.000|
|renal                            |     0.0|       0.000|          26.6|  0.194|      0.457|
|valve_hd                         |     0.0|       0.000|          11.8|  0.009|      0.091|
|other_arrhythm                   |     0.0|      -0.001|          12.2| -0.022|     -0.537|
|other_card                       |     0.0|       0.000|          21.0| -0.280|     -0.252|
|afib_aflu                        |     0.0|       0.003|           6.6|  0.024|      0.059|
|hypertension                     |     0.0|       0.016|           4.0|  0.000|      0.000|

## Ranks

Rank 1 indicates the variable ranked as most important.

Table: Ranks of variable importance measures

|                                 | Effects| Permutation| Minimal depth| ATE RF| ATE logreg|
|:--------------------------------|-------:|-----------:|-------------:|------:|----------:|
|sex                              |       2|           1|             2|     29|         20|
|diag12sl_atrial_fibrillation     |       2|           2|             6|      4|          7|
|diag12sl_atrial_flutter          |       2|          25|            33|      1|          5|
|diag12sl_first_degree_av_block   |       2|           8|             6|      7|          6|
|diag12sl_sec_deg_avblock_type_i  |       6|          25|            40|      5|          8|
|diag12sl_sec_deg_avblock_type_ii |       6|          25|            35|     24|         22|
|diag12sl_third_degree_av_block   |       6|          25|            40|     10|          3|
|diag12sl_lbbb                    |       6|          17|            30|     24|         22|
|diag12sl_rbbb                    |      26|          34|             9|     28|         19|
|diag12sl_left_ant_fascic_block   |      26|          34|            18|      9|         35|
|diag12sl_left_post_fascic_block  |      26|          25|            37|     36|         32|
|diag12sl_bifascicular_block      |      26|          34|            34|     11|          4|
|diag12sl_early_repolarization    |      26|          38|            26|      8|          1|
|diagmanual_qwave                 |      26|           9|             7|     33|         39|
|diagmanual_stdep                 |      26|          17|            20|     12|         10|
|diagmanual_stele                 |      26|          14|            14|     37|         18|
|diagmanual_lvh                   |      26|          11|            19|     22|          9|
|qtcprol_all                      |      26|          11|             4|     15|         14|
|statin_hyperlipidemia            |      26|          34|            13|     31|         25|
|diabetes_med                     |      26|           5|             9|      6|         17|
|vasodilator                      |      26|          41|            20|     21|         15|
|digoxin                          |      26|          39|            22|     14|         12|
|antiarrhythmics                  |      26|          25|            29|     27|         34|
|betablocker                      |      26|          42|            11|     17|         29|
|ca_channel_blocker               |      26|           6|            12|     19|         30|
|other_qt_prolong                 |      26|           4|             9|     32|         28|
|cancer                           |      26|          40|            15|     40|         33|
|cardiomp                         |      26|          34|            36|     34|         41|
|cerebro_vasc                     |      26|          14|            16|     35|         37|
|cong_hd                          |      26|          25|            40|     39|         31|
|copd                             |      26|          25|            24|     38|         38|
|hf                               |      26|          14|            28|      3|         11|
|ihd                              |      26|           8|             1|     16|         26|
|liver                            |      26|          17|            32|     41|         36|
|peri_vasc                        |      26|          25|            24|     13|         27|
|prev_mi                          |      26|          25|            23|     24|         22|
|renal                            |      26|          25|            40|      2|          2|
|valve_hd                         |      26|          25|            27|     20|         13|
|other_arrhythm                   |      26|          34|            30|     30|         42|
|other_card                       |      26|          25|            38|     42|         40|
|afib_aflu                        |      26|          11|            17|     18|         16|
|hypertension                     |      26|           3|             3|     24|         22|
