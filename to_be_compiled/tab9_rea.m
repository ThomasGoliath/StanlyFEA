%% REACTION LOADS
[select,yes_list]=listdlg('PromptString',tab.rea.Properties.Description,...
    'ListString',{'Reaction loads along X','Reaction loads along Y',...
    'Reaction loads along Z','Reaction moments around X',...
    'Reaction moments around Y','Reaction moments around Z'});
if isempty(select), yes_list=0; end
if yes_list
    colname=tab.rea.Properties.VariableNames(1+select);
    colname=colname();
    if nn>=15
        height=300;
    elseif nn<3
        height=128;
    else
        height=20+18*nn;
    end
    if length(select)>3
        width=430;
    else
        width=360;
    end
    tabp=[20    20+buttadd   390   height];
    figp=[34   688-height-buttadd   430   height+33+buttadd];
    tab_fig=uifigure('Name',tab.rea.Properties.Description,'Position',figp);
    uitable(tab_fig,'ColumnName',colname,...
        'Data',table2cell(tab.rea(:,1+select)),'ColumnEditable',false,...
    'Position',tabp,'RowName',table2cell(tab.rea(:,1)));
    status_info(sprintf('Table "%i - [%s]"',ktab,num2str(select)),1)
    store.rea=tab.rea(:,[0 select]+1);
    uibutton(tab_fig,'Position',[160 10 100 22],'Text','Export',...
        'ButtonPushedFcn','savetab(store.rea)','Position',[20 10 100 22]);
end