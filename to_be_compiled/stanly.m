%% STANLY FEA - FRAME SOLVER version 2017

%%% Tommaso Cavandoli
clear, clc
close all
fclose all;
diary off
format shorte

%% Logger
% Init logger (with logger max size)
global Logger
Logger.Size = 50;
Logger.Index = 0;
Logger.Queue = {};
Logger.Window = [];
if exist('stanly.log','file'), delete('stanly.log'), end
diary stanly.log;
fprintf('\n---------------------------------------------------------------\n')
LogMsg(sprintf('STANLY FEA - FRAME SOLVER 2017 - MATLAB %s',version))

%% Opening window
global GphUsrInterface
LogMsg('Start application')
LogMsg('Set environment variables')
extension_list={'*.stan','Static Analysis STAN (*.stan)';...
   '*.fstan','Fatigue Analysis STAN (*.fstan)';...
   '*.dstan','Dynamic Analysis STAN (*.dstan)';};
pause(4.5)
LogMsg('Opening User Interface')
GphUsrInterface=gobjects(1);
BuildGUI;

%% Global variables
global index bush
global dtab axx incl
global xyztab ph_nodes ph_elems
global material
global sections notch
global Ftab Ttab Qtab
global nn ne ndof ndob
global L ang d_sca cb
global Li Ri Kcorr springs
global ext_list_sel filetype
ext_list_sel=1:2;
filetype=0; stan_flag=1; bckgr=0;
iasca=4; toll=1e-9; pnres=0;
opened_uifig=gobjects(1,17);

%% Start program
menu_const_open(GUI)
warning OFF BACKTRACE
pause(.5)
status_info('Ready')
uiwait(GUI)

%% Closing program
boole_vec=false(1,17);
for i=1:17
    if isa(opened_uifig(i),'matlab.ui.Figure')
        boole_vec(i)=true;
    end
end
opened_uifig(~boole_vec)=[];
if ~isempty(opened_uifig)
    status_info('Closing tables')
    close(opened_uifig)
end
if exist('lic_fig','var')
	status_info('Closing license window')
    close(lic_fig)
end
status_info('Reset environment variables')
status_info('Stop application')
fprintf('\n')
warning ON BACKTRACE
diary off