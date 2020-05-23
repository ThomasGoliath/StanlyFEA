function status_info(string,user)
if nargin==1
	user=0;
end
if user
	fprintf('[%04i/%02i/%02i %02i:%2i:%02.0f] [USER] %s (%.4f)\n',clock,string,cputime)
else
	fprintf('[%04i/%02i/%02i %02i:%02i:%02.0f] %s (%.4f)\n',clock,string,cputime)
end