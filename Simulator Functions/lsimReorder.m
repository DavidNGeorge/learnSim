function newlist = lsimReorder(triallist)
%lsimReoder reorders a matrix
%   [A] = lsimReorder(X) returns a matrix sorted first by the sum of each
%   row and then by each column in turn. Useful for reordering a list of
%   trial types defined by ones and zeros used in learning simulators so
%   that they appear in a convential order (e.g. A, B, C, AB, AC, BC, ABC)

n_stim = size(triallist, 2);
newcolumn = sum(triallist, 2);
newlist = triallist * -1;
newlist = [newlist newcolumn];
sortorder = [n_stim + 1 1:1:n_stim];
newlist = sortrows(newlist, sortorder);
newlist = newlist(:, 1:1:n_stim) * -1;