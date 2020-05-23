function [mesh,prp]=drawmesh(mm,pick,ax)
if nargin<=1, pick=0; end
global xyztab axx ph_nodes ph_elems
global index springs Qtab
global ne nn ang
global UIax
if nargin == 2
    ax = UIax;
end
prp.lw=4;
prp.lc1=[.5 .5 .5];
prp.lc2='k'; prp.mfc='c'; prp.mec='b'; prp.ms=12; prp.fsn=8; prp.fse=15;
if nargin==0
    mm=0;
end
[Nd,X,Y,Z]=deal(xyztab(:,1),xyztab(:,2),xyztab(:,3),xyztab(:,4));
E=roman(index(:,1)); N=cell(size(Nd));
for i=1:length(Nd)
    N(i)={num2str(Nd(i))};
end
switch mm
    case 1
        mesh=[];
        for i=1:ne
            if sum(ph_elems==i)==0
                x=X(index(i,2:3)); y=Y(index(i,2:3)); z=Z(index(i,2:3));
                mesh(i)=line(ax,x,y,z,'LineWidth',prp.lw,'Color',prp.lc1);
                if i==1, hold on, end
            end
        end
        n=length(mesh);
        for i=1:size(Qtab,1)
            if ~isempty(Qtab)
                x=X(Qtab(i,9:10)); y=Y(Qtab(i,9:10)); z=Z(Qtab(i,9:10));
                mesh(n+i)=line(ax,x,y,z,'LineWidth',prp.lw,'Color',prp.lc1);
                if i==1, hold on, end
            end
        end
        n=length(mesh);
        for i=1:size(springs,1)
            x=X(springs(i,2:3));
            y=Y(springs(i,2:3));
            z=Z(springs(i,2:3));
            mesh(n+i)=line(ax,x,y,z,'LineWidth',prp.lw,'Color','k'...
                ,'LineStyle','-.');
        end
        n=length(mesh);
        naxx=1:nn;
        if ~isempty(axx)
            naxx(axx(:,2))=[];
        end
        for i=naxx
            if sum(ph_nodes==i)==0
                mesh(n+i)=plot3(ax,X(i),Y(i),Z(i),'o',...
                    'MarkerEdgeColor',prp.mec,'MarkerFaceColor',...
                    prp.mfc,'MarkerSize',prp.ms);
            else
                mesh(n+i)=plot3(ax,X(i),Y(i),Z(i),'o',...
                    'MarkerEdgeColor',prp.mec);
            end
        end
        n=length(mesh);
        for i=naxx
            if sum(ph_nodes==i)==0
                mesh(n+i)=text(ax,X(i),Y(i),Z(i),N(i),'VerticalAlignment','middle'...
                    ,'HorizontalAlignment','center','FontSize',prp.fsn);
            end
        end
        n=length(mesh);
        for i=1:ne
            if sum(ph_elems==i)==0
                if ang(i)==0||ang(i)==pi, hal='left'; else, hal='center'; end
                Xe=sum(xyztab(index(i,2:3),2))/2;
                Ye=sum(xyztab(index(i,2:3),3))/2;
                Ze=sum(xyztab(index(i,2:3),4))/2;
                mesh(n+i)=text(ax,Xe,Ye,Ze,E(i),'FontSize',prp.fse...
                    ,'VerticalAlignment','bottom'...
                    ,'HorizontalAlignment',hal);
            end
        end
%         for i=1:size(Qtab,1)
%             if ~isempty(Qtab)
%                 if ang(Qtab(i,1))==0||ang(Qtab(i,1))==pi, hal='left'; else, hal='center'; end
%                 Xe=sum(xyztab(Qtab(i,7:8),2))/2;
%                 Ye=sum(xyztab(Qtab(i,7:8),3))/2;
%                 Ze=sum(xyztab(Qtab(i,7:8),4))/2;
%                 mesh(n+i)=text(Xe,Ye,Ze,E(Qtab(i,1)),'FontSize',prp.fse...
%                     ,'VerticalAlignment','bottom'...
%                     ,'HorizontalAlignment',hal);
%             end
%         end
    case 0
        mesh=gobjects(1,ne);
        for i=1:ne
            if sum(ph_elems==i)==0
                x=X(index(i,2:3)); y=Y(index(i,2:3)); z=Z(index(i,2:3));
                mesh(i)=line(ax,x,y,z,'LineWidth',prp.lw,'Color',prp.lc2); hold on
            end
            if i==1, hold on, end
        end
        n=length(mesh);
        if ~isempty(Qtab)
            for i=1:size(Qtab,1)
                x=X(Qtab(i,9:10)); y=Y(Qtab(i,9:10)); z=Z(Qtab(i,9:10));
                mesh(n+i)=line(ax,x,y,z,'LineWidth',prp.lw,'Color',prp.lc2); hold on
                if n+i==1, hold on, end
            end
        end
    case 2
        mesh=[];
        for i=1:ne
            if sum(ph_elems==i)==0
                x=X(index(i,2:3)); y=Y(index(i,2:3)); z=Z(index(i,2:3));
                mesh(i)=line(ax,x,y,z,'LineStyle','--','Color',prp.lc2); hold on
            end
            if i==1, hold on, end
        end
        n=length(mesh);
        if ~isempty(Qtab)
            for i=1:size(Qtab,1)
                x=X(Qtab(i,9:10)); y=Y(Qtab(i,9:10)); z=Z(Qtab(i,9:10));
                mesh(n+i)=line(ax,x,y,z,'LineStyle','--','Color',prp.lc2);
                if n+i==1, hold on, end
            end
        end
end
boole=false(size(mesh));
for i=1:length(mesh)
    if isa(mesh(i),'matlab.graphics.GraphicsPlaceholder')
        boole(i)=true;
    end
end
mesh(boole)=[];
daspect([1 1 1])
pbaspect([2 1 1])
if ~pick
    set(mesh,'PickableParts','none')
end
end