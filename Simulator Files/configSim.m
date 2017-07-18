function varargout = configSim(varargin)
% CONFIGSIM MATLAB code for configSim.fig
%      CONFIGSIM, by itself, creates a new CONFIGSIM or raises the existing
%      singleton*.
%
%      H = CONFIGSIM returns the handle to a new CONFIGSIM or the handle to
%      the existing singleton*.
%
%      CONFIGSIM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CONFIGSIM.M with the given input arguments.
%
%      CONFIGSIM('Property','Value',...) creates a new CONFIGSIM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before configSim_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to configSim_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help configSim

% Last Modified by GUIDE v2.5 14-Jul-2017 12:43:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @configSim_OpeningFcn, ...
                   'gui_OutputFcn',  @configSim_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before configSim is made visible.
function configSim_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to configSim (see VARARGIN)

%centre window on screen
movegui(gcf, 'center');
% Do some basic housekeeping
% Description of simulator module
handles.Module.name = 'configSim';
handles.Module.version = 'v1.0.0';
handles.Module.description = 'Pearce''s (1987, 1994) configural theory';
handles.Module.author = 'David N. George';
handles.Module.institution = 'University of Hull';
handles.Module.contact = 'd.george@hull.ac.uk';
handles.Module.date = 'June 2016';
% Set up default values in one place for convenience
handles.Sim.figTitleList = {'Patterns', 'Configural Units'};
handles.defaultBlocks = 1;
handles.defaultRandOrder = 0;
handles.defaultD = 2;
handles.defaultEpochs = 1;
handles.defaultFigFont = 'Arial';
handles.defaultFigFontSize = 8;
handles.defaultFigFontWeight = 'normal';
handles.defaultAxisLineWidth = (72 / 25.4) * 0.5; %last value is width in mm
handles.defaultPlotLineWidth = (72 / 25.4) * 1;   %last value is width in mm
% Some general housekeeping for the axes
handles.Sim.XLab = 'Blocks of epochs';
handles.Sim.YLab = 'Net associative strength';
handles.Sim.currentFig = handles.Sim.figTitleList(1);
set(handles.FigureTitle, 'String', handles.Sim.currentFig);
set(get(handles.simAxes, 'XLabel'), 'String', handles.Sim.XLab);
set(get(handles.simAxes, 'YLabel'), 'String', handles.Sim.YLab);
set(handles.simAxes, 'FontSize', handles.defaultFigFontSize);
set(handles.simAxes, 'Fontweight', handles.defaultFigFontWeight);
set(handles.simAxes, 'Visible', 'on');
% Lots of the buttons should be disabled at startup
set(handles.RunButton, 'Enable', 'off');
set(handles.SaveButton, 'Enable', 'off');
set(handles.LoadButton, 'Enable', 'off');
set(handles.NewButton, 'Enable', 'off');
set(handles.TestButton, 'Enable', 'off');
set(handles.PatFigButton, 'Enable', 'off');
set(handles.CUFigButton, 'Enable', 'off');
set(handles.InitButton, 'Enable', 'off');
% Do some basic housekeeping for the simulator
handles.appName = 'configSim';
handles.titleBar = 'Configural Theory simulator (Pearce 1994)';
set(handles.configSim, 'Name', handles.titleBar);
% Write those defaults to handles and the gui 
%control panel
handles.Sim.blocks = handles.defaultBlocks;
set(handles.BlocksValue, 'String', handles.Sim.blocks);
%options panel
handles.Sim.randomOrder = handles.defaultRandOrder;
if handles.Sim.randomOrder == 1
    set(handles.RandomCheckBox, 'Value', get(handles.RandomCheckBox,'Max'));
else
    set(handles.RandomCheckBox,'Value', get(handles.RandomCheckBox,'Min'));
end
handles.Network.dParam = handles.defaultD;
set(handles.dValue, 'String', handles.Network.dParam);
handles.Sim.epochs = handles.defaultEpochs;
set(handles.EpochsValue, 'String', handles.Sim.epochs);

