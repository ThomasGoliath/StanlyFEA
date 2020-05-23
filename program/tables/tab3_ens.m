%% ENSLAVEMENTS
if size(axx,1)>=15
    height=300;
elseif size(axx,1)<=5
    height=128;
else
    height=20+18*size(axx,1);
end
tabp=[20    20+buttadd   390   height];
figp=[34   688-height-buttadd   430   height+33+buttadd];
colname=tab.ens.Properties.VariableNames;
tab_fig=uifigure('Name',tab.ens.Properties.Description,'Position',figp);
uitable(tab_fig,'ColumnName',colname,...
    'Data',table2cell(tab.ens),'ColumnEditable',false,'Position',tabp);
status_info(sprintf('Table "%i"',ktab),1)
uibutton(tab_fig,'Position',[160 10 100 22],'Text','Export',...
'ButtonPushedFcn','savetab(tab.ens)','Position',[20 10 100 22]);