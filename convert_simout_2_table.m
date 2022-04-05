
function sim_results = convert_simout_2_table(sim_out, t, lt)
% sim_results = convert_simout_2_table(sim_out, t, lt)
% Converts time-series in a Simulink simulation output 
% object to a table of data with the same column names.
%
% Each item in the simulation output may be a vector, array,
% timeseries object, or struct. For structs and timeseries, 
% the time data is compared to the time vector t provided. 
% For arrays, any array which has the same length as t will
% be included.
%
% Data arrays (i.e. 2 dimensional) are given labels with
% a numerical subscript. For example, if 'x' is an
% array of size length(t) x 3, then the columns of the
% resulting table will include 'x_1', 'x_2', and 'x_3'.
% 
% Arguments:
%   sim_out : Simulink.SimulationOutput
%       Simulation outputs.
%   t : column vector
%       Expected sample times to be returned. Any vectors
%       or arrays from the simulation outputs that are the
%       same length as t (i.e. size(x, 1) == size(t, 1)) will
%       be assumed to be time series data and included.
%   lt : bool (optional)
%       If true, the table labels will include Latex
%       symbols, e.g. '$x$'.
%
    if nargin == 2
        lt = false;
    end
    var_names = sim_out.find();
    n_vars = numel(var_names);
    selected_data = containers.Map();
    col_names = containers.Map();
    for i = 1:n_vars
        var_name = var_names{i};
        ts = sim_out.(var_name);
        data = [];
        % Select data if it is the desired length
        if isa(ts, 'timeseries')
            if all(ts.Time == t)
                data = ts.Data;
            end
        elseif isstruct(ts)
            if all(ts.time == t)
                data = ts.signals.values;
            end
        elseif size(ts, 1) == size(t, 1)
            data = ts;
        end
        if numel(data) > 0
            selected_data(var_name) = data;
            n_cols = size(data, 2);
            col_names(var_name) = ...
                vector_element_labels(var_name, '', n_cols, lt);
        end
    end
    assert(numel(selected_data.keys) > 0, "No datasets found in results")
    ts = selected_data.values;
    ts = cell2mat(ts);
    col_names = col_names.values;
    col_names = cat(2, col_names{:});
    sim_results = array2table(ts, 'VariableNames', col_names);
end