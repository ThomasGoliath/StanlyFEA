function mesh_err_ctrl(a,nl)
global ne
if ne==0
    error('elements must be before mesh control')
end
if isempty(a)
    error('mesh control (line %i): sintax error',nl)
end
if sum(~isnumeric(a))
	error('mesh control (line %i): values must be numeric',nl)
end
if sum(isnan(a))||sum(isinf(a))
	error('mesh control (line %i): not valid value',nl)
end
if length(a)~=2
	error('mesh control (line %i): this line must contains 2 values',nl)
end
if a(1)<1||a(1)>ne||floor(a(1))~=a(1)
	error('mesh control (line %i): not valid element ID',nl)
end
if floor(a(2))~=a(2)
	error('mesh control (line %i): resolution must be an integer value',nl)
end