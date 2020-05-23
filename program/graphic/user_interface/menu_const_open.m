function menu_const_open(fig)
global ext_list_sel
ext_en={'off';'off';'off'};
for i=ext_list_sel, ext_en(i)={'on'}; end
main1=uimenu(fig,'Label','File');
bmod=uimenu(main1,'Label','Blank model');
uimenu(bmod,'Label','Static analysis','Callback','extnum=1; blank_stan','Enable',char(ext_en(1)));
uimenu(bmod,'Label','Fatigue analysis','Callback','extnum=2; blank_stan','Enable',char(ext_en(2)));
%uimenu(bmod,'Label','Dynamic analysis','Callback','extnum=3; blank_stan','Enable',char(ext_en(3)));
uimenu(main1,'Label','Open STAN','Callback','open_stan');
uimenu(main1,'Label','Load STAN','Callback','loader','Separator','on');
export1=uimenu(main1,'Label','Export','Enable','off');
uimenu(export1,'Label','Report','Callback','pub_rep','Enable','off');
uimenu(export1,'Label','Workspace','Callback','export_mat','Enable','off');
uimenu(main1,'Label','Close STAN','Callback','close_stan','Enable','off','Separator','on');
uimenu(main1,'Label','Quit','Callback','close all');
main5=uimenu(fig,'Label','Documentation');
uimenu(main5,'Label','Input manual','Callback','winopen inp_manual.pdf','Enable','on');
uimenu(main5,'Label','Output manual','Callback','winopen out_manual.pdf','Enable','off');
uimenu(main5,'Label','License','Callback','open_lic','Separator','on');