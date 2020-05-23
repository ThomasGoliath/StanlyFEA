function shear(int_act,iasca,fig,rep)
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
Tz=gobjects(1,ne); www=[3 9]; uuu=[2 8]; zz=0;
scala=norm(int_act(:,[www uuu]),Inf);
if scala==0
    maxs=1;
else
    maxs=max(max(abs(int_act(:,[www uuu]))));
end
scala=iasca*maxs/d_sca;
for i=1:ne
    matL=[0 0 L(i) L(i); zeros(1,4); 0 int_act(i,www)/scala 0];
    matC=abs(int_act(i,[www(1) www www(2)]));
    if prod(int_act(i,www))<0
        matL1=[matL(:,1:2) [interp1(int_act(i,www),[0 L(i)],0); 0; 0]];
        matL2=[[interp1(int_act(i,www),[0 L(i)],0); 0; 0] matL(:,3:4)];
        matC1=[matC(1:2) 0 matC(1)]; matC2=[0 matC(3:4) 0];
        matL1=[matL1 matL1(:,1)]; matL2=[matL2 matL2(:,1)];
        matG1=xyztab(index(i,2),2:end).'+Ri(:,:,i).'*matL1;
        matG2=xyztab(index(i,2),2:end).'+Ri(:,:,i).'*matL2;
        Tz(length(Tz)+1)=gobjects(1);
        Tz(i+zz)=patch(matG1(1,:),matG1(2,:),matG1(3,:),matC1,'FaceAlpha',fa);
        if i==1, hold on, end
        Tz(i+zz+1)=patch(matG2(1,:),matG2(2,:),matG2(3,:),matC2,'FaceAlpha',fa);
        if int_act(i,www(1))>0
            set(Tz(i+zz),'EdgeColor','r','LineWidth',1)
            set(Tz(i+zz+1),'EdgeColor','b','LineWidth',1)
        elseif int_act(i,www(1))<0
            set(Tz(i+zz),'EdgeColor','b','LineWidth',1)
            set(Tz(i+zz+1),'EdgeColor','r','LineWidth',1)
        end
        zz=zz+1;
    else
        matG=xyztab(index(i,2),2:end).'+Ri(:,:,i).'*matL;
        Tz(i+zz)=patch(matG(1,:),matG(2,:),matG(3,:),matC,'FaceAlpha',fa);
        if int_act(i,www(1))>0
            set(Tz(i+zz),'EdgeColor','r','LineWidth',1)
        elseif int_act(i,www(1))<0
            set(Tz(i+zz),'EdgeColor','b','LineWidth',1)
        end
        if i==1, hold on, end
    end
end
Ty=gobjects(1,ne); zz=0;
for i=1:ne
    matL=[0 0 L(i) L(i); 0 int_act(i,uuu)/scala 0; zeros(1,4)];
    matC=abs(int_act(i,[uuu(1) uuu uuu(2)]));
    if prod(int_act(i,uuu))<0
        matL1=[matL(:,1:2) [interp1(int_act(i,uuu),[0 L(i)],0); 0; 0]];
        matL2=[[interp1(int_act(i,uuu),[0 L(i)],0); 0; 0] matL(:,3:4)];
        matC1=[matC(1:2) 0 matC(1)]; matC2=[0 matC(3:4) 0];
        matL1=[matL1 matL1(:,1)]; matL2=[matL2 matL2(:,1)];
        matG1=xyztab(index(i,2),2:end).'+Ri(:,:,i).'*matL1;
        matG2=xyztab(index(i,2),2:end).'+Ri(:,:,i).'*matL2;
        Ty(length(Ty)+1)=gobjects(1);
        Ty(i+zz)=patch(matG1(1,:),matG1(2,:),matG1(3,:),matC1,'FaceAlpha',fa);
        if i==1, hold on, end
        Ty(i+zz+1)=patch(matG2(1,:),matG2(2,:),matG2(3,:),matC2,'FaceAlpha',fa);
        if int_act(i,uuu(1))>0
            set(Ty(i+zz),'EdgeColor','r','LineWidth',1)
            set(Ty(i+zz+1),'EdgeColor','b','LineWidth',1)
        elseif int_act(i,uuu(1))<0
            set(Ty(i+zz),'EdgeColor','b','LineWidth',1)
            set(Ty(i+zz+1),'EdgeColor','r','LineWidth',1)
        end
        zz=zz+1;
    else
        matG=xyztab(index(i,2),2:end).'+Ri(:,:,i).'*matL;
        Ty(i+zz)=patch(matG(1,:),matG(2,:),matG(3,:),matC,'FaceAlpha',fa);
        if int_act(i,uuu(1))>0
            set(Ty(i+zz),'EdgeColor','r','LineWidth',1)
        elseif int_act(i,uuu(1))<0
            set(Ty(i+zz),'EdgeColor','b','LineWidth',1)
        end
        if i==1, hold on, end
    end
end
drawmesh;
title('Shear load')
dcm=datacursormode(fig);
set(dcm,'updatefcn',@myfunction)
set(get(gca,'Children'),'Clipping','off')
set_title_gui('T - SHEAR LOAD',fig)
labl='T [fu]'; limsc=[0 maxs];
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
output_txt = {['T: ',num2str(col(k),'%10.7e')]};
end