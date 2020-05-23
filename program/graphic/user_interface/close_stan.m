status_info('Closing tables')
boole_vec=false(1,17);
for i=1:17
    if isa(opened_uifig(i),'matlab.ui.Figure')
        boole_vec(i)=true;
    end
end
opened_uifig(~boole_vec)=[];
if ~isempty(opened_uifig), close(opened_uifig), end
status_info(sprintf('Closing %s',fname),1)
clf(GUI), menu_const_open(GUI)
opened_uifig=gobjects(1,17);