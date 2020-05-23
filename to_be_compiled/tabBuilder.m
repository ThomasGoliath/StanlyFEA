function TAB=tabBuilder(Ex,R,IA,DISP,SS,SSn,EE,EEn,eta,FF)
global xyztab index material axx sections
global notch nn ne filetype L ang dtab ndof

%% Nodal coordinates
Node=xyztab(:,1);
X=xyztab(:,2);
Y=xyztab(:,3);
Z=xyztab(:,4);
units={'','[lu]','[lu]','[lu]'};
TAB.nco=table(Node,X,Y,Z);
TAB.nco.Properties.VariableUnits=units;
TAB.nco.Properties.Description='Nodal coordinates';

%% Index
Element=index(:,1);
Node_1=index(:,2);
Node_2=index(:,3);
Section_ID=index(:,4);
Material_ID=index(:,5);
TAB.ind=table(Element,Node_1,Node_2,Section_ID,Material_ID);
TAB.ind.Properties.Description='Index Matrix';

%% Enslavements
if ~isempty(axx)
    Master=axx(:,1);
    Slave=axx(:,2);
    Kx=axx(:,3);
    Ky=axx(:,4);
    Kz=axx(:,5);
    Krx=axx(:,6);
    Kry=axx(:,7);
    Krz=axx(:,8);
    units={'','','[fu]/[lu]','[fu]/[lu]','[fu]/[lu]','[fu]*[lu]/[lu]',...
        '[fu]*[lu]/[lu]','[fu]*[lu]/[lu]'};
    TAB.ens=table(Master,Slave,Kx,Ky,Kz,Krx,Kry,Krz);
    TAB.ens.Properties.VariableUnits=units;
    TAB.ens.Properties.Description='Enslavements';
end

%% Materials
ID=material(:,1);
Young_E=material(:,2);
Poisson_v=material(:,3);
alpha=material(:,4);
mass=material(:,5);
YS=material(:,6);
UTS=material(:,7);
if filetype==1
    TAB.mat=table(ID,Young_E,Poisson_v,alpha,mass,YS,UTS);
    units={'','[fu]/[lu]^2','','1/[tu]','[fu]*[sec]^2','[fu]/[lu]^2',...
        '[fu]/[lu]^2'};
else
    ms=material(:,8);
    TAB.mat=table(ID,Young_E,Poisson_v,alpha,mass,YS,UTS,ms);
    units={'','[fu]/[lu]^2','','1/[tu]','[fu]*[sec]^2','[fu]/[lu]^2',...
        '[fu]/[lu]^2',''};
end
TAB.mat.Properties.VariableUnits=units;
TAB.mat.Properties.Description='Materials';

%% Sections
ID=sections(:,1);
A=sections(:,2);
Jv=sections(:,3);
Jw=sections(:,4);
Wv=sections(:,5);
Ww=sections(:,6);
tv=sections(:,7);
tw=sections(:,8);
if filetype==1
    TAB.sec=table(ID,A,Jv,Jw,Wv,Ww,tv,tw);
    units={'','[lu]^2','[lu]^4','[lu]^4','[lu]^3','[lu]^3','',''};
else
    md=sections(:,end);
    TAB.sec=table(ID,A,Jv,Jw,Wv,Ww,tv,tw,md);
    units={'','[lu]^2','[lu]^4','[lu]^4','[lu]^3','[lu]^3','','',''};
end
TAB.sec.Properties.VariableUnits=units;
TAB.sec.Properties.Description='Section properties';

%% Notches
Node=notch(:,1);
if filetype==1
    Kta=notch(:,2);
    Ktb=notch(:,3);
    Ktt=notch(:,4);
    TAB.not=table(Node,Kta,Ktb,Ktt);
else
    Ktb=notch(:,2);
    Ktt=notch(:,3);
    q=notch(:,4);
    TAB.not=table(Node,Ktb,Ktt,q);
end
TAB.not.Properties.Description='Stress concentration factors';

%% Orientation
Element=(1:ne).';
Length=L;
Azimut=ang(:,1)*180/pi;
Elevation=ang(:,2)*180/pi;
Axial=ang(:,3)*180/pi;
units={'','[lu]','[deg]','[deg]','[deg]'};
TAB.ori=table(Element,Length,Azimut,Elevation,Axial);
TAB.ori.Properties.VariableUnits=units;
TAB.ori.Properties.Description='Elements orientation';

%% External loads
cpos=zeros(nn,1);
for i=1:nn
    if sum(Ex(i,:)~=0)
        cpos(i)=i;
    end
