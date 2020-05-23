function glob_err_ctrl
global index bush
global dtab
global xyztab nn ne
global material
global sections
global Ftab Ttab Qtab
global springs
global filetype

status_info('Checking global variables file')

if ~sum(sum(dtab~=0))
    error('Not constrained structure')
end

%% MESH
if isempty(xyztab)
    error('No nodes ==> no structure')
end
if isempty(index)
    error('No elements ==> no structure')
end


%% PROPERTIES
for i=1:ne
    if max(index(i,5))>size(material,1)
        error('element %i: No material correspondance inside index matrix',i)
    end
    if max(index(i,4))>size(sections,1)
        error('element %i: No section correspondance inside index matrix',i)
    end
end
for i=1:size(material,1)
    if ~sum(index(:,5)==material(i,1))
        warning('Material %i property is unused',i)
    end
end
for i=1:size(sections,1)
    if ~sum(index(:,4)==sections(i,1))
        warning('Section %i property is unused',i)
    end
end