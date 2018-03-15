function varargout = gpSim(varargin)
%GPSIM MATLAB code file for gpSim.fig
%      GPSIM, by itself, creates a new GPSIM or raises the existing
%      singleton*.
%
%      H = GPSIM returns the handle to a new GPSIM or the handle to
%      the existing singleton*.
%
%      GPSIM('Property','Value',...) creates a new GPSIM using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to gpSim_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      GPSIM('CALLBACK') and GPSIM('CALLBACK',hObject,...) call the
%      local function named CALLBACK in GPSIM.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gpSim

% Last Modified by GUIDE v2.5 11-Sep-2017 12:15:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gpSim_OpeningFcn, ...
                   'gui_OutputFcn',  @gpSim_OutputFcn, ...
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


% --- Executes just before gpSim is made visible.
function gpSim_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

%centre window on screen
movegui(gcf, 'center');
% Do some basic housekeeping
% Description of simulator module
handles.Module.name = 'gpSim';
handles.Module.version = 'v0.0.1';
handles.Module.description = 'George & Pearce''s (2012) configural theory with attention';
handles.Module.author = 'David N. George';
handles.Module.institution = 'University of Hull';
handles.Module.contact = 'd.george@hull.ac.uk';
handles.Module.date = 'March 2018';
% Set up default values in one place for convenience - this allows the
% simulator to populate values in the GUI
handles.Sim.figTitleList = {'Patterns', 'Configural Units', 'Effectiveness', 'Associability'};
handles.defaultBlocks = 1;
handles.defaultRandOrder = 0;
handles.defaultD = 2;
handles.defaultEpochs = 1;
handles.defaultAlphaMin = .05;
handles.defaultAlphaMax = 1;
handles.defaultAlphaRate = .1;
handles.defaultSigmaMin = .05;
handles.defaultSigmaMax = 1;
handles.defaultSigmaRate = .1;
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
set(handles.AlphaFigButton, 'Enable', 'off');
set(handles.SigmaFigButton, 'Enable', 'off');
set(handles.InitButton, 'Enable', 'off');
% Do some basic housekeeping for the simulator
handles.appName = 'gpSim';
handles.titleBar = 'Attentional Configural Theory simulator (George & Pearce, 2012)';
set(handles.gpSim, 'Name', handles.titleBar);
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
handles.Network.alphaMin = handles.defaultAlphaMin;
set(handles.minEValue, 'String', handles.Network.alphaMin);
handles.Network.alphaMax = handles.defaultAlphaMax;
set(handles.maxEValue, 'String', handles.Network.alphaMax);
handles.Network.alphaRate = handles.defaultAlphaRate;
set(handles.rateEValue, 'String', handles.Network.alphaRate);
handles.Network.sigmaMin = handles.defaultSigmaMin;
set(handles.minAValue, 'String', handles.Network.sigmaMin);
handles.Network.sigmaMax = handles.defaultSigmaMax;
set(handles.maxAValue, 'String', handles.Network.sigmaMax);
handles.Network.sigmaRate = handles.defaultSigmaRate;
set(handles.rateAValue, 'String', handles.Network.sigmaRate);
handles.Sim.epochs = handles.defaultEpochs;
set(handles.EpochsValue, 'String', handles.Sim.epochs);
% these values have some effect on the behaviour of the simulator, but for
% the sake of simplicity have not been included in the GUI
%alphaLinear: changes to alpha same throughout range. otherwise, changes
%using (alpha - alphaMin)(alphaMax - alpha)
handles.Network.alphaLinear = 1;
%can be set to recruit new configural units as the effectiveness of a
%stimulus to activate its own CU changes. If so, will recruit new unit when
%activation of maximally active unit falls below threshold.
handles.Network.recruit = 0;
handles.Network.recruitThreshold = .95;
%new CUs should have some default associability - cannot be set in a file
%because we don't necessarily know when new CUs will be recruited
handles.Network.sigmaDefault = .6;
% Choose default command line output for gpSim
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gpSim wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gpSim_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object deletion, before destroying properties.
function gpSim_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to configSim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% resets main GUI data so that push buttons are active and a new simulator may be started
% find handle of main GUI
hMain = findobj('Tag', 'learnSim');
% fetch data associated with main GUI
mainGuiData = guidata(hMain);
% re-enable push buttons
set(mainGuiData.GPbutton, 'Enable', 'on');
% return main GUI data
guidata(hMain, mainGuiData);


