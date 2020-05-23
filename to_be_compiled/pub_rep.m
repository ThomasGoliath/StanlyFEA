% dialog
status_info('Report',1)
[AZ,EL]=view;
[fig_choice,tab_choice,yes_pub]=pub_sel;

%% start publishing
try
    if yes_pub
        [popt,fin,temp,yes_pub,jjj]=pub_opt(file);
        if yes_pub
            status_info('Start publishing',1)
            if jjj
                publish('report',popt);
            else
                publish('reportPDF',popt);
            end
            if ~isempty(fin)
                copyfile(temp,fin,'f')
                delete(temp)
            else
                fin=temp;
            end
            msgbox(sprintf('Report published in:\n%s',fin))
            close(rep_fig)
            status_info(sprintf('Report published in %s',fin))
            clear pub_opt pub_path rep_fig
        else
            status_info('Operation aborted')
        end
    else
        status_info('Operation aborted')
    end
catch
    errordlg('Operation aborted. Check log file for errors')
	status_info('Operation aborted')
end