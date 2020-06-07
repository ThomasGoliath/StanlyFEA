function ycon_err_ctrl(a,nl)
global Mesh
global Constraints
if Mesh.Numbers.Nodes==0
    ErrorManager('nodes must be before yielding constraints')
end
if isempty(a)
    ErrorManager('yielding constraints (line %i): sintax error',nl)
end
if ~sum(sum(Constraints.Dtab~=0))
    ErrorManager('yielding constraints must be before yielding constraints')
end
if length(a)~=7
	ErrorManager('yielding constraints (line %i): every line must contains 7 values',nl)
end
if sum(~isnumeric(a))
	ErrorManager('yielding constraints (line %i): values must be numeric',nl)
end
if sum(isnan(a))||sum(isinf(a))
	ErrorManager('yielding constraints (line %i): not valid value',nl)
end
if a(1)>Mesh.Numbers.Nodes||a(1)<1||floor(a(1))~=a(1)
	ErrorManager('yielding constraints (line %i): not valid node ID',nl)
end
for i=2:7
    if Constraints.Dtab(a(1),i-1)>-1&&a(i)~=0
        ErrorManager('yielding constraints (line %i): yielding must be applied on a constraint',nl)
    end
end
if ~sum(a(2:7)~=0)
    WarningManager('yielding constraint (line %i): add an empty line won''t have any effect',nl)
end