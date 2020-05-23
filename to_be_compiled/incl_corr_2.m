function x=incl_corr_2(x)
global incl ndof dtab
if ~isempty(incl)
    for i=1:size(incl,1)
        node=incl(i,1); th=incl(i,2)*pi/180; ph=incl(i,3)*pi/180;
        R=[rotmat(th,3) zeros(3); zeros(3) rotmat(th,3)];
        R=R*[rotmat(ph,2) zeros(3); zeros(3) rotmat(ph,2)];
        kk=1:max(max(dtab)); jj=dtab(node,:); kk(jj)=[];
        x(jj)=R.'*x(jj);
    end
end