function strain = strains(model, stress)
%STRAINS Mechanical strain from isotropic linear elasticity, excluding thermal strain.
names = {'Max','Nom'};
for k = 1:numel(names)
    values = stress.(names{k}); strain.(names{k}) = zeros(size(values,1),12);
    for i = 1:size(values,1)
        e = model.Mesh.Elements(i,:);
        material = model.Properties.Materials(model.Properties.Materials(:,1) == e(5),:);
        E = material(2); nu = material(3); G = E/(2*(1+nu));
        for j = 1:2
            normal = values(i,(j-1)*8+1)/E;
            shear = values(i,(j-1)*8+2)/(2*G);
            tensor = [normal shear 0; shear -nu*normal 0; 0 0 -nu*normal];
            principal = eig(tensor);
            strain.(names{k})(i,(j-1)*6+(1:6)) = ...
                [normal shear max(principal) min(principal) trace(tensor) det(tensor)];
        end
    end
end
end