% --- Executes on button press in PatFigButton.
function PatFigButton_Callback(hObject, eventdata, handles)
% hObject    handle to PatFigButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Sim.currentFig = handles.Sim.figTitleList(1);
set(handles.PatFigButton, 'Enable', 'off');
if ~isempty(handles.Network.Wij)
    set(handles.CUFigButton, 'Enable', 'on');
    set(handles.SigmaFigButton, 'Enable', 'on');
else
    set(handles.CUFigButton, 'Enable', 'off');
    set(handles.SigmaFigButton, 'Enable', 'off');
end
set(handles.AlphaFigButton, 'Enable', 'on');
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
set(handles.AlphaFigButton, 'Enable', 'on');
if ~isempty(handles.Network.Wij)
    set(handles.SigmaFigButton, 'Enable', 'on');
else
    set(handles.SigmaFigButton, 'Enable', 'off');
end
handles = PlotData(hObject, eventdata, handles);
guidata(hObject, handles);


% --- Executes on button press in AlphaFigButton.
function AlphaFigButton_Callback(hObject, eventdata, handles)
% hObject    handle to AlphaFigButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Sim.currentFig = handles.Sim.figTitleList(3);
set(handles.PatFigButton, 'Enable', 'on');
if ~isempty(handles.Network.Wij)
    set(handles.CUFigButton, 'Enable', 'on');
    set(handles.SigmaFigButton, 'Enable', 'on');
else
    set(handles.CUFigButton, 'Enable', 'off');
    set(handles.SigmaFigButton, 'Enable', 'off');
end
set(handles.AlphaFigButton, 'Enable', 'off');
handles = PlotData(hObject, eventdata, handles);
guidata(hObject, handles);


% --- Executes on button press in SigmaFigButton.
function SigmaFigButton_Callback(hObject, eventdata, handles)
% hObject    handle to SigmaFigButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Sim.currentFig = handles.Sim.figTitleList(4);
set(handles.PatFigButton, 'Enable', 'on');
if ~isempty(handles.Network.Wij)
    set(handles.CUFigButton, 'Enable', 'on');
else
    set(handles.CUFigButton, 'Enable', 'off');
end
set(handles.SigmaFigButton, 'Enable', 'off');
set(handles.AlphaFigButton, 'Enable', 'on');
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

% Hints: get(hObject,'String') returns contents of dValue as text
%        str2double(get(hObject,'String')) returns contents of dValue as a double
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


function minEValue_Callback(hObject, eventdata, handles)
% hObject    handle to minEValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of minEValue as text
%        str2double(get(hObject,'String')) returns contents of minEValue as a double
S = get(hObject, 'String');
% Issue a warning if non-numerical characters were entered:
if ~all(ismember(S, '.1234567890'))
  warndlg('Minimum effectiveness must be a numerical value in the range 0 to 1', 'Incorrect format', 'modal');
end
% Exclude characters which are not numeric:
S(~ismember(S, '.1234567890')) = '';
% Check that the string is not empty:
if isempty(S)
    S = num2str(handles.Network.alphaMin);
end
% Check that the value is not greater than 1:
if str2num(S) > 1
    S = num2str(1);
    warndlg('Minimum effectiveness must be in the range 0 to 1', 'Value too large', 'modal');
end
% Set the value:
set(hObject, 'String', S);
% Finally set the value in memory
handles.Network.alphaMin = str2num(S);
guidata(hObject, handles);


function minAValue_Callback(hObject, eventdata, handles)
% hObject    handle to minAValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of minAValue as text
%        str2double(get(hObject,'String')) returns contents of minAValue as a double
S = get(hObject, 'String');
% Issue a warning if non-numerical characters were entered:
if ~all(ismember(S, '.1234567890'))
  warndlg('Minimum associability must be a numerical value in the range 0 to 1', 'Incorrect format', 'modal');
end
% Exclude characters which are not numeric:
S(~ismember(S, '.1234567890')) = '';
% Check that the string is not empty:
if isempty(S)
    S = num2str(handles.Network.sigmaMin);
end
% Check that the value is not greater than 1:
if str2num(S) > 1
    S = num2str(1);
    warndlg('Minimum associability must be in the range 0 to 1', 'Value too large', 'modal');
end
% Set the value:
set(hObject, 'String', S);
% Finally set the value in memory
handles.Network.sigmaMin = str2num(S);
guidata(hObject, handles);


function maxEValue_Callback(hObject, eventdata, handles)
% hObject    handle to maxEValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxEValue as text
%        str2double(get(hObject,'String')) returns contents of maxEValue as a double
S = get(hObject, 'String');
% Issue a warning if non-numerical characters were entered:
if ~all(ismember(S, '.1234567890'))
  warndlg('Maximum effectiveness must be a numerical value in the range 0 to 1', 'Incorrect format', 'modal');
