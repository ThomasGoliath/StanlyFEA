function glob_err_ctrl
global FileManager
global Loads
global Properties
global Mesh
global Constraints

LogMsg('Checking global variables file')

if ~sum(sum(Constraints.Dtab~=0))
    ErrorManager('Not constrained structure')
end

%% MESH
if isempty(Mesh.Nodes.Tab)
    ErrorManager('No nodes ==> no structure')
end
if isempty(Mesh.Element)
    ErrorManager('No elements ==> no structure')
end


%% PROPERTIES
for i=1:Mesh.Numbers.Elements
    if max(Mesh.Element(i).Index(5))>size(Properties.Materials,1)
        ErrorManager(sprintf('element %i: No material correspondance inside index matrix',i))
    end
    if max(Mesh.Element(i).Index(4))>size(Properties.Sections,1)
        ErrorManager(sprintf('element %i: No section correspondance inside index matrix',i))
    end
end
% TODO ripristinare warnings
for i=1:size(Properties.Materials,1)
%     if ~sum(index(:,5)==Properties.Materials(i,1))
%         WarningManager(sprintf('Material %i property is unused',i))
%     end
end
for i=1:size(Properties.Sections,1)
%     if ~sum(index(:,4)==Properties.Sections(i,1))
%         WarningManager(sprintf('Section %i property is unused',i))
%     end
end