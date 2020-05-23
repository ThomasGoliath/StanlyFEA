%% NOMINAL STRESSES
[select,yes_list]=listdlg('PromptString',tab.stn.Properties.Description,...
    'ListString',{'Normal stress';'Shear stress';...
    'Maximum principal';'Minimum principal';...
    'Von Mises';'Guest-Tresca';...
    'First invariant';'Third invariant'});
if isempty(select), yes_list=0; end
if yes_list
    colname=tab.stn.Properties.VariableNames(2:end);
    colname=colname([0 select]+1);
    if ne*2>=15
        height=300;
    elseif ne<3
        height=128;
    else
        height=20+18*2*ne;
    end
    if length(select)+1>3
        width=430;
    else
        width=360;
    end
    tabp=[20    20+buttadd   390   height];
    figp=[34   688-height-buttadd   430   height+33+buttadd];
    tab_fig=uifigure('Name',tab.stn.Properties.Description,'Position',figp);
    uitable(tab_fig,'ColumnName',colname,...
        'RowName',table2cell(tab.stn(:,1)),...
        'Data',table2cell(tab.stn(:,2+[0 select])),...
        'ColumnEditable',false,'Position',tabp);
    status_info(sprintf('Table "%i - [%s]"',ktab,num2str(select)),1)
    store.stn=tab.stn(:,[-1 0 select]+2);
    uibutton(tab_fig,'Position',[160 10 100 22],'Text','Export',...
        'ButtonPushedFcn','savetab(store.stn)','Position',[20 10 100 22]);
end