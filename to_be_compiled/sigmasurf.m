function sigmasurf(shape,prop,N,M1,M2,M3,k,fig)
global mt cg cbf
n=500; ms=6;
J2=prop(2);
J3=prop(3);
W2=prop(4);
W3=prop(5);
A=prop(1);
Jp=J2+J3;
ttl={'Axial \sigma_u';'Shear \tau_u_v';...
    'Maximum principal \sigma_2';'Minimum principal \sigma_1';...
    'Von Mises \sigma*_V_M';'Guest-Tresca \sigma*_G_T';...
    'First invariant I_\sigma_1';'Third invariant I_\sigma_3'};
if k~=8, labl='S [fu]/[lu]^2'; else, labl='S [fu]^2/[lu]^4'; end
c_ticks=16;

% Shape
%   1   Circular\Pipe
%   2   Rectangular\Box
%   3   Hexagonal
%   4   Trapezoidal
%   5   I
%   6   T
%   7   L
%   8   C

switch shape
    case 1
        %% Pipe
        if J2~=J3||W2~=W3, error('Not matching properites'); end
        de=2*J2/W2; di=sqrt(-4*A/pi+de^2); if ~isreal(di), di=0; end
        n=n*(de-di)/de;
        r=linspace(di/2,de/2,n);
        t=linspace(0,2*pi,n);
        V=zeros(n); W=zeros(n); S=zeros(n);
        for i=1:n
            for j=1:n
                v=r(i)*cos(t(j));
                w=r(i)*sin(t(j));
                [V(i,j),W(i,j),S(i,j)]=Scalc(k,N,M1,M2,M3,A,Jp,J2,J3,v,w,r(i));
            end
        end
    case 2
        %% Box
        he=2*J2/W2; be=2*J3/W3; m=floor(n/be*he);
        H3=he^3*be/12-J2; H2=he*be^3/12-J3;
        bi=(H2^3*144/H3)^(1/8);
        if ~isreal(bi), bi=0; end, hi=H2*12/bi^3;
        %if isnan(bi)||bi==inf||bi==0, bi=0; hi=0; end
        v=linspace(-be/2,be/2,n);
        w=linspace(-he/2,he/2,m);
        for i=1:n
            for j=1:m
                if abs(v(i))<bi/2 && abs(w(j))<hi/2
                    V(i,j)=nan;
                    W(i,j)=nan;
                    S(i,j)=nan;
                else
                    [V(i,j),W(i,j),S(i,j)]=Scalc(k,N,M1,M2,M3,A,Jp,J2,J3,v(i),w(j));
                end
            end
        end
    case 3
        %% Hexagonal
        if J2~=J3, error('Not matching properites'); end
        t2=J2/W2;
        t1=sqrt((sqrt(3)*3/2*t2^2-A)*2/3/sqrt(3));
        if ~isreal(t1), t1=0; end
        m=n/cosd(30);
        v=linspace(-t2,t2,n)*cosd(30);
        w=linspace(-t2,t2,m);
        for i=1:n
            for j=1:m
                condition=0;
                if abs(w(j))>abs(-abs(v(i))/2/cosd(30)+t2)
                    condition=1;
                elseif abs(v(i))<t1*cosd(30)&&abs(w(j))<t1
                    if abs(w(j))<abs(-abs(v(i))/2/cosd(30)+t1)
                        condition=1;
                    end
                end
                if condition
                    V(i,j)=nan;
                    W(i,j)=nan;
                    S(i,j)=nan;
                else
                    [V(i,j),W(i,j),S(i,j)]=Scalc(k,N,M1,M2,M3,A,Jp,J2,J3,v(i),w(j));
                end
            end
        end
    case 4
        %% Trapezoidal
        b=2*J3/W3;
        a=(12*((A*(- A*b^2 + 24*J3))/144)^(1/2))/A;
        if ~isreal(a), a=0; end
        h=2*A/(a+b); m=n/b*h;
        yb=J2/W2;
        v=linspace(-b/2,b/2,n);
        w=linspace(-h,0,m)+yb;
        if max(w)<0, error('Not matching properites'); end
        if min(w)<0, error('Not matching properites'); end
        if max(v)<0, error('Not matching properites'); end
        if min(v)<0, error('Not matching properites'); end
        for i=1:n
            for j=1:m
                condition=0;
                if abs(v(i))>a/2
                    if w(j)>2*h/(a-b)*(abs(v(i))-a/2)+yb
                        condition=1;
                    end
                end
                if condition
                    V(i,j)=nan;
                    W(i,j)=nan;
                    S(i,j)=nan;
                else
                    [V(i,j),W(i,j),S(i,j)]=Scalc(k,N,M1,M2,M3,A,Jp,J2,J3,v(i),w(j));
                end
            end
        end
    case 5
        %% I profile
        h=2*J2/W2; b=2*J3/W3; m=n/b*h;
        e=(24*J3*h - 3*A^2*b - (-(A - b*h)^3*(h*b^3 + 3*A*b^2 - 48*J3))^(1/2) + b^3*h^2)/(8*h*b^3 - 12*A*b^2 + 48*J3);
        if ~isreal(e)||e<0, e=[]; end
        a=(A-2*e*b)./(h-2*e);
        v=linspace(-b/2,b/2,n);
        w=linspace(-h/2,h/2,m);
        for i=1:n
            for j=1:m
                if abs(v(i))>a/2 && abs(w(j))<(h-e)/2
                    V(i,j)=nan;
                    W(i,j)=nan;
                    S(i,j)=nan;
                else
                    [V(i,j),W(i,j),S(i,j)]=Scalc(k,N,M1,M2,M3,A,Jp,J2,J3,v(i),w(j));
                end
            end
        end
    case 6
        %% T profile
        b=2*J3/W3;
        cc=[12*J3*W2^2*b^2 - A*W2^2*b^4
            - 2*A^2*W2^2*b^3 + 4*J2*A*W2*b^4
            2*A^3*W2^2*b^2 - 48*J2*J3*A*W2*b
            A^4*W2^2*b - 4*A^2*J2^2*b^3
            - A^5*W2^2 + 48*J3*A^2*J2^2];
        e=roots(cc); e=e(4);
        if ~isreal(e)||e<0, e=[]; end
        h=(2*J2/W2*A-b*e^2)/(A+b*e); m=n*h/b;
        a=(A-e*b)./h;
        yb=J2/W2;
        v=linspace(-b/2,b/2,n);
        w=linspace(0,h+e,m)-yb;
        if max(w)<0, error('Not matching properites'); end
        if min(w)<0, error('Not matching properites'); end
        if max(v)<0, error('Not matching properites'); end
        if min(v)<0, error('Not matching properites'); end
        for i=1:n
            for j=1:m
                if abs(v(i))>a/2 && w(j)<(h-yb)
                    V(i,j)=nan;
                    W(i,j)=nan;
                    S(i,j)=nan;
                else
                    [V(i,j),W(i,j),S(i,j)]=Scalc(k,N,M1,M2,M3,A,Jp,J2,J3,v(i),w(j));
                end
            end
        end
    case 8
        %% C profile
        b=2*J3/W3;
        cc=[12*J3*W2^2*b^2 - A*W2^2*b^4
            - 2*A^2*W2^2*b^3 + 4*J2*A*W2*b^4
            2*A^3*W2^2*b^2 - 48*J2*J3*A*W2*b
            A^4*W2^2*b - 4*A^2*J2^2*b^3
            - A^5*W2^2 + 48*J3*A^2*J2^2];
        e=roots(cc); e=e(4);
        if ~isreal(e)||e<0, e=[]; end
        h=(2*J2/W2*A-b*e^2)/(A+b*e); m=n*h/b;
        a=(A-e*b)./h;
        yb=J2/W2;
        v=linspace(-b/2,b/2,n);
        w=linspace(0,h+e,m)-yb;
        if max(w)<0, error('Not matching properites'); end
        if min(w)<0, error('Not matching properites'); end
        if max(v)<0, error('Not matching properites'); end
        if min(v)<0, error('Not matching properites'); end
        for i=1:n
            for j=1:m
                if abs(v(i))>a/2 && w(j)<(h-yb)
                    V(i,j)=nan;
                    W(i,j)=nan;
                    S(i,j)=nan;
                else
                    [V(i,j),W(i,j),S(i,j)]=Scalc(k,N,M1,M2,M3,A,Jp,J2,J3,v(i),w(j));
                end
            end
        end
