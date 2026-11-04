function plotResult(ax,result,kind,scale)
%PLOTRESULT Draw with explicit axes; no dependence on the current figure.
if nargin < 4, scale = 1; end
cla(ax); hold(ax,'on'); colorbar(ax,'off');
model = result.Model; nodes = model.Mesh.Nodes; e = model.Mesh.Elements;
colorValues = []; label = '';
switch kind
    case 'Von Mises'
        colorValues = max(result.Stress.Max(:,[5 13]),[],2); label = 'Von Mises stress';
    case 'Normal stress'
        colorValues = max(abs(result.Stress.Max(:,[1 9])),[],2); label = 'Absolute normal stress envelope';
    case 'Fatigue safety factor'
        colorValues = min(result.Fatigue.SafetyFactors,[],2);
        colorValues(isinf(colorValues)) = NaN;
        label = 'Minimum legacy fatigue safety factor (gray = infinite)';
    case 'Fatigue life'
        colorValues = min(result.Fatigue.Values(:,[4 8]),[],2);
        label = 'Estimated legacy fatigue cycles';
    case {'Axial force','Shear force','Torque','Bending moment'}
        switch kind
            case 'Axial force', columns = [1 7];
            case 'Shear force', columns = [2 3 8 9];
            case 'Torque', columns = [4 10];
            otherwise, columns = [5 6 11 12];
        end
        colorValues = max(abs(result.InternalForces(:,columns)),[],2); label = [kind ' (end envelope)'];
end
if ~isempty(colorValues)
    colors = parula(256); finite = colorValues(isfinite(colorValues));
    if isempty(finite), lo = 0; hi = 1; else, lo = min(finite); hi = max(finite); end
    if lo == hi, hi = lo+max(1,abs(lo))*1e-6; end
    colormap(ax,colors); clim(ax,[lo hi]); colorbar(ax);
end
for i = 1:size(e,1)
    [~, ends] = ismember(e(i,2:3),nodes(:,1)); xyz = nodes(ends,2:4);
    color = [.25 .35 .5]; width = 1.5;
    if ~isempty(colorValues) && isfinite(colorValues(i))
        index = 1+round(255*(colorValues(i)-lo)/(hi-lo));
        color = colors(index,:); width = 3;
    end
    plot3(ax,xyz(:,1),xyz(:,2),xyz(:,3),'-','Color',color,'LineWidth',width);
end
if strcmp(kind,'Deformed')
    paths = stanlyfea.deformedCoordinates(result,scale);
    for i = 1:numel(paths)
        xyz = paths{i}; plot3(ax,xyz(:,1),xyz(:,2),xyz(:,3),'r-','LineWidth',2);
    end
    label = sprintf('Deformed shape (scale %.4g)',scale);
elseif strcmp(kind,'Loads and supports')
    constrained = model.Constraints.Ground(:,1);
    [~, rows] = ismember(constrained,nodes(:,1));
    xyz = nodes(rows,2:4);
    scatter3(ax,xyz(:,1),xyz(:,2),xyz(:,3),60,'^','filled','MarkerFaceColor',[.2 .6 .3]);
    forces = result.AppliedLoads(:,1:3);
    magnitude = max(sqrt(sum(forces.^2,2)));
    extent = max(max(nodes(:,2:4))-min(nodes(:,2:4)));
    if magnitude > 0
        forces = forces/magnitude*extent*.15;
        quiver3(ax,nodes(:,2),nodes(:,3),nodes(:,4), ...
            forces(:,1),forces(:,2),forces(:,3),0,'Color',[.85 .2 .1],'LineWidth',1.5);
    end
    label = 'Equivalent translational loads and ground supports';
end
if isempty(label), label = kind; end
axis(ax,'equal'); grid(ax,'on'); view(ax,3);
xlabel(ax,'X'); ylabel(ax,'Y'); zlabel(ax,'Z'); title(ax,label);
hold(ax,'off');
end