% Choose default command line output for configSim
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes configSim wait for user response (see UIRESUME)
% uiwait(handles.configSim);


% --- Outputs from this function are returned to the command line.
function varargout = configSim_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object deletion, before destroying properties.
function configSim_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to configSim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% resets main GUI data so that push buttons are active and a new simulator may be started
% find handle of main GUI
hMain = findobj('Tag', 'learnSim');
% fetch data associated with main GUI
mainGuiData = guidata(hMain);
% re-enable push buttons
set(mainGuiData.CTbutton, 'Enable', 'on');
% return main GUI data
guidata(hMain, mainGuiData);


% --- Executes on button press in PatFigButton.
function PatFigButton_Callback(hObject, eventdata, handles)
% hObject    handle to PatFigButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Sim.currentFig = handles.Sim.figTitleList(1);
set(handles.PatFigButton, 'Enable', 'off');
set(handles.CUFigButton, 'Enable', 'on');
handles = PlotData(hObject, eventdata, handles);
guidata(hObject, handles);


% --- Executes on button press in CUFigButton.
function CUFigButton_Callback(hObject, eventdata, handles)
% hObject    handle to CUFigButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Sim.currentFig = handles.Sim.figTitleList(2);
set(handles.PatFigButton, 'Enable', 'on');
set(handles.CUFigButton, 'Enable', 'off');
handles = PlotData(hObject, eventdata, handles);
guidata(hObject, handles);


% --- Executes on button press in RandomCheckBox.
function RandomCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to RandomCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RandomCheckBox
if (get(hObject,'Value') == get(hObject,'Max'))
	handles.Sim.randomOrder = 1;
else
	handles.Sim.randomOrder = 0;
end
guidata(hObject, handles);


function dValue_Callback(hObject, eventdata, handles)
% hObject    handle to dValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% This code should ensure that only numerical values greater than zero are entered for d
% Get contents of text box
S = get(hObject, 'String');
% Issue a warning if non-numerical characters were entered:
if ~all(ismember(S, '.1234567890'))
  warndlg('d must be a numerical value greater than zero', 'Incorrect format', 'modal');
end
% Exclude characters which are not numeric:
S(~ismember(S, '.1234567890')) = '';
% Check that the string is not empty and set the value:
if isempty(S)
    S = num2str(handles.Network.dParam);
end
set(hObject, 'String', S);
% Finally set the value in memory
handles.Network.dParam = str2num(S);
guidata(hObject, handles);


function EpochsValue_Callback(hObject, eventdata, handles)
% hObject    handle to EpochsValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% This code should ensure that only numerical values greater than zero are entered for epochs
% Get the contents of the text box
S = get(hObject, 'String');
% Issue a warning if non-numerical characters were entered:
if ~all(ismember(S, '1234567890'))
  warndlg('Epochs must be a whole number greater than zero', 'Incorrect format', 'modal');
end
% Exclude characters which are not numeric:
S(~ismember(S, '1234567890')) = '';
% Check that the string is not empty and set the value:
if isempty(S)
    S = num2str(handles.Sim.epochs);
end
set(hObject, 'String', S);
% Finally set the value in memory
handles.Sim.epochs = str2num(S);
guidata(hObject, handles);


% --- Executes on button press in SelectButton.
function SelectButton_Callback(hObject, eventdata, handles)
% hObject    handle to SelectButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
expFolder = uigetdir(fullfile(pwd, 'Experiments'), 'Select experiment folder');
[filelist,fileexist] = lsimGetFileList(expFolder,'config');
if all(fileexist)
    handles.Sim.expFolder = expFolder;
    handles.Sim.fileList = filelist;
    set(handles.InitButton, 'Enable', 'on');
    [~, handles.expName, ~] = fileparts(expFolder);
    set(handles.configSim, 'Name', [handles.titleBar ' : ' handles.expName]);
    guidata(hObject, handles);
elseif expFolder
    warndlg(['Folder does not contain all files needed by ' handles.appName], 'Folder not selected', 'modal');
