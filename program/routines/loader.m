% Structure loading
status_info('Load STAN',1)
if exist('fname','var')
    if fname(1)~=0
        old_fname=fname;
    end
end
stan_flag=1;
[fname,pname,filetype]=uigetfile(extension_list(ext_list_sel,:),...
    'Select STAN input file','.\structures\');
if fname~=0
    switch filetype
        case 1
            STAsolver
            if exist('err_rep','var'), clear err_rep; return; end
            status_info('Loading UI')
            status_info('Graph "Mesh"')
            fprintf('Nodes\t\t%i\nElements\t%i\nDoFs\t\t%i\nDoBs\t\t%i\n',...
                nn,ne,ndof,ndob)
        case 2
            if exist(strcat(pname,fname(1:end-5),'stan'),'file')
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
            DYNsolver
    end
    clf(GUI)
    menu_const(GUI)
    build_UIax;
    ucs=build_ucs(GUI);
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