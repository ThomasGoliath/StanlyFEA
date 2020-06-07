function elem_err_ctrl(a,nl)
global Mesh
if Mesh.Numbers.Nodes==0
    ErrorManager('nodes must be before elements')
end
if isempty(a)
    ErrorManager('elements (line %i): sintax error',nl)
end
if length(a)~=6
	ErrorManager('elements (line %i): every line must contains 6 values',nl)
end
if sum(~isnumeric(a))
	ErrorManager('elements (line %i): values must be numeric',nl)
end
if sum(isnan(a))||sum(isinf(a))
	ErrorManager('elements (line %i): not valid value',nl)
end
if a(1)~=size(Mesh.Element,1)+1
	ErrorManager('elements (line %i): not valid element ID',nl)
end
if (a(2)<1||floor(a(2))~=a(2)||a(2)>Mesh.Numbers.Nodes)||(a(3)<1||floor(a(3))~=a(3)||a(3)>Mesh.Numbers.Nodes)
	ErrorManager('elements (line %i): not valid node ID',nl)
end
if (a(5)<1||floor(a(5))~=a(5))||(a(4)<1||floor(a(4))~=a(4))
	ErrorManager('elements (line %i): not valid property ID',nl)
end