function ycon_err_ctrl(a,nl)
global nn dtab
if nn==0
    error('nodes must be before yielding constraints')
end
if isempty(a)
    error('yielding constraints (line %i): sintax error',nl)
end
if ~sum(sum(dtab~=0))
    error('yielding constraints must be before yielding constraints')
end
if length(a)~=7
	error('yielding constraints (line %i): every line must contains 7 values',nl)
end
if sum(~isnumeric(a))
	error('yielding constraints (line %i): values must be numeric',nl)
end
if sum(isnan(a))||sum(isinf(a))
	error('yielding constraints (line %i): not valid value',nl)
end
if a(1)>nn||a(1)<1||floor(a(1))~=a(1)
	error('yielding constraints (line %i): not valid node ID',nl)
end
for i=2:7
    if dtab(a(1),i-1)>-1&&a(i)~=0
        error('yielding constraints (line %i): yielding must be applied on a constraint',nl)
    end
end
if ~sum(a(2:7)~=0)
    warning('yielding constraint (line %i): add an empty line won''t have any effect',nl)
end