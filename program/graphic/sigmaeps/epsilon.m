function epsilon(k,E,En,fig,rep)
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
ttl={'\epsilon_{U} - NORMAL STRAIN';'\epsilon_{UV} - SHEAR STRAIN';...
    '\epsilon_{MAX} - MAXIMUM PRINCIPAL STRAIN';'\epsilon_{MIN} - MINIMUM PRINCIPAL STRAIN';...
    'I_{1} - STRAIN FIRST INVARIANT';'I_{3} - STRAIN THIRD INVARIANT'};
if k==8, labl='E [lu]/[lu]'; else, labl='E [lu]^2/[lu]^2'; end
hh=gobjects(ne,1);
lw=4;
res=2e-2*d_sca;
for i=1:ne
    pN=floor(L(i)/res)+1; if pN<2, pN=2; end
    cmat=linspace(En(i,k),En(i,6+k),pN);
    cmat(1)=E(i,k); cmat(end)=E(i,6+k);
    cmat=[cmat flip(cmat)];
    x=linspace(xyztab(index(i,2),2),xyztab(index(i,3),2),pN);
    y=linspace(xyztab(index(i,2),3),xyztab(index(i,3),3),pN);
    z=linspace(xyztab(index(i,2),4),xyztab(index(i,3),4),pN);
    x=[x flip(x)]; y=[y flip(y)]; z=[z flip(z)];
    hh(i)=patch(x,y,z,cmat);
end
maxim=max(max(E(:,[0 6]+k)));
minim=min(min(E(:,[0 6]+k)));
if maxim==0&&minim==0
    maxim=1; minim=-1;
end
set(hh,'LineWidth',lw,'EdgeColor','interp')
title(ttl(k))
limsc=[-1 1]*max(abs([maxim minim]));
if k==2, limsc(1)=0; end
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
    output_txt = {['E: ',num2str(col(k),'%10.7e')]};
catch
    output_txt = {'Error'};
end
end