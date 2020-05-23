function L=logs(text_file)
if ~strcmp(text_file(end-3:end),'.txt')
    text_file=strcat(text_file,'.txt');
end
b=fopen(text_file,'r');
L=[];
while (~feof(b))
    s=fgetl(b);
    a=L;
    L=strcat(a,s,'\n');
end
L=sprintf(L);
fclose(b);
end

