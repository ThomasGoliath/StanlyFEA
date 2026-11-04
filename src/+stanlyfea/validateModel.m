function validateModel(model)
%VALIDATEMODEL Validate IDs, references and physical parameters before assembly.
n = model.Mesh.Nodes; e = model.Mesh.Elements;
s = model.Properties.Sections; m = model.Properties.Materials;
require(~isempty(n) && ~isempty(e) && ~isempty(s) && ~isempty(m), ...
    'Nodes, elements, sections and materials must not be empty.');
sets = {n, e, s, m, model.Mesh.Springs};
for i = 1:numel(sets)
    t = sets{i};
    if isempty(t), continue; end
    require(all(isfinite(t(:))), 'Mesh and property values must be finite.');
    require(all(t(:,1) > 0 & t(:,1) == fix(t(:,1))) && ...
        numel(unique(t(:,1))) == size(t,1), 'IDs must be unique positive integers.');
end
references(e(:,2:3), n(:,1), 'element node');
references(e(:,4), s(:,1), 'element section');
references(e(:,5), m(:,1), 'element material');
require(all(e(:,2) ~= e(:,3)), 'An element must connect distinct nodes.');
[~, a] = ismember(e(:,2), n(:,1)); [~, b] = ismember(e(:,3), n(:,1));
require(all(sum((n(a,2:4)-n(b,2:4)).^2,2) > 0), 'Zero length element.');
require(all(all(s(:,2:6) > 0)) && all(all(s(:,7:8) >= 0)), ...
    'Section areas, inertias and moduli must be positive; shear factors nonnegative.');
require(all(m(:,2) > 0 & m(:,3) > -1 & m(:,3) < .5 & ...
    m(:,5) >= 0 & m(:,6) > 0 & m(:,7) >= m(:,6)), 'Invalid material parameters.');
nodeBlocks = {model.Constraints.Ground, model.Constraints.Prescribed, ...
    model.Loads.Nodal, model.Properties.Notches};
for i = 1:numel(nodeBlocks)
    t = nodeBlocks{i}; if isempty(t), continue; end
    references(t(:,1), n(:,1), 'node');
    if i ~= 1, require(all(isfinite(t(:))), 'Nonfinite node data.'); end
    if i ~= 3
        require(numel(unique(t(:,1))) == size(t,1), 'Duplicate node record.');
    end
end
g = model.Constraints.Ground;
require(~any(isnan(g(:))) && all(all(g(:,2:7) >= 0)) && ...
    all(all(isfinite(g(:,8:9)))), 'Invalid ground constraints.');
internal = model.Constraints.Internal;
if ~isempty(internal)
    references(internal(:,1:2), n(:,1), 'internal constraint node');
    require(all(internal(:,1) ~= internal(:,2)) && ...
        ~any(isnan(internal(:))) && all(all(internal(:,3:8) >= 0)), ...
        'Invalid internal constraints.');
end
springs = model.Mesh.Springs;
if ~isempty(springs)
    references(springs(:,2:3), n(:,1), 'spring node');
    [~, a] = ismember(springs(:,2), n(:,1)); [~, b] = ismember(springs(:,3), n(:,1));
    require(all(springs(:,4) > 0) && ...
        all(sum((n(a,2:4)-n(b,2:4)).^2,2) > 0), 'Invalid axial spring.');
end
elementBlocks = {model.Mesh.Refinement, model.Loads.Distributed, model.Loads.Thermal};
for i = 1:numel(elementBlocks)
    t = elementBlocks{i}; if isempty(t), continue; end
    references(t(:,1), e(:,1), 'element');
    require(all(isfinite(t(:))), 'Nonfinite element load.');
    if i <= 2
        require(all(t(:,end) >= 0 & t(:,end) == fix(t(:,end))), ...
            'Mesh subdivisions must be nonnegative integers.');
    end
end
require(size(model.Loads.Gravity,1) <= 1 && ...
    all(isfinite(model.Loads.Gravity(:))), 'Specify at most one gravity vector.');
notches = model.Properties.Notches;
if ~isempty(notches)
    if model.IsFatigue
        require(all(all(notches(:,2:3) >= 1)) && ...
            all(notches(:,4) >= 0 & notches(:,4) <= 1), 'Invalid fatigue notch factors.');
    else
        require(all(all(notches(:,2:4) >= 1)), 'Notch factors must be at least one.');
    end
end
if model.IsFatigue
    require(all(s(:,9) > 0 & s(:,9) <= 1) && all(m(:,8) > 0 & m(:,8) <= 1), ...
        'Fatigue size and surface factors must be in (0,1].');
end
end

function references(values, ids, label)
require(all(ismember(values(:), ids)), ['Unknown ' label ' reference.']);
end
function require(condition, message)
if ~condition, error('Stanly:InvalidModel', '%s', message); end
end