end
% Exclude characters which are not numeric:
S(~ismember(S, '.1234567890')) = '';
% Check that the string is not empty:
if isempty(S)
    S = num2str(handles.Network.alphaMax);
end
% Check that the value is not greater than 1:
if str2num(S) > 1
    S = num2str(1);
    warndlg('Maximum effectiveness must be in the range 0 to 1', 'Value too large', 'modal');
end
% Set the value:
set(hObject, 'String', S);
% Finally set the value in memory
handles.Network.alphaMax = str2num(S);
guidata(hObject, handles);


function maxAValue_Callback(hObject, eventdata, handles)
% hObject    handle to maxAValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxAValue as text
%        str2double(get(hObject,'String')) returns contents of maxAValue as a double
S = get(hObject, 'String');
% Issue a warning if non-numerical characters were entered:
if ~all(ismember(S, '.1234567890'))
  warndlg('Maximum associability must be a numerical value in the range 0 to 1', 'Incorrect format', 'modal');
end
% Exclude characters which are not numeric:
S(~ismember(S, '.1234567890')) = '';
% Check that the string is not empty:
if isempty(S)
    S = num2str(handles.Network.sigmaMax);
end
% Check that the value is not greater than 1:
if str2num(S) > 1
    S = num2str(1);
    warndlg('Maximum associability must be in the range 0 to 1', 'Value too large', 'modal');
end
% Set the value:
set(hObject, 'String', S);
% Finally set the value in memory
handles.Network.sigmaMax = str2num(S);
guidata(hObject, handles);


function rateAValue_Callback(hObject, eventdata, handles)
% hObject    handle to rateAValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rateAValue as text
%        str2double(get(hObject,'String')) returns contents of rateAValue as a double
S = get(hObject, 'String');
% Issue a warning if non-numerical characters were entered:
if ~all(ismember(S, '.1234567890'))
  warndlg('Associability learning rate must be a numerical value in the range 0 to 1', 'Incorrect format', 'modal');
end
% Exclude characters which are not numeric:
S(~ismember(S, '.1234567890')) = '';
% Check that the string is not empty:
if isempty(S)
    S = num2str(handles.Network.sigmaRate);
end
% Check that the value is not greater than 1:
if str2num(S) > 1
    S = num2str(1);
    warndlg('Associability learning rate must be in the range 0 to 1', 'Value too large', 'modal');
end
% Set the value:
set(hObject, 'String', S);
% Finally set the value in memory
handles.Network.sigmaRate = str2num(S);
guidata(hObject, handles);


function rateEValue_Callback(hObject, eventdata, handles)
% hObject    handle to rateEValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rateEValue as text
%        str2double(get(hObject,'String')) returns contents of rateEValue as a double
S = get(hObject, 'String');
% Issue a warning if non-numerical characters were entered:
if ~all(ismember(S, '.1234567890'))
  warndlg('Effectiveness learning rate must be a numerical value in the range 0 to 1', 'Incorrect format', 'modal');
end
% Exclude characters which are not numeric:
S(~ismember(S, '.1234567890')) = '';
% Check that the string is not empty:
if isempty(S)
    S = num2str(handles.Network.alphaRate);
end
% Check that the value is not greater than 1:
if str2num(S) > 1
    S = num2str(1);
    warndlg('Effectiveness learning rate be in the range 0 to 1', 'Value too large', 'modal');
end
% Set the value:
set(hObject, 'String', S);
% Finally set the value in memory
handles.Network.alphaRate = str2num(S);
guidata(hObject, handles);


% --- Executes on button press in SelectButton.
function SelectButton_Callback(hObject, eventdata, handles)
% hObject    handle to SelectButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
expFolder = uigetdir(fullfile(pwd, 'Experiments'), 'Select experiment folder');
[filelist,fileexist] = lsimGetFileList(expFolder,'gp');
if all(fileexist)
    handles.Sim.expFolder = expFolder;
    handles.Sim.fileList = filelist;
    set(handles.InitButton, 'Enable', 'on');
    [~, handles.expName, ~] = fileparts(expFolder);
    set(handles.gpSim, 'Name', [handles.titleBar ' : ' handles.expName]);
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
rflag = 0;
if handles.Network.alphaMin > handles.Network.alphaMax
    warndlg('Minimum effectiveness cannot be greater than maximum effectiveness', 'Effectiveness range', 'modal')
    rflag = 1;
end
if handles.Network.sigmaMin > handles.Network.sigmaMax
    warndlg('Minimum associability cannot be greater than maximum effectiveness', 'Associability range', 'modal')
    rflag = 1;
