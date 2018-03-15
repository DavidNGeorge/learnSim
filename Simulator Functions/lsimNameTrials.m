function[A] = lsimNameTrials(trials)
%lsimNameTrials Simulator name trials
%   [A] = simNameTrials(X) returns a list of the patterns specified in
%   matrix [X].

[n_trials, n_stimuli] = size(trials);
label = zeros(n_trials, n_stimuli);

for trial = 1:1:n_trials
    pos_counter = 1;
    for stimulus = 1:1:n_stimuli
        if (trials(trial, stimulus) == 1);
            label(trial, pos_counter) = (96 + stimulus);
            pos_counter = pos_counter + 1;
        elseif (trials(trial, stimulus) > 0 && trials(trial, stimulus) ~= 1)
            label(trial, pos_counter) = 91;
            label(trial, pos_counter + 1) = (96 + stimulus);
            dummy = num2str(trials(trial, stimulus));
            label(trial, pos_counter + 2)=(48 + str2double(dummy(1)));
            label(trial, pos_counter + 3) = 93;
            pos_counter = pos_counter + 4;
        end
    end
end

A = cellstr(char(label));