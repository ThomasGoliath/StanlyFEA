function [H,B,T1,T2,cm,n] = newraphL(Area,I2,I3,W2,W3,toll)
x=[42;8;6];
n=0;
syms b c d
d
F=[((d*(b + c)^2)/2 + (c^2*(Area/c - (d*(b + c))/c))/2)/Area - c - b + I3/W3
    I2/W2 - d - Area/c + ((b*d^2)/2 + (c*(d + Area/c - (d*(b + c))/c)^2)/2)/Area + (d*(b + c))/c
    b*(I2/W2 - Area/c + (d*(b + c))/c)^3 - 3*I2 + (I2^3*c)/W2^3 + ((b + c)*((b*d^2)/2 + (c*(d + Area/c - (d*(b + c))/c)^2)/2)^3)/Area^3];
J=[diff(F,1,b) diff(F,1,c) diff(F,1,d)];
x0=x+2*toll;
while abs(x-x0)>toll
    x0=x;
    b=x0(1); c=x0(2); d=x0(3);
    n=n+1;
    x=x0-eval(J)\eval(F);
end
B=x(1)+x(2);
T1=x(2);
T2=x(3);
H=(Area-B*T2)/T1;
cm=[(H*T2^2+B^2*T1)/2/Area; (H*T2*(H+T1)+T1^2*B)/2/Area];

