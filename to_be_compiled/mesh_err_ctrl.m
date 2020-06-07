function mesh_err_ctrl(a,nl)
global Mesh
if Mesh.Numbers.Elements==0
    ErrorManager('elements must be before mesh control')
end
if isempty(a)
    ErrorManager('mesh control (line %i): sintax error',nl)
end
if sum(~isnumeric(a))
	ErrorManager('mesh control (line %i): values must be numeric',nl)
end
if sum(isnan(a))||sum(isinf(a))
	ErrorManager('mesh control (line %i): not valid value',nl)
end
if length(a)~=2
	ErrorManager('mesh control (line %i): this line must contains 2 values',nl)
end
if a(1)<1||a(1)>Mesh.Numbers.Elements||floor(a(1))~=a(1)
	ErrorManager('mesh control (line %i): not valid element ID',nl)
end
if floor(a(2))~=a(2)
	ErrorManager('mesh control (line %i): resolution must be an integer value',nl)
end