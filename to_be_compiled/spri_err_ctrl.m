function spri_err_ctrl(a,nl)
global nn springs
if nn==0
    error('nodes must be before springs')
end
if isempty(a)
    error('springs (line %i): sintax error',nl)
end
if length(a)~=4
	error('springs (line %i): every line must contains 4 values',nl)
end
if sum(~isnumeric(a))
	error('springs (line %i): values must be numeric',nl)
end
if sum(isnan(a))||sum(isinf(a))
	error('springs (line %i): not valid value',nl)
end
if a(1)~=size(springs,1)+1
	error('springs (line %i): not valid spring element id',nl)
end
if (a(2)<1||floor(a(2))~=a(2)||a(2)>nn)||(a(3)<1||floor(a(3))~=a(3)||a(3)>nn)
	error('springs (line %i): not valid node id',nl)
end
if a(4)<0
	error('springs (line %i): stiffness must be positive',nl)
end
if a(4)==0
	warning('springs (line %i): zero stiffness spring element won''t influence the structure',nl)
end