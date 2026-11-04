function R = rotation(coordinates, roll)
%ROTATION Global-to-local beam rotation, preserving the historical convention.
direction = coordinates(:);
L = norm(direction);
if L == 0, error('Stanly:ZeroLength', 'Zero length element.'); end
theta = atan2(direction(2), direction(1));
phi = acos(max(-1, min(1, direction(3)/L)));
a = -roll*pi/180; b = pi/2-phi; c = -theta;
Rx = [1 0 0; 0 cos(a) -sin(a); 0 sin(a) cos(a)];
Ry = [cos(b) 0 sin(b); 0 1 0; -sin(b) 0 cos(b)];
Rz = [cos(c) -sin(c) 0; sin(c) cos(c) 0; 0 0 1];
R = Rx*Ry*Rz;
end
