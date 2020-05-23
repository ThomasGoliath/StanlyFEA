function fatigue_plot(k,F,Fn,fig,rep)
global index xyztab ne L d_sca
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
ttl={'\sigma*_{GP} - GOUGH-POLLARD';'\sigma*_{S} - SINES';...
    '\sigma''_{e} - ENDURANCE LIMIT';'N_{LIM} - FATIGUE LIFE'};
if k<=3, labl='S [fu]/[lu]^2'; else, labl='N [cycles]'; end
hh=gobjects(ne,1);
lw=4;
res=2e-2*d_sca;
for i=1:ne
    pN=floor(L(i)/res)+1;
    cmat=linspace(Fn(i,k),Fn(i,4+k),pN);
    cmat(1)=F(i,k); cmat(end)=F(i,4+k);
    cmat=[cmat flip(cmat)];
    x=linspace(xyztab(index(i,2),2),xyztab(index(i,3),2),pN);
    y=linspace(xyztab(index(i,2),3),xyztab(index(i,3),3),pN);
    z=linspace(xyztab(index(i,2),4),xyztab(index(i,3),4),pN);
    x=[x flip(x)]; y=[y flip(y)]; z=[z flip(z)];
    hh(i)=patch(x,y,z,cmat);
end
set(hh,'LineWidth',lw,'EdgeColor','interp')
grid on
xlabel('X [lu]'), ylabel('Y [lu]'), zlabel('Z [lu]'), grid on
title(ttl(k))
maxim=max(max(F(:,[0 4]+k)));
if maxim==0, maxim=1; end
if maxim>1e7&&k==4, maxim=1e7; end
if maxim==inf, maxim=1; end
minim=0;
if k==4, minim=min(min(F(:,[0 4]+k))); end
if minim==inf||minim>=1e7, minim=1e3; end
limsc=[minim maxim];
daspect([1 1 1])
pbaspect([2 1 1])
dcm=datacursormode(fig);
set(dcm,'updatefcn',@myfunction)
set(get(gca,'Children'),'Clipping','off')
set_title_gui(ttl(k),fig)
if rep
    local_colorbar(fig,limsc,labl);
else
    editcb(labl,limsc);
    set(findall(fig,'ToolTipString','Colorbar'),'Visible','On','State','On')
end
end

function output_txt = myfunction(obj,event_obj)
try
targ = get(event_obj,'Target');
pos=get(event_obj,'Position');
col=get(targ,'CData');
x=get(targ,'XData'); if isrow(x), x=x.'; end
y=get(targ,'YData'); if isrow(y), y=y.'; end
z=get(targ,'ZData'); if isrow(z), z=z.'; end
[~,k]=matfix(pos,[x y z]);
output_txt = {num2str(col(k),'%10.7e')};
catch
    output_txt = {'Error'};
end
end