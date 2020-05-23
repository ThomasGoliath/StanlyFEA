%% ELEMENT ORIENTATION
if ne>=15
    height=300;
elseif ne<=5
    height=128;
else
    height=20+18*ne;
end
tabp=[20    20+buttadd   390   height];
figp=[34   688-height-buttadd   430   height+33+buttadd];
tab_fig=uifigure('Name',tab.ori.Properties.Description,'Position',figp);
colname=tab.ori.Properties.VariableNames(2:end);
uitable(tab_fig,'ColumnName',colname,'Data',table2cell(tab.ori(:,2:end)),...
    'ColumnEditable',false,'Position',tabp);
status_info(sprintf('Table "%i"',ktab),1)
uibutton(tab_fig,'Position',[160 10 100 22],'Text','Export',...
'ButtonPushedFcn','savetab(tab.ori)','Position',[20 10 100 22]);