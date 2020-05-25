function InitGUI

%% InitGUI()
% Build the Graphic User Interface object
%

global GphUsrInterface
global Logger

% WinBarSize = 41;
% UpsideBar = 44;
% SizeGUI=get(groot,'ScreenSize');
% SizeGUI(2) = WinBarSize;
% SizeGUI(4) = SizeGUI(4) - WinBarSize - UpsideBar;
name=sprintf('STANLY FEA 2017 - Copiright \x24B8 Tommaso Cavandoli - MatLab\x24C7 %s',version);

GphUsrInterface.Figure = uifigure;
set(GphUsrInterface.Figure,'Name',name)
set(GphUsrInterface.Figure,'NumberTitle','off')
set(GphUsrInterface.Figure,'WindowState','maximized')
%set(GphUsrInterface.Figure,'Position',SizeGUI)
set(GphUsrInterface.Figure,'Color',rgb(0,0,0))

% Log viewer
SizeGUI = get(GphUsrInterface.Figure,'Position');
Logger.Window = uilistbox(GphUsrInterface.Figure);
set(Logger.Window,'Position',[5 5 SizeGUI(3) SizeGUI(4)*0.2])
set(Logger.Window,'Items',Logger.Queue);
set(Logger.Window,'Value',Logger.Queue(end));

end