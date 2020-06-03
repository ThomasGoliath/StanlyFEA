function Deform=ShapeF(xx,res,scala)

% global variables
global Li Ri d_sca
global Mesh
global Constraints

Deform.uvwtab=xx(Constraints.Dtab);
Deform.maxd=zeros(1,13);

% DEFMAT is a cell matrix of double matrices containings the global
% coordinates of each deformed element SCALED

% UVWTAB double matrix of displacements in global coordinates of the
% user-defined nodes NOT SCALED

% MAXD maximum total arrow displacement of the structure NOT SCALED

Emat=zeros(Mesh.Numbers.Elements,12);
for i=1:Mesh.Numbers.Elements
    Emat(i,:)=[Deform.uvwtab(Mesh.Element(i).Index(2),:) Deform.uvwtab(Mesh.Element(i).Index(3),:)]*Li(:,:,i).';
end
Emat(:,[5 11])=-Emat(:,[5 11]);
Deform.defmat=cell(Mesh.Numbers.Elements,1);
if nargin==2
    scala=0;
elseif nargin==1
    scala=0;
    res=0;
end
if scala==0
    scala=sqrt(sum((max(Mesh.Nodes.Tab(:,2:4))-min(Mesh.Nodes.Tab(:,2:4))).^2))/norm(xx,Inf)/5;
    if scala==Inf, scala=1; end
end
if res==0
    res=2e-2*d_sca;
end
for i=1:Mesh.Numbers.Elements
    pN=floor(Mesh.Element(i).Length/res)+1; if pN<2, pN=2; end
    ll=linspace(0,Mesh.Element(i).Length,pN);
    A=zeros(pN,3); F=zeros(pN,3);
    A(:,1)=interp1([0 Mesh.Element(i).Length],Emat(i,[1 7]),ll);
    A(:,2)=spline([0 Mesh.Element(i).Length],Emat(i,[6 2 8 12]),ll);
    A(:,3)=spline([0 Mesh.Element(i).Length],Emat(i,[5 3 9 11]),ll);
    F(:,1)=interp1([0 Mesh.Element(i).Length],Emat(i,[4 10]),ll);
    pp2=spline([0 Mesh.Element(i).Length],Emat(i,[6 2 8 12]));
    pp3=spline([0 Mesh.Element(i).Length],Emat(i,[5 3 9 11]));
    pp2.coefs=[pp2.coefs(1)*3  pp2.coefs(2)*2 pp2.coefs(3)]; pp2.order=pp2.order-1;
    pp3.coefs=[pp3.coefs(1)*3  pp3.coefs(2)*2 pp3.coefs(3)]; pp3.order=pp3.order-1;
    F(:,2)=ppval(pp3,ll);
    F(:,3)=ppval(pp2,ll);
    R=F*Ri(:,:,i);
    D=A*Ri(:,:,i);
    C=sqrt(sum(A.^2,2)); A=[A C D A R F]; 
    Deform.defmat(i)={A};
    if max(C)>maxd(1), maxd(1)=max(C); end
    if max(abs(D(:,1)))>maxd(2), maxd(2)=max(abs(D(:,1))); end
    if max(abs(D(:,2)))>maxd(3), maxd(3)=max(abs(D(:,2))); end
    if max(abs(D(:,3)))>maxd(4), maxd(4)=max(abs(D(:,3))); end
    if max(abs(A(:,1)))>maxd(5), maxd(5)=max(abs(A(:,1))); end
    if max(abs(A(:,2)))>maxd(6), maxd(6)=max(abs(A(:,2))); end
    if max(abs(A(:,3)))>maxd(7), maxd(7)=max(abs(A(:,3))); end
    if max(abs(R(:,1)))>maxd(8), maxd(8)=max(abs(R(:,1))); end
    if max(abs(R(:,2)))>maxd(9), maxd(9)=max(abs(R(:,2))); end
    if max(abs(R(:,3)))>maxd(10), maxd(10)=max(abs(R(:,3))); end
    if max(abs(F(:,1)))>maxd(11), maxd(11)=max(abs(F(:,1))); end
    if max(abs(F(:,2)))>maxd(12), maxd(12)=max(abs(F(:,2))); end
    if max(abs(F(:,3)))>maxd(13), maxd(13)=max(abs(F(:,3))); end
end
for i=1:13
    if Deform.maxd(i)==0, Deform.maxd(i)=1; end
end
scala=scala/Deform.maxd(1);
for i=1:Mesh.Numbers.Elements  
    pN=floor(Mesh.Element(i).Length/res)+1;
    if pN<2
        pN=2;
    end
    ll=linspace(0,Mesh.Element(i).Length,pN);
    A=cell2mat(Deform.defmat(i));
    A(:,1:3)=A(:,1:3)*scala;
    A(:,1)=A(:,1)+ll.';
    A(:,1:3)=Mesh.Nodes.Tab(Mesh.Element(i).Index(2),2:4)+A(:,1:3)*Ri(:,:,i);
    A=[A; flipud(A)];
    Deform.defmat(i)={A};
end