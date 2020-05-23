function [V,W,S]=Scalc(k,N,M1,M2,M3,A,Jp,J2,J3,v,w,r)

V=v;
W=w;
if nargin==11
    r=sqrt(v^2+w^2);
end
s11=N/A+M2/J2*w+M3/J3*v;
s12=abs(M1/Jp*r);
tens=[s11 s12; s12 0];
switch k
    case 1
        % normal stress
        S=s11;
    case 2
        % shear stress
        S=s12;
    case 3
        % maximum principal
        S=max(eig(tens));
    case 4
        % minimum principal
        S=min(eig(tens));
    case 5
        % Von Mises
        S=sqrt(s11^2+3*s12^2);
    case 6
        % Guest-Tresca
        S=sqrt(s11^2+4*s12^2);
    case 7
        % first invariant
        S=trace(tens);
    case 8
        % third invariant
        S=det(tens);
end

end

