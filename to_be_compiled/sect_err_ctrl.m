function sect_err_ctrl(a,nl)
global FileManager
global Properties
if FileManager.CurrentFile.FileType==2, g=1; else, g=0; end
if isempty(a)
    ErrorManager('sections (line %i): sintax error',nl)
end
if length(a)~=8+g
	ErrorManager('sections (line %i): every line must contains %i values',nl,8+g)
end
if sum(~isnumeric(a))
	ErrorManager('sections (line %i): values must be numeric',nl)
end
if sum(isnan(a))||sum(isinf(a))
	ErrorManager('sections (line %i): not valid value',nl)
end
if a(1)~=size(Properties.Sections,1)+1
	ErrorManager('sections (line %i): not valid section property ID',nl)
end
if sum(a(2:end)<0)
	ErrorManager('sections (line %i): all parameters must be positive',nl)
end
if sum(a(2:6)==0)
	ErrorManager('sections (line %i): area, inertia, resistance modulus must be >0',nl)
end
if FileManager.CurrentFile.FileType==2
    if a(end)>1||a(end)<0.7
        ErrorManager('sections (line %i): dimension fatigue factor must be in range [0.7 1]',nl)
    end
end