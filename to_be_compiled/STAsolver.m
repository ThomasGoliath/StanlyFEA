% Solver
if exist('old_fname','var')
    new_fname=fname; fname=old_fname;
    close_stan
    fname=new_fname;
    clear old_fname new_fname
end
tic
status_info('Building global variables')
xyztab=[]; dtab=[]; axx=[]; index=[];
Ftab=[]; Ttab=[]; Qtab=[]; sections=[]; material=[];
nn=0; ne=0; ndof=0; ndob=0;
L=[]; ang=[]; bush=[]; ph_nodes=[]; ph_elems=[];
Kcorr=[]; springs=[]; incl=[]; notch=[];
file=[pname fname];
finp=fopen(file,'r');
Li=zeros(12,12,ne);
Ri=zeros(3,3,ne); %rotation matrices definitions
status_info(sprintf('Loading file: %s',fname))
readstr(finp);
fclose all;
%d_sca=max([xlim ylim zlim]);

try
    %%% Constraints reactions
    limbb=ndob; if ~isempty(axx), limbb=limbb-sum(sum(axx(:,3:8)==Inf)); end
    ff=1:ndof; bb=ndof+(1:limbb);
    status_info('Global system assembly')
    [~,K,F,~,Ki]=assembly;
    ext_f=F(dtab); onc_f=F;
    onc_f(bb)=zeros(size(F(bb)));
    onc_f=-onc_f(dtab)+ext_f;
    if ~isempty(Ttab)
        status_info('Thermal load correction')
        F=thermal_corr(F);
    end
    onc_t=F(dtab)+ext_f; onc_t(dtab<=ndof)=zeros(size(onc_t(dtab<=ndof)));
    %F(bb)=zeros(size(F(bb)));
    if ~isempty(bush)
        status_info('Bushing correction')
        [K,F]=bushing_corr(K,F);
    end
    tab_f=F(dtab);
    if ~isempty(incl)
        status_info('Inclined constraints correction (K,F)')
        [K,F]=incl_corr_1(K,F);
    end
    corr_f=F(dtab);
    status_info('Matrix partitioning')
    Kff=K(ff,ff); Kfb=K(ff,bb);
    Kbf=K(bb,ff); Kbb=K(bb,bb);
    xf=Kff\F(ff);
    if det(Kbb)~=0
        xb=Kbb\F(bb);
    else
        xb=zeros(ndob,1);
    end
    xx=[xf; xb];
    if ~isempty(incl)
        status_info('Inclined constraints correction (x)')
        xx=incl_corr_2(xx);
    end
    F(bb)=F(bb)+Kbf*xf;
    status_info('Linear system solved')
    int_f=F(dtab)-corr_f-onc_f-onc_t;
    int_f=incl_corr_3(int_f);
    if toll~=0
        for i=1:nn
            for j=1:6
                if abs(ext_f(i,j))<toll
                    ext_f(i,j)=0;
                end
            end
        end
    end
    
    %%% Internal actions
    status_info('Computing internal actions')
    fa=.5;
    int_act=zeros(ne,12);
    for i=1:ne
        ind=[dtab(index(i,2),:) dtab(index(i,3),:)];
        xloc=xx(ind);
        int_act(i,:)=Li(:,:,i)*Ki(:,:,i)*xx(ind);
        if toll~=0
            for j=1:12
                if abs(int_act(i,j))<toll
                    int_act(i,j)=0;
                end
            end
        end
    end
    vvv=[1 4 8 9 5 12];
    int_act(:,vvv)=-int_act(:,vvv);
    for i=1:size(Ttab,1)
        int_act(Ttab(i,1),[1 7])=int_act(Ttab(i,1),[1 7])+Ttab(i,6);
        int_act(Ttab(i,1),[5 11])=int_act(Ttab(i,1),[5 11])+Ttab(i,7);
        int_act(Ttab(i,1),[6 12])=int_act(Ttab(i,1),[6 12])-Ttab(i,8);
    end
    
    %%% Stress and strain
    defsca=6/60*d_sca;
    if stan_flag
        status_info('Computing displacements')
        [defmat,uvwtab,maxd]=shapef(xx,pnres,defsca);
    end
    status_info('Computing stresses')
    if filetype==1&&sum(sum(notch(:,2:end)~=1))
        [SS,SSnom]=stresses(int_act);
        if stan_flag
            status_info('Computing strains')
            [EE,EEnom]=strains(SS,SSnom);
        end
    else
        SS=stresses(int_act);
        if stan_flag
            status_info('Computing strains')
            EE=strains(SS);
        end
        SSnom=SS; if stan_flag, EEnom=EE; end
    end
    
    %% Assessment
    if stan_flag
        status_info('Computing safety factors')
        if filetype==1
            keta=[0 5];
            eta=zeros(size(SS,1),keta(2)*2);
        else
            keta=[0 7];
            eta=zeros(size(SS,1),keta(2)*2);
        end
        for i=1:ne
            ys=material(index(i,5),6);
            uts=material(index(i,5),7);
            eta(i,1+keta)=ys./SS(i,[5 13]); %mises 1st y
            eta(i,2+keta)=ys./SS(i,[6 14]); %tresca 1st y
            eta(i,3+keta)=ys./SSnom(i,[5 13]); %mises fail
            eta(i,4+keta)=ys./SSnom(i,[6 14]); %tresca fail
            gr=[max(abs(SS(i,[3 4]))) max(abs(SS(i,[11 12])))];
            eta(i,5+keta)=uts./gr; %galileo
        end
        eta(eta==Inf)=-ones(size(eta(eta==Inf)));
        eta(eta<0)=max(max(eta))*ones(size(eta(eta<0)));
    end
    status_info(sprintf('Structure loaded successfully in %f seconds',toc))
catch ME
    status_info('Operation Failed: see message error')
    clf(GUI)
    menu_const_open(GUI)
    meshstr(GUI)
    errordlg('Not able to solve the structure. Check the mesh and correct mistakes.')
    err_rep=[];
    return
end