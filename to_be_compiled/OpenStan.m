function OpenStan
%% OpenStan()
% Open a .stan / .fstan / .dyan file with notepad
%

% Richiamo variabili globali
global FileManager
% Parametri
DefaultPath = '.\structures\';

LogMsg('Open STAN',1)
ExtensionList = FileManager.FileTypes.List;
ExtensionList = ExtensionList(FileManager.FileTypes.Enabled);
[StanName,StanPath]=uigetfile(ExtensionList,'Select STAN input file',DefaultPath);
if StanName~=0
	dos(sprintf('notepad.exe %s &',strcat(StanPath,StanName)));
    LogMsg(sprintf('Open "%s"',strcat(StanPath,StanName)))
else
    LogMsg('Operation canceled')
end

end