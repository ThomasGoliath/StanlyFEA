function v=rgb(R,G,B,string)
%%
%  v=RGB(R,G,B)
%   this function create the right colormap vector for matlab, using the
%   informations given by every common RGB colormap code.
%   Put string='s' if you want the output like a string
%
if nargin==3
    string=0;
end

v=[R/255    G/255   B/255];
if string
    v=strcat('[',num2str(v),']');
end
end