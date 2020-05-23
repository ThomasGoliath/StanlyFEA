clear FF
md=zeros(ne,1);
ms=zeros(ne,1);
YS=zeros(ne,1);
UTS=zeros(ne,1);
q=zeros(ne,2);
Ktb=zeros(ne,2);
Ktt=zeros(ne,2);
for i=1:ne
    md(i)=sections(index(i,4),9);
    YS(i)=material(index(i,5),6);
    UTS(i)=material(index(i,5),7);
    ms(i)=material(index(i,5),8);
    Ktb(i,:)=notch(index(i,2:3),2).';
    Ktt(i,:)=notch(index(i,2:3),3).';
    q(i,:)=notch(index(i,2:3),4).';
end
Kfb=1+q.*(Ktb-1);
Kft=1+q.*(Ktt-1);

FF=zeros(size(SS,1),8);
FF(:,[2 6])=SS(:,[5 13])./(1-meanS(:,[7 15])./UTS);
FF(:,[3 7])=UTS*.5.*md.*ms./Kfb;
Bwohl=log10(.9.*Kfb./(.5.*md.*ms))/log10(1e3/1e7);
Awohl=.9*UTS./(1e3.^Bwohl);
FF(:,[4 8])=(FF(:,[2 6])./Awohl).^(1./Bwohl);
for i=1:length(FF(:,4))
    if FF(i,4)>1e7, FF(i,4)=1e7; end
    if FF(i,8)>1e7, FF(i,8)=1e7; end
end
for i=1:ne
    jf=[1 9]; kf=[3 7];
    for j=1:2
        if SS(i,jf(j))~=0
            sFAlim=FF(i,kf(j));
            salt=SS(i,jf(j))/(1-meanS(i,jf(j))/UTS(i));
        else
            sFAlim=YS(i);
            salt=meanS(i,jf(j));
        end
        if SS(i,jf(j)+1)~=0
            tFAlim=FF(i,kf(j));
            talt=SS(i,jf(j)+1)/(1-meanS(i,jf(j)+1)/UTS(i));
        else
            tFAlim=YS(i)/3;
            talt=meanS(i,jf(j)+1);
        end
        H=(sFAlim/tFAlim)^2;
        FF(i,kf(j)-2)=sqrt(salt.^2+H*talt.^2);
    end
end

% nominal
if sum(sum(notch(:,2:end)~=1))
    FFnom=zeros(size(SS,1),8);
    FFnom(:,[2 6])=SS(:,[5 13])./(1-meanS(:,[7 15])./UTS);
    FFnom(:,[3 7])=UTS*.5.*md.*ms./Kfb;
    Bwohl=log10(.9.*Kfb./(.5.*md.*ms))/log10(1e3/1e7);
    Awohl=.9*UTS./(1e3.^Bwohl);
    FFnom(:,[4 8])=(FFnom(:,[2 6])./Awohl).^(1./Bwohl);
    for i=1:length(FFnom(:,4))
        if FFnom(i,4)>1e7, FFnom(i,4)=1e7; end
        if FFnom(i,8)>1e7, FFnom(i,8)=1e7; end
    end
    for i=1:ne
        jf=[1 9]; kf=[3 7];
        for j=1:2
            if SS(i,jf(j))~=0
                sFAlim=FFnom(i,kf(j));
                salt=SS(i,jf(j))/(1-meanS(i,jf(j))/UTS(i));
            else
                sFAlim=YS(i);
                salt=meanS(i,jf(j));
            end
            if SS(i,jf(j)+1)~=0
                tFAlim=FFnom(i,kf(j));
                talt=SS(i,jf(j)+1)/(1-meanS(i,jf(j)+1)/UTS(i));
            else
                tFAlim=YS(i)/3;
                talt=meanS(i,jf(j)+1);
            end
            H=(sFAlim/tFAlim)^2;
            FFnom(i,kf(j)-2)=sqrt(salt.^2+H*talt.^2);
        end
    end
else
    FFnom=FF;
end

for i=1:ne
    eta(i,6+keta)=FF(i,[3 7])./FF(i,[1 5]); %gough_pollard
    eta(i,7+keta)=FF(i,[3 7])./FF(i,[2 6]); %sines
end
eta(eta==Inf)=-ones(size(eta(eta==Inf)));
eta(eta<0)=max(max(eta))*ones(size(eta(eta<0)));