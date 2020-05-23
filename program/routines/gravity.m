function gravity(G)
global Qtab Ri material ne index
for i=1:ne
    if ~isempty(Qtab)
        n=find(Qtab(:,1)==i);
    else
        n=[];
    end
    A=(G*material(index(i,5),5))*Ri(:,:,i).';
    A=[A(1) A(2) A(2) A(3) A(3)];
    if ~isempty(n)
        Qtab(n,2:6)=Qtab(n,2:6)+A;
    else
        Qtab=[Qtab; [i A 0 0]];
    end
end