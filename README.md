# ml-data-utils
MATLAB functions to facilitate handling and saving diverse data (variables, parameters, etc.) during automated calculations or experiments in one large CSV file for subsequent analysis.

## Examples

The [array2table_with_name](array2table_with_name.m) function converts a matrix to a table with custom column labels.

```matlab
X = reshape(1:6, 3, 2);
array2table_with_name(X.^2, 'Xsq')
```

```text
ans =

  3×2 table

    Xsq1    Xsq2
    ____    ____

     1       16 
     4       25 
     9       36 

```

This is similar to but more concise than the built-in function `array2table(X.^2, 'VariableNames', {'Xsq1', 'Xsq2'})`.

The [array2tablerow](array2tablerow.m) function converts an array into a table with one row by 'flattening' the elements, and adds column labels with subscripts to indicate the array indices.

```matlab
array2tablerow(X.^2, 'Xsq')
```

```text
ans =

  1×6 table

    Xsq_1_1    Xsq_2_1    Xsq_3_1    Xsq_1_2    Xsq_2_2    Xsq_3_2
    _______    _______    _______    _______    _______    _______

       1          4          9         16         25         36   

```

The [objects2tablerow](objects2tablerow.m) converts a Map container of MATLAB variables into a single table row. This is useful when iteratively recording a collection of variables or parameter values. A variety of MATLAB variable classes are supported.

```matlab
person.name = "Amy";
person.age = int16(5);
person.siblings = {'Peter', 'Fred'};
data = [0.5377  1.8339 -2.2588];
vars = containers.Map({'Person', 'Data'}, {person, data});
T = objects2tablerow(vars)
```

```text
T =

  1×7 table

    Data_1    Data_2    Data_3     Person_age    Person_name    Person_siblings_1    Person_siblings_2
    ______    ______    _______    __________    ___________    _________________    _________________

    0.5377    1.8339    -2.2588        5            "Amy"           {'Peter'}            {'Fred'}     

```

## Use case example for objects2tablerow

```matlab
% Demonstration of how to use objects2tablerow function
if ~isfolder('test')
    mkdir('test')
end

% Parameters
a_values = [1 2];
b_values = [10 15 20];
experiments = fullfact([numel(a_values) numel(b_values)]);

% Some arbitrary data
x = linspace(0, 5, 6);
y = 2*x - 10 + randn(1, 6);

for i = 1:size(experiments, 1)
    desc = sprintf("Experiment %d", i);
    params.a = a_values(experiments(i, 1));
    params.b = b_values(experiments(i, 2));

    % Run numerical experiment
    y_est = params.a*x + params.b;
    mse = mean((y_est - y).^2);
    results = containers.Map( ...
        {'i', 'Description', 'params', 'mse'}, ...
        {i, desc, params, mse} ...
    );
    new_results = objects2tablerow(results);

    % Save to csv file
    filename = 'experiment_results.csv';
    filepath = fullfile('test', filename);
    if isfile(filepath)
        % Load existing results and combine
        existing_results = readtable(filepath);
        new_results = vertcat(existing_results, new_results);
    end
    writetable(new_results, filepath);
end

% Display all results
readtable(filepath)
```

This produces a csv file with the following contents:
```text

ans =

  6×5 table

      Description       i     mse      params_a    params_b
    ________________    _    ______    ________    ________

    {'Experiment 1'}    1    318.63       1           10   
    {'Experiment 2'}    2    408.89       2           10   
    {'Experiment 3'}    3    520.63       1           15   
    {'Experiment 4'}    4     635.9       2           15   
    {'Experiment 5'}    5    772.64       1           20   
    {'Experiment 6'}    6     912.9       2           20   

```

## Automating Simulink simulations

This example shows how you can run Simulink model simulations from a Matlab
script and capture the results as a table and/or csv file.

```matlab
sim_model = "sim_test_model";
nT = 15;  % number of samples
Ts = 0.2;  % sample period (set Simulink 'to workspace' blocks to sample at Ts

% Prepare simulation inputs
t = Ts*(0:nT)';  % time vector
u = zeros(nT,1);
u(t > 1) = 1;  % input signal

simin.u = [t u];  % make this a workspace input in Simulink
sim_results = run_simulation(sim_model, t, 'sim_result.csv');

head(sim_results)
```

Output:
```text

ans =

  8×4 table

     t      y1      y2      y3 
    ___    ____    ____    ____

      0       0       0       0
    0.2       0       0       0
    0.4       0       0       0
    0.6       0       0       0
    0.8       0       0       0
      1       0       0       0
    1.2     0.1     0.1     0.1
    1.4    0.19    0.19    0.19
```

