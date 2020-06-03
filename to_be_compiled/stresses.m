function Stress=Stresses(ia)
global Properties
global Mesh
global FileManager

Stress.Max=zeros(Mesh.Numbers.Elements,16);
Stress.Nom=zeros(Mesh.Numbers.Elements,16);
for i=1:Mesh.Numbers.Elements
    A=Properties.Sections(Mesh.Elements(i).Index(4),2);
    Jy=Properties.Sections(Mesh.Elements(i).Index(4),3);
    Jz=Properties.Sections(Mesh.Elements(i).Index(4),4);
    Wy=Properties.Sections(Mesh.Elements(i).Index(4),5);
    Wz=Properties.Sections(Mesh.Elements(i).Index(4),6);
    if FileManager.CurrentFile.FileType==1
        Kta=Properties.Notches(Mesh.Elements(i).Index(2:3),2).';
        Ktb=Properties.Notches(Mesh.Elements(i).Index(2:3),3).';
        Ktt=Properties.Notches(Mesh.Elements(i).Index(2:3),4).';
    elseif FileManager.CurrentFile.FileType==2
        Kta=ones(1,2);
        Ktb=ones(1,2);
        Ktt=ones(1,2);
    end
    h=[Jy/Wy Jz/Wz]; Wp=(Jy+Jz)/max(h);
    
    % maximum
    p=sign(ia(i,[1 7]));
    if p(1)==0, p(1)=1; end
    if p(2)==0, p(2)=1; end
    Stress.Max(i,[1 9])=p.*abs(Kta.*ia(i,[1 7])/A+Ktb.*sqrt((ia(i,[5 11])/Wy).^2+(ia(i,[6 12])/Wz).^2));
    Stress.Max(i,[2 10])=Ktt.*abs(ia(i,[4 10])/Wp);
    ten1=[Stress.Max(i,1) Stress.Max(i,2); Stress.Max(i,2) 0];
    ten2=[Stress.Max(i,9) Stress.Max(i,10); Stress.Max(i,10) 0];
    Stress.Max(i,[3 11])=[max(eig(ten1)) max(eig(ten2))];
    Stress.Max(i,[4 12])=[min(eig(ten1)) min(eig(ten2))];
    Stress.Max(i,[5 13])=[sqrt(Stress.Max(i,1)^2+3*Stress.Max(i,2)^2) sqrt(Stress.Max(i,9)^2+3*Stress.Max(i,10)^2)];
    Stress.Max(i,[6 14])=[sqrt(Stress.Max(i,1)^2+4*Stress.Max(i,2)^2) sqrt(Stress.Max(i,9)^2+4*Stress.Max(i,10)^2)];
    Stress.Max(i,[7 15])=[trace(ten1) trace(ten2)];
    Stress.Max(i,[8 16])=[det(ten1) det(ten2)];
    
    if nargout==2
        % nominal
        Stress.Nom(i,[1 9])=p.*abs(ia(i,[1 7])/A+sqrt((ia(i,[5 11])/Wy).^2+(ia(i,[6 12])/Wz).^2));
        Stress.Nom(i,[2 10])=abs(ia(i,[4 10])/Wp);
        ten1=[Stress.Nom(i,1) Stress.Nom(i,2); Stress.Nom(i,2) 0];
        ten2=[Stress.Nom(i,9) Stress.Nom(i,10); Stress.Nom(i,10) 0];
        Stress.Nom(i,[3 11])=[max(eig(ten1)) max(eig(ten2))];
        Stress.Nom(i,[4 12])=[min(eig(ten1)) min(eig(ten2))];
        Stress.Nom(i,[5 13])=[sqrt(Stress.Nom(i,1)^2+3*Stress.Nom(i,2)^2) sqrt(Stress.Nom(i,9)^2+3*Stress.Nom(i,10)^2)];
        Stress.Nom(i,[6 14])=[sqrt(Stress.Nom(i,1)^2+4*Stress.Nom(i,2)^2) sqrt(Stress.Nom(i,9)^2+4*Stress.Nom(i,10)^2)];
        Stress.Nom(i,[7 15])=[trace(ten1) trace(ten2)];
        Stress.Nom(i,[8 16])=[det(ten1) det(ten2)];
    end
end

