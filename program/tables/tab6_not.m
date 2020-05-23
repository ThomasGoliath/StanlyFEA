%% NOTCHES
if nn>=15
    height=300;
elseif nn<=5
    height=128;
else
    height=20+18*nn;
end
tabp=[20    20+buttadd   390   height];
figp=[34   688-height-buttadd   430   height+33+buttadd];
colname=tab.not.Properties.VariableNames(2:end);
tab_fig=uifigure('Name',tab.not.Properties.Description,'Position',figp);
uitable(tab_fig,'ColumnName',colname,'Data',table2cell(tab.not(:,2:end)),...
    'ColumnEditable',false,'Position',tabp);
status_info(sprintf('Table "%i"',ktab),1)
uibutton(tab_fig,'Position',[160 10 100 22],'Text','Export',...
'ButtonPushedFcn','savetab(tab.not)','Position',[20 10 100 22]);