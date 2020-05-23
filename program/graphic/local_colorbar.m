function local_colorbar(fig,lims,labl)
set(groot,'CurrentFigure',fig)
colormap jet
cbl=colorbar('FontSize',7.5,'Position',[0.8522 0.1103 0.0308 0.8155]);
cticks_res=32;
caxis(lims)
set(cbl,'Ticks',linspace(lims(1),lims(2),cticks_res),...
    'TickLabels',sprintf('%+.3e\n',linspace(lims(1),lims(2),cticks_res)));
cbl.Label.String=labl;
cbl.Label.FontSize=10;
cbl.Label.Position=[-1.5515e+00 mean(lims) 0];
end