function BlankModel(modelType)
%% BlankModel(modelType)
% Open a blank model with default structure for the specified filetype:
%   1 - stan (Static Analysis)
%   2 - fstan (Fatigue Analysis)
%   3 - dyan (Dynamic Analysis)
%
    LogMsg('Blank model',1)
    
    switch modelType
        
        % (.stan) Static Analysis
        case 1
            fPath = strcat(cd,'model.stan');
            fID = fopen(fPath,'w+');
            fwrite(fID,ModelStan);
            fclose(fID);
            
        % (.fstan) Fatigue Analysis
        case 2
            fPath = strcat(cd,'model.fstan');
            fID = fopen(fPath,'w+');
            fwrite(fID,ModelFstan);
            fclose(fID);
            
        % (.dyan) Dynamics Analysis
        case 3
            fPath = strcat(cd,'model.dyan');
            fID = fopen(fPath,'w+');
            fwrite(fID,ModelDstan);
            fclose(fID);
            
        otherwise
            ErrorManager('InvalidFileType')
    end
    
    dos(sprintf('notepad.exe .%s',fPath));
    LogMsg(sprintf('Blank model opened [%i]',modelType))
    
end