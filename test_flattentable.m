% Test flattentable.m

clear all


%% Examples from doc string

names = ["Jill"; "Jack"; "Zack"]; age = [21; 32; 5]; weight = [76; 81; 45];
T = table(age, weight, 'RowNames', names);
T_flat = flattentable(T);
col_names = {'T_Jill_age', 'T_Jack_age', 'T_Zack_age', 'T_Jill_weight', ...
    'T_Jack_weight', 'T_Zack_weight'};
T_flat_test = array2table([21 32 5 76 81 45], 'VariableNames', col_names);
assert(isequal(T_flat, T_flat_test));

T_flat = flattentable(T, 'Data');
col_names = {'Data_Jill_age', 'Data_Jack_age', 'Data_Zack_age', 'Data_Jill_weight', ...
    'Data_Jack_weight', 'Data_Zack_weight'};
T_flat_test = array2table([21 32 5 76 81 45], 'VariableNames', col_names);
assert(isequal(T_flat, T_flat_test));


%% Table argument with no row names

k = [4; 5]; x = [-10; -20]; y = [1.1; 1.2];
t = table(k, x, y);
t_flat = flattentable(t);

col_names = {'t_1_k', 't_2_k', 't_1_x', 't_2_x', 't_1_y', 't_2_y'};
t_flat_test = array2table([4  5 -10 -20  1.1  1.2 ], 'VariableNames', col_names);
assert(isequal(t_flat, t_flat_test));

