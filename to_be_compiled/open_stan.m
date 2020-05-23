status_info('Open STAN',1)
backup_models
[fop,pop]=uigetfile(extension_list(ext_list_sel,:),...
    'Select STAN input file','.\structures\');
if fop~=0
	comm=sprintf('notepad.exe %s &',strcat(pop,fop));
	dos(comm);
    status_info(sprintf('Open "%s"',strcat(pop,fop)))
else
    status_info('Operation aborted')
end
clear fop pop comm