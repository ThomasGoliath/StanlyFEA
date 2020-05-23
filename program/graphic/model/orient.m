function orient(fig)
global index xyztab Ri ne ph_elems Qtab UIax GUI cb
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
drawmesh(0,1); hold on
r=1.7/60*max([xlim ylim zlim]); lw=2.2;
for i=1:ne
    if sum(ph_elems==i)==0
        or=mean(xyztab(index(i,2:3),2:4));
        x=[1 0 0]; y=[0 1 0]; z=[0 0 1]; xyz=[x;y;z];
        xyz=or+Ri(:,:,i)*xyz*2.2*r; x=xyz(1,:); y=xyz(2,:);  z=xyz(3,:);
        if i==1
            direct(1)=line([or(1) x(1)],[or(2) x(2)],[or(3) x(3)],'Color','r','LineWidth',lw,'PickableParts','none');
            direct(2)=line([or(1) y(1)],[or(2) y(2)],[or(3) y(3)],'Color','g','LineWidth',lw,'PickableParts','none');
            direct(3)=line([or(1) z(1)],[or(2) z(2)],[or(3) z(3)],'Color','b','LineWidth',lw,'PickableParts','none');
        else
            line([or(1) x(1)],[or(2) x(2)],[or(3) x(3)],'Color','r','LineWidth',lw,'PickableParts','none');
            line([or(1) y(1)],[or(2) y(2)],[or(3) y(3)],'Color','g','LineWidth',lw,'PickableParts','none');
            line([or(1) z(1)],[or(2) z(2)],[or(3) z(3)],'Color','b','LineWidth',lw,'PickableParts','none');
        end
    end
end
for j=1:size(Qtab,1)
    i=Qtab(j,1);
    or=mean(xyztab(Qtab(j,9:10),2:4));
    x=[1 0 0]; y=[0 1 0]; z=[0 0 1]; xyz=[x;y;z];
    xyz=or+Ri(:,:,i)*xyz*2.2*r; x=xyz(1,:); y=xyz(2,:);  z=xyz(3,:);
    if j==1
        direct(1)=line([or(1) x(1)],[or(2) x(2)],[or(3) x(3)],'Color','r','LineWidth',lw);
        direct(2)=line([or(1) y(1)],[or(2) y(2)],[or(3) y(3)],'Color','g','LineWidth',lw);
        direct(3)=line([or(1) z(1)],[or(2) z(2)],[or(3) z(3)],'Color','b','LineWidth',lw);
    else
        line([or(1) x(1)],[or(2) x(2)],[or(3) x(3)],'Color','r','LineWidth',lw);
        line([or(1) y(1)],[or(2) y(2)],[or(3) y(3)],'Color','g','LineWidth',lw);
        line([or(1) z(1)],[or(2) z(2)],[or(3) z(3)],'Color','b','LineWidth',lw);
    end
end
title('Beams orientation')
legend(direct,'U (x_L_O_C)','V (y_L_O_C)','W (z_L_O_C)','location','Best')
set(get(gca,'Children'),'Clipping','off')
set_title_gui('BEAMS ORIENTATION',fig)
dcm=datacursormode(fig);
set(dcm,'updatefcn',@myfunction)
set(findall(GUI,'ToolTipString','Colorbar'),'Visible','Off')
set(cb,'Visible','off')
end

function output_txt = myfunction(obj,event_obj)
global xyztab axx
pos=get(event_obj,'Position');
[~,k]=matfix(pos,xyztab(:,2:4)); card=xyztab(k,1);
if ~isempty(axx), j=find(axx(:,2)==card); else, j=[]; end
if ~isempty(j), j=j(1); card=axx(j,1); end
targ = get(event_obj,'Target');
output_txt = {['Node ',num2str(card,'%i')];
    ['(x,y,z) : ',num2str(pos,'(%.2f,%.2f,%.2f)')]};
end