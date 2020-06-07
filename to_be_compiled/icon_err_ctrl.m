function icon_err_ctrl(a,nl)
global Mesh
if Mesh.Numbers.Nodes==0
    ErrorManager('nodes must be before internal constraints')
end
if isempty(a)
    ErrorManager('internal constraints (line %i): sintax error',nl)
end
if length(a)~=8
	ErrorManager('internal constraints (line %i): every line must contains 8 values',nl)
end
if sum(~isnumeric(a))
	ErrorManager('internal constraints (line %i): values must be numeric',nl)
end
if sum(isnan(a))
	ErrorManager('internal constraints (line %i): not valid value',nl)
end
if a(1)>Mesh.Numbers.Nodes||a(1)<1||floor(a(1))~=a(1)
	ErrorManager('internal constraints (line %i): not valid master node ID',nl)
end
if a(2)>Mesh.Numbers.Nodes||a(2)<1||floor(a(2))~=a(2)
	ErrorManager('internal constraints (line %i): not valid slave node ID',nl)
end
if a(2)==a(1)
    ErrorManager('internal constraints (line %i): master and slave must be different',nl)
end
if sum(a(3:8)<0)
	ErrorManager('internal constraints (line %i): stiffness must be positive',nl)
end
if ~sum(a(3:8)~=0)
    WarningManager('internal constraints (line %i): this line is useless',nl,a(1),a(2))
end
if ~sum(a(3:8)~=inf)
    WarningManager('internal constraints (line %i): this enslavement is useless',nl)
end