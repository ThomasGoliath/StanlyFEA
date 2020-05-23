function [S,Snom]=stresses(ia)
global sections ne index notch filetype
S=zeros(ne,16);
Snom=zeros(ne,16);
for i=1:ne
    A=sections(index(i,4),2);
    Jy=sections(index(i,4),3);
    Jz=sections(index(i,4),4);
    Wy=sections(index(i,4),5);
    Wz=sections(index(i,4),6);
    if filetype==1
        Kta=notch(index(i,2:3),2).';
        Ktb=notch(index(i,2:3),3).';
        Ktt=notch(index(i,2:3),4).';
    elseif filetype==2
        Kta=ones(1,2);
        Ktb=ones(1,2);
        Ktt=ones(1,2);
    end
    h=[Jy/Wy Jz/Wz]; Wp=(Jy+Jz)/max(h);
    
    % maximum
    p=sign(ia(i,[1 7]));
    if p(1)==0, p(1)=1; end
    if p(2)==0, p(2)=1; end
    S(i,[1 9])=p.*abs(Kta.*ia(i,[1 7])/A+Ktb.*sqrt((ia(i,[5 11])/Wy).^2+(ia(i,[6 12])/Wz).^2));
    S(i,[2 10])=Ktt.*abs(ia(i,[4 10])/Wp);
    ten1=[S(i,1) S(i,2); S(i,2) 0];
    ten2=[S(i,9) S(i,10); S(i,10) 0];
    S(i,[3 11])=[max(eig(ten1)) max(eig(ten2))];
    S(i,[4 12])=[min(eig(ten1)) min(eig(ten2))];
    S(i,[5 13])=[sqrt(S(i,1)^2+3*S(i,2)^2) sqrt(S(i,9)^2+3*S(i,10)^2)];
    S(i,[6 14])=[sqrt(S(i,1)^2+4*S(i,2)^2) sqrt(S(i,9)^2+4*S(i,10)^2)];
    S(i,[7 15])=[trace(ten1) trace(ten2)];
    S(i,[8 16])=[det(ten1) det(ten2)];
    
    if nargout==2
        % nominal
        Snom(i,[1 9])=p.*abs(ia(i,[1 7])/A+sqrt((ia(i,[5 11])/Wy).^2+(ia(i,[6 12])/Wz).^2));
        Snom(i,[2 10])=abs(ia(i,[4 10])/Wp);
        ten1=[Snom(i,1) Snom(i,2); Snom(i,2) 0];
        ten2=[Snom(i,9) Snom(i,10); Snom(i,10) 0];
        Snom(i,[3 11])=[max(eig(ten1)) max(eig(ten2))];
        Snom(i,[4 12])=[min(eig(ten1)) min(eig(ten2))];
        Snom(i,[5 13])=[sqrt(Snom(i,1)^2+3*Snom(i,2)^2) sqrt(Snom(i,9)^2+3*Snom(i,10)^2)];
        Snom(i,[6 14])=[sqrt(Snom(i,1)^2+4*Snom(i,2)^2) sqrt(Snom(i,9)^2+4*Snom(i,10)^2)];
        Snom(i,[7 15])=[trace(ten1) trace(ten2)];
        Snom(i,[8 16])=[det(ten1) det(ten2)];
    end
end

