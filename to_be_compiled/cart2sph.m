function S = cart2sph(C)
%SPH2CART convert cartesian coordinates in spherical
x=C(1); y=C(2); z=C(3);
r=sqrt(x^2+y^2+z^2);
if r==0
    p=pi/2;
else
    p=acos(z/r);
end
if x==0&&y>0, t=pi/2;
elseif x==0&&y<0, t=3*pi/2;
elseif x==0&&y==0, t=0;
else, t=atan2(y,x);
end
S=[r;t;p];
end

