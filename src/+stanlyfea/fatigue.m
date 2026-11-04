function output = fatigue(model,alternating,meanStress)
%FATIGUE Legacy empirical fatigue estimate, made explicit and independently callable.
% Keep the original Sines/Goodman and Gough-Pollard formulae for comparison.
% This is not a general multiaxial fatigue or code-compliance implementation.
ne = size(model.Mesh.Elements,1);
output.Values = zeros(ne,8); output.SafetyFactors = zeros(ne,4);
output.Method = 'STANLY legacy empirical fatigue estimate';
for i = 1:ne
    element = model.Mesh.Elements(i,:);
    s = model.Properties.Sections(model.Properties.Sections(:,1) == element(4),:);
    m = model.Properties.Materials(model.Properties.Materials(:,1) == element(5),:);
    for j = 1:2
        notch = model.Properties.Notches(model.Properties.Notches(:,1) == element(j+1),:);
        Kfb = 1;
        if ~isempty(notch), Kfb = 1+notch(4)*(notch(2)-1); end
        endurance = .5*m(7)*s(9)*m(8)/Kfb;
        c = (j-1)*8;
        denominator = 1-meanStress(i,c+7)/m(7);
        if denominator <= 0
            equivalent = Inf;
        else
            equivalent = alternating(i,c+5)/denominator;
        end
        B = log10(.9*Kfb/(.5*s(9)*m(8)))/log10(1e3/1e7);
        A = .9*m(7)/(1e3^B);
        cycles = min(1e7,(equivalent/A)^(1/B));
        if equivalent == 0, cycles = 1e7; end
        normal = corrected(alternating(i,c+1),meanStress(i,c+1),m(7));
        shear = corrected(alternating(i,c+2),meanStress(i,c+2),m(7));
        normalLimit = endurance; shearLimit = endurance;
        if alternating(i,c+1) == 0
            normal = meanStress(i,c+1); normalLimit = m(6);
        end
        if alternating(i,c+2) == 0
            shear = meanStress(i,c+2); shearLimit = m(6)/3;
        end
        gough = hypot(normal,normalLimit/shearLimit*shear);
        output.Values(i,(j-1)*4+(1:4)) = [gough equivalent endurance cycles];
        output.SafetyFactors(i,(j-1)*2+(1:2)) = [endurance/gough endurance/equivalent];
    end
end
end

function value = corrected(alternating,meanStress,ultimate)
denominator = 1-meanStress/ultimate;
if denominator <= 0, value = Inf; else, value = alternating/denominator; end
end
