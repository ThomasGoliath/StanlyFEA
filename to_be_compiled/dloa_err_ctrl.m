function dloa_err_ctrl(a,nl)
global Mesh
if Mesh.Numbers.Elements==0
    ErrorManager('elements must be before distributed loads')
end
if isempty(a)
    ErrorManager('distributed loads (line %i): sintax error',nl)
end
if length(a)~=8
	ErrorManager('distributed loads (line %i): every line must contains 8 values',nl)
end
if sum(~isnumeric(a))
	ErrorManager('distributed loads (line %i): values must be numeric',nl)
end
if sum(isnan(a))||sum(isinf(a))
	ErrorManager('distributed loads (line %i): not valid value',nl)
end
if a(1)>Mesh.Numbers.Elements||a(1)<1||floor(a(1))~=a(1)
	ErrorManager('distributed loads (line %i): not valid element ID',nl)
end
if ~sum(a(2:7)~=0)
    WarningManager('distributed loads (line %i): empty line, use mesh control instead',nl)
end
if floor(a(8))~=a(8)||a(8)<0
	ErrorManager('distributed loads (line %i): intermediate nodes number must be integer, positive and at least 0',nl)
end