end
guidata(hObject, handles);


% --- Executes on button press in InitButton.
function InitButton_Callback(hObject, eventdata, handles)
% hObject    handle to InitButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles.Train.trials, handles.Train.outcome, handles.Network.intensity, handles.Network.beta, eflag] = lsimGetExptData(handles.Sim.fileList, 'config');
if ~eflag
    % do some gui housekeeping
    if handles.Sim.epochs == 1
        handles.Sim.XLab = 'Epochs';
    else
        handles.Sim.XLab = ['Blocks of ' num2str(handles.Sim.epochs) ' epochs'];
    end;
    set(handles.RandomCheckBox, 'Enable', 'off');
    set(handles.dValue, 'Enable', 'off');
    set(handles.dLabel, 'Enable', 'off');
    set(handles.EpochsValue, 'Enable', 'off');
    set(handles.EpochsLabel, 'Enable', 'off');
    set(handles.SelectButton, 'Enable', 'off');
    set(handles.InitButton, 'Enable', 'off');
    set(handles.RunButton, 'Enable', 'on');
    set(handles.SaveButton, 'Enable', 'on');
    set(handles.LoadButton, 'Enable', 'on');
    set(handles.NewButton, 'Enable', 'on');
    set(handles.TestButton, 'Enable', 'on');
    set(handles.PatFigButton, 'Enable', 'on');
    set(handles.CUFigButton, 'Enable', 'on');
    % initialize the network
    handles.Sim.currentBlock = 0;
    handles.Sim.currentStage = 1;
    handles.Train.patterns = [];
    [handles.Train.patterns, ~, handles.Network.actOut] = lsimPatterns(handles.Train.trials, handles.Train.patterns, handles.Network.intensity);
    [handles.Train.currentPatterns, ~, ~] = lsimPatterns(handles.Train.trials, [], handles.Network.intensity);
    handles.Train.trialList = lsimTrials(handles.Train.trials, handles.Train.patterns);
    handles.Network.configNames = lsimNameTrials(handles.Train.patterns);
    handles.Data.stage(handles.Sim.currentStage).CUNames = handles.Network.configNames;
    handles.Train.currentList = lsimTrials(handles.Train.currentPatterns, handles.Train.patterns);
    [handles.Train.nCurrentPats, ~] = size(handles.Train.currentList);
    handles.Train.currentNames = handles.Network.configNames(handles.Train.currentList);
    handles.Data.stage(handles.Sim.currentStage).patNames = handles.Train.currentNames;
    [handles.Train.nTrials, handles.Network.nStimuli] = size(handles.Train.trials);
    [handles.Network.nConfigs, ~] = size(handles.Train.patterns);
    handles.Network.E = zeros(1, handles.Network.nConfigs);
    handles.Data.stage(handles.Sim.currentStage).Et = zeros(1, handles.Network.nConfigs);
    handles.Data.stage(handles.Sim.currentStage).Vt = zeros(1, handles.Train.nCurrentPats);
    handles.XVal = zeros(1);
    handles.patValues = {'Pattern associative strength'};
    handles.confValues = {'CU associative strength'};
    % initialize figures
    handles.Sim.currentFig = handles.Sim.figTitleList(1);
    set(handles.FigureTitle, 'String', handles.Sim.currentFig);
    set(handles.PatFigButton, 'Enable', 'off');
    set(handles.CUFigButton, 'Enable', 'on');
    plot(handles.XVal, handles.Data.stage(handles.Sim.currentStage).Vt);
    set(get(handles.simAxes, 'XLabel'), 'String', handles.Sim.XLab);
    set(get(handles.simAxes, 'YLabel'), 'String', handles.Sim.YLab);
    handles.simLegend = legend(handles.Train.currentNames, 'Location', 'east');
    handles = PlotData(hObject, eventdata, handles);
    % save gui data
    guidata(hObject, handles);
else
    warndlg('Invalid simulation.', 'Warning', 'modal');
end


