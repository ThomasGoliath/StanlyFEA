function F=thermal_corr(F)
global Ttab index ne dtab Li material sections ndof
Ttab=[Ttab zeros(size(Ttab,1),3)];
for i=1:size(Ttab,1)
    n_elem=Ttab(i,1);
    a=material(index(n_elem,5),4);
    E=material(index(n_elem,5),2);
    A=sections(index(n_elem,4),2);
    W1=sections(index(n_elem,4),5);
    W2=sections(index(n_elem,4),6);
    Hb=mean(Ttab(i,2:3))*a*E*A+mean(Ttab(i,4:5))*a*E*A;
    X1=-diff(Ttab(i,4:5))*a*E*W1/2;
    X2=-diff(Ttab(i,2:3))*a*E*W2/2;
    tl=Li(:,:,n_elem)*[-Hb 0 0 0 -X1 -X2 Hb 0 0 0 X1 X2].';
    j=[dtab(index(n_elem,2),:) dtab(index(n_elem,3),:)];
    F(j)=F(j)+tl;
    Ttab(i,6)=-Hb; Ttab(i,7)=-X1; Ttab(i,8)=-X2;
end
end