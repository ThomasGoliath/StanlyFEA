function build_UIax
global UIax GUI cb
set(groot,'CurrentFigure',GUI)
UIax=axes('Visible','off');
set(UIax,'Clipping','off')
% xlabel('X [lu]'), ylabel('Y [lu]'), zlabel('Z [lu]'), grid on
set(GUI,'Color',rgb(220,220,220))
view(3);
% Colorbar
colormap jet
cb=colorbar('FontSize',7.5,'Visible','off',...
    'Position',[0.8522 0.1103 0.0308 0.8155]);
delete(findall(GUI,'ToolTipString','Colorbar'))
uitoggletool(findall(GUI,'Type','uitoolbar'),'CData',...
    imread('.\media\colorbar.png','BackgroundColor',[1 1 .8]),...
    'ToolTipString','Colorbar',...
    'OnCallback',@setcbon,'OffCallback',@setcboff,'State','on');
end

function setcbon(src,event)
global cb
set(cb,'Visible','on')
end

function setcboff(src,event)
global cb
set(cb,'Visible','off')
end