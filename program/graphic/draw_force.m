function h=draw_force(components,point,color,radii,m)
if isrow(components), components=components.'; end
if isrow(point), point=point.'; end
W=[-components zeros(3,1) ]+point;
x=W(1,:); y=W(2,:); z=W(3,:);
if nargin==4, m=1; end
if m~=1&&m~=2, m=2; end
switch m
    case 1
        h=arrow3d(x,y,z,.1,radii,radii,color);
    case 2
        h=dubarrow3d(x,y,z,.4,radii,radii,color);
end
set(h,'PickableParts','none')
