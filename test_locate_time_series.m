% Test locate_time_series.m

y = [];
loc = locate_time_series(y);
assert(isempty(loc))

y = 1;
loc = locate_time_series(y);
assert(isequal(loc, [1 1]))

y = [1 2 3]';
loc = locate_time_series(y);
assert(isequal(loc, [1 3]))

y = [1 2 3];
loc = locate_time_series(y);
assert(isequal(loc, [1 3]))

y = [1 2 nan]';
loc = locate_time_series(y);
assert(isequal(loc, [1 2]))

y = [nan 2 3 4]';
loc = locate_time_series(y);
assert(isequal(loc, [2 4]))

y = [nan nan 1 2 3 nan nan nan]';
loc = locate_time_series(y);
assert(isequal(loc, [3 5]))

y = [nan nan 1 2 3 nan 4 nan nan];
loc = locate_time_series(y);
assert(isequal(loc, [3 5; 7 7]))

y = [nan nan 1 2 3 nan 4 nan nan nan 5 6 7]';
loc = locate_time_series(y);
assert(isequal(loc, [3 5; 7 7; 11 13]))

y = [nan nan 1 2 3 nan 4 nan nan nan 5 6 7 nan nan];
loc = locate_time_series(y);
assert(isequal(loc, [3 5; 7 7; 11 13]))