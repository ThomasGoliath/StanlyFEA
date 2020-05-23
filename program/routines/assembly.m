function [M,K,F,Mj,Kj]=assembly
global index axx
global dtab Kcorr
global L ang Ftab
global material
global sections
global nn ne ndof
global Li Ri springs

% K matrix assembly
status_info('assembly\Stiffness and mass matrix assembly')
K=zeros(max(max(dtab)));
Kj=zeros(12,12,ne);
M=zeros(max(max(dtab)));
Mj=zeros(12,12,ne);
for i=1:ne
    E=material(index(i,5),2);
    v=material(index(i,5),3);
    m=material(index(i,5),5);
    A=sections(index(i,5),2);
    J2=sections(index(i,4),3);
    J1=sections(index(i,4),4);
    timo1=sections(index(i,4),7);
    timo2=sections(index(i,4),8);
    k=index(i,2:3);
    j=[dtab(k(1),:) dtab(k(2),:)];
    R=Li(:,:,i);
    K(j,j)=K(j,j)+R.'*stiff_i(E,v,A,J1,J2,L(i),timo1,timo2)*R;
    Kj(:,:,i)=R.'*stiff_i(E,v,A,J1,J2,L(i),timo1,timo2)*R;
    M(j,j)=M(j,j)+R.'*mass_i(m,A,J1,J2,L(i))*R;
    Mj(:,:,i)=R.'*mass_i(m,A,J1,J2,L(i))*R;
end

% F vector assembly
status_info('assembly\Load vector assembly')
F=zeros(max(max(dtab)),1);
for i=1:size(Ftab,1)
    k=dtab(Ftab(i,1),:);
    F(k)=F(k)+Ftab(i,2:7).';
end

% elastic constraints correction
if ~isempty(Kcorr)
    status_info('assembly\Elastic constraints correction')
    for i=1:size(Kcorr,1)
        j=dtab(Kcorr(i,1),Kcorr(i,2));
        K(j,j)=K(j,j)+Kcorr(i,3);
    end
end

% internal elastic constraints correction
if ~isempty(axx)
    status_info('assembly\Internal elastic constraints correction')
    for i=1:size(axx,1)
        for j=3:8
            if axx(i,j)<Inf
                kstf=[1 -1;-1 1]*axx(i,j); 
                z=[dtab(axx(i,1),j-2) dtab(axx(i,2),j-2)];
                K(z,z)=K(z,z)+kstf;
            end
        end
    end
end

% spring element correction
if ~isempty(springs)
    status_info('assembly\Spring element correction')
    for i=1:size(springs,1)
        Ry=rotmat(-springs(i,6)+pi/2,2);
        Rz=rotmat(-springs(i,5),3);
        R=Ry*Rz;
        R=[R zeros(3,9); zeros(3) R zeros(3,6)
            zeros(3,6) R zeros(3);zeros(3,9) R];
        Ks=stiff_i(springs(i,4),.3,1,0,0,1,0,0);
        Ks=R.'*Ks*R;
        j=[dtab(springs(i,2),:) dtab(springs(i,3),:)];
        K(j,j)=K(j,j)+Ks;
    end
end