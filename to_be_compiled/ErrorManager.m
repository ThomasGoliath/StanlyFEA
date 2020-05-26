function ErrorManager(message, exception)
%% ErrorManager(message, exception)
% Manages the expetions logging and recording with personal messages
%

error(message)
if nargin == 2
    LogMsg(exception.identifier)
    LogMsg(exception.message)
    for i=1:length(exception.stack)
        LogMsg(sprintf('%s, line %i (%s)', exception.stack.name,...
            exception.stack.line,exception.stack.file));
    end
end

end