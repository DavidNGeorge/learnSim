function varargout = learnSim(varargin)
%LEARNSIM MATLAB code file for learnSim.fig
%      LEARNSIM, by itself, creates a new LEARNSIM or raises the existing
%      singleton*.
%
%      H = LEARNSIM returns the handle to a new LEARNSIM or the handle to
%      the existing singleton*.
%
%      LEARNSIM('Property','Value',...) creates a new LEARNSIM using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to learnSim_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      LEARNSIM('CALLBACK') and LEARNSIM('CALLBACK',hObject,...) call the
%      local function named CALLBACK in LEARNSIM.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help learnSim

% Last Modified by GUIDE v2.5 14-Jul-2017 17:28:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @learnSim_OpeningFcn, ...
                   'gui_OutputFcn',  @learnSim_OutputFcn, ...
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


% --- Executes just before learnSim is made visible.
function learnSim_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to learnSim (see VARARGIN)

movegui(gcf, 'center');

% add some folders to the path
addpath(fullfile(pwd, 'Simulator Files'));
addpath(fullfile(pwd, 'Simulator Functions'));

% enable buttons only for implemented models
set(handles.CTbutton, 'Enable', 'on');
set(handles.REMbutton, 'Enable', 'on');

% Choose default command line output for learnSim
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes learnSim wait for user response (see UIRESUME)
% uiwait(handles.learnSim);


% --- Outputs from this function are returned to the command line.
function varargout = learnSim_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in closebutton.
function closebutton_Callback(hObject, eventdata, handles)
% hObject    handle to closebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close all;


% --- Executes on button press in CTbutton.
function CTbutton_Callback(hObject, eventdata, handles)
% hObject    handle to CTbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% button disabled once simulator launched
    configSim;
    set(handles.CTbutton, 'Enable', 'off');
    guidata(hObject, handles);


% --- Executes on button press in REMbutton.
function REMbutton_Callback(hObject, eventdata, handles)
% hObject    handle to REMbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    remSim;
    set(handles.REMbutton, 'Enable', 'off');
    guidata(hObject, handles);


% --- Executes on button press in RWbutton.
function RWbutton_Callback(hObject, eventdata, handles)
% hObject    handle to RWbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    rwSim;
    set(handles.RWbutton, 'Enable', 'off');
    guidata(hObject, handles);
