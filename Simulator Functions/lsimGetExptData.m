function [A, B, C, D, E, F, G] = lsimGetExptData(filelist, model, param)
%simGetExptData Simulator get experiment data
%   [A, B, C, D, E, F, G] = getexptdata(X, Y) reads a number of data
%   files and returns information to run simulations of associative 
%   learning models.  X = list of full path file names to read; Z = associative 
%   learning model being simulated; Z = parameter available for some simulators 
%   to use. data for model returned in [A, B, C,....]. The last variable 
%   returned is an error flag.

eflag = 0;
trials = [];

%populate some variables
switch lower(model)
    case 'config'
        in = 1; infile = filelist(1);
        out = 1; outfile = filelist(2);
        int = 1; intfile = filelist(3);
        be = 1; befile = filelist(4);
        r = 0;
        a = 0;
        s = 0;
    case 'gp'
        in = 1; infile = filelist(1);
        out = 1; outfile = filelist(2);
        int = 1; intfile = filelist(3);
        be = 1; befile = filelist(4);
        r = 0;
        a = 1; afile = filelist(5);
        s = 0;
    case {'rem', 'aem'}
        if param == 1
            in = 1; infile = filelist(1);
            out = 1; outfile = filelist(2);
            int = 0;
            be = 1; befile = filelist(3);
            r = 1; rfile = filelist(4);
            a = 1; afile = filelist(5);
            s = 0;
        else
            in = 1; infile = filelist(1);
            out = 1; outfile = filelist(2);
            int = 0;
            be = 1; befile = filelist(3);
            r = 0;
            a = 1; afile = filelist(4);
            s = 0;
        end
    case 'rw'
        in = 1; infile = filelist(1);
        out = 1; outfile = filelist(2);
        int = 0;
        be = 1; befile = filelist(3);
        r = 0;
        a = 1; afile = filelist(4);
        s = 0;
end

%do some loading and checking
%We shall assume that all required files exist because this should already 
%have been checked. In this version, there is no tolerance for absent files.
%First, the input file. Check whether we want it. If so, read it. If not, 
%set the error flag. This will tell the simulator that something is very
%wrong.
if in == 1
    trials = dlmread(char(infile));
else
    eflag = 1;
    disp('#Warning:: No input file requested');
end

%Second, the r file. Check whether we want it first.
%If so, read it then check its size. If it is too small, create a 
%new matrix. If it is too big, truncate it.
%Checks both eflag and in values in case additional error checking is added
%in the future. Currently, either would be sufficient.
if r == 1
    r = dlmread(char(rfile));
    if (eflag ~= 1) && (in == 1)
        if (size(r,1) < size(trials,2)) || (size(r,2) < size(trials,2))
            r = triu(0.2*ones(size(trials,2)),1) + tril(0.2*ones(size(trials,2)),-1);
            disp('#Warning:: r matrix has too few columns and/or rows. All r values set to 0.2.');
        end
        if size(r,1) > size(trials,2)
            r = r(1:size(trials,2),:);
            disp('#Warning:: r matrix has too many rows. Matrix truncated.');
        end
        if size(r,2) > size(trials,2)
            r = r(:,1:size(trials,2));
            disp('#Warning:: r matrix has too many columns. Matrix truncated.');
        end
    end
end

%Third, the intensity file.
%Again, check its size. If too small, creat a new array. If too big, truncate it.
if int == 1
     intensity = dlmread(char(intfile));
    if (eflag ~= 1) && (in == 1)
        if size(intensity,2) < size(trials,2)
            intensity = ones(1,size(trials,2));
            disp('#Warning:: Too few intensity values. All intensity values set to 1.');
        elseif size(intensity,2) > size(trials,2)
            intensity = intensity(:,1:size(trials,2));
            disp('#Warning:: Too many intensity values. Surplus values discarded.');
        end
    end
end

%Fourth, the alpha file.
%Repeat steps as for intensities.
if a == 1
    alpha = dlmread(char(afile));
    if (eflag ~= 1) && (in == 1)
        if size(alpha,2) < size(trials,2)
            alpha = 0.1 * ones(1,size(trials,2));
            disp('#Warning:: Too few alpha values. All alpha values set to 0.1.');
        elseif size(alpha,2) > size(trials,2)
            if strcmpi(model, 'rw') && (size(alpha, 2) == (2^size(trials, 2) - 1))
                disp('#Info:: Alpha values provided for each configurational unit');
            else
                alpha = alpha(:,1:size(trials,2));
                disp('#Warning:: Too many alpha values. Surplus values discarded.');
            end
        end
    end
end

%Fifth, the beta file.
%Repeat steps as for intensities.
if be == 1
    beta = dlmread(char(befile));
    switch size(beta,2)
        case 0
            beta = [0.1 0.1];
            disp('#Warning:: No beta values specified. Both beta values set to 0.1.');
        case 1
            beta = [beta beta];
            disp('#Warning:: Only one value specified. Beta values will be equal.');
        case 2
        otherwise
            beta = beta(:,1:2);
            disp('#Warning:: More than two betas specified. Only first two will be used.');
    end
end

%Sixth, the sigma file.
%repeat steps as for intensities.
if s == 1
    sigma = dlmread(char(sfile));
    if (eflag ~= 1) && (in == 1)
        if size(sigma,2) < size(trials,2)
            sigma = 0.9 * ones(1,size(trials,2));
            disp('#Warning:: Too few sigma values. All sigma values set to 0.9.', 'Warning');
        elseif size(sigma,2) > size(trials,2)
            sigma = sigma(:,1:size(trials,2));
            disp('#Warning:: Too many sigma values. Surplus values discarded.', 'Warning');
        end
    end
end

%Finally, the output file.
%Once more, check whether it is being used and check size.
%If it is too small, set error flag. This issue cannot be ignored.
%If it is too big, truncate it.
if out == 1
    outcome = dlmread(char(outfile));
    if (eflag ~= 1) && (in == 1)
        if size(outcome,1) < size(trials,1)
            disp('#Warning:: Not enough outcome values');
            eflag = 1;
        elseif size(outcome,1) > size(trials,1)
            outcome = outcome(1:size(trials,1),:);
            disp('#Warning:: Too many outcome values. Surplus values discarded.');
        end
    end
end

%populate return variables
switch lower(model)
    case 'config'
        A = trials;
        B = outcome;
        C = intensity;
        D = beta;
        E = eflag;
    case 'gp'
        A = trials;
        B = outcome;
        C = intensity;
        D = beta;
        E = alpha;
        F = eflag;
    case {'rem', 'aem'}
        if param == 1
            A = trials;
            B = outcome;
            C = beta;
            D = r;
            E = alpha;
            F = eflag;
        else
            A = trials;
            B = outcome;
            C = beta;
            D = alpha;
            E = eflag;
        end
    case 'rw'
        A = trials;
        B = outcome;
        C = beta;
        D = alpha;
        E = eflag; 
end