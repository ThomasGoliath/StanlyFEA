%% STANLY FEA - FRAME SOLVER version 2017
%%% Tommaso Cavandoli
clear, clc
close all
fclose all;
diary off
format shorte
fprintf('STANLY FEA - FRAME SOLVER 2017 - MATLAB %s\n',version)
%%% Opening window
global GUI UIax AXLIM
GUI=gobjects(1);
addpath('.\diagnostic')
status_info('Start application')
status_info('Set environment variables')
wpath={'.\graphic','.\routines','.\graphic\user_interface',...
	'.\graphic\intact','.\graphic\sigmaeps','.\graphic\model',...
    '.\doc','.\media','.\tables','.\report','.\graphic\sec_det'};
extension_list={'*.stan','Static Analysis STAN (*.stan)';...
   '*.fstan','Fatigue Analysis STAN (*.fstan)';...
   '*.dstan','Dynamic Analysis STAN (*.dstan)';};
for i=1:length(wpath)
    addpath(cell2mat(wpath(i)))
end
backup_models
intro=SplashScreen('','.\media\opening.jpg');
pause(4.5)
scrsz=[1 41 1366 651];
status_info('Opening User Interface')
build_GUI;

%%% Global variables
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

%%% Start program
menu_const_open(GUI)
warning OFF BACKTRACE
status_info('Detecting bugs')
if ~strcmp(sprintf('NO BUGS\n'),logs('bugs_notice.txt'))
    warndlg(logs('bugs_notice.txt'))
end
pause(.5)
delete(intro)
status_info('Ready')
uiwait(GUI)

%%% Closing program
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
for i=1:length(wpath)
    rmpath(cell2mat(wpath(i)))
end
status_info('Stop application')
fprintf('\n')
rmpath('.\diagnostic')
warning ON BACKTRACE