end
cpos(cpos==0)=[];
Node=cpos;
Fx=Ex(cpos,1);
Fy=Ex(cpos,2);
Fz=Ex(cpos,3);
Mx=Ex(cpos,4);
My=Ex(cpos,5);
Mz=Ex(cpos,6);
TAB.ext=table(Node,Fx,Fy,Fz,Mx,My,Mz);
units={'','[fu]','[fu]','[fu]','[fu]*[lu]','[fu]*[lu]','[fu]*[lu]'};
TAB.ext.Properties.VariableUnits=units;
TAB.ext.Properties.Description='External loads';

%% Reactions
cpos=(1:nn).';
for i=1:nn
    if ~(max(dtab(i,:))>ndof&&sum(R(i,:)~=0))
        cpos(i)=0;
    end
end
cpos(cpos==0)=[];
Node=cpos;
Rx=R(cpos,1);
Ry=R(cpos,2);
Rz=R(cpos,3);
Mx=R(cpos,4);
My=R(cpos,5);
Mz=R(cpos,6);
TAB.rea=table(Node,Rx,Ry,Rz,Mx,My,Mz);
units={'','[fu]','[fu]','[fu]','[fu]*[lu]','[fu]*[lu]','[fu]*[lu]'};
TAB.rea.Properties.VariableUnits=units;
TAB.rea.Properties.Description='Reaction loads';

%% Internal forces
Element=zeros(2*ne,1);
Node=zeros(2*ne,1);
N=zeros(2*ne,1);
Tv=zeros(2*ne,1);
Tw=zeros(2*ne,1);
Mt=zeros(2*ne,1);
Mbv=zeros(2*ne,1);
Mbw=zeros(2*ne,1);
for i=1:2*ne
    el=floor((i+1)/2);
    Element(i)=el;
    if floor(i/2)*2~=i
        Node(i)=index(el,2);
        N(i)=IA(el,1);
        Tv(i)=IA(el,2);
        Tw(i)=IA(el,3);
        Mt(i)=IA(el,4);
        Mbv(i)=IA(el,5);
        Mbw(i)=IA(el,6);
    else
        Node(i)=index(el,3);
        N(i)=IA(el,7);
        Tv(i)=IA(el,8);
        Tw(i)=IA(el,9);
        Mt(i)=IA(el,10);
        Mbv(i)=IA(el,11);
        Mbw(i)=IA(el,12);
    end
end
TAB.int=table(Element,Node,N,Tv,Tw,Mt,Mbv,Mbw);
units={'','','[fu]','[fu]','[fu]','[fu]*[lu]','[fu]*[lu]','[fu]*[lu]'};
TAB.int.Properties.VariableUnits=units;
TAB.int.Properties.Description='Internal forces';

%% Nodal disp
Node=(1:nn).';
s_TOT=sqrt(sum(DISP(:,1:3).^2,2));
s_x=DISP(:,1);
s_y=DISP(:,2);
s_z=DISP(:,3);
r_x=DISP(:,4);
r_y=DISP(:,5);
r_z=DISP(:,6);
units={'','[lu]','[lu]','[lu]','[lu]','[lu]/[lu]','[lu]/[lu]','[lu]/[lu]'};
TAB.uvw=table(Node,s_TOT,s_x,s_y,s_z,r_x,r_y,r_z);
TAB.uvw.Properties.VariableUnits=units;
TAB.uvw.Properties.Description='Nodal displacements';

%% Maximum Stresses
sk=8;
Element=zeros(2*ne,1);
Node=zeros(2*ne,1);
S11=zeros(2*ne,1);
S12=zeros(2*ne,1);
MaxPrin=zeros(2*ne,1);
MinPrin=zeros(2*ne,1);
Von_Mises=zeros(2*ne,1);
Guest_Tresca=zeros(2*ne,1);
I1=zeros(2*ne,1);
I3=zeros(2*ne,1);
for i=1:2*ne
    el=floor((i+1)/2);
    Element(i)=el;
    if floor(i/2)*2~=i
        Node(i)=index(el,2);
        S11(i)=SS(el,1);
        S12(i)=SS(el,2);
        MaxPrin(i)=SS(el,3);
        MinPrin(i)=SS(el,4);
        Von_Mises(i)=SS(el,5);
        Guest_Tresca(i)=SS(el,6);
        I1(i)=SS(el,7);
        I3(i)=SS(el,8);
    else
        Node(i)=index(el,3);
        S11(i)=SS(el,1+sk);
        S12(i)=SS(el,2+sk);
        MaxPrin(i)=SS(el,3+sk);
        MinPrin(i)=SS(el,4+sk);
        Von_Mises(i)=SS(el,5+sk);
        Guest_Tresca(i)=SS(el,6+sk);
        I1(i)=SS(el,7+sk);
        I3(i)=SS(el,8+sk);
    end
