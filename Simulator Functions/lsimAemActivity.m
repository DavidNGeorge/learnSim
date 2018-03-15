function [activity] = lsimAemActivity(active, patterns, r)
%lsimRWCues defines unique cues for compound stimuli
%   [A] = lsimRWCues(X, Y) returns in [A] an m x n matrix of the activity
%   in each of m representational units which can be activated by n stimuli
%   [X] is a matrix indicating which unit is active on each trial type, and
%   [Y] gives the extent to which each stimulus perceptually interacts with
%   each other stimulus.
[nPats, nStim] = size(patterns);
if nStim == 1
    activity = 1;
    return
end
pSize = sum(patterns, 2);
activity = zeros(nPats);

for currentPat = 1:1:nPats
    activeUnits = active(currentPat, :)';
    comparison = zeros(nStim);
    %find all comparisons within the pattern
    %this code fills in the top right triangle of the matrix which is later
    %copied into the bottom left, too. It checks to see whether see whether
    %pairs of stimuli are active together.
    for firstStim = 1:1:nStim - 1
        if patterns(currentPat, firstStim) == 1
            for secondStim = firstStim + 1:nStim
                comparison(firstStim, secondStim) = patterns(currentPat, secondStim) == 1;
            end
        end
    end
    comparison=comparison + comparison';
    %find pairwise comparisons within each active unit (if any)
    for patNum = 1:nPats
        thiscomp = zeros(nStim);
        if activeUnits(patNum) == 1 
            if pSize(patNum) > 1
                for firstStim = 1:nStim - 1
                    if patterns(patNum, firstStim) == 1
                        for secondStim = firstStim + 1:nStim
                            thiscomp(firstStim, secondStim) = patterns(patNum, secondStim) == 1;
                        end
                    end
                end
            end
            thiscomp = thiscomp + thiscomp';
            %now calculate activity based on these comparison
            diff = comparison - thiscomp;
            for affectedStim = 1:nStim
                increment = 1;
                for interactingStim = 1:nStim
                    increment = increment * (r(interactingStim, affectedStim)^thiscomp(interactingStim, affectedStim)) * ((1 - r(interactingStim, affectedStim))^diff(interactingStim, affectedStim));
                end
                activity(currentPat, patNum)=activity(currentPat, patNum) + (patterns(currentPat, affectedStim) * (patterns(patNum, affectedStim) * increment));
            end
        end
    end
end