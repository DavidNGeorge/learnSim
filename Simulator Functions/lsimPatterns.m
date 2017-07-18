function [A, B, C]=lsimPatterns(trials,patterns,intensity)
%simPatterns Simulator patterns
%   [A, B, C] = simPatterns(X, Y, Z) returns matrices containing [A]: the
%   definition of all unique patterns contained in the matrix [X]; [B]: the
%   activity at the input layer of the input network of Pearce's configural
%   theory for each of those patterns; [C] the activity at the output layer
%   of the input network for each of those patterns. Activity at the input
%   layer is dependent upon [Z]. If an exisiting pattern matrix is passed
%   to [Y], then it will be preserved in [A].

switch nargin
    case 0
        A = [];
        B = [];
        C = [];
        return
    case 1
        patterns = [];
        intensity = ones(1, size(trials, 2));
    case 2
        intensity = ones(1, size(trials, 2));
end

[pat_count, ~] = size(patterns);
[newtrials, stim] = size(trials);
%pre-allocate space in matrix to avoid chaning size of matrix on every
%cycle in following loops
if pat_count == 0
    patterns = zeros(newtrials, stim);
else
    patterns = [patterns; zeros(newtrials, stim)];
end

for x = 1:1:newtrials
    if ~pat_count %if there are no exisiting patterns, the first one will be new
        pat_count = pat_count + 1;
        patterns(pat_count, :) = trials(x,:);
    else %if not, we need to check whether each new pattern is already in the list
        found = 0;
        for y = 1:1:pat_count
            if (patterns(y,:) == trials(x,:))
                found = 1;
            end
        end
        if (found == 0)
            pat_count = pat_count + 1;
            patterns(pat_count, :) = trials(x,:);
        end
    end
end
%now we truncate the pattern matrix to remove unused rows
patterns = patterns(1:pat_count, :);

% Determine input level activity for each pattern
act_in = zeros(size(patterns));
for x = 1:size(patterns,1)
    act_in(x,:) = patterns(x,:).*intensity;
end

% Determine output level activity for each pattern
denom = sum(act_in.^2,2);
qa = sqrt(1./denom);
act_out = zeros(size(act_in));
for y = 1:size(patterns,2)
    act_out(:,y) = act_in(:,y).*qa;
end

A = patterns;
B = act_in;
C = act_out;