end

%% Plotting
SEC=surf(V,zeros(size(S)),W,S); hold on
maxim=max(max(S));
minim=min(min(S));
axis equal
view([0 0])
set(SEC,'EdgeColor','none')
grid on
grid minor
xlabel('V [lu]'), zlabel('W [lu]')
title(ttl(k))
if maxim==0&&minim==0
    maxim=1; minim=-1;
end
limsc=[-1 1]*max(abs([maxim minim]));
if k==5||k==6||k==2, limsc(1)=0; end
caxis(limsc)
colormap jet
shading interp
cbf=colorbar('Ticks',linspace(limsc(1),limsc(2),c_ticks),...
    'TickLabels',sprintf('%+.3e\n',linspace(limsc(1),limsc(2),c_ticks)),...
    'FontSize',7.5);
cbf.Label.String=labl;
cbf.Label.FontSize=10;
cbf.Label.Position(1)=cbf.Label.Position(1)-5.4;
dcm=datacursormode(fig);
set(dcm,'updatefcn',@myfunction)
set(fig,'Color',rgb(220,220,220))
set(gca,'Box','on')
set(fig,'MenuBar','none','ToolBar','figure')
set(findall(fig,'ToolTipString','New Figure'),'Visible','Off')
set(findall(fig,'ToolTipString','Open File'),'Visible','Off')
set(findall(fig,'ToolTipString','Print Figure'),'Visible','Off')
set(findall(fig,'ToolTipString','Edit Plot'),'Visible','Off','Separator','off')
set(findall(fig,'ToolTipString','Rotate 3D'),'Visible','Off')
set(findall(fig,'ToolTipString','Brush/Select Data'),'Visible','Off')
set(findall(fig,'ToolTipString','Link Plot'),'Visible','Off','Separator','off')
set(findall(fig,'ToolTipString','Insert Legend'),'Visible','Off')
set(findall(fig,'ToolTipString','Insert Colorbar'),'Visible','Off')
set(findall(fig,'ToolTipString','Hide Plot Tools'),'Visible','Off','Separator','off')
set(findall(fig,'ToolTipString','Show Plot Tools and Dock Figure'),'Visible','Off')
set(findall(fig,'ToolTipString','Link/Unlink Plot'),'Visible','Off','Separator','off')
set(findall(fig,'ToolTipString','Open Property Inspector'),'Visible','Off')
[maxi,maxj]=find(S==max(max(S))); maxi=maxi(1); maxj=maxj(1);
mappa=jet; mappa=mappa([1 end],:);
mt(1)=plot3(V(maxi,maxj),0,W(maxi,maxj),'o','MarkerSize',ms,...
    'MarkerFaceColor',mappa(2,:),'MarkerEdgeColor','w','UserData',max(max(S)));
