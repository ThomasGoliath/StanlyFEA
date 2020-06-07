function spri_err_ctrl(a,nl)
global Mesh
if Mesh.Numbers.Nodes==0
    ErrorManager('nodes must be before springs')
end
if isempty(a)
    ErrorManager('springs (line %i): sintax error',nl)
end
if length(a)~=4
	ErrorManager('springs (line %i): every line must contains 4 values',nl)
end
if sum(~isnumeric(a))
	ErrorManager('springs (line %i): values must be numeric',nl)
end
if sum(isnan(a))||sum(isinf(a))
	ErrorManager('springs (line %i): not valid value',nl)
end
if a(1)~=size(Mesh.Springs.Tab,1)+1
	ErrorManager('springs (line %i): not valid spring element id',nl)
end
if (a(2)<1||floor(a(2))~=a(2)||a(2)>Mesh.Numbers.Nodes)||(a(3)<1||floor(a(3))~=a(3)||a(3)>Mesh.Numbers.Nodes)
	ErrorManager('springs (line %i): not valid node id',nl)
end
if a(4)<0
	ErrorManager('springs (line %i): stiffness must be positive',nl)
end
if a(4)==0
	WarningManager('springs (line %i): zero stiffness spring element won''t influence the structure',nl)
end