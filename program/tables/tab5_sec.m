%% SECTIONS
if size(sections,1)>=15
    height=300;
elseif size(sections,1)<=5
    height=128;
else
    height=20+18*size(sections,1);
end
colname=tab.sec.Properties.VariableNames(2:end);
tabp=[20    20+buttadd   390   height];
figp=[34   688-height-buttadd   430   height+33+buttadd];
tab_fig=uifigure('Name',tab.sec.Properties.Description,'Position',figp);
uitable(tab_fig,'ColumnName',colname,...
    'Data',table2cell(tab.sec(:,2:end)),'ColumnEditable',false,'Position',tabp);
status_info(sprintf('Table "%i"',ktab),1)
uibutton(tab_fig,'Position',[160 10 100 22],'Text','Export',...
'ButtonPushedFcn','savetab(tab.sec)','Position',[20 10 100 22]);