function form = FormatString(unform,elements)
%% form = FormatString(unform, elements)
% Something like sprintf but with cell arguments
%

nperc = length(strfind(unform,'%'));

if nperc~=length(elements)
    error('Format elements do not match with string')
end

form = unform;
for i = 1:nperc
    jperc = [strfind(form,'%') length(form)];
    thisperc = jperc(1);
    nextperc = jperc(2);
    first = form(1:thisperc-1);
    second = form(thisperc:nextperc-1);
    third = form(nextperc:end);
    second = sprintf(second,cell2mat(elements(i)));
    form = [first second third];
end