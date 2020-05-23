function status_info(string,user)

global logger logIndex logWindow logSize

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
if logIndex == logSize
    logger(1)=[];
elseif logIndex < logSize
    logIndex = logIndex +1;
else
    error('Unexpected log error')
end
logger(logIndex)={message};

try
    if ishandle(logWindow)
        set(logWindow,'Items',logger);
        set(logWindow,'Value',logger(end));
    end
catch ME
    error('Unexpected log error')
end