function R = rotmat(th,dir)
%ROTMAT returns counter-clockwise rotation matrix of th around dir
switch dir
    case 1, R=[1 0 0; 0 cos(th) -sin(th); 0 sin(th) cos(th)];
    case 2, R=[cos(th) 0 sin(th); 0 1 0; -sin(th) 0 cos(th)];
    case 3, R=[cos(th) -sin(th) 0; sin(th) cos(th) 0; 0 0 1];
end

