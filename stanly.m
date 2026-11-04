function result = stanly(filename,outputFile)
%STANLY Open the desktop app or analyze a STAN/FSTAN model without the GUI.
%   stanly                        opens the application
%   result = stanly('beam.stan')   returns a self-contained result structure
%   stanly('beam.stan','out.mat')  also saves the result
if ~isdeployed
    addpath(fullfile(fileparts(mfilename('fullpath')),'src'));
end
if nargin == 0
    app = stanlyfea.App();
    if nargout > 0, result = app; end
    if isdeployed, waitfor(app.Figure); end
else
    result = stanlyfea.analyze(filename);
    if nargin > 1
        outputFile = char(outputFile);
        save(outputFile,'result');
    end
end
end
