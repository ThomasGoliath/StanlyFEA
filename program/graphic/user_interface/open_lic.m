status_info('License',1)
if exist('lic_fig','var'), close(lic_fig), end
lic_fig=uifigure('Name','License','DeleteFcn','clear lic_fig','Resize','off');
uta=uitextarea(lic_fig,'Value',logs('license_stan.txt'),'Position',[10 10 540 400]);
set(uta,'Editable','off')
status_info('License window opened')