% --- Executes on button press in RunButton.
function RunButton_Callback(hObject, eventdata, handles)
% hObject    handle to RunButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% train the network
% pre-allocate matrix to accept training data
handles.Data.currentVt = zeros(1, handles.Train.nCurrentPats);
handles.Data.stage(handles.Sim.currentStage).Vt = [handles.Data.stage(handles.Sim.currentStage).Vt; zeros(handles.Sim.blocks, handles.Train.nCurrentPats)];
handles.Data.stage(handles.Sim.currentStage).Et = [handles.Data.stage(handles.Sim.currentStage).Et; zeros(handles.Sim.blocks, handles.Network.nConfigs)];
handles.XVal = [handles.XVal; zeros(handles.Sim.blocks, 1)];
% loop training blocks
for blockNum = 1:1:handles.Sim.blocks
    handles.Sim.currentBlock = handles.Sim.currentBlock + 1;
% loop epochs
    for epochNum = 1:1:handles.Sim.epochs
        order = lsimGetOrder(handles.Sim.randomOrder, handles.Train.nTrials);
    	trialSequence = handles.Train.trialList(order);
    	outcomeSequence = handles.Train.outcome(order);
% loop trough individual training trials
        for trialNum = 1:1:handles.Train.nTrials
%there are four steps to each training trial
%First, Calculate Vsum. act_out is a matrix containing the output layer activation for each unit for each pattern - 
%which also happens to be the weight matrix for each output unit to each configural unit. Hence, we can multiply the 
%weight matrix - act_out - by the activation of the output layer on a given trial - act_out(triallist(order(y)),:)' - 
%and raise this to the power of the discriminatbility parameter - dParam - to get the activity across all of the 
%configural units. This is multiplied by the array E which contains the associative strength of each configural unit
%to give Vsum!
            Vsum = sum(handles.Network.E .* ((handles.Network.actOut * handles.Network.actOut(trialSequence(trialNum), :)') .^ handles.Network.dParam)');
%Second, calculate the prediction error
            Verror = outcomeSequence(trialNum) - Vsum;
%Third, decide which beta to use (excitatory or inhibitory) - dependent upon US. In this case, we can set any value for the
%US and so it is not so simple as distinguishing between the presence and absence of the US. Instead, we use beta(1) for 
%postive values of US and beta(2) for other values - zero or negative.
            if (outcomeSequence(trialNum) > 0)
                b=handles.Network.beta(1);
            elseif (outcomeSequence(trialNum) <= 0)
                b=handles.Network.beta(2);
            end
%Fourth update the associative strength of the configural unit corresponding to the pattern presented
            handles.Network.E(trialSequence(trialNum)) = handles.Network.E(trialSequence(trialNum)) + (b * Verror);
        end
    end
%Now we run through each training pattern and calculate Vsum again - for plotting and data storage. This means all data 
%out are as measured following the end of cycle block rather than as we go along. This should not be particularly 
%important MOST of the time. Only unique trial types that are used in the current training stage are used here
    for patNum = 1:1:handles.Train.nCurrentPats
        Vsum = sum(handles.Network.E .* ((handles.Network.actOut * handles.Network.actOut(handles.Train.currentList(patNum), :)') .^ handles.Network.dParam)');
        handles.Data.currentVt(patNum) = Vsum;
    end
%Next we update our data stores
    handles.Data.stage(handles.Sim.currentStage).Vt(handles.Sim.currentBlock + 1, :) = handles.Data.currentVt;
    handles.Data.stage(handles.Sim.currentStage).Et(handles.Sim.currentBlock + 1, :) = handles.Network.E;
    handles.XVal(handles.Sim.currentBlock + 1) = handles.Sim.currentBlock;
end
%Finally, plot the updated data
handles = PlotData(hObject, eventdata, handles);
for patNum = 1:1:handles.Train.nCurrentPats
	handles.patValues = [handles.patValues [char(handles.Train.currentNames(patNum)) ' = ' num2str(handles.Data.currentVt(patNum))]];
end
for confNum = 1:1:handles.Network.nConfigs
    handles.confValues = [handles.confValues [char(handles.Network.configNames(confNum)) ' = ' num2str(handles.Network.E(confNum))]];
end
set(handles.PatternText, 'String', handles.patValues, 'Value', length(handles.patValues));
set(handles.CUText,  'String', handles.confValues, 'Value', length(handles.confValues));
guidata(hObject, handles);

% --- Executes on button press in SaveButton.
function SaveButton_Callback(hObject, eventdata, handles)
% hObject    handle to SaveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
currentFolder = pwd;
cd(handles.Sim.expFolder);
[fileName, pathName, filterIndex] = uiputfile({'*.mat', 'Save all data (*.mat)';...
    '*.mat', 'Save current network state (*.mat)';...
    '*.xlsx', 'Save training data [CUs] (*.xlsx)';...
    '*.xlsx', 'Save training data [patterns] (*.xlsx)'});
switch filterIndex
    case 1
        %save all data in an mat-file
        NETWORK = handles.Network;
        DATA = handles.Data;
        TRAIN = handles.Train;
        SIM = handles.Sim;
        save(fullfile(pathName, fileName), 'NETWORK', 'DATA', 'TRAIN', 'SIM');
    case 2
        %save current associative strengths only. Can later be used to 'Load Network' but only is net has been
        %appropriately initialized
        E = handles.Network.E;
        save(fullfile(pathName, fileName), 'E');
    case 3
        %save training data (CU associative strength) in an xlsx file. Each stage is saved in a separate sheet
        xlswrite(fullfile(pathName, fileName), ...
            [{'Module', handles.Module.name; 'Version', handles.Module.version;...
            'Description', handles.Module.description; 'Author', handles.Module.author;...
            'Institution', handles.Module.institution; 'Address', handles.Module.contact;...
            'Date', handles.Module.date; 'Experiment', handles.Sim.expFolder}], 'Sheet1');
        for simStage = 1:1:handles.Sim.currentStage
            warning off MATLAB:xlswrite:AddSheet
            xlswrite(fullfile(pathName, fileName), ...
                [handles.Data.stage(simStage).CUNames'; num2cell(handles.Data.stage(simStage).Et)], ...
                horzcat('Stage ', num2str(simStage)));
        end
    case 4
        %save training data (pattern net associative strength) in an xlsx file. Each stage is saved in a separate sheet
        xlswrite(fullfile(pathName, fileName), ...
            [{'Module', handles.Module.name; 'Version', handles.Module.version;...
            'Description', handles.Module.description; 'Author', handles.Module.author;...
            'Institution', handles.Module.institution; 'Address', handles.Module.contact;...
            'Date', handles.Module.date; 'Experiment', handles.Sim.expFolder}], 'Sheet1');
        for simStage = 1:1:handles.Sim.currentStage
            warning off MATLAB:xlswrite:AddSheet
            xlswrite(fullfile(pathName, fileName), ...
                [handles.Data.stage(simStage).patNames'; num2cell(handles.Data.stage(simStage).Vt)], ...
                horzcat('Stage ', num2str(simStage)));
        end
    case 0
        %cancel button clicked - do nothing
end
cd(currentFolder);
guidata(hObject, handles);


% --- Executes on button press in NewButton.
function NewButton_Callback(hObject, eventdata, handles)
% hObject    handle to NewButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 
currentFolder = pwd;
cd(handles.Sim.expFolder);
[inFile, inPath] = uigetfile('*.*','Select input file');
%if a file is chosen, load data and select an output file
if inFile
    newInFile = fullfile(inPath, inFile);
    newInBuffer = dlmread(newInFile);
    [outFile, outPath] = uigetfile('*.*','Select output file');
%if an output file is chosen, load data and then check that the data in
%the input and output files are in the correct format
    if outFile
        newOutFile = fullfile(outPath, outFile);
        newOutBuffer = dlmread(newOutFile);
        if (size(newInBuffer, 2) == size(handles.Train.trials, 2)) && ...
                (size(newOutBuffer, 2) == size(handles.Train.outcome, 2)) && ...
                (size(newInBuffer, 1) == size(newOutBuffer, 1))
            handles.Train.trials = newInBuffer;
            handles.Train.outcome = newOutBuffer;
            msgbox('Input and output patterns loaded', 'New training phase', 'modal');
            handles.Sim.currentStage = handles.Sim.currentStage + 1;
            handles.Sim.currentBlock = 0;
            [handles.Train.patterns, ~, handles.Network.actOut] = lsimPatterns(handles.Train.trials, handles.Train.patterns, handles.Network.intensity);
            [handles.Train.currentPatterns, ~, ~] = lsimPatterns(handles.Train.trials, [], handles.Network.intensity);     
            handles.Train.trialList = lsimTrials(handles.Train.trials, handles.Train.patterns);
            handles.Network.configNames = lsimNameTrials(handles.Train.patterns);
            handles.Data.stage(handles.Sim.currentStage).CUNames = handles.Network.configNames;
            handles.Train.currentList = lsimTrials(handles.Train.currentPatterns, handles.Train.patterns);
            [handles.Train.nCurrentPats, ~] = size(handles.Train.currentList);
            handles.Train.currentNames = handles.Network.configNames(handles.Train.currentList);
            handles.Data.stage(handles.Sim.currentStage).patNames = handles.Train.currentNames;
            handles.Train.nTrials = size(handles.Train.trials, 1);
            handles.Network.nConfigs = size(handles.Train.patterns, 1);
            handles.Network.E = [handles.Network.E'; zeros(handles.Network.nConfigs - size(handles.Network.E, 2), 1)]';
            handles.Data.stage(handles.Sim.currentStage).Et = handles.Network.E;
            for patNum = 1:1:handles.Train.nCurrentPats
                Vsum = sum(handles.Network.E .* ((handles.Network.actOut * handles.Network.actOut(handles.Train.currentList(patNum), :)') .^ handles.Network.dParam)');
                handles.Data.currentVt(patNum) = Vsum;
            end
            handles.Data.stage(handles.Sim.currentStage).Vt = handles.Data.currentVt;
            handles.XVal = zeros(1);
            handles = PlotData(hObject, eventdata, handles);
            for patNum = 1:1:handles.Train.nCurrentPats
                handles.patValues = [handles.patValues [char(handles.Train.currentNames(patNum)) ' = ' num2str(handles.Data.currentVt(patNum))]];
            end
            for confNum = 1:1:handles.Network.nConfigs
                handles.confValues = [handles.confValues [char(handles.Network.configNames(confNum)) ' = ' num2str(handles.Network.E(confNum))]];
            end
            set(handles.PatternText, 'String', handles.patValues, 'Value', length(handles.patValues));
            set(handles.CUText,  'String', handles.confValues, 'Value', length(handles.confValues));
        else
            errordlg('File formats invalid or file dimensions do not match', 'New training phase', 'modal');
        end
    else
        errordlg('No output file selected', 'New training phase', 'modal');
    end
else
    errordlg('No input file selected', 'New training phase', 'modal');
end
cd(currentFolder);
guidata(hObject, handles);


% --- Executes on button press in LoadButton.
function LoadButton_Callback(hObject, eventdata, handles)
% hObject    handle to LoadButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Loads associative weights for each CU from previously created mat-file
warning('off', 'MATLAB:load:variableNotFound');
currentFolder = pwd;
cd(handles.Sim.expFolder);
[loadFile, loadPath] = uigetfile('*.mat', 'Load Previous Network State');
if loadFile
    try
        E = load(fullfile(loadPath, loadFile), '-mat', 'E');
        [brow, bcol] = size(E.E);
        [erow, ecol] = size(handles.Network.E);
        if (brow == erow) && (bcol == ecol)
            handles.Network.E = E.E;
            msgbox('Network state loaded from file.', 'Load Previous Network State', 'modal');
        else
            errordlg('Network dimensions do not match', 'Load Error', 'modal');
        end
    catch err
        if (strcmp(err.identifier, 'MATLAB:load:notBinaryFile'))
            errordlg('Not a binary MAT file', 'Load Error', 'modal');
        elseif (strcmp(err.identifier, 'MATLAB:nonExistentField'))
            errordlg('Not a Configural Theory file', 'Load Error', 'modal');
        else
            cd(currentFolder)
            rethrow(err);
        end
    end
end
cd(currentFolder);
warning('on', 'MATLAB:load:variableNotFound');
guidata(hObject, handles);


% --- Executes on button press in TestButton.
function TestButton_Callback(hObject, eventdata, handles)
% hObject    handle to TestButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Returns the net associative strength of user-entered test pattern
testPattern = inputdlg('Enter space-separated numbers', 'Test pattern');
if ~isempty(testPattern)
    [testPattern, status] = str2num(testPattern{:});
    if (status == 1) && (size(testPattern, 2) == handles.Network.nStimuli)
        testName = lsimNameTrials(testPattern);
        testActIn = testPattern.*handles.Network.intensity;
        testActOut = testActIn./sqrt(sum(testActIn.^2, 2));
        testValue = sum(handles.Network.E.*((handles.Network.actOut * testActOut').^handles.Network.dParam)');
        msgbox(strcat(testName, {' = '}, num2str(testValue)), 'Test pattern');
    else
        errordlg('Invalid test pattern', 'Error!', 'modal')
    end
end
guidata(hObject, handles);


% --- Executes on button press in QuitButton.
function QuitButton_Callback(hObject, eventdata, handles)
% hObject    handle to QuitButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;


function BlocksValue_Callback(hObject, eventdata, handles)
% hObject    handle to BlocksValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% This code should ensure that only numerical values greater than zero are entered for epochs
% Get the contents of the text box
S = get(hObject, 'String');
% Issue a warning if non-numerical characters were entered:
if ~all(ismember(S, '1234567890'))
  warndlg('Blocks must be a whole number greater than zero', 'Incorrect format', 'modal');
end
% Exclude characters which are not numeric:
S(~ismember(S, '1234567890')) = '';
% Check that the string is not empty and set the value:
if isempty(S)
    S = num2str(handles.Sim.blocks);
end
set(hObject, 'String', S);
% Finally set the value in memory
handles.Sim.blocks = str2num(S);
guidata(hObject, handles);


% --- Called by RunButton PatFigButton and CTFigButton.
function handles = PlotData(hObject, eventdata, handles)
lPos = get(handles.simLegend, 'Position');
switch char(handles.Sim.currentFig)
    case 'Patterns'
        yData = handles.Data.stage(handles.Sim.currentStage).Vt';
        lText = handles.Train.currentNames;
    case 'Configural Units'
        yData = handles.Data.stage(handles.Sim.currentStage).Et';
        lText = handles.Network.configNames;
end
xLab = 0:1:size(yData, 2) - 1;
axes(handles.simAxes);
plot(xLab, yData', 'LineWidth', handles.defaultPlotLineWidth);
handles.simLegend = legend(handles.Train.currentNames, 'Position', lPos);
legend('boxoff');
set(get(handles.simAxes, 'XLabel'), 'String', handles.Sim.XLab);
set(get(handles.simAxes, 'YLabel'), 'String', handles.Sim.YLab);
set(handles.simAxes, 'FontName', handles.defaultFigFont);
set(handles.simAxes, 'FontSize', handles.defaultFigFontSize);
set(handles.simAxes, 'FontWeight', handles.defaultFigFontWeight);
set(handles.simAxes, 'LineWidth', handles.defaultAxisLineWidth);
set(handles.simAxes, 'TickDir', 'out');
set(handles.simAxes, 'YMinorTick', 'off');
set(handles.simAxes, 'ZMinorTick', 'off');
set(handles.FigureTitle, 'String', handles.Sim.currentFig);
box('off');
