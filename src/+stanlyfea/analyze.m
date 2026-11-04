function result = analyze(filename)
%ANALYZE Load and solve a static model or the alternating/mean fatigue pair.
model = stanlyfea.readModel(filename);
result = stanlyfea.solveStatic(model);
if ~model.IsFatigue, return; end
[folder,name] = fileparts(char(filename));
meanFile = fullfile(folder,[name '.stan']);
meanStress = zeros(size(result.Stress.Nom));
if exist(meanFile,'file') == 2
    meanResult = stanlyfea.solveStatic(stanlyfea.readModel(meanFile));
    a = result.Model; b = meanResult.Model;
    if ~isequal(a.Mesh.Nodes,b.Mesh.Nodes) || ~isequal(a.Mesh.Elements,b.Mesh.Elements) || ...
            ~isequal(a.Properties.Sections(:,1:8),b.Properties.Sections(:,1:8)) || ...
            ~isequal(a.Properties.Materials(:,1:7),b.Properties.Materials(:,1:7))
        error('Stanly:FatiguePair', 'Mean and alternating models must have matching meshes and properties.');
    end
    meanStress = meanResult.Stress.Nom;
    result.MeanResult = meanResult;
end
result.Fatigue = stanlyfea.fatigue(result.Model,result.Stress.Nom,meanStress);
end
