function materials_mesh(fig)
global xyztab axx
global index springs
global ne nn ang Qtab cb
global ph_nodes ph_elems UIax GUI
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
unmat=unique(index(:,5));
matt=gobjects(length(unmat),1);
labl=cell(length(unmat),1);
prp.lw=4;
prp.lc=[0 0 1; 0 1 0; 1 0 0; 0 1 1; 1 1 0; 1 0 1; 1 1 1
    .2 .2 1; .2 1 .2; 1 .2 .2; .2 1 1; 1 1 .2; 1 .2 1
    .4 .4 1; .4 1 .4; 1 .4 .4; .4 1 1; 1 1 .4; 1 .4 1
    .6 .6 1; .6 1 .6; 1 .6 .6; .6 1 1; 1 1 .6; 1 .6 1
    .8 .8 1; .8 1 .8; 1 .8 .8; .8 1 1; 1 1 .8; 1 .8 1];
prp.mfc='c'; prp.mec='b'; prp.ms=9; prp.fsn=8; prp.fse=15;
[Nd,X,Y,Z]=deal(xyztab(:,1),xyztab(:,2),xyztab(:,3),xyztab(:,4));
E=roman(index(:,1)); N=cell(size(Nd));
for i=1:length(Nd)
    N(i)={num2str(Nd(i))};
end
for i=1:ne
    if sum(ph_elems==i)==0
        x=X(index(i,2:3)); y=Y(index(i,2:3)); z=Z(index(i,2:3));
        matt(index(i,5))=line(x,y,z,'LineWidth',prp.lw,'Color',prp.lc(index(i,5),:));
        if i==1, hold on, end
    end
end
for i=1:size(Qtab,1)
    x=X(Qtab(i,9:10)); y=Y(Qtab(i,9:10)); z=Z(Qtab(i,9:10));
    matt(index(Qtab(i,1),5))=line(x,y,z,'LineWidth',prp.lw,'Color',prp.lc(index(Qtab(i,1),5),:));
    if i==1, hold on, end
end
for i=1:size(springs,1)
    x=X(springs(i,2:3));
    y=Y(springs(i,2:3));
    z=Z(springs(i,2:3));
    line(x,y,z,'LineWidth',prp.lw,'Color','k'...
        ,'LineStyle','-.');
end
naxx=1:nn;
if ~isempty(axx)
    naxx(axx(:,2))=[];
end
for i=naxx
    if sum(ph_nodes==i)==0
        plot3(X(i),Y(i),Z(i),'o','MarkerEdgeColor',prp.mec,'MarkerFaceColor',...
            prp.mfc,'MarkerSize',prp.ms);
    end
end
% for i=naxx
%     mesh(nne+1+i)=text(X(i),Y(i),Z(i),N(i),'VerticalAlignment','middle'...
%         ,'HorizontalAlignment','center','FontSize',prp.fsn);
% end
for i=1:ne
    if sum(ph_elems==i)==0
        if ang(i)==0||ang(i)==pi, hal='left'; else, hal='center'; end
        Xe=sum(xyztab(index(i,2:3),2))/2;
        Ye=sum(xyztab(index(i,2:3),3))/2;
        Ze=sum(xyztab(index(i,2:3),4))/2;
        text(Xe,Ye,Ze,E(i),'FontSize',prp.fse...
            ,'VerticalAlignment','bottom'...
            ,'HorizontalAlignment',hal);
    end
end
% for i=1:size(Qtab,1)
%     if ang(i)==0||ang(i)==pi, hal='left'; else, hal='center'; end
%     Xe=sum(xyztab(Qtab(i,7:8),2))/2;
%     Ye=sum(xyztab(Qtab(i,7:8),3))/2;
%     Ze=sum(xyztab(Qtab(i,7:8),4))/2;
%     text(Xe,Ye,Ze,E(Qtab(i,1)),'FontSize',prp.fse...
%         ,'VerticalAlignment','bottom'...
%         ,'HorizontalAlignment',hal);
% end
for i=1:length(unmat)
    labl(i)={sprintf('Material %i',unmat(i))};
end
legend(matt,labl,'location','Best')
daspect([1 1 1])
pbaspect([2 1 1])
title('Materials')
set(get(gca,'Children'),'Clipping','off')
set_title_gui('MATERIALS',fig)
dcm=datacursormode(fig);
set(dcm,'updatefcn',@myfunction)
set(findall(GUI,'ToolTipString','Colorbar'),'Visible','Off')
end

function output_txt = myfunction(obj,event_obj)
global xyztab axx
try
pos=get(event_obj,'Position');
[~,k]=matfix(pos,xyztab(:,2:4)); card=xyztab(k,1);
if ~isempty(axx), j=find(axx(:,2)==card); else, j=[]; end
if ~isempty(j), j=j(1); card=axx(j,1); end
output_txt = {['Node ',num2str(card,'%i')];
    ['(x,y,z) : ',num2str(pos,'(%.2f,%.2f,%.2f)')]};
catch
    disp('')
end
end