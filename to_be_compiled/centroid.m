function CM=centroid(xc,yc,lim)
r=0.02*lim; n=100;
t=linspace(0,pi/2,n/4);
sh=[0 1 2 3]*pi/2;
CM=gobjects(1,4);
c='kwkw';
for i=1:4
    x=xc+[0 r*cos(t+sh(i)) 0];
    z=yc+[0 r*sin(t+sh(i)) 0];
    CM(i)=patch(x,zeros(size(x)),z,c(i));
end
set(CM,'EdgeColor','k','LineWidth',1)
set(CM,'PickableParts','none')
end