end
TAB.stm=table(Element,Node,S11,S12,MaxPrin,MinPrin,Von_Mises,Guest_Tresca,I1,I3);
units={'','','[fu]/[lu]^2','[fu]/[lu]^2','[fu]/[lu]^2','[fu]/[lu]^2',...
    '[fu]/[lu]^2','[fu]/[lu]^2','[fu]/[lu]^2','[fu]^2/[lu]^4'};
TAB.stm.Properties.VariableUnits=units;
TAB.stm.Properties.Description='Maximum stresses';

%% Nominal Stresses
sk=8;
Element=zeros(2*ne,1);
Node=zeros(2*ne,1);
S11=zeros(2*ne,1);
S12=zeros(2*ne,1);
MaxPrin=zeros(2*ne,1);
MinPrin=zeros(2*ne,1);
Von_Mises=zeros(2*ne,1);
Guest_Tresca=zeros(2*ne,1);
I1=zeros(2*ne,1);
I3=zeros(2*ne,1);
for i=1:2*ne
    el=floor((i+1)/2);
    Element(i)=el;
    if floor(i/2)*2~=i
        Node(i)=index(el,2);
        S11(i)=SSn(el,1);
        S12(i)=SSn(el,2);
        MaxPrin(i)=SSn(el,3);
        MinPrin(i)=SSn(el,4);
        Von_Mises(i)=SSn(el,5);
        Guest_Tresca(i)=SSn(el,6);
        I1(i)=SSn(el,7);
        I3(i)=SSn(el,8);
    else
        Node(i)=index(el,3);
        S11(i)=SSn(el,1+sk);
        S12(i)=SSn(el,2+sk);
        MaxPrin(i)=SSn(el,3+sk);
        MinPrin(i)=SSn(el,4+sk);
        Von_Mises(i)=SSn(el,5+sk);
        Guest_Tresca(i)=SSn(el,6+sk);
        I1(i)=SSn(el,7+sk);
        I3(i)=SSn(el,8+sk);
    end
end
TAB.stn=table(Element,Node,S11,S12,MaxPrin,MinPrin,Von_Mises,Guest_Tresca,I1,I3);
units={'','','[fu]/[lu]^2','[fu]/[lu]^2','[fu]/[lu]^2','[fu]/[lu]^2',...
    '[fu]/[lu]^2','[fu]/[lu]^2','[fu]/[lu]^2','[fu]^2/[lu]^4'};
TAB.stn.Properties.VariableUnits=units;
TAB.stn.Properties.Description='Nominal stresses';

%% Maximum Strains
sk=6;
Element=zeros(2*ne,1);
Node=zeros(2*ne,1);
E11=zeros(2*ne,1);
E12=zeros(2*ne,1);
MaxPrin=zeros(2*ne,1);
MinPrin=zeros(2*ne,1);
I1=zeros(2*ne,1);
I3=zeros(2*ne,1);
for i=1:2*ne
    el=floor((i+1)/2);
    Element(i)=el;
    if floor(i/2)*2~=i
        Node(i)=index(el,2);
        E11(i)=EE(el,1);
        E12(i)=EE(el,2);
        MaxPrin(i)=EE(el,3);
        MinPrin(i)=EE(el,4);
        I1(i)=EE(el,5);
        I3(i)=EE(el,6);
    else
        Node(i)=index(el,3);
        E11(i)=EE(el,1+sk);
        E12(i)=EE(el,2+sk);
        MaxPrin(i)=EE(el,3+sk);
        MinPrin(i)=EE(el,4+sk);
        I1(i)=EE(el,5+sk);
        I3(i)=EE(el,6+sk);
    end
end
TAB.etm=table(Element,Node,E11,E12,MaxPrin,MinPrin,I1,I3);
units={'','','[lu]/[lu]','[lu]/[lu]','[lu]/[lu]','[lu]/[lu]',...
    '[lu]/[lu]','[lu]^2/[lu]^2'};
TAB.etm.Properties.VariableUnits=units;
TAB.etm.Properties.Description='Maximum strains';

%% Nominal Strains
sk=4;
Element=zeros(2*ne,1);
Node=zeros(2*ne,1);
E11=zeros(2*ne,1);
E12=zeros(2*ne,1);
MaxPrin=zeros(2*ne,1);
MinPrin=zeros(2*ne,1);
I1=zeros(2*ne,1);
I3=zeros(2*ne,1);
for i=1:2*ne
    el=floor((i+1)/2);
    Element(i)=el;
    if floor(i/2)*2~=i
        Node(i)=index(el,2);
        E11(i)=EEn(el,1);
        E12(i)=EEn(el,2);
        MaxPrin(i)=EEn(el,3);
        MinPrin(i)=EEn(el,4);
        I1(i)=EEn(el,5);
        I3(i)=EEn(el,6);
    else
        Node(i)=index(el,3);
        E11(i)=EEn(el,1+sk);
        E12(i)=EEn(el,2+sk);
        MaxPrin(i)=EEn(el,3+sk);
        MinPrin(i)=EEn(el,4+sk);
        I1(i)=EEn(el,5+sk);
        I3(i)=EEn(el,6+sk);
    end
