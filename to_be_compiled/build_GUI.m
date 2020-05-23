function build_GUI
global GphUsrInterface Logger
GUIsize=get(groot,'ScreenSize');
name=sprintf('STANLY FEA 2017 - Copiright \x24B8 Tommaso Cavandoli - MatLab\x24C7 %s',version);
GUI=uifigure;
set(GUI,'Name',name)
set(GUI,'NumberTitle','off')
%set(GUI,'MenuBar','none','ToolBar','figure')
%set(GUI,'OuterPosition',[316 203 739 513])
set(GUI,'Position',GUIsize)
set(GUI,'Color',rgb(0,0,0))
% Log viewer
logWindow = uilistbox(GUI);
%set(logWindow,'Unit','normalized')
set(logWindow,'Position',[5 5 GUIsize(3)-10 GUIsize(4)*0.2])
set(logWindow,'Items',logger);
set(logWindow,'Value',logger(end));
end