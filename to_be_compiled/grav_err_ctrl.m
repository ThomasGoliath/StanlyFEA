function grav_err_ctrl(a,nl,G)
if isempty(a)
    ErrorManager('gravity (line %i): sintax error',nl)
end
if size(G,1)==1
    ErrorManager('gravity (line %i): this matrix must have a single line',nl)
end
if length(a)~=3
	ErrorManager('gravity (line %i): this line must contains 3 values',nl)
end
if sum(~isnumeric(a))
	ErrorManager('gravity (line %i): values must be numeric',nl)
end
if sum(isnan(a))
	ErrorManager('gravity (line %i): not valid value',nl)
end