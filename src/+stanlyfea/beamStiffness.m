function K = beamStiffness(material, section, L)
%BEAMSTIFFNESS 12-DOF 3-D Timoshenko frame element in local coordinates.
% Section columns: ID A Iv Iw Wv Ww shear-v shear-w size-factor.
E = material(2); G = E/(2*(1+material(3)));
A = section(2); Iv = section(3); Iw = section(4);
K = zeros(12);
pair = [1 -1; -1 1];
K([1 7],[1 7]) = E*A/L*pair;
% Preserve the original polar-inertia torsion approximation.
K([4 10],[4 10]) = G*(Iv+Iw)/L*pair;
K([2 6 8 12],[2 6 8 12]) = bending(E, G, A, Iw, L, section(7), 1);
K([3 5 9 11],[3 5 9 11]) = bending(E, G, A, Iv, L, section(8), -1);
end

function B = bending(E, G, A, I, L, shear, signRotation)
phi = 12*shear*E*I/(G*A*L^2);
B = E*I/(1+phi)*[12/L^3 6/L^2 -12/L^3 6/L^2; ...
    6/L^2 (4+phi)/L -6/L^2 (2-phi)/L; ...
    -12/L^3 -6/L^2 12/L^3 -6/L^2; ...
    6/L^2 (2-phi)/L -6/L^2 (4+phi)/L];
S = diag([1 signRotation 1 signRotation]); B = S*B*S;
end
