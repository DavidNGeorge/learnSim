function varargout = rwSim(varargin)
%RWSIM MATLAB code file for rwSim.fig
%      RWSIM, by itself, creates a new RWSIM or raises the existing
%      singleton*.
%
%      H = RWSIM returns the handle to a new RWSIM or the handle to
%      the existing singleton*.
%
%      RWSIM('Property','Value',...) creates a new RWSIM using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to rwSim_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      RWSIM('CALLBACK') and RWSIM('CALLBACK',hObject,...) call the
%      local function named CALLBACK in RWSIM.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help rwSim

% Last Modified by GUIDE v2.5 21-Jul-2017 20:34:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @rwSim_OpeningFcn, ...
                   'gui_OutputFcn',  @rwSim_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before rwSim is made visible.
function rwSim_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to rwSim (see VARARGIN)

%centre window on screen
movegui(gcf, 'center');
% Do some basic housekeeping
% Description of simulator module
handles.Module.name = 'rwSim';
handles.Module.version = 'v1.0.0';
handles.Module.description = 'Rescorla & wagner (1972)';
handles.Module.author = 'David N. George';
handles.Module.institution = 'University of Hull';
handles.Module.contact = 'd.george@hull.ac.uk';
handles.Module.date = 'July 2017';
% Set up default values in one place for convenience
handles.Sim.figTitleList = {'Patterns', 'Stimuli'};
handles.defaultBlocks = 1;
handles.defaultRandOrder = 0;
handles.defaultUniqueCue = 0;
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
set(handles.StimFigButton, 'Enable', 'off');
set(handles.InitButton, 'Enable', 'off');
% Do some basic housekeeping for the simulator
handles.appName = 'rwSim';
handles.titleBar = 'Rescorla-Wagner model simulator (1972)';
set(handles.rwSim, 'Name', handles.titleBar);
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
handles.Network.uniqueCue = handles.defaultUniqueCue;
if handles.Network.uniqueCue == 1
    set(handles.UCCheckBox, 'Value', get(handles.UCCheckBox,'Max'));
    set(handles.uq1RadioButton, 'Value', 1);
    set(handles.uq1RadioButton, 'Enable', 'on');
    set(handles.uq2RadioButton, 'Value', 0);
    set(handles.uq2RadioButton, 'Enable', 'on');
elseif handles.Network.uniqueCue == 2
    set(handles.UCCheckBox, 'Value', get(handles.UCCheckBox,'Max'));
    set(handles.uq1RadioButton, 'Value', 0);
    set(handles.uq1RadioButton, 'Enable', 'on');
    set(handles.uq2RadioButton, 'Value', 1);
    set(handles.uq2RadioButton, 'Enable', 'on');
else
    set(handles.UCCheckBox,'Value', get(handles.UCCheckBox,'Min'));
    set(handles.uq1RadioButton, 'Value', 1);
    set(handles.uq1RadioButton, 'Enable', 'off');
    set(handles.uq2RadioButton, 'Value', 0);
    set(handles.uq2RadioButton, 'Enable', 'off');
end
handles.Sim.epochs = handles.defaultEpochs;
set(handles.EpochsValue, 'String', handles.Sim.epochs);

% Choose default command line output for rwSim
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes rwSim wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = rwSim_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object deletion, before destroying properties.
function rwSim_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to rwSim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% resets main GUI data so that push buttons are active and a new simulator may be started
% find handle of main GUI
hMain = findobj('Tag', 'learnSim');
% fetch data associated with main GUI
mainGuiData = guidata(hMain);
% re-enable push buttons
set(mainGuiData.RWbutton, 'Enable', 'on');
% return main GUI data
guidata(hMain, mainGuiData);


% --- Executes on button press in PatFigButton.
function PatFigButton_Callback(hObject, eventdata, handles)
% hObject    handle to PatFigButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Sim.currentFig = handles.Sim.figTitleList(1);
set(handles.PatFigButton, 'Enable', 'off');
set(handles.StimFigButton, 'Enable', 'on');
handles = PlotData(hObject, eventdata, handles);
guidata(hObject, handles);


% --- Executes on button press in StimFigButton.
function StimFigButton_Callback(hObject, eventdata, handles)
% hObject    handle to StimFigButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Sim.currentFig = handles.Sim.figTitleList(2);
set(handles.PatFigButton, 'Enable', 'on');
set(handles.StimFigButton, 'Enable', 'off');
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


