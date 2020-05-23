function [H,B,T1,T2,cm,n] = newraphL(Area,I2,I3,W2,W3,toll)
x=[42;8;6];
n=0;
%% Symbolic non supportato in runtime
% syms b c d
% F=[((d*(b + c)^2)/2 + (c^2*(Area/c - (d*(b + c))/c))/2)/Area - c - b + I3/W3
%     I2/W2 - d - Area/c + ((b*d^2)/2 + (c*(d + Area/c - (d*(b + c))/c)^2)/2)/Area + (d*(b + c))/c
%     b*(I2/W2 - Area/c + (d*(b + c))/c)^3 - 3*I2 + (I2^3*c)/W2^3 + ((b + c)*((b*d^2)/2 + (c*(d + Area/c - (d*(b + c))/c)^2)/2)^3)/Area^3];
% J=[diff(F,1,b) diff(F,1,c) diff(F,1,d)];

x0=x+2*toll;
while abs(x-x0)>toll
    x0=x;
    b=x0(1); c=x0(2); d=x0(3);
    n=n+1;
    
    F=[((d*(b + c)^2)/2 + (c^2*(Area/c - (d*(b + c))/c))/2)/Area - c - b + I3/W3
    I2/W2 - d - Area/c + ((b*d^2)/2 + (c*(d + Area/c - (d*(b + c))/c)^2)/2)/Area + (d*(b + c))/c
    b*(I2/W2 - Area/c + (d*(b + c))/c)^3 - 3*I2 + (I2^3*c)/W2^3 + ((b + c)*((b*d^2)/2 + (c*(d + Area/c - (d*(b + c))/c)^2)/2)^3)/Area^3];
    
    % Jacobiano calcolato offline con syms
    J=[                                                                                                                                                                                                                           - ((c*d)/2 - (d*(2*b + 2*c))/2)/Area - 1,                                                                                                                                                                                                                               (c*(Area/c - (d*(b + c))/c) - (c^2*(Area/c^2 + d/c - (d*(b + c))/c^2))/2 + (d*(2*b + 2*c))/2)/Area - 1,                                                                                                                                                  ((b + c)^2/2 - (c*(b + c))/2)/Area
                                                                                                                                                                                                                d/c - (d*(d + Area/c - (d*(b + c))/c) - d^2/2)/Area,                                                                                                                                                                                       Area/c^2 + ((d + Area/c - (d*(b + c))/c)^2/2 - c*(d + Area/c - (d*(b + c))/c)*(Area/c^2 + d/c - (d*(b + c))/c^2))/Area + d/c - (d*(b + c))/c^2,                                                                                                         (b + c)/c + (b*d - c*((b + c)/c - 1)*(d + Area/c - (d*(b + c))/c))/Area - 1
 (I2/W2 - Area/c + (d*(b + c))/c)^3 + ((b*d^2)/2 + (c*(d + Area/c - (d*(b + c))/c)^2)/2)^3/Area^3 + (3*b*d*(I2/W2 - Area/c + (d*(b + c))/c)^2)/c - (3*(d*(d + Area/c - (d*(b + c))/c) - d^2/2)*(b + c)*((b*d^2)/2 + (c*(d + Area/c - (d*(b + c))/c)^2)/2)^2)/Area^3, ((b*d^2)/2 + (c*(d + Area/c - (d*(b + c))/c)^2)/2)^3/Area^3 + I2^3/W2^3 + 3*b*(I2/W2 - Area/c + (d*(b + c))/c)^2*(Area/c^2 + d/c - (d*(b + c))/c^2) + (3*(b + c)*((d + Area/c - (d*(b + c))/c)^2/2 - c*(d + Area/c - (d*(b + c))/c)*(Area/c^2 + d/c - (d*(b + c))/c^2))*((b*d^2)/2 + (c*(d + Area/c - (d*(b + c))/c)^2)/2)^2)/Area^3, (3*(b + c)*(b*d - c*((b + c)/c - 1)*(d + Area/c - (d*(b + c))/c))*((b*d^2)/2 + (c*(d + Area/c - (d*(b + c))/c)^2)/2)^2)/Area^3 + (3*b*(b + c)*(I2/W2 - Area/c + (d*(b + c))/c)^2)/c];

    %x=x0-eval(J)\eval(F);
    x=x0-J\F;
end
B=x(1)+x(2);
T1=x(2);
T2=x(3);
H=(Area-B*T2)/T1;
cm=[(H*T2^2+B^2*T1)/2/Area; (H*T2*(H+T1)+T1^2*B)/2/Area];

