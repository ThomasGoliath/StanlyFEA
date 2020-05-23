%% NODAL DISPLACEMENTS
rowname=tab.uvw(:,1);
[select,yes_list]=listdlg('PromptString',tab.uvw.Properties.Description,...
    'ListString',{'Total displacement','X displacement',...
    'Y displacement','Z displacement','X rotation',...
    'Y rotation','Z rotation'});
if isempty(select), yes_list=0; end
if yes_list
    colname=tab.uvw.Properties.VariableNames(2:end);
    colname=colname(select);
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
    tab_fig=uifigure('Name',tab.uvw.Properties.Description,'Position',figp);
    exTab=uitable(tab_fig,'ColumnName',colname,'Data',table2cell(tab.uvw(:,1+select)),...
        'ColumnEditable',false,'Position',tabp,'Rowname',table2cell(tab.uvw(:,1)));
    status_info(sprintf('Table "%i - [%s]"',ktab,num2str(select)),1)
    store.uvw=tab.uvw(:,[0 select]+1);
    uibutton(tab_fig,'Position',[160 10 100 22],'Text','Export',...
        'ButtonPushedFcn','savetab(store.uvw)','Position',[20 10 100 22]);
end