% --- Executes on button press in UCCheckBox.
function UCCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to UCCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of UCCheckBox
if (get(hObject,'Value') == get(hObject,'Max'))
    set(handles.uq1RadioButton, 'Enable', 'on');
    set(handles.uq2RadioButton, 'Enable', 'on');
    if get(handles.uq1RadioButton, 'Value') == 1
        handles.Network.uniqueCue = 1;
    elseif get(handles.uq2RadioButton, 'Value') == 1
        handles.Network.uniqueCue = 2;
    end
else
	handles.Network.uniqueCue = 0;
    set(handles.uq1RadioButton, 'Enable', 'off');
    set(handles.uq2RadioButton, 'Enable', 'off');
end
guidata(hObject, handles);


% --- Executes on button press in uq1RadioButton.
function uq1RadioButton_Callback(hObject, eventdata, handles)
% hObject    handle to uq1RadioButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of uq1RadioButton
set(handles.uq1RadioButton, 'Value', 1);
set(handles.uq2RadioButton, 'Value', 0);
handles.Network.uniqueCue = 1;
guidata(hObject, handles);


% --- Executes on button press in uq2RadioButton.
function uq2RadioButton_Callback(hObject, eventdata, handles)
% hObject    handle to uq2RadioButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of uq2RadioButton
set(handles.uq1RadioButton, 'Value', 0);
set(handles.uq2RadioButton, 'Value', 1);
handles.Network.uniqueCue = 2;
guidata(hObject, handles);

function EpochsValue_Callback(hObject, eventdata, handles)
% hObject    handle to EpochsValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EpochsValue as text
%        str2double(get(hObject,'String')) returns contents of EpochsValue as a double
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
[filelist,fileexist] = lsimGetFileList(expFolder,'rw');
if all(fileexist)
    handles.Sim.expFolder = expFolder;
    handles.Sim.fileList = filelist;
    set(handles.InitButton, 'Enable', 'on');
    [~, handles.expName, ~] = fileparts(expFolder);
    set(handles.rwSim, 'Name', [handles.titleBar ' : ' handles.expName]);
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
[handles.Train.trials, handles.Train.outcome, handles.Network.beta, handles.Network.alpha, eflag] = lsimGetExptData(handles.Sim.fileList, 'rw');
if ~eflag
    % do some gui housekeeping
    if handles.Sim.epochs == 1
        handles.Sim.XLab = 'Epochs';
    else
        handles.Sim.XLab = ['Blocks of ' num2str(handles.Sim.epochs) ' epochs'];
    end
    set(handles.RandomCheckBox, 'Enable', 'off');
    set(handles.UCCheckBox, 'Enable', 'off');
    set(handles.uq1RadioButton, 'Enable', 'off');
    set(handles.uq2RadioButton, 'Enable', 'off');
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
    set(handles.StimFigButton, 'Enable', 'on');
    % initialize the network
    handles.Sim.currentBlock = 0;
    handles.Sim.currentStage = 1;
    [handles.Train.nTrials, handles.Network.nStimuli] = size(handles.Train.trials);
    [handles.Network.patterns, handles.Network.active, handles.Network.unitAlpha, handles.Network.unitNames] = lsimRWCues(handles.Network.nStimuli, handles.Network.alpha, handles.Network.uniqueCue);
    [handles.Network.nPatterns, handles.Network.nUnits] = size(handles.Network.active);
    handles.Network.patternNames = lsimNameTrials(handles.Network.patterns);
    handles.Network.V = zeros(1, handles.Network.nUnits);
    handles.Train.currentList = lsimTrials(lsimReorder(lsimPatterns(handles.Train.trials)), handles.Network.patterns);
    handles.Train.nCurrentPats = size(handles.Train.currentList, 1);
    handles.Train.trialList = lsimTrials(handles.Train.trials, handles.Network.patterns);
    handles.Data.currentVSum = zeros(1,handles.Train.nCurrentPats);
    handles.Data.stage(handles.Sim.currentStage).V = zeros(1, handles.Network.nUnits);
    handles.Data.stage(handles.Sim.currentStage).VSum = zeros(1, handles.Train.nCurrentPats);
    handles.Data.stage(handles.Sim.currentStage).patNames = handles.Network.patternNames(handles.Train.currentList);
    handles.XVal = zeros(1);
    handles.patValues = {'Pattern associative strength'};
    handles.stimValues = {'Stimulus associative strength'};
    % initialize figures
    handles.Sim.currentFig = handles.Sim.figTitleList(1);
    set(handles.FigureTitle, 'String', handles.Sim.currentFig);
    set(handles.PatFigButton, 'Enable', 'off');
    set(handles.StimFigButton, 'Enable', 'on');
    plot(handles.XVal, handles.Data.stage(handles.Sim.currentStage).VSum);
    set(get(handles.simAxes, 'XLabel'), 'String', handles.Sim.XLab);
    set(get(handles.simAxes, 'YLabel'), 'String', handles.Sim.YLab);
    handles.simLegend = legend(handles.Data.stage(handles.Sim.currentStage).patNames, 'Location', 'east');
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
% pre-allocate matrix to accept training data
handles.Data.currentVSum = zeros(1, handles.Train.nCurrentPats);
handles.Data.stage(handles.Sim.currentStage).VSum = [handles.Data.stage(handles.Sim.currentStage).VSum; zeros(handles.Sim.blocks, handles.Train.nCurrentPats)];
handles.Data.stage(handles.Sim.currentStage).V = [handles.Data.stage(handles.Sim.currentStage).V; zeros(handles.Sim.blocks, handles.Network.nUnits)];
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
%First, Calculate Vsum. active is a matrix indicating which units (stimuli
%and unique cues) are active for each pattern. We simply multiply this by 
%each units's associative strength (.Network.V) and sum across everything.
            VSum = sum(handles.Network.V .* handles.Network.active(trialSequence(trialNum),:));
