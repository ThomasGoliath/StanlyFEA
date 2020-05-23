function [E,Enom]=strains(S,Snom)
global material ne index
E=zeros(ne,12);
Enom=zeros(ne,12);
for i=1:ne
    Y=material(index(i,5),2);
    v=material(index(i,5),3);
    G=Y/2/(1+v);
    
    % maximum
    E(i,[1 7])=S(i,[1 9])/Y;
    E(i,[2 8])=S(i,[2 10])/G/2;
    ten1=[E(i,1) E(i,2) 0; E(i,2) -v*E(i,1) 0; 0 0 -v*E(i,1)];
    ten2=[E(i,7) E(i,8) 0; E(i,8) -v*E(i,7) 0; 0 0 -v*E(i,7)];
    E(i,[3 9])=[max(eig(ten1)) max(eig(ten2))];
    E(i,[4 10])=[min(eig(ten1)) min(eig(ten2))];
    E(i,[5 11])=[trace(ten1) trace(ten2)];
    E(i,[6 12])=[det(ten1) det(ten2)];
    
    if nargin==2&&nargout==2
        % nominal
        Enom(i,[1 7])=Snom(i,[1 9])/Y;
        Enom(i,[2 8])=Snom(i,[2 10])/G/2;
        ten1=[Enom(i,1) Enom(i,2) 0; Enom(i,2) -v*Enom(i,1) 0; 0 0 -v*Enom(i,1)];
        ten2=[Enom(i,7) Enom(i,8) 0; Enom(i,8) -v*Enom(i,7) 0; 0 0 -v*Enom(i,7)];
        Enom(i,[3 9])=[max(eig(ten1)) max(eig(ten2))];
        Enom(i,[4 10])=[min(eig(ten1)) min(eig(ten2))];
        Enom(i,[5 11])=[trace(ten1) trace(ten2)];
        Enom(i,[6 12])=[det(ten1) det(ten2)];
    end
end
