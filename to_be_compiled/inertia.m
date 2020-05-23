function [A,Jz,Wz,Jy,Wy]=inertia(siz,kin)
%% [A,Jz,Wz,Jy,Wy]=INERTIA(siz,kin)
% Computes all the properties of specific kind of cross section, related on
% the value of kin:
% kin='O'   circular                siz=[d]
% kin='R'   rectangular             siz=[h b]
% kin='Oh'  hollowed circular       siz=[de di]
% kin='Rh'  hollowed rectangular    siz=[he be hi bi]
% kin='I'   'I' beam profile        siz=[h a (web) e b (flanges)]
% kin='L'   'L' beam profile        siz=[h a (web) e b (flanges)]
% kin='T'   'T' beam profile        siz=[h a (web) e b (flange)]
% kin='C'   'C' beam profile        siz=[h a (web) e b (flanges)]

if nargin==1
    if length(siz)==1, kin='O';
    elseif length(siz)==2, kin='R';
    elseif length(siz)==4, kin='I';
    else, error('Wrong input format'),
    end
end

switch kin
    case 'O'
        if nargin==2&&length(siz)~=1, error('Wrong input format'), end
        A=pi*siz^2/4;
        Jz=pi*siz^4/64;
        Jy=Jz;     
        Wz=2*Jz/siz;
        Wy=2*Jy/siz;
    case 'R'
        if nargin==2&&length(siz)~=2, error('Wrong input format'), end
        A=siz(1)*siz(2);
        Jz=siz(1)^3*siz(2)/12;
        Jy=siz(1)*siz(2)^3/12;
        Wz=2*Jz/siz(1);
        Wy=2*Jy/siz(2);
    case 'Oh'
        if nargin==2&&length(siz)~=2, error('Wrong input format'), end
        A=pi*(siz(1)^2-siz(2)^2)/4;
        Jz=pi*(siz(1)^4-siz(2)^4)/64;
        Jy=Jz;
        Wz=2*Jz/siz(1);
        Wy=2*Jy/siz(1);
    case 'Rh'
        if nargin==2&&length(siz)~=4, error('Wrong input format'), end
        A=siz(1)*siz(2)-siz(3)*siz(4);
        Jz=siz(1)^3*siz(2)/12-siz(3)^3*siz(4)/12;
        Jy=siz(1)*siz(2)^3/12-siz(3)*siz(4)^3/12;
        Wz=2*Jz/siz(1);
        Wy=2*Jy/siz(2);
    case 'I'
        if nargin==2&&length(siz)~=4, error('Wrong input format'), end
        A=(siz(1)-2*siz(3))*siz(2)+2*siz(3)*siz(4);
        Jz=(siz(1)-2*siz(3))^3*siz(2)/12+2*siz(3)^3*siz(4)/12+2*siz(3)*siz(4)*siz(1)^2/4;
        Jy=(siz(1)-2*siz(3))*siz(2)^3/12+2*siz(3)*siz(4)^3/12;
        Wz=2*Jz/siz(1);
        Wy=2*Jy/siz(4);
    case 'L'
        if nargin==2&&length(siz)~=4, error('Wrong input format'), end
        A=(siz(1)-siz(3))*siz(2)+siz(3)*siz(4);
        Jz=(siz(1)-siz(3))^3*siz(2)/12+2*siz(3)^3*siz(4)/12+siz(3)*siz(4)*siz(1)^2/4;
        Jy=(siz(1)-2*siz(3))*siz(2)^3/12+2*siz(3)*siz(4)^3/12+siz(3)*siz(4)*siz(1)^2/4;
        Wz=2*Jz/siz(1);
        Wy=2*Jy/siz(4);
    otherwise
        error('Kind of sections are [O R Oh Rh I L T C]')
end