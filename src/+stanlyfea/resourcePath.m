function folder = resourcePath(name)
%RESOURCEPATH Resolve bundled read-only assets independently of working directory.
if isdeployed
    root = ctfroot;
    folder = fullfile(root,name);
    if ~isfolder(folder)
        entry = which('stanly');
        folder = fullfile(fileparts(entry),name);
    end
else
    root = fileparts(fileparts(fileparts(mfilename('fullpath'))));
    folder = fullfile(root,name);
end
if ~isfolder(folder), error('Stanly:Resource','Missing resource folder: %s',folder); end
end
