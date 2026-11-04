function f = beamLoads(model, element, R, L, material, section)
%BEAMLOADS Consistent local nodal loads, including self weight and temperature.
e = element(1); f = zeros(12,1);
loads = model.Loads.Distributed(model.Loads.Distributed(:,1) == e,:);
if ~isempty(model.Loads.Gravity)
    % Gravity is acceleration; material column 5 is mass per unit volume.
    q = R*(model.Loads.Gravity(:)*material(5)*section(2));
    loads(end+1,:) = [e q(1) q(2) q(2) q(3) q(3) 0 0];
end
G = material(2)/(2*(1+material(3)));
phiV = 12*section(7)*material(2)*section(4)/(G*section(2)*L^2);
phiW = 12*section(8)*material(2)*section(3)/(G*section(2)*L^2);
points = ([-sqrt(3/5), 0, sqrt(3/5)]+1)/2;
weights = [5/9, 8/9, 5/9]/2;
for i = 1:size(loads,1)
    q = loads(i,:);
    f([1 7]) = f([1 7])+q(2)*L/2;
    f([4 10]) = f([4 10])+q(7)*L/2;
    for j = 1:3
        x = points(j); w = weights(j)*L;
        qv = q(3)+(q(4)-q(3))*x; qw = q(5)+(q(6)-q(5))*x;
        f([2 6 8 12]) = f([2 6 8 12])+shape(x,L,phiV)*qv*w;
        f([3 5 9 11]) = f([3 5 9 11])+ ...
            shape(x,L,phiW).*[1;-1;1;-1]*qw*w;
    end
end
thermal = model.Loads.Thermal(model.Loads.Thermal(:,1) == e,2:5);
for i = 1:size(thermal,1)
    t = thermal(i,:); Ealpha = material(2)*material(4);
    % Legacy convention: mean temperatures of the two planes are additive.
    N = Ealpha*section(2)*(mean(t(1:2))+mean(t(3:4)));
    Mv = Ealpha*section(5)/2*(t(1)-t(2));
    Mw = Ealpha*section(6)/2*(t(3)-t(4));
    f = f+[-N;0;0;0;-Mv;-Mw;N;0;0;0;Mv;Mw];
end
end

function N = shape(x, L, phi)
N = [1-3*x^2+2*x^3+phi*(1-x); ...
    L*(x-2*x^2+x^3+phi*(x-x^2)/2); ...
    3*x^2-2*x^3+phi*x; ...
    L*(-x^2+x^3-phi*(x-x^2)/2)]/(1+phi);
end
