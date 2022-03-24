function loc = locate_time_series(y)
% Returns the indices of the beginning and end of
% all contigious series of non-NaN values in vector y
% as a matrix, with the begin indeces in the first
% column and the end indeces in the second column.
%
% Arguments:
%   y : row or column vector.
%
% Example:
% >> y = [nan 1 2 3 nan nan 4 3]';
% >> loc = locate_time_series(y)
% 
% loc =
% 
%      2     4
%      7     8
% 

    if size(y)
        y = reshape(y, [], 1);
        k_changes = diff(~isnan([nan; y; nan]));
        k_begin = find(k_changes > 0);
        k_end = find(k_changes < 0) - 1;
        loc = [k_begin k_end];
    else
        loc = [];
    end
end