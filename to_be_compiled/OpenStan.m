function OpenStan
%% OpenStan()
% Open a .stan / .fstan / .dyan file with notepad
%

% Richiamo variabili globali
global FileManager

LogMsg('Open STAN',1)
[StanName,StanPath]=uigetfile(FileManager.FileTypes.EnabledList,...
    'Select STAN input file',FileManager.DefaultPath);
if StanName~=0
	dos(sprintf('notepad.exe %s &',strcat(StanPath,StanName)));
    LogMsg(sprintf('Open "%s"',strcat(StanPath,StanName)))
else
    LogMsg('Operation canceled')
end

end