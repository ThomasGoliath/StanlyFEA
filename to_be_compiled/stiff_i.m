function K=stiff_i(E,v,A,J1,J2,L,k1,k2)
G=E/2/(1+v);
Jp=J1+J2;
EA=E*A;
EJ1=E*J1;
EJ2=E*J2;
GJ=G*Jp;
% Timoshenko correction
f1=12*k1*E/G*J1/A/L^2;
f2=12*k2*E/G*J1/A/L^2;
%
axK=[EA/L -EA/L; -EA/L EA/L];
toK=[GJ/L -GJ/L; -GJ/L GJ/L];
b1K=[12/L^3     6/L^2       -12/L^3     6/L^2
     6/L^2      (4+f1)/L    -6/L^2      (2-f1)/L
    -12/L^3     -6/L^2      12/L^3      -6/L^2
     6/L^2      (2-f1)/L    -6/L^2      (4+f1)/L];
b1K=b1K.*EJ1/(1+f1);
b2K=[12/L^3     -6/L^2      -12/L^3     -6/L^2
    -6/L^2      (4+f2)/L    6/L^2       (2-f2)/L
    -12/L^3     6/L^2       12/L^3      6/L^2
    -6/L^2      (2-f2)/L    6/L^2       (4+f2)/L];
b2K=b2K.*EJ2/(1+f2);
K=zeros(12);
K([1 7],[1 7])=axK;
K([4 10],[4 10])=toK;
K([2 6 8 12],[2 6 8 12])=b1K;
K([3 5 9 11],[3 5 9 11])=b2K;
end