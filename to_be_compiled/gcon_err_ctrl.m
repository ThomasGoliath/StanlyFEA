function gcon_err_ctrl(a,nl)
global nn
if nn==0
    error('nodes must be before ground constraints')
end
if isempty(a)
    error('ground constraints (line %i): sintax error',nl)
end
if length(a)~=9
	error('ground constraints (line %i): every line must contains 9 values',nl)
end
if sum(~isnumeric(a))
	error('ground constraints (line %i): values must be numeric',nl)
end
if sum(isnan(a))
	error('ground constraints (line %i): not valid value',nl)
end
if a(1)>nn||a(1)<1||floor(a(1))~=a(1)
	error('ground constraints (line %i): not valid node ID',nl)
end
if sum(a(2:7)<0)
	error('ground constraints (line %i): stiffness must be positive',nl)
end
if ~sum(a(2:7)~=0)
    warning('ground constraints (line %i): add an empty line won''t have any effect',nl)
end