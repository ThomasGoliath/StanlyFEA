%% STANLY FEA - FRAME SOLVER version 2017

%%% Tommaso Cavandoli
clc
clear all
close all
fclose all;
diary off
format shorte

%% Check for first execution

if exist('~first_run','file')
    FirstRun
end

%% Logger

% Init logger (with logger max size)
global Logger
Logger.Size = 50;
Logger.Index = 0;
Logger.Queue = {};
Logger.Window = [];
if exist('stanly.log','file'), delete('stanly.log'), end
diary stanly.log;
separator = '-';
header = sprintf('STANLY FEA - FRAME SOLVER 2017 - MATLAB %s',version);
while (length(separator)<100), separator = strcat(separator,'-'); end
fprintf('\n%s\n',separator);
LogMsg(header)

%% Opening window
LogMsg('Start application')
LogMsg('Set environment variables')
pause(4.5)

%% Global variables

global GphUsrInterface %GUI
GphUsrInterface.Figure = gobjects(1);
GphUsrInterface.Axes = gobjects(1); %UIax
GphUsrInterface.Colorbar = gobjects(1); %cb
GphUsrInterface.Ucs = gobjects(1);
GphUsrInterface.Menu = [];
GphUsrInterface.ToolBar = gobjects(1);

global Mesh
% General mesh info
Mesh.Numbers.Dofs = 0; %ndof
Mesh.Numbers.Dobs = 0; %ndob
Mesh.Numbers.Nodes = 0; %nn
Mesh.Numbers.Elements = 0; %ne
% Elements
Mesh.Element.Index = 0; % index
Mesh.Element.Length = 0; % L
Mesh.Element.SphAng = [0 0]; % ang
Mesh.Element.Loc2Glob = zeros(12); %Li
Mesh.Element.Rotated = zeros(3); %Li
% Nodes
Mesh.Nodes.Tab = [];  % xyztab
Mesh.Springs.Tab = []; % springs

global Properties
Properties.Materials=[]; %material
Properties.Sections=[]; %sections
Properties.Notches=[]; %notch

global Loads
Loads.Nodal = []; %Ftab
Loads.Elemental = []; %Qtab
Loads.Thermal = []; %Ttab

global Constraints
Constraints.Ground = []; %dtab
Constraints.Bushing = []; %bush

global FileManager
FileManager.CurrentFile.Name = 0;
FileManager.CurrentFile.Path = 0;
FileManager.CurrentFile.FileType = 0; %filetype
FileManager.FileTypes.Enabled = [1 2]; %ext_list_sel
FileManager.FileTypes.List ={'*.stan','Static Analysis STAN (*.stan)';...
                '*.fstan','Fatigue Analysis STAN (*.fstan)';...
                '*.dstan','Dynamic Analysis STAN (*.dstan)';};

global FiguresStack

global dtab axx incl
global ph_nodes ph_elems
global d_sca
global Kcorr
stan_flag=1; bckgr=0;
iasca=4; toll=1e-9; pnres=0;
opened_uifig=gobjects(1,17);

%% Start program
LogMsg('Opening User Interface')
InitGUI;
InitMenu;
warning OFF BACKTRACE
pause(.5)
LogMsg('Ready')
uiwait(GphUsrInterface.Figure)

%% Closing program
boole_vec=false(1,17);
for i=1:17
    if isa(opened_uifig(i),'matlab.ui.Figure')
        boole_vec(i)=true;
    end
end
opened_uifig(~boole_vec)=[];
if ~isempty(opened_uifig)
    LogMsg('Closing tables')
    close(opened_uifig)
end
if exist('lic_fig','var')
	LogMsg('Closing license window')
    close(lic_fig)
end
LogMsg('Reset environment variables')
LogMsg('Stop application')
fprintf('\n')
warning ON BACKTRACE
diary off