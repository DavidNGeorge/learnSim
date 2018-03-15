function [A] = lsimNameCU(Wij)
%lsimNameCU generates names for configural units for George & Pearce (2012)
%	[A] = lsimNameCU(X) returns a character array containing names for each
%of the configural units defined by [X], a matrix of weights between output
%units of the input network and the configural units. Wij is not affected
%by changes in the effectiveness of output units and so the weights reflect
%activity in the units at the time that the configural unit was recruited. 
%This information is used to include numbers in the configural unit name
%indicating the relative contribuation of each output unit to the 
%activation of the configural unit.

%to start off, create a new matrix (connections) which just indicates where
%there is a connection between an output unit and a configural unit (1) and
%where there is not (0). get the numner of configural units (nCU) and
%output units (nStim), and create a cell array to store the names in.
connections = Wij;
connections(connections~=0) = 1;
[nCU,nStim] = size(connections);
label = cell(nCU, 1);
%now cycle through all of the configural units
for configUnit = 1:1:nCU
    lab = [];
    %cycle through the stimuli and add their label to the name of the
    %configural unit if there is a connection
    for outputUnit = 1:1:nStim
        if connections(configUnit, outputUnit) == 1
            lab = [lab char(96 + outputUnit)];
        end
    end
    %add a colon at the end of the configural unit name to separate it from
    %the numbers which indicate the contribution of each output unit to the
    %activation of the configural unit
    lab = [lab ': '];
    count = 0;
    %cucle through the stimuli and, where there is a connection, add the
    %square of the weight which gives the contribution that the output unit
    %made to the activation of the configural unit when the configural unit
    %was first recruited. This may be very different to what it does now if
    %the effectiveness of the output units has changed, but does show what
    %the configural unit represents.
    for outputUnit = 1:1:nStim
        if connections(configUnit,outputUnit) == 1 
            if (Wij(configUnit, outputUnit)^2 > 0.995)
                lab = [lab '1.0'];
            elseif (round((Wij(configUnit,outputUnit)^2) * 100) < 10)
                lab = [lab '.0' num2str(round((Wij(configUnit, outputUnit)^2) * 100))];
            else
                lab = [lab '.' num2str(round((Wij(configUnit, outputUnit)^2) * 100))];
            end
            %counter is used to insert semi-colons between numbers
            %corresponding to different output units, but not at the end
            count = count + 1;
            if count < sum(connections(configUnit, :))
                lab = [lab ';'];
            end
        end
    end
    label(configUnit) = {lab};
end
A = label;