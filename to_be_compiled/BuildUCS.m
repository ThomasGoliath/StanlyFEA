function out=build_ucs(fig)
global ucs AZ EL GUI
AZ=0; EL=0;
fs=8;
if nargin==0
    fig = GUI;
end
orig=get(fig,'CurrentAxes');
lw=1.5;
ucs=axes(fig,'Units','pixels',...
    'Position',[20 70 50 50],...
    'Visible','off',...
    'Clipping','off',...
    'Tag','UCS');
line(ucs,[0 1],[0 0],[0 0],'Color','r','Linewidth',lw,'Clipping','off')
line(ucs,[0 0],[0 1],[0 0],'Color','g','Linewidth',lw,'Clipping','off')
line(ucs,[0 0],[0 0],[0 1],'Color','b','Linewidth',lw,'Clipping','off')
text(ucs,1.5,0,0,'X','Color','r','FontWeight','bold',...
    'HorizontalAlignment','center','VerticalAlignment','middle',...
    'FontSize',fs)
text(ucs,0,1.5,0,'Y','Color','g','FontWeight','bold',...
    'HorizontalAlignment','center','VerticalAlignment','middle',...
    'FontSize',fs)
text(ucs,0,0,1.5,'Z','Color','b','FontWeight','bold',...
    'HorizontalAlignment','center','VerticalAlignment','middle',...
    'FontSize',fs)
view(3);
linkprop([orig,ucs],{'View'});
pbaspect([1 1 1])
xlim([-1 1]);
ylim([-1 1]);
zlim([-1 1]);
if nargout==1
    out=ucs;
end
ctrlpan=zoom(fig);
ctrlzoom=pan(fig);
set(ctrlzoom,'ActionPostCallback',@mypost)
set(ctrlzoom,'ActionPreCallback',@mypre)
set(ctrlpan,'ActionPostCallback',@mypost)
set(ctrlpan,'ActionPreCallback',@mypre)
end

function mypost(obj,event_obj)
% If the tag of the object is 'DoNotIgnore', then return true.
global ucs AZ EL
set(ucs,'Xlim',[-1 1],'YLim',[-1 1],'Zlim',[-1 1])
set(ucs,'View',[AZ EL])
end

function mypre(obj,event_obj)
% If the tag of the object is 'DoNotIgnore', then return true.
global ucs AZ EL
[AZ,EL]=view(ucs);
end


