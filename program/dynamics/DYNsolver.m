% Solver
if exist('old_fname','var')
    new_fname=fname; fname=old_fname;
    close_stan
    fname=new_fname;
    clear old_fname new_fname
end
tic
status_info('Building global variables')
AZ=-37.5000; EL=30;
xyztab=[]; dtab=[]; axx=[]; index=[];
sections=[]; material=[];
nn=0; ne=0; ndof=0; ndob=0;
L=[]; ang=[]; bush=[]; ph_nodes=[]; ph_elems=[];
Kcorr=[]; springs=[]; incl=[];
file=[pname fname];
finp=fopen(file,'r');
Li=zeros(12,12,ne);
Ri=zeros(3,3,ne); %rotation matrices definitions
status_info(sprintf('Loading file: %s',fname))
readstr(finp);
fclose all;
%d_sca=max([xlim ylim zlim]);

%System assembly
limbb=ndob; if ~isempty(axx), limbb=limbb-sum(sum(axx(:,3:8)==Inf)); end
ff=1:ndof; bb=ndof+(1:limbb);
status_info('Global system assembly')
[M,K,~,Mi,Ki]=assembly;
if ~isempty(incl)
    status_info('Inclined constraints correction (K,M)')
    [K,~]=incl_corr_1(K);
    [M,~]=incl_corr_1(M);
end
corr_f=F(dtab);
status_info('Matrix partitioning')
Mff=M(ff,ff); Mfb=M(ff,bb);
Mbf=M(bb,ff); Mbb=M(bb,bb);
Kff=K(ff,ff); Kfb=K(ff,bb);
Kbf=K(bb,ff); Kbb=K(bb,bb);
status_info('Damping matrix (Rayleigh)')
if ~exist('alfa','var'), alfa=0; end
if ~exist('beta','var'), beta=0; end
C=alfa*M+beta*K;

%%% Dynamics
status_info('Mode shapes and natural frequencies')
[Xm,Nf]=eig(Mff\Kff); Nf=sqrt(diag(Nf))/2/pi;