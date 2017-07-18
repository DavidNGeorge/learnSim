function [A] = lsimGetOrder(rand_ord,numberOfTrials)
%simGetOrder Simulator Get Order
%   A = simGetOrder(N, K) returns a vector that contains a random
%   permutation of the numbers 1 to K if N equals 1, or else the numbers
%   1 to K in order if N does not equal 1.
%
%   simGetOrder calls randperm which in turn calls RAND and therefore 
%   changes the state of the random number generator that underlies RAND, 
%   RANDI, and RANDN.  Control that shared generator using RNG.

if (rand_ord == 1);
    order = randperm(numberOfTrials);
else
    order = 1:1:numberOfTrials;
end;

A = order;