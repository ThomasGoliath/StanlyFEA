function BuildGUI

%% BuildGUI()
% Build the Graphic User Interface object
%

global GphUsrInterface Logger

SizeGUI=get(groot,'ScreenSize');
name=sprintf('STANLY FEA 2017 - Copiright \x24B8 Tommaso Cavandoli - MatLab\x24C7 %s',version);

GphUsrInterface=uifigure;
set(GphUsrInterface,'Name',name)
set(GphUsrInterface,'NumberTitle','off')
set(GphUsrInterface,'Position',SizeGUI)
set(GphUsrInterface,'Color',rgb(0,0,0))

% Log viewer
Logger.Window = uilistbox(GphUsrInterface);
set(Logger.Window,'Position',[5 5 SizeGUI(3)-10 SizeGUI(4)*0.2])
set(Logger.Window,'Items',Logger.Queue);
set(Logger.Window,'Value',Logger.Queue(end));

end