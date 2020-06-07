function Loader

global FileManager
global Mesh

% Backup del file corrente
LogMsg('Load STAN',1)
FileManager.PreviousFile = FileManager.CurrentFile;

stan_flag=1;
% User sceglie il file da aprire
[FileManager.CurrentFile.Name,FileManager.CurrentFile.Path,...
    FileManager.CurrentFile.FileType]...
    = uigetfile(FileManager.FileTypes.EnabledList,...
    'Select STAN input file',FileManager.DefaultPath);

if FileManager.CurrentFile.Name~=0
    
    switch FileManager.CurrentFile.FileType
        
        % (.stan) STATIC ANALYSIS
        case 1            
            SolverStatic
            if exist('err_rep','var'), clear err_rep; return; end % TODO sistema
            LogMsg('Loading UI')
            LogMsg('Graph "Mesh"')
            LogMsg(sprintf('Nodes\t\t%i',Mesh.Numbers.Nodes))
            LogMsg(sprintf('Elements\t\t%i',Mesh.Numbers.Elements))
            LogMsg(sprintf('nDoFs\t\t%i',Mesh.Numbers.Dofs))
            LogMsg(sprintf('nDoBs\t\t%i',Mesh.Numbers.Dobs))
            
        case 2
            % Controllo se esiste anche il file STAN per carichi medi
            if exist(strcat(FileManager.CurrentFile.Path,...
                    FileManager.CurrentFile.Name(1:end-5),'stan'),'file')
                altfname=fname; fname=strcat(fname(1:end-5),'stan');
                filetype=1; stan_flag=0;
                STAsolver
                if exist('err_rep','var'), clear err_rep; return; end
                stan_flag=1;
                status_info('Mean stress configuration loaded')
                meanS=SS;
                filetype=2;
                fname=altfname;
            end
            STAsolver
            status_info('Alternate stress configuration loaded')
            if ~exist('meanS','var'), meanS=zeros(size(SS)); end
            status_info('Computing fatigue parameters')
            FATsolver
            status_info('Fatigue assessed')
            status_info('Loading UI')
            status_info('Graph "Mesh"')
            fprintf('Nodes\t\t%i\nElements\t%i\nDoFs\t\t%i\nDoBs\t\t%i\n',...
                nn,ne,ndof,ndob)
        case 3
            %DYNsolver
    end
    delete(UIax)
    menu_const(GUI)
    build_UIax;
    ucs=build_ucs;
    ucs_link=linkprop([UIax,ucs],{'View'});
    meshstr
    view(3)
    AXLIM=axis;
    status_info('Constructing tables')
    if filetype==1
        tab=tabBuilder(tab_f,int_f,int_act,uvwtab,SS,SSnom,EE,EEnom,eta);
    else
        tab=tabBuilder(tab_f,int_f,int_act,uvwtab,SS,SSnom,EE,EEnom,eta,FF);
    end
    status_info('Operation completed')
else
    status_info('Operation aborted')
end