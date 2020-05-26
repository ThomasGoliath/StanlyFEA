function ExportMat
%% ExportMat
% Save global variables in a .mat file

    global FileManager
    global Mesh
    global Properties
    global Loads
    global Constraints

    LogMsg('Export MAT',1)
    % Escludo estensione dal nome del file
    if (FileManager.CurrentFile.FileType == 1 || FileManager.CurrentFile.FileType == 3)
        % stan || dyan
        defaultMatName = FileManager.CurrentFile.Name(1:end-5);
    else
        % fstan
        defaultMatName = FileManager.CurrentFile.Name(1:end-6);
    end
    [matName,matPath]=uiputfile(strcat(defaultMatName,'.mat'),'Save Workspace as');
    if matName~=0
        % TODO definire variabili da inserire in salvataggio
        save(strcat(matPath,matName),Mesh,Properties,Loads,Constraints)
        LogMsg(sprintf('Save "%s"',strcat(matPath,matName)))
    else
        LogMsg('Operation canceled')
    end

end