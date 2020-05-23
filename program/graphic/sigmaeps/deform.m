function deform(defmat,maxd,k,fig,rep)
global UIax GUI cb
if nargin==3
    fig=GUI; rep=0;
    set(groot,'CurrentFigure',fig)
    set(fig,'CurrentAxes',UIax)
else
    set(groot,'CurrentFigure',fig)
    build_ucs(fig)
    set(gcf,'CurrentAxes',axes('Visible','off'))
end
if nargin==4, rep=0; end
legend('off')
ttl={'TOTAL DISPLACEMENTS'...
    ,'sx - GLOBAL DISPLACEMENT','sy - GLOBAL DISPLACEMENT',...
    'sz - GLOBAL DISPLACEMENT',...
    'u - LOCAL DISPLACEMENT','v - LOCAL DISPLACEMENT',...
    'w - LOCAL DISPLACEMENT',...
    'rx - GLOBAL ROTATION','ry - GLOBAL ROTATION',...
    'rz - GLOBAL ROTATION',...
    'ru - LOCAL ROTATION','rv - LOCAL ROTATION',...
    'rw - LOCAL ROTATION',};
if k>7, labl='rotation [lu]/[lu]'; else, labl='displacement [lu]'; end
global ne
deformed=gobjects(1,ne);
for i=1:ne
    gg=cell2mat(defmat(i));
    deformed(i)=patch(gg(:,1),gg(:,2),gg(:,3),gg(:,3+k));
end
[~,prp]=drawmesh(2);
set(deformed,'EdgeColor','interp')
set(deformed,'LineWidth',prp.lw);
title(ttl(k))
if k<2
    limsc=[0 maxd(k)];
else
    limsc=[-maxd(k) maxd(k)];
end
dcm=datacursormode(fig);
set(dcm,'updatefcn',@defdatatips)
set(get(gca,'Children'),'Clipping','off')
set_title_gui(ttl(k),fig)
if rep
    local_colorbar(fig,limsc,labl);
else
    editcb(labl,limsc);
    set(findall(fig,'ToolTipString','Colorbar'),'Visible','On','State','On')
end
end

function output_txt = defdatatips(obj,event_obj)
% Display the position of the data cursor
% obj          Currently not used (empty)
% event_obj    Handle to event object
% output_txt   Data cursor text string (string or cell array of strings).
try
    targ = get(event_obj,'Target');
    pos=get(event_obj,'Position');
    col=get(targ,'CData');
    col=col(1:length(targ.CData)/2);
    x=get(targ,'XData'); if isrow(x), x=x.'; end
    y=get(targ,'YData'); if isrow(y), y=y.'; end
    z=get(targ,'ZData'); if isrow(z), z=z.'; end
    [~,k]=matfix(pos,[x y z]);
    output_txt = {num2str(col(k),'%10.7e')};
catch
    output_txt = {'Original structure'};
end
end