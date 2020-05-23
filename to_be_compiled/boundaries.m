function boundaries(Fe,Fr,fig)
global xyztab index nn dtab ndof Ttab Ri L axx UIax GUI cb
if nargin==2
    fig=GUI;
    set(groot,'CurrentFigure',fig)
    set(fig,'CurrentAxes',UIax)
else
    set(groot,'CurrentFigure',fig)
	build_ucs(fig)
    set(gcf,'CurrentAxes',axes('Visible','off'))
end
legend('off')
drawmesh(0,1); hold on
r=1.7/60*max([xlim ylim zlim]);
for i=1:nn
    if sum(Fe(i,1:3)~=0)
        for j=1:3
            vec=zeros(3,1); vec(j)=sign(Fe(i,j))*2.5*r;
            draw_force(vec,xyztab(i,2:4),'g',r);
        end
    end
    if sum(Fr(i,1:3)~=0)
        for j=1:3
            vec=zeros(3,1); vec(j)=sign(Fr(i,j))*2.5*r;
            coord=xyztab(i,2:4);
            if Fe(i,j)~=0&&Fr(i,j)*Fe(i,j)>0
                coord(j)=coord(j)-2.5*r*sign(Fr(i,j));
            end
            draw_force(vec,coord,'r',r);
        end
    end
end
for i=1:nn
    if sum(Fe(i,4:6)~=0)
        for j=4:6
            vec=zeros(3,1); vec(j-3)=sign(Fe(i,j))*4*r;
            coord=xyztab(i,2:4);
            if Fe(i,j-3)~=0&&Fe(i,j-3)*Fe(i,j)>0
                coord(j-3)=coord(j-3)-2.5*r*sign(Fe(i,j));
            end
            if Fr(i,j-3)~=0&&Fr(i,j-3)*Fe(i,j)>0
                coord(j-3)=coord(j-3)-2.5*r*sign(Fe(i,j));
            end
            draw_force(vec,coord,'c',r,2);
        end
    end
    if sum(Fr(i,4:6)~=0)
        for j=4:6
            vec=zeros(3,1); vec(j-3)=sign(Fr(i,j))*4*r;
            coord=xyztab(i,2:4);
            if Fe(i,j-3)~=0&&Fe(i,j-3)*Fr(i,j)>0
                coord(j-3)=coord(j-3)-2.5*r*sign(Fr(i,j));
            end
            if Fr(i,j-3)~=0&&Fr(i,j-3)*Fr(i,j)>0
                coord(j-3)=coord(j-3)-2.5*r*sign(Fr(i,j));
            end
            draw_force(vec,coord,'m',r,2);
        end
    end
end
if ~isempty(Ttab)
    tsca=r/max(max(abs(Ttab(:,2:5)))); fa=.5;
    for i=1:size(Ttab,1)
        j=Ttab(i,1);
        xe=zeros(1,3);
        or=mean(xyztab(index(j,2:3),2:4));
        rot=Ri(:,:,j);
        if sum(Ttab(i,2:3)~=0)
            x1=[xe; xe; xe; xe];
            x1([1 2],2)=x1([1 2],2)+2*r; x1(2,1)=x1(2,1)+2*Ttab(i,2)*tsca;
            x1([3 4],2)=x1([3 4],2)-2*r; x1(3,1)=x1(3,1)+2*Ttab(i,3)*tsca;
            c1=[Ttab(i,2) Ttab(i,2) Ttab(i,3) Ttab(i,3)].'; x1=or+x1*rot.';
            patch(x1(:,1),x1(:,2),x1(:,3),c1,'FaceAlpha',fa)
        end
        if sum(Ttab(i,4:5)~=0)
            x2=[xe; xe; xe; xe];
            x2([1 2],3)=x2([1 2],3)+2*r; x2(2,1)=x2(2,1)+2*Ttab(i,4)*tsca;
            x2([3 4],3)=x2([3 4],3)-2*r; x2(3,1)=x2(3,1)+2*Ttab(i,5)*tsca;
            c2=[Ttab(i,4) Ttab(i,4) Ttab(i,5) Ttab(i,5)].'; x2=or+x2*rot.';
            patch(x2(:,1),x2(:,2),x2(:,3),c2,'FaceAlpha',fa)
        end
    end
    colormap parula
    caxis([-1 1]*max(max(abs(Ttab(:,2:5)))))
end
title('Loads and boundaries')
camlight
set(get(gca,'Children'),'Clipping','off')
set_title_gui('LOADS AND BOUNDARIES',fig)
dcm=datacursormode(fig);
set(dcm,'updatefcn',@myfunction)
set(cb,'Visible','off')
set(findall(GUI,'ToolTipString','Colorbar'),'Visible','Off')
end

function output_txt = myfunction(obj,event_obj)
global xyztab axx
pos=get(event_obj,'Position');
[~,k]=matfix(pos,xyztab(:,2:4)); card=xyztab(k,1);
if ~isempty(axx), j=find(axx(:,2)==card); else, j=[]; end
if ~isempty(j), j=j(1); card=axx(j,1); end
output_txt = {['Node ',num2str(card,'%i')];
    ['(x,y,z) : ',num2str(pos,'(%.2f,%.2f,%.2f)')]};
end