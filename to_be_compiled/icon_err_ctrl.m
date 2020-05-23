function icon_err_ctrl(a,nl)
global nn
if nn==0
    error('nodes must be before internal constraints')
end
if isempty(a)
    error('internal constraints (line %i): sintax error',nl)
end
if length(a)~=8
	error('internal constraints (line %i): every line must contains 8 values',nl)
end
if sum(~isnumeric(a))
	error('internal constraints (line %i): values must be numeric',nl)
end
if sum(isnan(a))
	error('internal constraints (line %i): not valid value',nl)
end
if a(1)>nn||a(1)<1||floor(a(1))~=a(1)
	error('internal constraints (line %i): not valid master node ID',nl)
end
if a(2)>nn||a(2)<1||floor(a(2))~=a(2)
	error('internal constraints (line %i): not valid slave node ID',nl)
end
if a(2)==a(1)
    error('internal constraints (line %i): master and slave must be different',nl)
end
if sum(a(3:8)<0)
	error('internal constraints (line %i): stiffness must be positive',nl)
end
if ~sum(a(3:8)~=0)
    warning('internal constraints (line %i): this line is useless',nl,a(1),a(2))
end
if ~sum(a(3:8)~=inf)
    warning('internal constraints (line %i): this enslavement is useless',nl)
end