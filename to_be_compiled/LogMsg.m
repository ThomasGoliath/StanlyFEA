function LogMsg(string,user)
%% LogMsg(string,user)
% Log a string into the logger. Manage logger (file and Viewing). It
% manages also data binding with the log graphic object
%

global Logger

% Check input
if nargin==1
	user=0;
end

% Determine message
if user
	message = sprintf('[%04i/%02i/%02i %02i:%2i:%02.0f] [USER] %s (%.4f)\n',clock,string,cputime);
else
	message = sprintf('[%04i/%02i/%02i %02i:%02i:%02.0f] %s (%.4f)\n',clock,string,cputime);
end

% print message in command window
fprintf(message);

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