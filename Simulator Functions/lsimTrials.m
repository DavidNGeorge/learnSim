function [triallist] = lsimTrials(trials, patterns)
%simTrials Simulator trials
%   A = simTrials(X, Y) returns a vector of the same length as X, where
%   each element corresponds to the index of the row in Y which is the same
%   as the appropriate row in X. That is, the function enumerates the rows
%   of X with respect to the rows of Y.

n_patterns = size(patterns, 1);
n_trials = size(trials, 1);
triallist = zeros(n_trials, 1);

for x = 1:1:n_trials
    for y = 1:1:n_patterns
        if (trials(x, :) == patterns(y, :))
            triallist(x) = y;
        end
    end
end