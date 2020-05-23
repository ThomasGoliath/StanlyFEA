function savetab(seltab)
filtlist={'*.txt;*.dat;*.csv','Delimited Text File (*.txt;*.dat;*.csv)';
    '*.xlsx;*.xlsm;*.xlsb;*.xls','Microsoft Excel Spreadsheet(*.xlsx;*.xlsm;*.xlsb;*.xls)'};
[exptabname,exptabpath,filtspec]=uiputfile(filtlist,'Export table');
if exptabname~=0
    exptab=strcat(exptabpath,exptabname);
    try
        if exist(exptab,'file'), delete(exptab), end
        if filtspec==1
            writetable(seltab,exptab,'Delimiter','\t');
        else
            writetable(seltab,exptab);
        end
    catch
        errordlg(sprintf('The file is used by another application.\nNot possible to overwrite %s.',exptab))
    end
end
end