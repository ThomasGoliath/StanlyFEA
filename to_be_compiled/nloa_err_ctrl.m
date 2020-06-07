function nloa_err_ctrl(a,nl)
global Mesh
if Mesh.Numbers.Nodes==0
    ErrorManager('nodes must be before nodal loads')
end
if isempty(a)
    ErrorManager('nodal loads (line %i): sintax  error',nl)
end
if length(a)~=7
	ErrorManager('nodal loads (line %i): every line must contains 7 values',nl)
end
if sum(~isnumeric(a))
	ErrorManager('nodal loads (line %i): values must be numeric',nl)
end
if sum(isnan(a))||sum(isinf(a))
	ErrorManager('nodal loads (line %i): not valid value',nl)
end
if a(1)>Mesh.Numbers.Nodes||a(1)<1||floor(a(1))~=a(1)
	ErrorManager('nodal loads (line %i): not valid node ID',nl)
end
if ~sum(a(2:7)~=0)
    WarningManager('nodal loads (line %i): add an empty line won''t have any effect',nl)
end