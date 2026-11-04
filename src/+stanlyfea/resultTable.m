function data = resultTable(result,kind)
%RESULTTABLE Named numeric tables shared by GUI, CSV and report exports.
model = result.Model;
switch kind
    case 'Nodes'
        values = model.Mesh.Nodes;
        names = {'Node','X','Y','Z'};
    case 'Elements'
        values = [model.Mesh.Elements,result.ElementLengths];
        names = {'Element','Node1','Node2','Section','Material','Roll_deg','Length'};
    case 'Displacements'
        values = [model.Mesh.Nodes(:,1),result.Displacements];
        names = {'Node','Ux','Uy','Uz','Rx','Ry','Rz'};
    case 'Reactions'
        values = [model.Mesh.Nodes(:,1),result.Reactions];
        names = {'Node','Fx','Fy','Fz','Mx','My','Mz'};
    case 'Applied loads'
        values = [model.Mesh.Nodes(:,1),result.AppliedLoads];
        names = {'Node','Fx','Fy','Fz','Mx','My','Mz'};
    case 'Internal forces'
        values = [model.Mesh.Elements(:,1),result.InternalForces];
        names = {'Element','N1','Vy1','Vz1','T1','My1','Mz1', ...
            'N2','Vy2','Vz2','T2','My2','Mz2'};
    case {'Stress','Nominal stress'}
        if strcmp(kind,'Stress'), stress = result.Stress.Max; else, stress = result.Stress.Nom; end
        values = [model.Mesh.Elements(:,1),stress];
        names = {'Element','Normal1','Shear1','PrincipalMax1','PrincipalMin1', ...
            'VonMises1','Tresca1','Trace1','Det1','Normal2','Shear2', ...
            'PrincipalMax2','PrincipalMin2','VonMises2','Tresca2','Trace2','Det2'};
    case 'Strain'
        values = [model.Mesh.Elements(:,1),result.Strain.Max];
        names = {'Element','Normal1','TensorShear1','PrincipalMax1','PrincipalMin1', ...
            'Trace1','Det1','Normal2','TensorShear2','PrincipalMax2','PrincipalMin2','Trace2','Det2'};
    case 'Safety factors'
        values = [model.Mesh.Elements(:,1),result.SafetyFactors];
        names = {'Element','YieldMises1','YieldTresca1','NominalMises1','NominalTresca1', ...
            'Ultimate1','YieldMises2','YieldTresca2','NominalMises2','NominalTresca2','Ultimate2'};
    case 'Fatigue'
        if ~isfield(result,'Fatigue'), error('Stanly:NoFatigue','No fatigue result.'); end
        values = [model.Mesh.Elements(:,1),result.Fatigue.Values,result.Fatigue.SafetyFactors];
        names = {'Element','Gough1','Sines1','Endurance1','Cycles1', ...
            'Gough2','Sines2','Endurance2','Cycles2','GoughFactor1','SinesFactor1','GoughFactor2','SinesFactor2'};
    otherwise
        error('Stanly:Table','Unknown result table: %s',kind);
end
data = array2table(values,'VariableNames',names);
end