%Second, calculate the prediction error
            Verror = outcomeSequence(trialNum) - VSum;
%Third, decide which beta to use (excitatory or inhibitory) - dependent 
%upon the US. In this case, we can set any value for the US and so it is 
%not so simple as distinguishing between the presence and absence of the 
%US. Instead, we use beta(1) for postive values of US and beta(2) for other 
%values - zero or negative.
            if (outcomeSequence(trialNum) > 0)
                b=handles.Network.beta(1);
            elseif (outcomeSequence(trialNum) <= 0)
                b=handles.Network.beta(2);
            end
%Fourth, update the associative strength of each unit as a result of
%learning on this trial
            handles.Network.V = handles.Network.V + handles.Network.unitAlpha .* handles.Network.active(trialSequence(trialNum),:) * b * Verror;
        end %end of epoch loop
    end %end of block of epochs loop
%Now we run through each training pattern and calculate Vsum again - for 
%plotting and data storage. This means all data out are as measured 
%following the end of cycle block rather than as we go along. This should 
%not be particularly important MOST of the time. Only unique trial types 
%that are used in the current training stage are used here
    for patNum = 1:1:handles.Train.nCurrentPats
        VSum = sum(handles.Network.V .* handles.Network.active(handles.Train.currentList(patNum), :));
        handles.Data.currentVSum(patNum) = VSum;
    end
%Next we update our data stores
    handles.Data.stage(handles.Sim.currentStage).VSum(handles.Sim.currentBlock + 1, :) = handles.Data.currentVSum;
    handles.Data.stage(handles.Sim.currentStage).V(handles.Sim.currentBlock + 1, :, :) = handles.Network.V;
    handles.XVal(handles.Sim.currentBlock + 1) = handles.Sim.currentBlock;
end %end of run loop
%Finally, plot the updated data
handles = PlotData(hObject, eventdata, handles);
for patNum = 1:1:handles.Train.nCurrentPats
	handles.patValues = [handles.patValues [char(handles.Data.stage(handles.Sim.currentStage).patNames(patNum)) ' = ' num2str(handles.Data.currentVSum(patNum))]];
end
for unitNum = 1:1:handles.Network.nUnits
    handles.stimValues = [handles.stimValues [char(handles.Network.unitNames(unitNum)) ' = ' num2str(handles.Network.V(unitNum))]];
