function sim_results = run_simulation(sim_model, t, filename)
% sim_results = run_simulation(sim_model, t, filename)
% Runs the Simulink simulation model named sim_model and
% returns the simulation outputs (from 'to workspace' blocks)
% as a table. This is intended for capturing time-series 
% simulation outputs that are sampled at regular intervals.
% Set up the Simulink model with 'to workspace' blocks that 
% sample at the expected frequency (same as t).
%
% Arguments:
%   sim_model : string or cell array
%       Simulink model name
%   t : column vector
%       Expected sample times to be returned. This must start
%       at time zero (i.e. t(1) == 0) and the simulation will
%       be run until the last value in t (t(end)). Any vectors
%       or arrays from the simulation outputs that are the
%       same length as t (i.e. size(x, 1) == size(t, 1)) will
%       be assumed to be time series data and included.
%   filename : string or cell array (optional)
%       If included, the table will be saved to a csv file with
%       this name or filepath.
%

    % Run Simulink simulation
    assert(t(1) == 0)
    sim_out = sim(sim_model, t(end));

    % Convert results to table
    sim_results = convert_simout_2_table(sim_out, t, false);

    sim_results = [table(t) sim_results];

    if nargin > 2
        % Save to CSV file
        writetable(sim_results, filename)
    end

end