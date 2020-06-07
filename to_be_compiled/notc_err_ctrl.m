function notc_err_ctrl(a,nl)
global Mesh
global FileManager
if Mesh.Numbers.Nodes==0
    ErrorManager('nodes must be before notches')
end
if isempty(a)
    ErrorManager('notches (line %i): sintax error',nl)
end
if sum(~isnumeric(a))
	ErrorManager('notches (line %i): values must be numeric',nl)
end
if sum(isnan(a))||sum(isinf(a))
	ErrorManager('notches (line %i): not valid value',nl)
end
if a(1)<1||floor(a(1))~=a(1)||a(1)>Mesh.Numbers.Nodes
	ErrorManager('notches (line %i): not valid node ID',nl)
end
if sum(a(2:end)<0)
	ErrorManager('notches (line %i): all parameters must be positive',nl)
end
if length(a)~=4
	ErrorManager('notches (line %i): every line must contains 4 values')
end
if FileManager.CurrentFile.FileType==1
    if a(2)<1
        ErrorManager('notches (line %i): Kta must be >=1',nl)
    end
    if a(3)<1
        ErrorManager('notches (line %i): Ktb must be >=1',nl)
    end
    if a(4)<1
        ErrorManager('notches (line %i): Ktt must be >=1',nl)
    end
else
    if a(2)<1
        ErrorManager('notches (line %i): Ktb must be >=1',nl)
    end
    if a(3)<1
        ErrorManager('notches (line %i): Ktt must be >=1',nl)
    end
    if a(4)>1
        ErrorManager('notches (line %i): q must be <=1',nl)
    end
end