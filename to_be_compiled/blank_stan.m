status_info('Blank model',1)
backup_models
switch extnum
    case 1
        extstr=strcat(cd,'\model.stan &');
    case 2
        extstr=strcat(cd,'\model.fstan &');
    case 3
        extstr=strcat(cd,'\model.dstan &');
    otherwise
        extstr=strcat(cd,'\model.stan &');
end
dos(sprintf('notepad.exe .%s',extstr));
status_info(sprintf('Blank model opened %i',extnum))