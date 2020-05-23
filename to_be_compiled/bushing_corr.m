function [K,F]=bushing_corr(K,F)
global dtab bush
if ~isempty(bush)
    for i=1:size(bush,1)
        for j=1:6
            if bush(i,j+1)~=0
                k=dtab(bush(i,1),j);
                K(k,:)=zeros(size(K(k,:)));
                F=F-K(:,k)*bush(i,j+1);
                K(:,k)=zeros(size(K(:,k)));
                K(k,k)=1; F(k)=bush(i,j+1);
            end
        end
    end
end

end

