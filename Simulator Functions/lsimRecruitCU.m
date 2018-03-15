function [A, B] = lsimRecruitCU(act_in, Network, force)
%lsimRecruitCU Simulator recruit configural units
%   [A, B] = lsimRecruitCU(X, Y, Z) returns a network structure [A] in 
%which the fields .E (array containing net associative strength of each CU)
%.Wij (matrix of weights between output units of the input network and CUs,
%.sgima (the associability of each CU) may have been updated, and [B]: the 
%index of the most active CU. Requires input arguments [X]: act_in (array 
%containing input pattern of activity) and [Y]: a (Network) structure with 
%the fields: E, Wij, alpha, recruit, recruitThreshold, sigma, sigmaDefault, 
%and dParam. The third argument is optional, and when set to 'force' will 
%force recruitment, so long as the (exact) CU does not already exist.
switch nargin
    case {0, 1}
        return
    case 2
        force = 'null';
end
%if there are no CUs, we have to recruit one whatever the recruit flag is set to
if size(Network.E, 1) == 0
    %if there are none, create one.
    %add weights to Wij matrix
    Network.Wij = act_in .* Network.alpha .* (1 / sqrt(sum((act_in .* Network.alpha) .^2)));
    %add entry in E array
    Network.E = 0;
    %add entry in sigma array
    Network.sigma = Network.sigmaDefault;
    %get index of new CU
    max_index = 1;
%otherwise, we would normally only consider recruiting if the recruit flag
%is set to 1 - but we can also force recruitment if we want to, for example 
%the first time a pattern is presented
elseif strcmpi(force, 'force')
    %get output layer activation for the pattern
    act_out = act_in .* Network.alpha .* (1 / sqrt(sum((act_in .* Network.alpha) .^2)));
    %check that CU doesn't already exist
    if ~sum(ismember(Network.Wij, act_out, 'rows'))
        %it doesn't - so create it
        Network.Wij = [Network.Wij; act_out];
        Network.E = [Network.E 0];
        Network.sigma = [Network.sigma Network.sigmaDefault];
        [~, max_index] = size(Network.E);
    else
        %no new CU, but we still need to know which CU to learn about
        act_CU = (act_out * Network.Wij') .^Network.dParam;
        [~, max_index] = max(act_CU);
    end
%if we don't force it, we need to check whether or not the criteria for 
%recruitment are met 
elseif Network.recruit == 1
        act_out = act_in .* Network.alpha .* (1 / sqrt(sum((act_in .* Network.alpha) .^2)));
        act_CU = (act_out * Network.Wij') .^Network.dParam;
        [max_value, max_index] = max(act_CU);
        %Check whether the most active CU meets the threshold and if not 
        %generate new entries in the weight matrix, and E and sigma vectors
        if (max_value < Network.recruitThreshold)
            Network.Wij = [Network.Wij; act_out];
            Network.E = [Network.E 0];
            [~, max_index] = size(Network.E);
            Network.sigma = [Network.sigma Network.sigmaDefault];
        end
else
    %even if recruit flag is zero, we still need to know which CU to 
    %learn about
    act_out = act_in .* Network.alpha .* (1 / sqrt(sum((act_in .* Network.alpha) .^2)));
    act_CU = (act_out * Network.Wij') .^Network.dParam;
    [~, max_index] = max(act_CU);
end
A = Network;
B = max_index;