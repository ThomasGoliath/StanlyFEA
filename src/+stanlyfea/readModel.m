function model = readModel(filename)
%READMODEL Read a STAN/FSTAN file without global state or code evaluation.
filename = char(filename);
[fid, message] = fopen(filename, 'rt');
if fid < 0, error('Stanly:FileOpen', '%s: %s', filename, message); end
cleanup = onCleanup(@() fclose(fid)); %#ok<NASGU>
[~, ~, extension] = fileparts(filename);
if ~ismember(lower(extension), {'.stan', '.fstan'})
    error('Stanly:FileType', 'Only .stan and .fstan models are supported.');
end
model.SchemaVersion = 1;
model.Filename = filename;
model.IsFatigue = strcmpi(extension, '.fstan');
model.Title = '';
names = {'nodes', 'elements', 'springs', 'mesh control', 'sections', ...
    'materials', 'notches', 'ground constraints', 'internal constraints', ...
    'yielded constraints', 'nodal loads', 'distributed loads', ...
    'thermal variations', 'gravity'};
widths = {[4], [6], [4], [2], [8 9], [7 8], [4], [7 9], ...
    [8], [7], [7], [8], [5], [3]};
blocks = cell(size(names));
for i = 1:numel(blocks), blocks{i} = zeros(0, max(widths{i})); end
started = false; ended = false; active = 0; lineNumber = 0;
while true
    line = fgetl(fid);
    if ~ischar(line), break; end
    lineNumber = lineNumber + 1;
    if lineNumber == 1, model.Title = strtrim(line); end
    line = strtrim(regexprep(line, '%.*$', ''));
    if isempty(line), continue; end
    if strcmpi(line, '*start')
        if started, fail('Duplicate *start marker'); end
        started = true; continue
    end
    if ~started, continue; end
    if strcmpi(line, '*end')
        if active ~= 0, fail('Unclosed data block'); end
        ended = true; break
    end
    if active == 0
        header = regexp(line, '^(.+?)\s*\{$', 'tokens', 'once');
        if isempty(header)
            if line(1) == '-' || strncmp(line, '>>>', 3), continue; end
            fail('Expected a block header');
        end
        active = find(strcmpi(strtrim(header{1}), names), 1);
        if isempty(active), fail('Unknown block'); end
    elseif strcmp(line, '}')
        active = 0;
    else
        fields = regexp(line, '[\s,]+', 'split');
        if ~ismember(numel(fields), widths{active}), fail('Wrong column count'); end
        record = zeros(1, max(widths{active}));
        if ismember(active, [5 6]), record(end) = 1; end
        try
            for i = 1:numel(fields), record(i) = stanlyfea.number(fields{i}); end
        catch exception
            fail(exception.message);
        end
        blocks{active}(end+1, :) = record;
    end
end
if ~started || ~ended, fail('Missing *start or *end marker'); end
model.Mesh.Nodes = blocks{1};
model.Mesh.Elements = blocks{2};
model.Mesh.Springs = blocks{3};
model.Mesh.Refinement = blocks{4};
model.Properties.Sections = blocks{5};
model.Properties.Materials = blocks{6};
model.Properties.Notches = blocks{7};
model.Constraints.Ground = blocks{8};
model.Constraints.Internal = blocks{9};
model.Constraints.Prescribed = blocks{10};
model.Loads.Nodal = blocks{11};
model.Loads.Distributed = blocks{12};
model.Loads.Thermal = blocks{13};
model.Loads.Gravity = blocks{14};
stanlyfea.validateModel(model);

    function fail(message)
        error('Stanly:Parse', '%s:%d: %s. [%s]', ...
            filename, lineNumber, message, line);
    end
end
