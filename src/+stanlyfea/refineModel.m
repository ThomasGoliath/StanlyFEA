function model = refineModel(model)
%REFINEMODEL Honor legacy subdivision counts while retaining original IDs.
% A count of r creates r interior nodes and r+1 beam segments.
original = model.Mesh.Elements;
model.Mesh.ParentElementIDs = original(:,1);
nextNode = max(model.Mesh.Nodes(:,1));
nextElement = max(original(:,1));
for i = 1:size(original,1)
    e = original(i,:); count = 0;
    r = model.Mesh.Refinement(model.Mesh.Refinement(:,1) == e(1),2);
    q = model.Loads.Distributed(model.Loads.Distributed(:,1) == e(1),8);
    if ~isempty([r; q]), count = max([r; q]); end
    if count == 0, continue; end
    if count > 10000
        error('Stanly:Refinement', 'More than 10000 interior nodes on one element.');
    end
    [~, a] = ismember(e(2), model.Mesh.Nodes(:,1));
    [~, b] = ismember(e(3), model.Mesh.Nodes(:,1));
    xyz = model.Mesh.Nodes([a b],2:4);
    ids = [e(2), nextNode+(1:count), e(3)];
    for j = 1:count
        model.Mesh.Nodes(end+1,:) = [ids(j+1), xyz(1,:)+j/(count+1)*diff(xyz)];
    end
    nextNode = nextNode+count;
    elementIDs = [e(1), nextElement+(1:count)];
    nextElement = nextElement+count;
    model.Mesh.Elements(i,3) = ids(2);
    for j = 2:count+1
        model.Mesh.Elements(end+1,:) = [elementIDs(j), ids(j:j+1), e(4:6)];
        model.Mesh.ParentElementIDs(end+1,1) = e(1);
    end
    rows = model.Loads.Distributed(:,1) == e(1);
    loads = model.Loads.Distributed(rows,:);
    model.Loads.Distributed(rows,:) = [];
    for k = 1:size(loads,1)
        for j = 1:count+1
            values = loads(k,:); t = [j-1 j]/(count+1);
            values(1) = elementIDs(j); values(8) = 0;
            values(3:4) = loads(k,3)+diff(loads(k,3:4))*t;
            values(5:6) = loads(k,5)+diff(loads(k,5:6))*t;
            model.Loads.Distributed(end+1,:) = values;
        end
    end
    rows = model.Loads.Thermal(:,1) == e(1);
    loads = model.Loads.Thermal(rows,:);
    for k = 1:size(loads,1)
        for j = 2:count+1
            model.Loads.Thermal(end+1,:) = [elementIDs(j), loads(k,2:5)];
        end
    end
end
end
