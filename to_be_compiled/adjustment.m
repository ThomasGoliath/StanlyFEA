h=get(gcf,'Children');
bb=true(size(h));
for i=1:length(h)
    if isa(h(i),'matlab.graphics.axis.Axes')
        bb(i)=false;
    end
end
h(bb)=[];
set(gca,'Visible','off')
set(gca,'Clipping','off')
set(gca,'XLim',XLIM)
set(gca,'YLim',YLIM)
set(gca,'ZLim',ZLIM)
set(h,'View',[AZ EL])