end
[handles.Train.trials, handles.Train.outcome, handles.Network.intensity, handles.Network.beta, handles.Network.alpha, eflag] = lsimGetExptData(handles.Sim.fileList, 'gp');
handles.Network.alpha(handles.Network.alpha > handles.Network.alphaMax) = handles.Network.alphaMax;
handles.Network.alpha(handles.Network.alpha < handles.Network.alphaMin) = handles.Network.alphaMin;
if eflag || rflag
    return
end
% do some gui housekeeping
if handles.Sim.epochs == 1
    handles.Sim.XLab = 'Epochs';
else
    handles.Sim.XLab = ['Blocks of ' num2str(handles.Sim.epochs) ' epochs'];
end
set(handles.RandomCheckBox, 'Enable', 'off');
set(handles.dValue, 'Enable', 'off');
set(handles.dLabel, 'Enable', 'off');
set(handles.EpochsValue, 'Enable', 'off');
set(handles.EpochsLabel, 'Enable', 'off');
set(handles.SelectButton, 'Enable', 'off');
set(handles.InitButton, 'Enable', 'off');
set(handles.minEValue, 'Enable', 'off');
set(handles.maxEValue, 'Enable', 'off');
set(handles.rateEValue, 'Enable', 'off');
set(handles.minAValue, 'Enable', 'off');
set(handles.maxAValue, 'Enable', 'off');
set(handles.rateAValue, 'Enable', 'off');
set(handles.minLabel, 'Enable', 'off');
set(handles.maxLabel, 'Enable', 'off');
set(handles.rateLabel, 'Enable', 'off');
set(handles.EffectLabel, 'Enable', 'off');
set(handles.text11, 'Enable', 'off');
set(handles.RunButton, 'Enable', 'on');
set(handles.SaveButton, 'Enable', 'on');
set(handles.LoadButton, 'Enable', 'on');
set(handles.NewButton, 'Enable', 'on');
set(handles.TestButton, 'Enable', 'on');
set(handles.PatFigButton, 'Enable', 'on');
set(handles.CUFigButton, 'Enable', 'on');
% initialize the network
%NOTE - does not initialize any CUs because these are recruited during
%training.
handles.Sim.currentBlock = 0;
handles.Sim.currentStage = 1;
handles.Train.patterns = [];
[handles.Train.patterns, handles.Network.actIn, ~] = lsimPatterns(handles.Train.trials, handles.Train.patterns, handles.Network.intensity);
handles.Train.patternSeen = false(size(handles.Train.patterns, 1), 1);
[handles.Train.currentPatterns, ~, ~] = lsimPatterns(handles.Train.trials, [], handles.Network.intensity);
handles.Train.trialList = lsimTrials(handles.Train.trials, handles.Train.patterns);
handles.Train.currentList = lsimTrials(handles.Train.currentPatterns, handles.Train.patterns);
handles.Train.currentNames = lsimNameTrials(handles.Train.currentPatterns);
[handles.Train.nCurrentPats, ~] = size(handles.Train.currentList);
[handles.Train.nTrials, handles.Network.nStimuli] = size(handles.Train.trials);
handles.Network.E = [];
handles.Network.sigma = [];
handles.Network.stimulusNames = lsimNameTrials(diag(ones(handles.Network.nStimuli, 1)));
handles.Network.Wij = [];
handles.XVal = zeros(1);
handles.patValues = {'Pattern associative strength'};
handles.confValues = {'CU associative strength'};
handles.effectValues = {'Stimulus effectiveness'};
handles.assocValues = {'CU associability'};
if handles.Network.sigmaDefault > handles.Network.sigmaMax
    handles.Network.sigmaDefault = handles.Network.sigmaMax;
end
if handles.Network.sigmaDefault < handles.Network.sigmaMin
    handles.Network.sigmaDefault = handles.Network.sigmaMax;
end
handles.Data.stage(handles.Sim.currentStage).Et = zeros(1);
handles.Data.stage(handles.Sim.currentStage).sigma = handles.Network.sigmaDefault;
handles.Data.stage(handles.Sim.currentStage).Vt = zeros(1, handles.Train.nCurrentPats);
handles.Data.stage(handles.Sim.currentStage).alpha = handles.Network.alpha;
handles.Data.stage(handles.Sim.currentStage).patNames = handles.Train.currentNames;
% initialize figures - those related to CUs stay off because no CUs have
% yet been recruited
handles.Sim.currentFig = handles.Sim.figTitleList(1);
set(handles.FigureTitle, 'String', handles.Sim.currentFig);
set(handles.PatFigButton, 'Enable', 'off');
set(handles.CUFigButton, 'Enable', 'off');
set(handles.AlphaFigButton, 'Enable', 'on');
set(handles.SigmaFigButton, 'Enable', 'off');
plot(handles.XVal, handles.Data.stage(handles.Sim.currentStage).Vt);
set(get(handles.simAxes, 'XLabel'), 'String', handles.Sim.XLab);
set(get(handles.simAxes, 'YLabel'), 'String', handles.Sim.YLab);
handles.simLegend = legend([], 'Location', 'east');
handles = PlotData(hObject, eventdata, handles);
% save gui data
guidata(hObject, handles);
    

