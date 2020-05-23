function distrol_corr
global index xyztab dtab ang L Ftab ne nn Ttab Li Ri
global Qtab ph_nodes ph_elems d_sca notch sections material
N=size(Qtab,1); Qtab=[Qtab zeros(N,2)];
for  i=1:N
    % defining load
    el=Qtab(i,1); res=Qtab(i,8); info=index(el,:); Qtab(i,9:10)=info(2:3);
    E=material(index(el,5),2);
    v=material(index(el,5),3);
    G=E/2/(1+v);
    A=sections(index(el,5),2);
    Jv=sections(index(el,4),3);
    Jw=sections(index(el,4),4);
    tv=sections(index(el,4),7);
    tw=sections(index(el,4),8);
    if res==0, res=floor(22/d_sca*L(el)); end
    Lk=L(el)/(res+1); th=ang(el,1); ph=ang(el,2);
    L=[L; ones(res,1).*Lk]; L(el)=Lk;
    ang=[ang; zeros(res,3)+ang(el,:)]; index(el,3)=nn+1;
    z=Lk*cos(ph); x=Lk*sin(ph)*cos(th); y=Lk*sin(ph)*sin(th);
    R=Li(1:6,1:6,el).';
    cel=el;
    
    %mesh correction
    for j=1:res
        dtab=[dtab; zeros(1,6)];
        coord=[x y z];
        ph_nodes=[ph_nodes; nn+j];
        cel=[cel; ne+j];
        xyztab=[xyztab; [nn+j xyztab(info(2),2:4)+j*coord]];
        notch=[notch; [nn+j ones(1,size(notch,2)-1)]];
        index=[index; [ne+j nn+j nn+j+1 info(4:5)]];
        Li(:,:,ne+j)=Li(:,:,el);
        Ri(:,:,ne+j)=Ri(:,:,el);
    end
    ph_elems=[ph_elems; cel];
    index(end,3)=info(3);
    if ~isempty(Ttab)
        kk=find(Ttab(:,1)==el);
        if ~isempty(kk)
            for j=1:length(kk)
                tinfo=Ttab(kk(j),2:end);
                for k=1:res
                    Ttab=[Ttab; [ne+k tinfo]];
                end
            end
        end
    end
    nn=nn+res; ne=ne+res;
    
    % equivalent nodal loads
    a=Lk/12/E/Jw;   b=tv/A/G/Lk;    fv=b/(a+b);
    a=Lk/12/E/Jv;   b=tw/A/G/Lk;    fw=b/(a+b);
    q_ax=Qtab(i,2);                     q_to=Qtab(i,7);
    q_v1=Qtab(i,3);                     q_w1=Qtab(i,5);
    rv=diff(Qtab(i,3:4))/(res+1);       rw=diff(Qtab(i,5:6))/(res+1);
    for j=1:res+1
        q_vj=q_v1+[j-1 j]*rv;
        q_wj=q_w1+[j-1 j]*rw;
        [~,jjv]=min(q_vj);
        [~,jjw]=min(q_wj);
        q_const=[q_vj(jjv) q_wj(jjw)];
        q_trian=[diff(q_vj) diff(q_wj)];
        fneq_c=zeros(2,6);
        fneq_c(1,:)=[q_ax/2  q_const/2	q_to/2  [-q_const(2) q_const(1)]*Lk/12];
        fneq_c(2,:)=[q_ax/2  q_const/2	q_to/2  [q_const(2) -q_const(1)]*Lk/12];
        fneq_t=zeros(2,6);
        fneq_t(:,2:3)=fneq_t(:,2:3)+q_trian*7/20;
        fneq_t(jjv,2)=fneq_t(jjv,2)-q_trian(1)/5;
        fneq_t(jjw,3)=fneq_t(jjw,3)-q_trian(2)/5;
        fneq_t(1,5:6)=fneq_t(1,5:6)-[q_trian(2) -q_trian(1)]*Lk/20;
        fneq_t(2,5:6)=fneq_t(2,5:6)-[-q_trian(2) q_trian(1)]*Lk/20;
        fneq_t(jjv,6)=fneq_t(jjv,6)+(-1)^jjv*q_trian(1)*Lk/60;
        fneq_t(jjw,5)=fneq_t(jjw,5)-(-1)^jjw*q_trian(2)*Lk/60;
        % timoshenko
        fneq_t(jjv,2)=fneq_t(jjv,2)*(1+fv/9);
        fneq_t(jjv,6)=fneq_t(jjv,6)*(1+fv/4);
        fneq_t(jjw,3)=fneq_t(jjw,3)*(1+fw/9);
        fneq_t(jjw,5)=fneq_t(jjw,5)*(1+fw/4);
        fneq_t(1:2~=jjv,2)=fneq_t(1:2~=jjv,2)*(1-fv/21);
        fneq_t(1:2~=jjv,6)=fneq_t(1:2~=jjv,6)*(1-fv/6);
        fneq_t(1:2~=jjw,3)=fneq_t(1:2~=jjw,3)*(1-fw/21);
        fneq_t(1:2~=jjw,5)=fneq_t(1:2~=jjw,5)*(1-fw/6);
        %
        fneq=fneq_c+fneq_t;
        fneq=Lk*fneq*R.';
        if ~isempty(Ftab)
            kkf=find(Ftab(:,1)==index(cel(j),2));
        else
            kkf=[];
        end
        if ~isempty(kkf)
            Ftab(kkf(1),2:7)=Ftab(kkf(1),2:7)+fneq(1,:);
        else
            Ftab=[Ftab; [index(cel(j),2) fneq(1,:)]];
        end
        kkf=find(Ftab(:,1)==index(cel(j),3));
        if ~isempty(kkf)
            Ftab(kkf(1),2:7)=Ftab(kkf(1),2:7)+fneq(2,:);
        else
            Ftab=[Ftab; [index(cel(j),3) fneq(2,:)]];
        end
    end
end

end

