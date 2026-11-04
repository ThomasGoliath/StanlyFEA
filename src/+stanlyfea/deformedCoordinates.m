function coordinates = deformedCoordinates(result,scale)
%DEFORMEDCOORDINATES Interpolate local beam displacement, including end rotations.
model = result.Model; ne = size(model.Mesh.Elements,1);
coordinates = cell(ne,1);
for i = 1:ne
    e = model.Mesh.Elements(i,:); L = result.ElementLengths(i);
    [~, node] = ismember(e(2),model.Mesh.Nodes(:,1));
    material = model.Properties.Materials(model.Properties.Materials(:,1) == e(5),:);
    section = model.Properties.Sections(model.Properties.Sections(:,1) == e(4),:);
    G = material(2)/(2*(1+material(3)));
    phiV = 12*section(7)*material(2)*section(4)/(G*section(2)*L^2);
    phiW = 12*section(8)*material(2)*section(3)/(G*section(2)*L^2);
    x = linspace(0,1,31)'; d = result.LocalDisplacements(i,:);
    u = (1-x)*d(1)+x*d(7);
    v = basis(x,L,phiV)*d([2 6 8 12])';
    w = basis(x,L,phiW)*(d([3 5 9 11]).*[1 -1 1 -1])';
    local = [x*L zeros(numel(x),2)]+scale*[u v w];
    coordinates{i} = model.Mesh.Nodes(node,2:4)+local*result.ElementRotations(:,:,i);
end
end

function N = basis(x,L,phi)
N = [1-3*x.^2+2*x.^3+phi*(1-x), ...
    L*(x-2*x.^2+x.^3+phi*(x-x.^2)/2), ...
    3*x.^2-2*x.^3+phi*x, ...
    L*(-x.^2+x.^3-phi*(x-x.^2)/2)]/(1+phi);
end
