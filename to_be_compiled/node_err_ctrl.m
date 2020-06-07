function node_err_ctrl(a,nl)
global Mesh
if isempty(a)
    ErrorManager('nodes (line %i): sintax error',nl)
end
if sum(~isnumeric(a))
	ErrorManager('nodes (line %i): values must be numeric',nl)
end
if sum(isnan(a))||sum(isinf(a))
	ErrorManager('nodes (line %i): not valid value',nl)
end
if a(1)~=size(Mesh.Nodes.Tab,1)+1
	ErrorManager('nodes (line %i): not valid node ID',nl)
end
if length(a)~=4
	ErrorManager('nodes (line %i): every line must contains 4 values',nl)
end