function [M,K,F,Mj,Kj]=Assembly
global Constraints
global Properties
global Mesh
global Loads

% K matrix assembly
LogMsg('[Assembly] Stiffness and mass matrix assembly')
K=zeros(max(max(Constraints.Dtab)));
Kj=zeros(12,12,Mesh.Numbers.Elements);
M=zeros(max(max(Constraints.Dtab)));
Mj=zeros(12,12,Mesh.Numbers.Elements);
for i=1:Mesh.Numbers.Elements
    E=Properties.Materials(Mesh.Element(i).Index(5),2);
    v=Properties.Materials(Mesh.Element(i).Index(5),3);
    m=Properties.Materials(Mesh.Element(i).Index(5),5);
    A=Properties.Sections(Mesh.Element(i).Index(5),2);
    J2=Properties.Sections(Mesh.Element(i).Index(4),3);
    J1=Properties.Sections(Mesh.Element(i).Index(4),4);
    timo1=Properties.Sections(Mesh.Element(i).Index(4),7);
    timo2=Properties.Sections(Mesh.Element(i).Index(4),8);
    k=Mesh.Element(i).Index(2:3);
    j=[Constraints.Dtab(k(1),:) Constraints.Dtab(k(2),:)];
    R=Mesh.Element(i).Loc2Glob;
    K(j,j)=K(j,j)+R.'*stiff_i(E,v,A,J1,J2,Mesh.Element(i).Length,timo1,timo2)*R;
    Kj(:,:,i)=R.'*stiff_i(E,v,A,J1,J2,Mesh.Element(i).Length,timo1,timo2)*R;
    M(j,j)=M(j,j)+R.'*mass_i(m,A,J1,J2,Mesh.Element(i).Length)*R;
    Mj(:,:,i)=R.'*mass_i(m,A,J1,J2,Mesh.Element(i).Length)*R;
end

% F vector assembly
LogMsg('[Assembly] Load vector assembly')
F=zeros(max(max(Constraints.Dtab)),1);
for i=1:size(Loads.Nodal,1)
    k=Constraints.Dtab(Loads.Nodal(i,1),:);
    F(k)=F(k)+Loads.Nodal(i,2:7).';
end

% elastic constraints correction
if ~isempty(Constraints.Kcorr)
    LogMsg('[Assembly] Elastic constraints correction')
    for i=1:size(Constraints.Kcorr,1)
        j=Constraints.Dtab(Constraints.Kcorr(i,1),Constraints.Kcorr(i,2));
        K(j,j)=Solver.K(j,j)+Constraints.Kcorr(i,3);
    end
end

% internal elastic constraints correction
if ~isempty(Mesh.Nodes.Ensl)
    LogMsg('[Assembly] Internal elastic constraints correction')
    for i=1:size(Mesh.Nodes.Ensl,1)
        for j=3:8
            if Mesh.Nodes.Ensl(i,j)<Inf
                kstf=[1 -1;-1 1]*Mesh.Nodes.Ensl(i,j); 
                z=[Constraints.Dtab(Mesh.Nodes.Ensl(i,1),j-2) Constraints.Dtab(Mesh.Nodes.Ensl(i,2),j-2)];
                K(z,z)=Solver.K(z,z)+kstf;
            end
        end
    end
end

% spring element correction
if ~isempty(Mesh.Springs.Tab)
    LogMsg('[Assembly] Spring element correction')
    for i=1:size(Mesh.Springs.Tab,1)
        Ry=rotmat(-Mesh.Springs.Tab(i,6)+pi/2,2);
        Rz=rotmat(-Mesh.Springs.Tab(i,5),3);
        R=Ry*Rz;
        R=[R zeros(3,9); zeros(3) R zeros(3,6)
            zeros(3,6) R zeros(3);zeros(3,9) R];
        Ks=stiff_i(Mesh.Springs.Tab(i,4),.3,1,0,0,1,0,0);
        Ks=R.'*Ks*R;
        j=[Constraints.Dtab(Mesh.Springs.Tab(i,2),:) Constraints.Dtab(Mesh.Springs.Tab(i,3),:)];
        K(j,j)=K(j,j)+Ks;
    end
end