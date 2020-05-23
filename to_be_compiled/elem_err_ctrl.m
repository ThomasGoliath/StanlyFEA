function elem_err_ctrl(a,nl)
global nn index
if nn==0
    error('nodes must be before elements')
end
if isempty(a)
    error('elements (line %i): sintax error',nl)
end
if length(a)~=6
	error('elements (line %i): every line must contains 6 values',nl)
end
if sum(~isnumeric(a))
	error('elements (line %i): values must be numeric',nl)
end
if sum(isnan(a))||sum(isinf(a))
	error('elements (line %i): not valid value',nl)
end
if a(1)~=size(index,1)+1
	error('elements (line %i): not valid element ID',nl)
end
if (a(2)<1||floor(a(2))~=a(2)||a(2)>nn)||(a(3)<1||floor(a(3))~=a(3)||a(3)>nn)
	error('elements (line %i): not valid node ID',nl)
end
if (a(5)<1||floor(a(5))~=a(5))||(a(4)<1||floor(a(4))~=a(4))
	error('elements (line %i): not valid property ID',nl)
end