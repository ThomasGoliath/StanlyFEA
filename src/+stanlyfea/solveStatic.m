function result = solveStatic(model)
%SOLVESTATIC Solve a frame independently of the desktop and global workspace.
stanlyfea.validateModel(model);
model = stanlyfea.refineModel(model);
nodes = model.Mesh.Nodes; elements = model.Mesh.Elements;
nn = size(nodes,1); ne = size(elements,1); nd = 6*nn;
K = sparse(nd,nd); groundStiffness = sparse(nd,nd); F = zeros(nd,1);
elementData = repmat(struct('Dofs', [], 'Rotation', [], 'Length', 0, ...
    'Stiffness', [], 'Load', []), ne,1);
for i = 1:ne
    e = elements(i,:);
    [~, ends] = ismember(e(2:3), nodes(:,1));
    section = model.Properties.Sections(model.Properties.Sections(:,1) == e(4),:);
    material = model.Properties.Materials(model.Properties.Materials(:,1) == e(5),:);
    direction = nodes(ends(2),2:4)-nodes(ends(1),2:4);
    L = norm(direction); R = stanlyfea.rotation(direction,e(6));
    T = blkdiag(R,R,R,R);
    dofs = [6*(ends(1)-1)+(1:6), 6*(ends(2)-1)+(1:6)];
    k = stanlyfea.beamStiffness(material,section,L);
    f = stanlyfea.beamLoads(model,e,R,L,material,section);
    % sparse scatter also handles repeated DOFs without dropped contributions.
    [rows, cols] = ndgrid(dofs,dofs);
    kg = T'*k*T;
    K = K+sparse(rows(:),cols(:),kg(:),nd,nd);
    F(dofs) = F(dofs)+T'*f;
    elementData(i) = struct('Dofs',dofs,'Rotation',T,'Length',L, ...
        'Stiffness',k,'Load',f);
end
for i = 1:size(model.Loads.Nodal,1)
    load = model.Loads.Nodal(i,:);
    row = find(nodes(:,1) == load(1)); dofs = 6*(row-1)+(1:6);
    F(dofs) = F(dofs)+load(2:7)';
