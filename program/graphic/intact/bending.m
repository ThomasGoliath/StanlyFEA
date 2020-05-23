function bending(int_act,iasca,fig,rep)
global xyztab index Ri L ne nn d_sca UIax GUI cb
if nargin==2
    fig=GUI; rep=0;
    set(groot,'CurrentFigure',fig)
    set(fig,'CurrentAxes',UIax)
else
    set(groot,'CurrentFigure',fig)
    build_ucs(fig)
    set(gcf,'CurrentAxes',axes('Visible','off'))
end
if nargin==3, rep=0; end
legend('off')
fa=.5;
By=gobjects(1,ne); www=[5 11]; uuu=[6 12];
scala=norm(int_act(:,[www uuu]),Inf);
zz=0;
if scala==0
    maxb=1;
else
    maxb=max(max(abs(int_act(:,[www uuu]))));
end
res=2e-2*d_sca;
scala=iasca*maxb/d_sca;
for i=1:ne
    pN=floor(L(i)/res)+1; if pN<2, pN=2; end
    matL=[0 linspace(0,L(i),pN) L(i);
        zeros(1,pN+2);
        0 linspace(int_act(i,www(1)),int_act(i,www(2)),pN)/scala 0];
    matC=abs([int_act(i,www(1)) linspace(int_act(i,www(1)),int_act(i,www(2)),pN) int_act(i,www(2))]);
    matG=xyztab(index(i,2),2:end).'+Ri(:,:,i).'*matL;
    By(i+zz)=patch(matG(1,:),matG(2,:),matG(3,:),matC,'FaceAlpha',fa);
    if i==1, hold on, end
end
Bz=gobjects(1,ne); zz=0;
for i=1:ne
    pN=floor(L(i)/res)+1; if pN<2, pN=2; end
    matL=[0 linspace(0,L(i),pN) L(i);
        0 linspace(int_act(i,uuu(1)),int_act(i,uuu(2)),pN)/scala 0
        zeros(1,pN+2);];
    matC=abs([int_act(i,uuu(1)) linspace(int_act(i,uuu(1)),int_act(i,uuu(2)),pN) int_act(i,uuu(2))]);
    matG=xyztab(index(i,2),2:end).'+Ri(:,:,i).'*matL;
    Bz(i+zz)=patch(matG(1,:),matG(2,:),matG(3,:),matC,'FaceAlpha',fa);
    if i==1, hold on, end
end
drawmesh;
title('Bending moment')
dcm=datacursormode(fig);
set(dcm,'updatefcn',@myfunction)
set(get(gca,'Children'),'Clipping','off')
set_title_gui('M_{B} - BENDING MOMENT',fig)
labl='Mb [fu]*[lu]'; limsc=[0 maxb];
if rep
    local_colorbar(fig,limsc,labl);
else
    editcb(labl,limsc);
    set(findall(fig,'ToolTipString','Colorbar'),'Visible','On','State','On')
end
end

function output_txt = myfunction(obj,event_obj)
targ = get(event_obj,'Target');
pos=get(event_obj,'Position');
col=get(targ,'CData');
x=get(targ,'XData'); if isrow(x), x=x.'; end
y=get(targ,'YData'); if isrow(y), y=y.'; end
z=get(targ,'ZData'); if isrow(z), z=z.'; end
[~,k]=matfix(pos,[x y z]);
output_txt = {['Mb: ',num2str(col(k),'%10.7e')]};
end
