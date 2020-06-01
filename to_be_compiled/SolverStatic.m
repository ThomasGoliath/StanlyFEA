% Solver
function report = SolverStatic

global FileManager

global Mesh
global Properties
global Loads
global Constraints
global Solver
global Output

% Start Timer
tic

% Init global Variables
LogMsg('Building global variables')
InitGlobalVars
% Read Structure File
finp=fopen([FileManager.CurrentFile.Path FileManager.CurrentFile.Name],'r');
LogMsg(sprintf('Loading file: %s',fname))
ReadStructure(finp); % TODO ReadStructure Review
fclose(finp);

% Try to compose the Matrix
try
    %%% Reazioni ai vincoli
    if ~isempty(axx)
        TrueDobs = Mesh.Numbers.Dobs - sum(sum(axx(:,3:8)==Inf));
    else
        TrueDobs = Mesh.Numbers.Dobs;
    end
    % Trovo gli indici dei gradi di libertà e dei gradi di vincolo
    ff=1:Mesh.Numbers.Dofs;
    bb=Mesh.Numbers.Dofs+(1:TrueDobs);
    % Assemblo le matrici
    LogMsg('Global system assembly')
    [~,Solver.K,Solver.F,~,Solver.Ki]=Assembly; % TODO Assembly Review
    ExtLoads=Solver.F(Constraints.Dtab);   
    OnConstLoads = Solver.F;
    OnConstLoads(bb)=zeros(size(Solver.F(bb)));
    OnConstLoads=-OnConstLoads(Constraints.Dtab)+ExtLoads;
    
    % Carichi termici
    if ~isempty(Loads.Thermal)
        LogMsg('Thermal load correction')
        CorrectionThermalLoad; % TODO Thermal Load Review F=(F)
    end
    OnConstLoadTh=Solver.F(Constraints.Dtab)+ExtLoads;
    OnConstLoadTh(Constraints.Dtab <= Mesh.Numbers.Dofs) = ...
        zeros(size(OnConstLoadTh(Constraints.Dtab <= Mesh.Numbers.Dofs)));
    
    % Vincoli elastici
    if ~isempty(bush)
        LogMsg('Bushing correction')
        CorrectionBushing; % TODO Bushing Correction [K,F]=(K,F);
    end    
    TabLoad=Solver.F(Constraints.Dtab);  
    
    % Vincoli Inclinati (1)
    if ~isempty(incl)
        LogMsg('Inclined constraints correction (K,F)')
        CorrectionInclConst(1);
    end
    CorrectedLoads=Solver.F(Constraints.Dtab); 
    
    
    LogMsg('Matrix partitioning')
    Solver.Kff=Solver.K(ff,ff);
    Solver.Kfb=Solver.K(ff,bb);
    Solver.Kbf=Solver.K(bb,ff);
    Solver.Solver.Kbb=Solver.K(bb,bb);
    Solver.xf=Solver.Kff\Solver.F(ff);
    if det(Solver.Kbb)~=0
        Solver.xb=Solver.Kbb\Solver.F(bb);
    else
        Solver.xb=zeros(Mesh.Numbers.Dobs,1);
    end
    Solver.x=[Solver.xf; Solver.xb];
    LogMsg('Inclined constraints correction (x)')
    CorrectionInclConst(2)
    Solver.F(bb) = Solver.F(bb) + Solver.Kbf*Solver.xf;
    LogMsg('Linear system solved')
    Solver.React = Solver.F(Constraints.Dtab) - CorrectedLoads - OnConstLoad...
        - OnConstLoadTh;
    CorrectionInclConst(3);
    if toll~=0
        for i=1:nn
            for j=1:6
                if abs(ExtLoads(i,j))<toll
                    ExtLoads(i,j)=0;
                end
            end
        end
    end
    
    %%% Internal actions
    LogMsg('Computing internal actions')
    Output.InternalForces=zeros(ne,12);
    for i=1:Mesh.Numbers.Elements
        ind=[Constraints.Dtab(Mesh.Element(i).Index(2),:) Constraints.Dtab(Mesh.Element(i).Index(3),:)];
        xloc=Solver.x(ind);
        Output.InternalForces(i,:)=Mesh.Element(i).Li*Solver.Ki(:,:,i)*Solver.x(ind);
        % Zero tolerance
        if toll~=0
            for j=1:12
                if abs(Output.InternalForces(i,j))<toll
                    Output.InternalForces(i,j)=0;
                end
            end
        end
    end
    vvv=[1 4 8 9 5 12];
    Output.InternalForces(:,vvv)=-Output.InternalForces(:,vvv);
    for i=1:size(Ttab,1)
        Output.InternalForces(Loads.Thermal(i,1),[1 7])=Output.InternalForces(Loads.Thermal(i,1),[1 7])+Loads.Thermal(i,6);
        Output.InternalForces(Loads.Thermal(i,1),[5 11])=Output.InternalForces(Loads.Thermal(i,1),[5 11])+Loads.Thermal(i,7);
        Output.InternalForces(Loads.Thermal(i,1),[6 12])=Output.InternalForces(Loads.Thermal(i,1),[6 12])-Loads.Thermal(i,8);
    end
    
    %%% Stress and strain
    defsca=6/60*d_sca;
    if stan_flag
        status_info('Computing displacements')
        [defmat,uvwtab,maxd]=shapef(xx,pnres,defsca);
    end
    status_info('Computing stresses')
    if filetype==1&&sum(sum(notch(:,2:end)~=1))
        [SS,SSnom]=stresses(InternalForces);
        if stan_flag
            status_info('Computing strains')
            [EE,EEnom]=strains(SS,SSnom);
        end
    else
        SS=stresses(InternalForces);
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
    LogMsg(sprintf('Structure loaded successfully in %f seconds',toc))
    
catch ME
    % Clean GUI
    cla(GphUsrInterface.Axes);
    FixMenu(false)
    meshstr(GUI)
    % Notify error
    ErrorManager('Operation Failed: see message error',ME)
    errordlg('Not able to solve the structure. Check the mesh and correct mistakes.')
    err_rep=[];
    return
end