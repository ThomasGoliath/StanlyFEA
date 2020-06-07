function mate_err_ctrl(a,nl)
global FileManager
global Properties
if FileManager.CurrentFile.FileType==2, g=1; else, g=0; end
if isempty(a)
    ErrorManager('materials (line %i): sintax error',nl)
end
if length(a)~=7+g
	ErrorManager('materials (line %i): every line must contains %i values',nl,7+g)
end
if sum(~isnumeric(a))
	ErrorManager('materials (line %i): values must be numeric',nl)
end
if sum(isnan(a))||sum(isinf(a))
	ErrorManager('materials (line %i): not valid value',nl)
end
if a(1)~=size(Properties.Materials,1)+1
	ErrorManager('materials (line %i): not valid section property ID',nl)
end
if sum(a(2:end)<0)
	ErrorManager('materials (line %i): all parameters must be positive',nl)
end
if FileManager.CurrentFile.FileType==2
    if a(end)>1
        ErrorManager('materials (line %i): surface fatigue factor must be <=1',nl)
    end
end