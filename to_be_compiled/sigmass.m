function sigmass(k,S,Sn,fig,rep)
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
ttl={'\sigma_{U} - NORMAL STRESS';'\tau_{UV} - SHEAR STRESS';...
    '\sigma_{MAX} - MAXIMUM PRINCIPAL STRESS';'\sigma_{MIN} - MINIMUM PRINCIPAL STRESS';...
    '\sigma*_{VM} - VON MISES';'\sigma*_{GT} - GUEST-TRESCA';...
    'I_{1} - STRESS FIRST INVARIANT';'I_{3} - STRESS THIRD INVARIANT'};
if k~=8, labl='S [fu]/[lu]^2'; else, labl='S [fu]^2/[lu]^4'; end
hh=gobjects(ne,1);
lw=4;
res=2e-2*d_sca;
for i=1:ne
    pN=floor(L(i)/res)+1; if pN<2, pN=2; end
    cmat=linspace(Sn(i,k),Sn(i,8+k),pN);
    cmat(1)=S(i,k); cmat(end)=S(i,8+k);
    cmat=[cmat flip(cmat)];
    x=linspace(xyztab(index(i,2),2),xyztab(index(i,3),2),pN);
    y=linspace(xyztab(index(i,2),3),xyztab(index(i,3),3),pN);
    z=linspace(xyztab(index(i,2),4),xyztab(index(i,3),4),pN);
    x=[x flip(x)]; y=[y flip(y)]; z=[z flip(z)];
    hh(i)=patch(x,y,z,cmat);
end
maxim=max(max(S(:,[0 8]+k)));
minim=min(min(S(:,[0 8]+k)));
if maxim==0&&minim==0
    maxim=1; minim=-1;
end
set(hh,'LineWidth',lw,'EdgeColor','interp')
title(ttl(k))
limsc=[-1 1]*max(abs([maxim minim]));
if k==5||k==6||k==2, limsc(1)=0; end
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
output_txt = {['S: ',num2str(col(k),'%10.7e')]};
catch
    output_txt = {'Error'};
end
end