end
% Ground springs are resolved in the support coordinate system.
A = sparse(0,nd); b = zeros(0,1);
prescribed = model.Constraints.Prescribed;
for i = 1:nn
    id = nodes(i,1); dofs = 6*(i-1)+(1:6);
    ground = model.Constraints.Ground(model.Constraints.Ground(:,1) == id,:);
    values = zeros(1,6);
    p = prescribed(prescribed(:,1) == id,:);
    if ~isempty(p), values = p(2:7); end
    rotation = eye(6); stiffness = zeros(1,6);
    if ~isempty(ground)
        stiffness = ground(2:7);
        th = ground(8)*pi/180; ph = ground(9)*pi/180;
        Rz = [cos(th) -sin(th) 0; sin(th) cos(th) 0; 0 0 1];
        Ry = [cos(ph) 0 sin(ph); 0 1 0; -sin(ph) 0 cos(ph)];
        rotation = blkdiag(Rz*Ry,Rz*Ry);
    end
    for j = 1:6
        row = sparse(1,dofs,rotation(j,:),1,nd);
        if isinf(stiffness(j)) || values(j) ~= 0
            A(end+1,:) = row; b(end+1,1) = values(j);
        elseif stiffness(j) > 0
            contribution = stiffness(j)*(row'*row);
            K = K+contribution;
            groundStiffness = groundStiffness+contribution;
        end
    end
end
for i = 1:size(model.Constraints.Internal,1)
    c = model.Constraints.Internal(i,:);
    [~, ends] = ismember(c(1:2),nodes(:,1));
    for j = 1:6
        row = sparse(1,6*(ends-1)+j,[1 -1],1,nd);
        if isinf(c(j+2))
            A(end+1,:) = row; b(end+1,1) = 0;
        elseif c(j+2) > 0
            K = K+c(j+2)*(row'*row);
        end
    end
end
for i = 1:size(model.Mesh.Springs,1)
    spring = model.Mesh.Springs(i,:);
    [~, ends] = ismember(spring(2:3),nodes(:,1));
    direction = nodes(ends(2),2:4)-nodes(ends(1),2:4); direction = direction/norm(direction);
    dofs = [6*(ends(1)-1)+(1:3),6*(ends(2)-1)+(1:3)];
    row = sparse(1,dofs,[direction -direction],1,nd);
    K = K+spring(4)*(row'*row);
end
% Remove redundant constraints, rejecting incompatible prescribed values.
if ~isempty(b)
    [~, Qr, permutation] = qr(full(A'),'econ','vector');
    tolerance = max(size(A))*eps(max(1,norm(Qr,Inf)));
    count = sum(abs(diag(Qr)) > tolerance);
    selected = permutation(1:count);
    independent = A(selected,:); rhs = b(selected);
    candidate = independent'*((independent*independent')\rhs);
    if norm(A*candidate-b,Inf) > 1e-9*max(1,norm(b,Inf))
        error('Stanly:Constraints', 'Incompatible prescribed displacements.');
    end
    A = independent; b = rhs;
end
% Symmetric scaling avoids comparing translations and rotations in raw units.
d = full(abs(diag(K))); d(d == 0) = 1;
D = spdiags(1./sqrt(d),0,nd,nd); C = A*D;
rowNorm = sqrt(full(sum(C.^2,2))); rowNorm(rowNorm == 0) = 1;
W = spdiags(1./rowNorm,0,numel(b),numel(b)); C = W*C;
system = [D*K*D C'; C sparse(size(C,1),size(C,1))];
rhs = [D*F; W*b];
state1 = warning('error','MATLAB:singularMatrix');
state2 = warning('error','MATLAB:nearlySingularMatrix');
restore = onCleanup(@() restoreWarnings(state1,state2)); %#ok<NASGU>
try
    solution = system\rhs;
catch exception
    error('Stanly:UnstableModel', 'Cannot solve the frame: %s', exception.message);
end
if any(~isfinite(solution)) || norm(system*solution-rhs,Inf) > 1e-7*max(1,norm(rhs,Inf))
    error('Stanly:UnstableModel', 'Singular or unstable frame. Check supports and connectivity.');
end
u = D*solution(1:nd);
result.SchemaVersion = 1;
result.Model = model;
result.Displacements = reshape(u,6,[])';
% Include elastic support forces, which otherwise cancel inside K*u-F.
% Rigid internal ties also contribute nodal constraint forces here.
result.Reactions = reshape((K-groundStiffness)*u-F,6,[])';
result.AppliedLoads = reshape(F,6,[])';
result.EndForces = zeros(ne,12);
result.LocalDisplacements = zeros(ne,12);
result.ElementLengths = zeros(ne,1);
result.ElementRotations = zeros(3,3,ne);
for i = 1:ne
    element = elementData(i);
    local = element.Rotation*u(element.Dofs);
    result.LocalDisplacements(i,:) = local';
    result.EndForces(i,:) = (element.Stiffness*local-element.Load)';
    result.ElementLengths(i) = element.Length;
    result.ElementRotations(:,:,i) = element.Rotation(1:3,1:3);
end
% Section forces are positive on the positive cut face at both beam ends.
result.InternalForces = result.EndForces;
result.InternalForces(:,1:6) = -result.InternalForces(:,1:6);
result.Stress = stanlyfea.stresses(model,result.InternalForces);
result.Strain = stanlyfea.strains(model,result.Stress);
result.SafetyFactors = stanlyfea.safetyFactors(model,result.Stress);
result.Diagnostics.FreeResidual = norm(K*u+A'*(W*solution(nd+1:end))-F,Inf);
result.Diagnostics.ConstraintResidual = norm(A*u-b,Inf);
conditionEstimate = condest(system);
if ~isfinite(conditionEstimate) || conditionEstimate > 1e15
    error('Stanly:UnstableModel', 'Singular or poorly conditioned frame. Check supports, units and connectivity.');
end
result.Diagnostics.ReciprocalConditionEstimate = 1/conditionEstimate;
end

function restoreWarnings(a,b)
warning(a); warning(b);
end
