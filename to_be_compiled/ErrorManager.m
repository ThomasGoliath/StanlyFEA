function ErrorManager(varargin)
%% ErrorManager(message, exception)
% Manages the expetions logging and recording with personal messages
%

global Logger

% Leggo gli input
% alla fine mi servirà una stringa formattata (string) e nell'eventualità
% una eccezione (exception)
argin = varargin; % copio per non modificare l'array di input
if ~isempty(argin)
    string = cell2mat(argin(1)); %Il primo è una stringa per forza
    argin(1)=[];
    % Vedo quanti input rimangono
    if ~isempty(argin)
        % Valuto se l'ultima è una eccezione
        if isa(cell2mat(argin(end)),'MException')
            exception = cell2mat(argin(end));
            argin(end) = [];
        else
            exception = [];
        end
        % Tutto il resto è messo per formattare la stringa
        string = FormatString(string,argin);
    else
        % C'è solamente il messaggio
        exception = [];
    end
else
    error('Unexpected error message')
end

% Determine message
message = sprintf('[%04i/%02i/%02i %02i:%02i:%02.0f] %s (%.4f)\n',clock,string,cputime);

% manage logger like a queue
if Logger.Index == Logger.Size
    Logger.Queue(1)=[];
elseif Logger.Index < Logger.Size
    Logger.Index = Logger.Index +1;
else
    % Nel logger non viene usato l'error manager perchè se no diventa un
    % loop infinito di errori
end
Logger.Queue(Logger.Index)={message};

try
    if ishandle(Logger.Window)
        set(Logger.Window,'Items',Logger.Queue);
        set(Logger.Window,'Value',Logger.Queue(end));
    end
catch ME
    % Nel logger non viene usato l'error manager perchè se no diventa un
    % loop infinito di errori
    error('Unexpected log error')
end

% CallStack
if ~isempty(exception)
    LogMsg(exception.identifier)
    LogMsg(exception.message)
    for i=1:length(exception.stack)
        LogMsg(sprintf('%s, line %i (%s)', exception.stack.name,...
            exception.stack.line,exception.stack.file));
    end
end

% print message in command window
error(string);

end