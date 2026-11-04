function eta = safetyFactors(model,stress)
%SAFETYFACTORS Yield/failure factors. Infinite means zero stress, not failure.
eta = zeros(size(model.Mesh.Elements,1),10);
for i = 1:size(eta,1)
    materialID = model.Mesh.Elements(i,5);
    m = model.Properties.Materials(model.Properties.Materials(:,1) == materialID,:);
    for j = 1:2
        c = (j-1)*8;
        eta(i,(j-1)*5+(1:5)) = [m(6)/stress.Max(i,c+5), ...
            m(6)/stress.Max(i,c+6), m(6)/stress.Nom(i,c+5), ...
            m(6)/stress.Nom(i,c+6), m(7)/max(abs(stress.Max(i,c+[3 4])))];
    end
end
end
