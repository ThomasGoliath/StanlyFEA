status_info('Export MAT',1)
if filetype==1
    defmatname=fname(1:end-5);
else
    defmatname=fname(1:end-6);
end
[matname,matpath]=uiputfile(strcat(defmatname,'.mat'),'Save Workspace as');
if matname~=0
    if filetype==1
        save(strcat(matpath,matname),'ang','axx','bush','defmat','dtab','EE','EEnom',...
            'F','file','Ftab','incl','index','int_act','K','L','Li','material','sections',...
            'ndob','ndof','ne','nn','notch','Qtab','Ri','springs','SS','SSnom','Ttab',...
            'uvwtab','xx','xyztab','eta')
    else
        save(strcat(matpath,matname),'ang','axx','bush','defmat','dtab','EE','EEnom',...
            'F','file','Ftab','incl','index','int_act','K','L','Li','material','sections',...
            'ndob','ndof','ne','nn','notch','Qtab','Ri','springs','SS','SSnom','Ttab',...
            'uvwtab','xx','xyztab','FF','FFnom','meanS','Awohl','Bwohl','eta')
    end
    status_info(sprintf('Save "%s"',strcat(matpath,matname)))
else
    status_info('Operation aborted')
end
clear defmatname