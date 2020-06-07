function tloa_err_ctrl(a,nl)
global Mesh
if Mesh.Numbers.Elements==0
    ErrorManager('elements must be before thermal variations')
end
if isempty(a)
    ErrorManager('thermal variations (line %i): sintax error',nl)
end
if length(a)~=5
	ErrorManager('thermal variations (line %i): every line must contains 5 values',nl)
end
if sum(~isnumeric(a))
	ErrorManager('thermal variations (line %i): values must be numeric',nl)
end
if sum(isnan(a))||sum(isinf(a))
	ErrorManager('thermal variations (line %i): not valid value',nl)
end
if a(1)>Mesh.Numbers.Elements||a(1)<1||floor(a(1))~=a(1)
	ErrorManager('thermal variations (line %i): not valid element ID',nl)
end
if ~sum(a(2:5)~=0)
    WarningManager('thermal variations (line %i): this line is useless',nl)
end