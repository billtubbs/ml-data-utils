# ml-data-utils
MATLAB functions to facilitate handling and saving data from automated experiments.

These are simple but useful tools to make saving experiment results and meta-data from a MATLAB script easier.

## Example

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
