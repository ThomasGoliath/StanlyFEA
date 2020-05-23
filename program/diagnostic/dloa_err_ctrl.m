function dloa_err_ctrl(a,nl)
global ne
if ne==0
    error('elements must be before distributed loads')
end
if isempty(a)
    error('distributed loads (line %i): sintax error',nl)
end
if length(a)~=8
	error('distributed loads (line %i): every line must contains 8 values',nl)
end
if sum(~isnumeric(a))
	error('distributed loads (line %i): values must be numeric',nl)
end
if sum(isnan(a))||sum(isinf(a))
	error('distributed loads (line %i): not valid value',nl)
end
if a(1)>ne||a(1)<1||floor(a(1))~=a(1)
	error('distributed loads (line %i): not valid element ID',nl)
end
if ~sum(a(2:7)~=0)
    warning('distributed loads (line %i): empty line, use mesh control instead',nl)
end
if floor(a(8))~=a(8)||a(8)<0
	error('distributed loads (line %i): intermediate nodes number must be integer, positive and at least 0',nl)
end