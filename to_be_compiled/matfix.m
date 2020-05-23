function [X,k,m]=matfix(x,v)
%%
%  [X,i]=MATFIX(x,v)
%   x is the value we want to fix, v is a vector. This function round x
%   with the closest value of v and returns the rounded value X and his
%   location i on the vector v.
%
[nx,dimx]=size(x); [~,dimv]=size(v);

if dimx~=dimv
    error('The dimensions of the points must be the same')
end

k=zeros(nx,1);
m=zeros(nx,1);
for j=1:nx
    D=0;
    for z=1:dimv
        D=D+(x(j,z)-v(:,z)).^2;
    end
    D=sqrt(D);
    [m(j),k(j)]=min(D);
end

X=v(k,:);
