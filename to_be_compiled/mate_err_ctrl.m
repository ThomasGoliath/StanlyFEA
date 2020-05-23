function mate_err_ctrl(a,nl)
global filetype material
if filetype==2, g=1; else, g=0; end
if isempty(a)
    error('materials (line %i): sintax error',nl)
end
if length(a)~=7+g
	error('materials (line %i): every line must contains %i values',nl,7+g)
end
if sum(~isnumeric(a))
	error('materials (line %i): values must be numeric',nl)
end
if sum(isnan(a))||sum(isinf(a))
	error('materials (line %i): not valid value',nl)
end
if a(1)~=size(material,1)+1
	error('materials (line %i): not valid section property ID',nl)
end
if sum(a(2:end)<0)
	error('materials (line %i): all parameters must be positive',nl)
end
if filetype==2
    if a(end)>1
        error('materials (line %i): surface fatigue factor must be <=1',nl)
    end
end