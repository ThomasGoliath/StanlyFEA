function editcb(labl,lims)
global cb
cticks_res=32;
caxis(lims)
set(cb,'Ticks',linspace(lims(1),lims(2),cticks_res),...
    'TickLabels',sprintf('%+.3e\n',linspace(lims(1),lims(2),cticks_res)));
cb.Label.String=labl;
cb.Label.FontSize=10;
cb.Label.Position=[-1.5515e+00 mean(lims) 0];
set(cb,'Visible','on')

