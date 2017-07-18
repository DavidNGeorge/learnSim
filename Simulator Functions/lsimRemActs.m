function [patterns,active] = lsimRemActs(populations)
%lsimRemActs REM simulator define patterns and active populations
%   [A, B] = lsimRemActs(X) returns all possible patterns that REM could be 
%   exposed to in A and the active representational populations for each of
%   those patterns in B based on population matrix X

[n_pop, n_stim,~] = size(populations);
n_pats = 2^n_stim - 1;
active = zeros(n_pop, n_stim, n_pats);

%Generate all patterns: 1 for on, -1 for off
patterns = zeros(n_pats + 1, (n_stim+1));
for x = 1:n_stim
    for y = 1:2^(x - 1)
        for z = 1:2^(n_stim - x)
            patterns(((y - 1) * 2^(n_stim - x + 1)) + z, x)=1;
        end
    end
end
patterns(:, n_stim + 1) = sum(patterns,2);
patterns = sortrows(patterns, n_stim + 1);
patterns(1, :) = [];
patterns(:, (n_stim + 1)) = [];
patterns = (patterns * 2) - 1;

%Create activity matrix
psize = zeros(n_pop, n_stim);
for x = 1:n_stim
    psize(:, x)=sum(abs(populations(:, :, x)), 2);
end
for z = 1:n_pats
    for x  =1:n_stim
        active(:, x, z) = 1 - (psize(:, x) - (populations(:, :, x) * patterns(z, :)'));
    end
end
active(active < 0) = 0;