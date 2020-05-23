function build_GUI
global GUI
name=sprintf('STANLY FEA 2017 - Copiright \x24B8 Tommaso Cavandoli - MatLab\x24C7 %s',version);
GUI=figure;
set(GUI,'Name',name)
set(GUI,'NumberTitle','off')
set(GUI,'MenuBar','none','ToolBar','figure')
set(GUI,'OuterPosition',[316 203 739 513])
set(GUI,'Color',rgb(0,0,0))
set(findall(GUI,'ToolTipString','New Figure'),'Visible','Off')
set(findall(GUI,'ToolTipString','Open File'),'Visible','Off')
set(findall(GUI,'ToolTipString','Print Figure'),'Visible','Off')
set(findall(GUI,'ToolTipString','Edit Plot'),'Visible','Off','Separator','off')
set(findall(GUI,'ToolTipString','Brush/Select Data'),'Visible','Off')
set(findall(GUI,'ToolTipString','Link Plot'),'Visible','Off','Separator','off')
set(findall(GUI,'ToolTipString','Insert Colorbar'),'Visible','Off')
set(findall(GUI,'ToolTipString','Insert Legend'),'Visible','Off')
set(findall(GUI,'ToolTipString','Hide Plot Tools'),'Visible','Off','Separator','off')
set(findall(GUI,'ToolTipString','Show Plot Tools and Dock Figure'),'Visible','Off')
end