end
set(handles.PatternText, 'String', handles.patValues, 'Value', length(handles.patValues));
set(handles.StimText, 'String', handles.stimValues, 'Value', length(handles.stimValues));
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
    '*.xlsx', 'Save training data [stimuli] (*.xlsx)';...
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
        V = handles.Network.V;
        save(fullfile(pathName, fileName), 'V');
    case 3
        %save training data (unit associative strength) in an xlsx file. Each stage is saved in a separate sheet
        xlswrite(fullfile(pathName, fileName), ...
            [{'Module', handles.Module.name; 'Version', handles.Module.version;...
            'Description', handles.Module.description; 'Author', handles.Module.author;...
            'Institution', handles.Module.institution; 'Address', handles.Module.contact;...
            'Date', handles.Module.date; 'Experiment', handles.Sim.expFolder}], 'Sheet1');
        for simStage = 1:1:handles.Sim.currentStage
            warning off MATLAB:xlswrite:AddSheet
            xlswrite(fullfile(pathName, fileName), ...
                [handles.Network.unitNames'; num2cell(handles.Data.stage(simStage).V)], ...
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
                [handles.Data.stage(simStage).patNames'; num2cell(handles.Data.stage(simStage).VSum)], ...
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
            handles.Train.currentList = lsimTrials(lsimReorder(lsimPatterns(handles.Train.trials)), handles.Network.patterns);
            handles.Train.nCurrentPats = size(handles.Train.currentList, 1);
            handles.Train.trialList = lsimTrials(handles.Train.trials, handles.Network.patterns);
            handles.Train.nTrials = size(handles.Train.trials, 1);
            handles.Data.currentVSum = zeros(1,handles.Train.nCurrentPats);
            for patNum = 1:1:handles.Train.nCurrentPats
                VSum = sum(handles.Network.V .* handles.Network.active(handles.Train.currentList(patNum), :));
                handles.Data.currentVSum(patNum) = VSum;
            end
            handles.Data.stage(handles.Sim.currentStage).V(1, :) = handles.Network.V;
            handles.Data.stage(handles.Sim.currentStage).VSum(1, :) = handles.Data.currentVSum;
            handles.Data.stage(handles.Sim.currentStage).patNames = handles.Network.patternNames(handles.Train.currentList);
            handles.XVal = zeros(1);
            handles = PlotData(hObject, eventdata, handles);
            for patNum = 1:1:handles.Train.nCurrentPats
                handles.patValues = [handles.patValues [char(handles.Data.stage(handles.Sim.currentStage).patNames(patNum)) ' = ' num2str(handles.Data.currentVSum(patNum))]];
            end
            for unitNum = 1:1:handles.Network.nUnits
                handles.stimValues = [handles.stimValues [char(handles.Network.unitNames(unitNum)) ' = ' num2str(handles.Network.V(unitNum))]];
            end
            set(handles.PatternText, 'String', handles.patValues, 'Value', length(handles.patValues));
            set(handles.StimText, 'String', handles.stimValues, 'Value', length(handles.stimValues));
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
warning('off', 'MATLAB:load:variableNotFound');
currentFolder = pwd;
cd(handles.Sim.expFolder);
[loadFile, loadPath] = uigetfile('*.mat', 'Load Previous Network State');
if loadFile
    try
        V = load(fullfile(loadPath, loadFile), '-mat', 'V');
        [brow, bcol] = size(V.V);
        [erow, ecol] = size(handles.Network.V);
        if (brow == erow) && (bcol == ecol)
            handles.Network.V = V.V;
            msgbox('Network state loaded from file.', 'Load Previous Network State', 'modal');
        else
            errordlg('Network dimensions do not match', 'Load Error', 'modal');
        end
    catch err
        if (strcmp(err.identifier, 'MATLAB:load:notBinaryFile'))
            errordlg('Not a binary MAT file', 'Load Error', 'modal');
        elseif (strcmp(err.identifier, 'MATLAB:nonExistentField'))
            errordlg('Not a Rescorla-Wagner file', 'Load Error', 'modal');
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
testPattern = inputdlg('Enter space-separated numbers', 'Test pattern');
if ~isempty(testPattern)
    [testPattern, status] = str2num(testPattern{:});
    if (status == 1) && (size(testPattern, 2) == handles.Network.nStimuli)
        testPattern(testPattern > 0) = 1;
        testNumber = lsimTrials(testPattern, handles.Network.patterns);
        testName = handles.Network.patternNames(testNumber);
        testValue = sum(handles.Network.V .* handles.Network.active(testNumber, :));
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
        yData = handles.Data.stage(handles.Sim.currentStage).VSum';
        lText = handles.Data.stage(handles.Sim.currentStage).patNames;
    case 'Stimuli'
        yData = handles.Data.stage(handles.Sim.currentStage).V';
        lText = handles.Network.unitNames;
end
xLab = 0:1:size(yData, 2) - 1;
axes(handles.simAxes);
plot(xLab, yData', 'LineWidth', handles.defaultPlotLineWidth);
handles.simLegend = legend(lText, 'Position', lPos);
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
