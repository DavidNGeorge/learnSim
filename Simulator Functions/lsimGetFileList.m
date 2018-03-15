function [A, B] = lsimGetFileList(folder, model, param)
%lsimGetFileList Simulator get file list
%   [A, B] = simGetFileList(X, Y, Z) returns a list of data files that are
%   required by the simulator model specified in Y, and a vector indicating
%   whether each file exists in folder X. Z is a simulator specific
%   parameter.

%check that neither too few or too many arguments have been given
minargin = 2; maxargin = 3;
narginchk(minargin, maxargin);
if nargin < 3, param = 0; end          

if isunix
    ifile = fullfile(folder,'in');
    ofile = fullfile(folder,'out');
    infile = fullfile(folder,'intensity');
    bfile = fullfile(folder,'beta');
    rfile = fullfile(folder,'r');
    afile = fullfile(folder,'alpha');
    sfile = fullfile(folder,'sigma');
elseif ispc
    ifile = fullfile(folder,'in.txt');
    ofile = fullfile(folder,'out.txt');
    infile = fullfile(folder,'intensity.txt');
    bfile = fullfile(folder,'beta.txt');
    rfile = fullfile(folder,'r.txt');
    afile = fullfile(folder,'alpha.txt');
    sfile = fullfile(folder,'sigma.txt');
end

switch lower(model)
    case 'config'
        filelist = cellstr(char(ifile, ofile, infile, bfile));
    case 'gp'
        filelist = cellstr(char(ifile, ofile, infile, bfile, afile));
    case {'rem', 'aem'}
        if param == 1
            filelist = cellstr(char(ifile, ofile, bfile, rfile, afile));
        else
            filelist = cellstr(char(ifile, ofile, bfile, afile));
        end
    case 'rw'
        filelist = cellstr(char(ifile, ofile, bfile, afile));
end

fileexist = zeros(size(filelist, 1), 1);
for x = 1:size(filelist, 1)
    fileexist(x) = exist(char(filelist(x)),'file');
end

A = filelist;
B = fileexist;