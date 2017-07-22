function [patterns, active, alpha, names] = lsimRWCues(nStimuli, alphaIn, uniqueCues)
%lsimRWCues defines unique cues for compound stimuli
%   [A, B, C, D] = lsimRWCues(N, Y) returns in [A] an m x n matrix of all 
%   possible combinations of nStimuli stimuli where m = (2^n) - 1, and in
%   [B] an m x m matrix where each row corresponds to a patterns of
%   stimulation (i.e. a row in A) and column corresponds to
%   respresentational unit which codes for the combination of cues
%   specified in a row of A. uniqueCues determines whether combinations of
%   stimuli generate unique cues. 0 = no; 1 = a single unique cue for each
%   compound; 2 = multiple cues for componds of more than two stimuli
%   (e.g., ABC -> ab, ac, bc, abc). [C] contains an array of alpha values
%   for each unit and [D} contains a cell array of their names. The size of
%   [C] and [D] depends upon the value of uniqueCues.
%first generate the matrix of patterns
nPatterns = 2^nStimuli - 1;
patterns = zeros(nPatterns + 1, (nStimuli + 1));
for x = 1:nStimuli
    for y = 1:2^(x - 1)
        for z = 1:2^(nStimuli - x)
            patterns(((y - 1) * 2^(nStimuli - x + 1)) + z, x) = 1;
        end
    end
end
patterns = patterns * -1;
patterns(:, nStimuli + 1) = sum(abs(patterns) ,2);
patterns = sortrows(patterns, [nStimuli + 1 1:nStimuli]);
patterns = patterns * -1;
patterns(1, :) = [];
patterns(:, (nStimuli + 1)) = [];

%then generate the matrix specifying which units exist and are active in
%each pattern
switch uniqueCues
    case 0
        active = patterns;
    case 1
        active = zeros(nPatterns);
        active(:, 1:nStimuli) = patterns;
        for x = nStimuli + 1:1:nPatterns
            active(x, x) = 1;
        end
    case 2
        active = zeros(nPatterns);
        for unit = 1:1:nPatterns
            stimInUnit = sum(patterns(unit, :));
            for pattern = 1:1:nPatterns
                count = 0;
                for stimulus = 1:1:nStimuli
                    if (patterns(unit, stimulus) == 1) && (patterns(pattern, stimulus) == 1)
                        count = count + 1;
                    end
                    if count == stimInUnit
                        active(pattern, unit) = 1;
                    end
                end
            end
        end
end

%next generate the alpha array. The input array could be of size nStimuli
%or 2^nStimuli - 1, but in neither case is this necessarily correct
switch uniqueCues
    case 0
        alpha = alphaIn(1:nStimuli);
    otherwise
        if size(alphaIn, 2) == (2^nStimuli) - 1
            alpha = alphaIn;
        else
            alpha = zeros(1, 2^nStimuli - 1);
            for pattern = 1:1:nPatterns
                count = 0;
                total = 0;
                for stimulus = 1:1:nStimuli
                    if patterns(pattern, stimulus) == 1
                        total = total + alphaIn(stimulus);
                        count = count + 1;
                    end
                    alpha(pattern) = total / count;
                end
            end
        end
end

%finally generate the cell array containing the names for the units. When
%we are not using unique cues, this will just be the names of the stimuli.
%When we are, this will be the names of all possible patterns. Unique cues
%are indicated by [].
switch uniqueCues
    case 0
        names = lsimNameTrials(patterns(1:nStimuli, :));
    otherwise
        names = lsimNameTrials(patterns);
        for unit = nStimuli+1:1:nPatterns
            names{unit} = ['[' names{unit} ']'];
        end
end