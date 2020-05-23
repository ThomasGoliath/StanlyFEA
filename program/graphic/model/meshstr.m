function meshstr(fig)
global xyztab nn ne ndof ndob UIax GUI cb
if nargin==0
    fig=GUI;
    set(groot,'CurrentFigure',fig)
    set(fig,'CurrentAxes',UIax)
else
    set(groot,'CurrentFigure',fig)
    build_ucs(fig)
    set(gcf,'CurrentAxes',axes('Visible','off'))
end
legend('off')
drawmesh(1,1);
title('Mesh')
dcm=datacursormode(fig);
set(dcm,'updatefcn',@myfunction)
set(gca,'Clipping','off')
set(get(gca,'Children'),'Clipping','off')
set_title_gui('MESH',fig)
set(findall(GUI,'ToolTipString','Colorbar'),'Visible','Off')
set(cb,'Visible','off')
end

function output_txt = myfunction(obj,event_obj)
global xyztab axx notch filetype
pos=get(event_obj,'Position');
[~,k]=matfix(pos,xyztab(:,2:4)); card=xyztab(k,1);
if ~isempty(axx), j=find(axx(:,2)==card); else, j=[]; end
if ~isempty(j), j=j(1); card=axx(j,1); end
if filetype==1
	output_txt = {['Node ',num2str(card,'%i')];
        ['(x,y,z) : ',num2str(pos,'(%.2f,%.2f,%.2f)')];
		['Kta : ',num2str(notch(card,2),'%.3f')];
		['Ktb : ',num2str(notch(card,3),'%.3f')];
		['Ktt : ',num2str(notch(card,4),'%.3f')]};
elseif filetype==2
	output_txt = {['Node ',num2str(card,'%i')];
        ['(x,y,z) : ',num2str(pos,'(%.2f,%.2f,%.2f)')];
		['Ktb : ',num2str(notch(card,2),'%.3f')];
		['Ktt : ',num2str(notch(card,3),'%.3f')];
		['q : ',num2str(notch(card,4),'%.3f')]};
end																				
end