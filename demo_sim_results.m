% Demonstration of how to use objects2tablerow function
if ~isfolder('test')
    mkdir('test')
end

% Parameters
a_values = [1 2];
b_values = [10 15 20];
experiments = fullfact([numel(a_values) numel(b_values)]);

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