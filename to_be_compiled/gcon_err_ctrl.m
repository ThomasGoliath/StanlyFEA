function gcon_err_ctrl(a,nl)
global Mesh
if Mesh.Numbers.Nodes==0
    ErrorManager('nodes must be before ground constraints')
end
if isempty(a)
    ErrorManager('ground constraints (line %i): sintax error',nl)
end
if length(a)~=9
	ErrorManager('ground constraints (line %i): every line must contains 9 values',nl)
end
if sum(~isnumeric(a))
	ErrorManager('ground constraints (line %i): values must be numeric',nl)
end
if sum(isnan(a))
	ErrorManager('ground constraints (line %i): not valid value',nl)
end
if a(1)>Mesh.Numbers.Nodes||a(1)<1||floor(a(1))~=a(1)
	ErrorManager('ground constraints (line %i): not valid node ID',nl)
end
if sum(a(2:7)<0)
	ErrorManager('ground constraints (line %i): stiffness must be positive',nl)
end
if ~sum(a(2:7)~=0)
    WarningManager('ground constraints (line %i): add an empty line won''t have any effect',nl)
end