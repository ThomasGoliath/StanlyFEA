function [H,B,T,cm,n] = newraphL(Area,I2,I3,W2,W3,toll)
x=[42;8];
n=0;
syms b c
F=[((c*(b + c)^2)/2 + (c^2*(Area/c - (c*(b + c))/c))/2)/Area - c - b + I3/W3
    I2/W2 - c - Area/c + ((b*c^2)/2 + (c*(c + Area/c - (c*(b + c))/c)^2)/2)/Area + (c*(b + c))/c];
J=[diff(F,1,b) diff(F,1,c)];
x0=x+2*toll;
while abs(x-x0)>toll
    x0=x;
    b=x0(1); c=x0(2);
    n=n+1;
    x=x0-eval(J)\eval(F);
end
B=x(1)+x(2);
T=x(2);
H=(Area-B*T)/T;
cm=[(H*T^2+B^2*T)/2/Area; (H*T*(H+T)+T^2*B)/2/Area];

