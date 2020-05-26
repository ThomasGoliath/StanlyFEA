function CloseStan
%% CloseStan
% Unload current structure
% TODO figure stack

global GphUsrInterface

LogMsg('Closing tables')
boole_vec=false(1,17);
for i=1:17
    if isa(opened_uifig(i),'matlab.ui.Figure')
        boole_vec(i)=true;
    end
end
opened_uifig(~boole_vec)=[];
if ~isempty(opened_uifig), close(opened_uifig), end
LogMsg(sprintf('Closing %s',fname),1)
cla(GphUsrInterface.Axes)
FixMenu(false)
opened_uifig=gobjects(1,17);