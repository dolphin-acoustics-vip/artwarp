T=readtable('../Test_Data_csv/Sb_HICEAS1706_20170913_AD259_S123_sel22_220035.csv')
assert(width(T) == 5, 'Problem with number of columns')
assert(height(T) == 159, 'Problem with number of row')
