function node_err_ctrl(a,nl)
global Mesh
if isempty(a)
    error('nodes (line %i): sintax error',nl)
end
if sum(~isnumeric(a))
	error('nodes (line %i): values must be numeric',nl)
end
if sum(isnan(a))||sum(isinf(a))
	error('nodes (line %i): not valid value',nl)
end
if a(1)~=size(Mesh.Nodes.Tab,1)+1
	error('nodes (line %i): not valid node ID',nl)
end
if length(a)~=4
	error('nodes (line %i): every line must contains 4 values',nl)
end