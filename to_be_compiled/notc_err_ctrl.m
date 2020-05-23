function notc_err_ctrl(a,nl)
global filetype nn
if nn==0
    error('nodes must be before notches')
end
if isempty(a)
    error('notches (line %i): sintax error',nl)
end
if sum(~isnumeric(a))
	error('notches (line %i): values must be numeric',nl)
end
if sum(isnan(a))||sum(isinf(a))
	error('notches (line %i): not valid value',nl)
end
if a(1)<1||floor(a(1))~=a(1)||a(1)>nn
	error('notches (line %i): not valid node ID',nl)
end
if sum(a(2:end)<0)
	error('notches (line %i): all parameters must be positive',nl)
end
if length(a)~=4
	error('notches (line %i): every line must contains 4 values')
end
if filetype==1
    if a(2)<1
        error('notches (line %i): Kta must be >=1',nl)
    end
    if a(3)<1
        error('notches (line %i): Ktb must be >=1',nl)
    end
    if a(4)<1
        error('notches (line %i): Ktt must be >=1',nl)
    end
else
    if a(2)<1
        error('notches (line %i): Ktb must be >=1',nl)
    end
    if a(3)<1
        error('notches (line %i): Ktt must be >=1',nl)
    end
    if a(4)>1
        error('notches (line %i): q must be <=1',nl)
    end
end