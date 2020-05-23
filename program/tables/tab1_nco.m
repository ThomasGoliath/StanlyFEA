%% NODAL COORDINATES
if nn>=15
    height=300;
elseif nn<=5
    height=128;
else
    height=20+18*nn;
end
tabp=[20    20+buttadd   320   height];
figp=[34   688-height-buttadd   360   height+33+buttadd];
tab_fig=uifigure('Name',tab.nco.Properties.Description,'Position',figp);
colname=tab.nco.Properties.VariableNames(2:end);
uitable(tab_fig,'ColumnName',colname,'Data',table2cell(tab.nco(:,2:end)),...
    'ColumnEditable',false,'Position',tabp);
status_info(sprintf('Table "%i"',ktab),1)
uibutton(tab_fig,'Position',[160 10 100 22],'Text','Export',...
'ButtonPushedFcn','savetab(tab.nco)','Position',[20 10 100 22]);