end
TAB.etn=table(Element,Node,E11,E12,MaxPrin,MinPrin,I1,I3);
units={'','','[lu]/[lu]','[lu]/[lu]','[lu]/[lu]','[lu]/[lu]',...
    '[lu]/[lu]','[lu]^2/[lu]^2'};
TAB.etn.Properties.VariableUnits=units;
TAB.etn.Properties.Description='Nominal strains';

%% Fatigue
if filetype==2
    sk=4;
    Element=zeros(2*ne,1);
    Node=zeros(2*ne,1);
    Gough_Pollard=zeros(2*ne,1);
    Sines=zeros(2*ne,1);
    S_endurance=zeros(2*ne,1);
    Nlim=zeros(2*ne,1);
    for i=1:2*ne
        el=floor((i+1)/2);
        Element(i)=el;
        if floor(i/2)*2~=i
            Node(i)=index(el,2);
            Gough_Pollard(i)=FF(el,1);
            Sines(i)=FF(el,2);
            S_endurance(i)=FF(el,3);
            Nlim(i)=FF(el,4);
        else
            Node(i)=index(el,3);
            Gough_Pollard(i)=FF(el,1+sk);
            Sines(i)=FF(el,2+sk);
            S_endurance(i)=FF(el,3+sk);
            Nlim(i)=FF(el,4+sk);
        end
    end
    TAB.fat=table(Element,Node,Gough_Pollard,Sines,S_endurance,Nlim);
    units={'','','[fu]/[lu]^2','[fu]/[lu]^2','[fu]/[lu]^2','[cycles]'};
    TAB.fat.Properties.VariableUnits=units;
    TAB.fat.Properties.Description='Fatigue parameters';
end

%% Safety Factors
if filetype==1
    Element=zeros(2*ne,1);
    Node=zeros(2*ne,1);
    VM_1stYield=zeros(2*ne,1);
    GT_1stYield=zeros(2*ne,1);
    VM_Failure=zeros(2*ne,1);
    GT_Failure=zeros(2*ne,1);
    Galileo_Rankine=zeros(2*ne,1);
    for i=1:2*ne
        el=floor((i+1)/2);
        Element(i)=el;
        if floor(i/2)*2~=i
            Node(i)=index(el,2);
            VM_1stYield(i)=eta(el,1);
            GT_1stYield(i)=eta(el,2);
            VM_Failure(i)=eta(el,3);
            GT_Failure(i)=eta(el,4);
            Galileo_Rankine(i)=eta(el,5);
        else
            Node(i)=index(el,3);
            VM_1stYield(i)=eta(el,1+sk);
            GT_1stYield(i)=eta(el,2+sk);
            VM_Failure(i)=eta(el,3+sk);
            GT_Failure(i)=eta(el,4+sk);
            Galileo_Rankine(i)=eta(el,5+sk);
        end
    end
    TAB.eta=table(Element,Node,VM_1stYield,GT_1stYield,VM_Failure,GT_Failure,Galileo_Rankine);
else
    Element=zeros(2*ne,1);
    Node=zeros(2*ne,1);
    VM_1stYield=zeros(2*ne,1);
    GT_1stYield=zeros(2*ne,1);
    VM_Failure=zeros(2*ne,1);
    GT_Failure=zeros(2*ne,1);
    Galileo_Rankine=zeros(2*ne,1);
    Gough_Pollard=zeros(2*ne,1);
    Sines=zeros(2*ne,1);
    for i=1:2*ne
        el=floor((i+1)/2);
        Element(i)=el;
        if floor(i/2)*2~=i
            Node(i)=index(el,2);
            VM_1stYield(i)=eta(el,1);
            GT_1stYield(i)=eta(el,2);
            VM_Failure(i)=eta(el,3);
            GT_Failure(i)=eta(el,4);
            Galileo_Rankine(i)=eta(el,5);
            Gough_Pollard(i)=eta(el,6);
            Sines(i)=eta(el,7);
        else
            Node(i)=index(el,3);
            VM_1stYield(i)=eta(el,1+sk);
            GT_1stYield(i)=eta(el,2+sk);
            VM_Failure(i)=eta(el,3+sk);
            GT_Failure(i)=eta(el,4+sk);
            Galileo_Rankine(i)=eta(el,5+sk);
            Gough_Pollard(i)=eta(el,6+sk);
            Sines(i)=eta(el,7+sk);
        end
    end
    TAB.eta=table(Element,Node,VM_1stYield,GT_1stYield,VM_Failure,GT_Failure,Galileo_Rankine,Gough_Pollard,Sines);
end
TAB.eta.Properties.Description='Safety factors';