[mini,minj]=find(S==min(min(S))); mini=mini(1); minj=minj(1);
mt(2)=plot3(V(mini,minj),0,W(mini,minj),'o','MarkerSize',ms,...
    'MarkerFaceColor',mappa(1,:),'MarkerEdgeColor','w','UserData',min(min(S)));
cg=centroid(0,0,max([diff(xlim) diff(zlim)]));
uitoggletool(findall(fig,'Type','uitoolbar'),'CData',...
    imread('.\colorbar.png','BackgroundColor',[1 1 .8]),...
    'ToolTipString','Colorbar',...
    'OnCallback',@setcbon,'OffCallback',@setcboff,'State','on');
uitoggletool(findall(fig,'Type','uitoolbar'),'CData',...
    imread('.\maxmintip.png','BackgroundColor',[1 1 .8]),...
    'ToolTipString','Maximum and Minimum Tips',...
    'OnCallback',@setmton,'OffCallback',@setmtoff,'State','on');
uitoggletool(findall(fig,'Type','uitoolbar'),'CData',...
    imread('.\centroid.png','BackgroundColor',[1 1 .8]),...
    'ToolTipString','Center of Mass',...
    'OnCallback',@setcgon,'OffCallback',@setcgoff,'State','on');
end

function setcbon(src,event)
global cbf
set(cbf,'Visible','on')
end

function setcboff(src,event)
global cbf
set(cbf,'Visible','off')
end

function setmton(src,event)
global mt
    set(mt,'Visible','on')
end

function setmtoff(src,event)
global mt
    set(mt,'Visible','off')
end

function setcgon(src,event)
global cg
    set(cg,'Visible','on')
end

function setcgoff(src,event)
global cg
    set(cg,'Visible','off')
end

function output_txt = myfunction(obj,event_obj)
    targ = get(event_obj,'Target');
    pos=get(event_obj,'Position');
    if isa(targ,'matlab.graphics.chart.primitive.Line')
        col=get(targ,'UserData');
        output_txt = {['v ;',num2str(pos(1),'%.3f')];
            ['w : ',num2str(pos(3),'%.3f')];
            ['S : ',num2str(col,'%10.7e')]};
    else
        x=get(targ,'XData');
        y=get(targ,'ZData');
        bool=(x==pos(1)).*(y==pos(3));
        [kx,ky]=find(bool);
        col=get(targ,'CData');
        output_txt = {['v ;',num2str(pos(1),'%.3f')];
            ['w : ',num2str(pos(3),'%.3f')];
            ['S : ',num2str(col(kx,ky),'%10.7e')]};
    end
end