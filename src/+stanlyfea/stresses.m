function stress = stresses(model, forces)
%STRESSES Beam-end stress envelopes using the original section approximation.
% Columns per end: axial+bending, torsional shear, principal max/min,
% von Mises, Tresca, trace, determinant. Transverse shear is not included.
ne = size(model.Mesh.Elements,1);
stress.Max = zeros(ne,16); stress.Nom = zeros(ne,16);
for i = 1:ne
    e = model.Mesh.Elements(i,:);
    s = model.Properties.Sections(model.Properties.Sections(:,1) == e(4),:);
    polarModulus = (s(3)+s(4))/max(s(3)/s(5),s(4)/s(6));
    for j = 1:2
        f = forces(i,(j-1)*6+(1:6));
        factors = ones(1,3);
        notch = model.Properties.Notches(model.Properties.Notches(:,1) == e(j+1),:);
        if ~model.IsFatigue && ~isempty(notch), factors = notch(2:4); end
        nominal = normalStress(f,s,[1 1 1],polarModulus);
        maximum = normalStress(f,s,factors,polarModulus);
        columns = (j-1)*8+(1:8);
        stress.Nom(i,columns) = nominal;
        stress.Max(i,columns) = maximum;
    end
end
end

function values = normalStress(f,s,k,polarModulus)
% Preserve compression and take the largest absolute bending envelope.
direction = sign(f(1)); if direction == 0, direction = 1; end
normal = direction*(k(1)*abs(f(1))/s(2)+k(2)*hypot(f(5)/s(5),f(6)/s(6)));
shear = k(3)*abs(f(4))/polarModulus;
principal = eig([normal shear; shear 0]);
values = [normal shear max(principal) min(principal) ...
    hypot(normal,sqrt(3)*shear) hypot(normal,2*shear) normal -shear^2];
end
