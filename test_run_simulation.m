% Test convert_simout_2_table.m

data_dir = 'test_data';

sim_model = "sim_test_model";
nT = 15;
Ts = 0.2;
t = Ts*(0:nT)';
u = zeros(nT,1);
u(t > 1) = 1;

simin.u = [t u];
sim_results = run_simulation(sim_model, t);

assert(all(sim_results{:, 't'} == t))
assert(all(sim_results{:, 'y1'} == sim_results{:, 'y2'}))
assert(all(sim_results{:, 'y1'} == sim_results{:, 'y3'}))
assert(all(sim_results{:, {'Y_1', 'Y_2', 'Y_3'}} == ...
    sim_results{:, {'y1', 'y2', 'y3'}}, [1 2]));

% Repeat with saving to csv file
filename = 'sim_results_test.csv';
sim_results = run_simulation(sim_model, t, fullfile(data_dir, filename));

data_from_file = readtable(fullfile(data_dir, filename));
assert(all(data_from_file{:, :} == round(sim_results{:, :}, 10), [1 2]))