% --- Executes on button press in RunButton.
function RunButton_Callback(hObject, eventdata, handles)
% hObject    handle to RunButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% train the network
% preallocating space in data storage arrays saves time, but cannot
% necessarily be done for this simulator - the number of CUs may change if
% it is set to recruit new CUs dependent upon changes in the effectiveness
% of output units (this is always the case on the first block of trials).
% in this version, we shall just use the slow simple method of checking
% every time.
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
%there are six steps involved in presenting a pattern and updating its
%associative strength.
%First, we must check whether we need to recruit a new CU for the pattern.
%a new CU will always be required the first time that a pattern is 
%presented. To enable this, there is a flag for each pattern which is false
%before the pattern has been presented, and is then flipped to true
            actIn = handles.Network.actIn(trialSequence(trialNum), :);
            if handles.Train.patternSeen(trialSequence(trialNum))
                [handles.Network, max_index] = lsimRecruitCU(actIn, handles.Network);
            else
                [handles.Network, max_index] = lsimRecruitCU(actIn, handles.Network, 'force');
                handles.Train.patternSeen(trialSequence(trialNum)) = true;
            end
%Second, calculate activity across the output layer of the input network.
%This has to be done each time the pattern is presetned because changes in
%the effectiveness of output units will have an effect.
            actOut = actIn .* handles.Network.alpha .* (1 / sqrt(sum((actIn .* handles.Network.alpha) .^2)));
%Third, calulate Vsum. handles.Network.Wij contains the weight matrix for 
%the connections between each output unit to each configural unit. Hence, 
%we can Wij by the activation of the output layer actOut, and raise this 
%to the power of the discriminatbility parameter - dParam - to get the 
%activity across all of the configural units. This is multiplied by the 
%array E which contains the associative strength of each configural unit
%to give Vsum!
            Vsum = sum(handles.Network.E .* ((handles.Network.Wij * actOut') .^ handles.Network.dParam)');
%Fourth, calculate the prediction error
            Verror = outcomeSequence(trialNum) - Vsum;
%Fifth, decide which beta to use (excitatory or inhibitory) - dependent 
%upon US. In this case, we can set any value for the US and so it is not so
%simple as distinguishing between the presence and absence of the US. 
%Instead, we use beta(1) for postive values of US and beta(2) for other 
%values - zero or negative.
            if (outcomeSequence(trialNum) > 0)
                b=handles.Network.beta(1);
            elseif (outcomeSequence(trialNum) <= 0)
                b=handles.Network.beta(2);
            end
%Sixth update the associative strength of the configural unit that is most
%active and so corresponds most closely to the pattern presented.
            handles.Network.E(max_index) = handles.Network.E(max_index) + (b * Verror * handles.Network.sigma(max_index));
%now we perform the attentional updating
%First, convert the sign of the associative strength of each CU to reflect
%whether or not it agress with the US. This code is only going to work
%properly when there are two outcomes, but shouldn't collapse under other
%conditions. Basically, when the US = 0 (if outputs are 1 and 0, or less 
%than 0 if outputs are +1 and -1) the signs of the associative strengths
%are reversed (excitatory become negative, inhibitory become positive).
            if outcomeSequence(trialNum) > 0
                signedOut = 1;
            else
                signedOut = -1;
            end
            signedE = handles.Network.E * signedOut;
%Second,calculate the feedback to each feature unit. We first need to
%calculate the input activation of each CU (Wij * actOut). Multiplying this 
%by the signedE gives the amount of feedback from each CU. The feedback to
%the output units is simply the sum of the feedback from each CU to which
%it is connected - this is not affected by the strength of the connection
%(Wij) between the output unit and CU. It is scaled by the activation of
%the output unit
            %feedback from each CU:
            feedback = signedE .* (handles.Network.Wij * actOut')';
            %feedback to each feature unit:
            connections = handles.Network.Wij;
            connections(connections > 0) = 1;
            feedback = feedback * connections;
            %scale by output unit activation:
            F = feedback .* actOut;
%Third, changes in effectiveness are proportional to the difference between
%the feedback to a particular output unit and the mean feedback to all
%active output units, so we need to calculate the mean feedback.
            active = sum(handles.Train.patterns(trialSequence(trialNum), :));
            if active == 1
                netF = F;
            else
                netF = F - mean(F(handles.Train.patterns(trialSequence(trialNum), :)~=0));
            end
%Fourth, make changes to output unit effectiveness
            if handles.Network.alphaLinear
                handles.Network.alpha = handles.Network.alpha + netF .* handles.Network.alphaRate;
                handles.Network.alpha(handles.Network.alpha > handles.Network.alphaMax) = handles.Network.alphaMax;
                handles.Network.alpha(handles.Network.alpha < handles.Network.alphaMin) = handles.Network.alphaMin;
            else
                handles.Network.alpha = handles.Network.alpha + netF .* handles.Network.alphaRate ...
                    .* (handles.Network.alpha - handles.Network.alphaMin) .* (handles.Network.alphaMax - handles.Network.alpha);
            end
%Fifth, make changes to the associability of the most active CU
            handles.Network.sigma(max_index) = (handles.Network.sigmaRate * abs(Verror)) + ((1 - handles.Network.sigmaRate) * handles.Network.sigma(max_index));
        end %end loop of trials in epoch
    end %end loop of epochs within block
%After each block of epochs, we must run through all of the training
%patterns again to calculate the data to report and to store. Only unique
%trial types are used here and no changes are made to E, alpha, or sigma
    for patNum = 1:1:handles.Train.nCurrentPats
        actIn = handles.Network.actIn(handles.Train.currentList(patNum), :);
        actOut = actIn .* handles.Network.alpha .* (1 / sqrt(sum((actIn .* handles.Network.alpha) .^2)));
        Vsum = sum(handles.Network.E .* ((handles.Network.Wij * actOut') .^ handles.Network.dParam)');
        handles.Data.currentVt(patNum) = Vsum;
    end
%Next we update our data stores
%Stores for E and sigma will have to expand if new CUs have been recruited
    handles.Data.stage(handles.Sim.currentStage).Vt(handles.Sim.currentBlock + 1, :) = handles.Data.currentVt;
    if size(handles.Network.E, 2) > size(handles.Data.stage(handles.Sim.currentStage).Et, 2)
        sRows = size(handles.Data.stage(handles.Sim.currentStage).Et, 1);
        sCols = size(handles.Data.stage(handles.Sim.currentStage).Et, 2);
        nCols = size(handles.Network.E, 2);
        handles.Data.stage(handles.Sim.currentStage).Et = [handles.Data.stage(handles.Sim.currentStage).Et zeros(sRows, nCols - sCols)];
    end
    handles.Data.stage(handles.Sim.currentStage).Et(handles.Sim.currentBlock + 1, :) = handles.Network.E;
    handles.Data.stage(handles.Sim.currentStage).alpha(handles.Sim.currentBlock + 1, :) = handles.Network.alpha;
    if size(handles.Network.sigma, 2) > size(handles.Data.stage(handles.Sim.currentStage).sigma, 2)
        sRows = size(handles.Data.stage(handles.Sim.currentStage).sigma, 1);
        sCols = size(handles.Data.stage(handles.Sim.currentStage).sigma, 2);
        nCols = size(handles.Network.sigma, 2);
        handles.Data.stage(handles.Sim.currentStage).sigma = [handles.Data.stage(handles.Sim.currentStage).sigma ones(sRows, nCols - sCols) * handles.Network.sigmaDefault];
    end
    handles.Data.stage(handles.Sim.currentStage).sigma(handles.Sim.currentBlock + 1, :) = handles.Network.sigma;
    handles.XVal(handles.Sim.currentBlock + 1) = handles.Sim.currentBlock;
end %end loop of blocks of training
%Finally, plot the updated data
handles = PlotData(hObject, eventdata, handles);
%enable figures that may not have been available before the first training
%run (i.e. associability and configural units)
switch char(handles.Sim.currentFig)
    case char(handles.Sim.figTitleList(1))
        set(handles.PatFigButton, 'Enable', 'off');
        set(handles.CUFigButton, 'Enable', 'on');
        set(handles.AlphaFigButton, 'Enable', 'on');
        set(handles.SigmaFigButton, 'Enable', 'on');
    case char(handles.Sim.figTitleList(2))
        set(handles.PatFigButton, 'Enable', 'on');
        set(handles.CUFigButton, 'Enable', 'off');
        set(handles.AlphaFigButton, 'Enable', 'on');
        set(handles.SigmaFigButton, 'Enable', 'on');
    case char(handles.Sim.figTitleList(3))
        set(handles.PatFigButton, 'Enable', 'on');
        set(handles.CUFigButton, 'Enable', 'on');
        set(handles.AlphaFigButton, 'Enable', 'off');
        set(handles.SigmaFigButton, 'Enable', 'on');
    case char(handles.Sim.figTitleList(4))
        set(handles.PatFigButton, 'Enable', 'on');
        set(handles.CUFigButton, 'Enable', 'on');
        set(handles.AlphaFigButton, 'Enable', 'on');
        set(handles.SigmaFigButton, 'Enable', 'off');
end
%and write it to the text boxes
for patNum = 1:1:handles.Train.nCurrentPats
	handles.patValues = [handles.patValues [char(handles.Train.currentNames(patNum)) ' = ' num2str(handles.Data.currentVt(patNum))]];
end
handles.Network.configNames = lsimNameCU(handles.Network.Wij);
handles.Data.stage(handles.Sim.currentStage).CUNames  = handles.Network.configNames;
handles.Network.nConfigs = size(handles.Network.Wij, 1);
for confNum = 1:1:handles.Network.nConfigs
    handles.confValues = [handles.confValues [char(handles.Network.configNames(confNum)) ' = ' num2str(handles.Network.E(confNum))]];
    handles.assocValues = [handles.assocValues [char(handles.Network.configNames(confNum)) ' = ' num2str(handles.Network.sigma(confNum))]];
end
for stimNum = 1:1:handles.Network.nStimuli
    handles.effectValues = [handles.effectValues [char(handles.Network.stimulusNames(stimNum)) ' = ' num2str(handles.Network.alpha(stimNum))]];
end
set(handles.PatternText, 'String', handles.patValues, 'Value', length(handles.patValues));
set(handles.CUText,  'String', handles.confValues, 'Value', length(handles.confValues));
set(handles.effectivenessText, 'String', handles.effectValues, 'Value', length(handles.effectValues));
set(handles.associabilityText, 'String', handles.assocValues, 'Value', length(handles.assocValues));
%Update all of the data stored in handles
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
    '*.xlsx', 'Save training data [patterns] (*.xlsx)';...
    '*.xlsx', 'Save training data [stimulus effectiveness] (*.xlsx)';...
    '*.xlsx', 'Save training data [CU associability] (*.xlsx)'});
switch filterIndex
    case 1
        %save all data in an mat-file
        NETWORK = handles.Network;
        DATA = handles.Data;
        TRAIN = handles.Train;
        SIM = handles.Sim;
        save(fullfile(pathName, fileName), 'NETWORK', 'DATA', 'TRAIN', 'SIM');
    case 2
        %save current network state. 
        %Might later be used to 'Load Network' but only is net has been
        %appropriately initialized
        NETWORK = handles.Network;
        save(fullfile(pathName, fileName), 'NETWORK');
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
    case 5
        %save training data (stimulus effectiveness, alpha) in an xlsx file. Each stage is saved in a separate sheet
        xlswrite(fullfile(pathName, fileName), ...
            [{'Module', handles.Module.name; 'Version', handles.Module.version;...
            'Description', handles.Module.description; 'Author', handles.Module.author;...
            'Institution', handles.Module.institution; 'Address', handles.Module.contact;...
            'Date', handles.Module.date; 'Experiment', handles.Sim.expFolder}], 'Sheet1');
        for simStage = 1:1:handles.Sim.currentStage
            warning off MATLAB:xlswrite:AddSheet
            xlswrite(fullfile(pathName, fileName), ...
                [handles.Network.stimulusNames'; num2cell(handles.Data.stage(simStage).alpha)], ...
                horzcat('Stage ', num2str(simStage)));
        end    
    case 6
        %save training data (CU associability, sigma) in an xlsx file. Each stage is saved in a separate sheet
        xlswrite(fullfile(pathName, fileName), ...
            [{'Module', handles.Module.name; 'Version', handles.Module.version;...
            'Description', handles.Module.description; 'Author', handles.Module.author;...
            'Institution', handles.Module.institution; 'Address', handles.Module.contact;...
            'Date', handles.Module.date; 'Experiment', handles.Sim.expFolder}], 'Sheet1');
        for simStage = 1:1:handles.Sim.currentStage
            warning off MATLAB:xlswrite:AddSheet
            xlswrite(fullfile(pathName, fileName), ...
                [handles.Data.stage(simStage).CUNames'; num2cell(handles.Data.stage(simStage).sigma)], ...
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
            [handles.Train.patterns, handles.Network.actIn, ~] = lsimPatterns(handles.Train.trials, handles.Train.patterns, handles.Network.intensity);
            if size(handles.Train.patterns, 1) > size(handles.Train.patternSeen)
                handles.Train.patternSeen = [handles.Train.patternSeen; false(size(handles.Train.patterns, 1) - size(handles.Train.patternSeen, 1), 1)];
            end
            [handles.Train.currentPatterns, ~, ~] = lsimPatterns(handles.Train.trials, [], handles.Network.intensity);
            handles.Train.trialList = lsimTrials(handles.Train.trials, handles.Train.patterns);
            handles.Train.currentList = lsimTrials(handles.Train.currentPatterns, handles.Train.patterns);
            handles.Train.currentNames = lsimNameTrials(handles.Train.currentPatterns);
            [handles.Train.nCurrentPats, ~] = size(handles.Train.currentList);
            handles.Train.nTrials = size(handles.Train.trials, 1);
            handles.XVal = zeros(1);
            handles.Data.stage(handles.Sim.currentStage).Et = handles.Network.E;
            handles.Data.stage(handles.Sim.currentStage).sigma = handles.Network.sigma;
            handles.Data.stage(handles.Sim.currentStage).alpha = handles.Network.alpha;
            handles.Data.stage(handles.Sim.currentStage).patNames = handles.Train.currentNames;
            handles.Data.stage(handles.Sim.currentStage).Vt = zeros(1, handles.Train.nCurrentPats);
            for patNum = 1:1:handles.Train.nCurrentPats
                actIn = handles.Network.actIn(handles.Train.currentList(patNum), :);
                actOut = actIn .* handles.Network.alpha .* (1 / sqrt(sum((actIn .* handles.Network.alpha) .^2)));
                Vsum = sum(handles.Network.E .* ((handles.Network.Wij * actOut') .^ handles.Network.dParam)');
                handles.Data.currentVt(patNum) = Vsum;
            end
            handles.Data.stage(handles.Sim.currentStage).Vt(1, :) = handles.Data.currentVt;
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
        Network = load(fullfile(loadPath, loadFile), '-mat', 'NETWORK');
        if all(size(Network.NETWORK.E) == size(handles.Network.E)) && ...
                all(size(Network.NETWORK.Wij) == size(handles.Network.Wij)) && ...
                (size(Network.NETWORK.sigma, 2) == size(handles.Network.sigma, 2)) && ...
                (size(Network.NETWORK.alpha, 2) == size(handles.Network.alpha, 2))
            handles.Network.E = Network.NETWORK.E;
            handles.Network.Wij = Network.NETWORK.Wij;
            handles.Network.sigma = Network.NETWORK.sigma;
            handles.Network.alpha = Network.NETWORK.alpha;
            msgbox('Network state loaded from file.', 'Load Previous Network State', 'modal');
        else
            errordlg('Network dimensions do not match', 'Load Error', 'modal');
        end
    catch err
        if (strcmp(err.identifier, 'MATLAB:load:notBinaryFile'))
            errordlg('Not a binary MAT file', 'Load Error', 'modal');
        elseif (strcmp(err.identifier, 'MATLAB:nonExistentField'))
            errordlg('Not a George & Pearce file', 'Load Error', 'modal');
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
        testName = lsimNameTrials(testPattern);
        actIn = testPattern .* handles.Network.intensity;
        actOut = actIn .* handles.Network.alpha .* (1 / sqrt(sum((actIn .* handles.Network.alpha) .^2)));
        testValue = sum(handles.Network.E .* ((handles.Network.Wij * actOut') .^ handles.Network.dParam)');
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

% Hints: get(hObject,'String') returns contents of BlocksValue as text
%        str2double(get(hObject,'String')) returns contents of BlocksValue as a double
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


% --- Called by RunButton PatFigButton CTFigButton SigmaFigButton and AlphaFigButton.
function handles = PlotData(hObject, eventdata, handles)
switch char(handles.Sim.currentFig)
    case 'Patterns'
        yData = handles.Data.stage(handles.Sim.currentStage).Vt';
        lText = handles.Train.currentNames;
    case 'Configural Units'
        yData = handles.Data.stage(handles.Sim.currentStage).Et';
        lText = handles.Network.configNames;
    case 'Effectiveness'
        yData = handles.Data.stage(handles.Sim.currentStage).alpha';
        lText = handles.Network.stimulusNames;
    case 'Associability'
        yData = handles.Data.stage(handles.Sim.currentStage).sigma';
        lText = handles.Network.configNames;
end
xLab = 0:1:size(yData, 2) - 1;
axes(handles.simAxes);
plot(xLab, yData', 'LineWidth', handles.defaultPlotLineWidth);
handles.simLegend = legend(lText, 'Location', 'East');
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