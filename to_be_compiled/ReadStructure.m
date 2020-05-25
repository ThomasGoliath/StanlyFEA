function readstr(fid)
global index bush
global dtab axx incl
global xyztab d_sca
global material notch
global sections
global Ftab L ang Ttab Qtab
global nn ne ndob ndof
global Kcorr springs
global Li Ri
global filetype
G=[]; clstart=0;
string=fgetl(fid);
while ~strcmp(string,'*start')
    string=fgetl(fid);
end
ctrl=1;
while ~strcmp(string,'*end')
    if nn>0&&ctrl
        dtab=zeros(nn,6); ctrl=0;
    end
    string=fgetl(fid);
    %% MESH
    % Nodes global coordinates matrix
    if strcmp(string,'nodes {')
        status_info('[ReadStructure] Reading "nodes" block')
		nl=clstart;
        while ~strcmp(string,'}')
		nl=nl+1;
            string=fgetl(fid);
            k=find(string=='%');
            if ~isempty(k)
                k=k(1); if k~=1, string(k:end)=[]; end
            end
            if ~isempty(string)
                if ~strcmp(string(1),'%')&&~strcmp(string(1),'}')
					rec=str2num(string);
					node_err_ctrl(rec,nl)
                    xyztab=[xyztab; rec];
                end
            end
        end
        nn=size(xyztab,1);
        notch=[(1:nn).' ones(nn,3)];
    end
    
    % Element index matrix
    if strcmp(string,'elements {')
        status_info('[ReadStructure] Reading "index" block')
        nl=clstart;
        while ~strcmp(string,'}')
		nl=nl+1;
            string=fgetl(fid);
            k=find(string=='%');
            if ~isempty(k)
                k=k(1); if k~=1, string(k:end)=[]; end
            end
            if ~isempty(string)
                if ~strcmp(string(1),'%')&&~strcmp(string(1),'}')
					rec=str2num(string);
					elem_err_ctrl(rec,nl)
                    index=[index; rec];
                end
            end
        end
        ne=size(index,1);
    end

    
    % Spring index matrix
    if strcmp(string,'springs {')
        status_info('[ReadStructure] Reading "springs" block')
        nl=clstart;
        while ~strcmp(string,'}')
            nl=nl+1;
            string=fgetl(fid);
            k=find(string=='%');
            if ~isempty(k)
                k=k(1); if k~=1, string(k:end)=[]; end
            end
            if ~isempty(string)
                if ~strcmp(string(1),'%')&&~strcmp(string(1),'}')
					rec=str2num(string);
					spri_err_ctrl(rec,nl)
                    springs=[springs; rec];
                end
            end
        end
    end
    
    % Notch matrix
    if strcmp(string,'notches {')
        status_info('[ReadStructure] Reading "notches" block')
        nl=clstart;
        while ~strcmp(string,'}')
            nl=nl+1;
            string=fgetl(fid);
            k=find(string=='%');
            if ~isempty(k)
                k=k(1); if k~=1, string(k:end)=[]; end
            end
            if ~isempty(string)
                if ~strcmp(string(1),'%')&&~strcmp(string(1),'}')
                    rec=str2num(string);
					notc_err_ctrl(rec,nl)
                    notch(rec(1),:)=rec;
                end
            end
        end
    end
    
    % Table of sections properties
    if strcmp(string,'sections {')
        status_info('[ReadStructure] Reading "sections" block')
        nl=clstart;
        while ~strcmp(string,'}')
            nl=nl+1;
            string=fgetl(fid);
            k=find(string=='%');
            if ~isempty(k)
                k=k(1); if k~=1, string(k:end)=[]; end
            end
            if ~isempty(string)
                if ~strcmp(string(1),'%')&&~strcmp(string(1),'}')
					rec=str2num(string);
					sect_err_ctrl(rec,nl)
                    sections=[sections; rec];
                end
            end
        end
    end
    
    % Table of material properties
    if strcmp(string,'materials {')
        status_info('[ReadStructure] Reading "materials" block')
        nl=clstart;
        while ~strcmp(string,'}')
            nl=nl+1;
            string=fgetl(fid);
            k=find(string=='%');
            if ~isempty(k)
                k=k(1); if k~=1, string(k:end)=[]; end
            end
            if ~isempty(string)
                if ~strcmp(string(1),'%')&&~strcmp(string(1),'}')
					rec=str2num(string);
					mate_err_ctrl(rec,nl)
                    material=[material; rec];
                end
            end
        end
    end
    
    %% CONSTRAINTS
    % DOF matrix
    if strcmp(string,'ground constraints {')
        status_info('[ReadStructure] Reading "ground constraints" block')
        nl=clstart;
        while ~strcmp(string,'}')
            nl=nl+1;
            string=fgetl(fid);
            k=find(string=='%');
            if ~isempty(k)
                k=k(1); if k~=1, string(k:end)=[]; end
            end
            if ~isempty(string)
                if ~strcmp(string(1),'%')&&~strcmp(string(1),'}')
                    rec=str2num(string);
					gcon_err_ctrl(rec,nl)
                    for i=1:6
                        if rec(i+1)==Inf
                            dtab(rec(1),i)=-1;
                        elseif rec(i+1)~=0
                            Kcorr=[Kcorr; rec(1) i rec(i+1)];
                        end
                    end
                    if length(rec)>7
                        if sum(rec(8:9)~=0)
                            incl=[incl; rec([1 8 9])];
                        end
                    end
                end
            end
        end
    end
    if strcmp(string,'internal constraints {')
        status_info('[ReadStructure] Reading "internal constraints" block')
        nl=clstart;
        while ~strcmp(string,'}')
            nl=nl+1;
            string=fgetl(fid);
            k=find(string=='%');
            if ~isempty(k)
                k=k(1); if k~=1, string(k:end)=[]; end
            end
            if ~isempty(string)
                if ~strcmp(string(1),'%')&&~strcmp(string(1),'}')
                    rec=str2num(string);
                    icon_err_ctrl(rec,nl)
                    axx=[axx; rec];
                    rec([false false rec(3:8)<Inf])=0; rec(rec==Inf)=1;
                    dtab(rec(2),:)=rec(3:8)*rec(1);
                end
            end
        end
    end
    
    % Yielded constraints matrix
    if strcmp(string,'yielded constraints {')
        status_info('[ReadStructure] Reading "yielded constraints" block')
        nl=clstart;
        while ~strcmp(string,'}')
            nl=nl+1;
            string=fgetl(fid);
            k=find(string=='%');
            if ~isempty(k)
                k=k(1); if k~=1, string(k:end)=[]; end
            end
            if ~isempty(string)
                if ~strcmp(string(1),'%')&&~strcmp(string(1),'}')
                    rec=str2num(string);
                    ycon_err_ctrl(rec,nl)
                    bush=[bush; rec];
                end
            end
        end
    end
    
    %% LOADS
    % Loads matrix
    if strcmp(string,'nodal loads {')
        status_info('[ReadStructure] Reading "nodal loads" block')
        nl=clstart;
        while ~strcmp(string,'}')
            nl=nl+1;
            string=fgetl(fid);
            k=find(string=='%');
            if ~isempty(k)
                k=k(1); if k~=1, string(k:end)=[]; end
            end
            if ~isempty(string)
                if ~strcmp(string(1),'%')&&~strcmp(string(1),'}')
                    rec=str2num(string);
                    nloa_err_ctrl(rec,nl)
                    Ftab=[Ftab; rec];
                end
            end
        end
    end
    
    % Thermal variations matrix
    if strcmp(string,'thermal variations {')
        status_info('[ReadStructure] Reading "thermal variations" block')
        nl=clstart;
        while ~strcmp(string,'}')
            nl=nl+1;
            string=fgetl(fid);
            k=find(string=='%');
            if ~isempty(k)
                k=k(1); if k~=1, string(k:end)=[]; end
            end
            if ~isempty(string)
                if ~strcmp(string(1),'%')&&~strcmp(string(1),'}')
                    rec=str2num(string);
                    tloa_err_ctrl(rec,nl)
                    Ttab=[Ttab; rec];
                end
            end
        end
    end
    
    % Distributed loads matrix
    if strcmp(string,'distributed loads {')
        status_info('[ReadStructure] Reading "distributed loads" block')
        nl=clstart;
        while ~strcmp(string,'}')
            nl=nl+1;
            string=fgetl(fid);
            k=find(string=='%');
            if ~isempty(k)
                k=k(1); if k~=1, string(k:end)=[]; end
            end
            if ~isempty(string)
                if ~strcmp(string(1),'%')&&~strcmp(string(1),'}')
					rec=str2num(string);
                    dloa_err_ctrl(rec,nl)
                    Qtab=[Qtab; rec];
                end
            end
        end
    end	
    
    % Mesh control
    if strcmp(string,'mesh control {')
        status_info('[ReadStructure] Reading "mesh control" block')
        nl=clstart;
        while ~strcmp(string,'}')
            nl=nl+1;
            string=fgetl(fid);
            k=find(string=='%');
            if ~isempty(k)
                k=k(1); if k~=1, string(k:end)=[]; end
            end
            if ~isempty(string)
                if ~strcmp(string(1),'%')&&~strcmp(string(1),'}')
                    rec=str2num(string);
                    mesh_err_ctrl(rec,nl)
					if ~isempty(Qtab), old_q=Qtab(:,1); else, old_q=[]; end
                    if ~sum(old_q==rec(1))
                        Qtab=[Qtab; rec(1) zeros(1,6) rec(end)];
                    end
                end
            end
        end
    end
    
    % Gravity
    if strcmp(string,'gravity {')
        status_info('[ReadStructure] Reading "gravity" block')
        gg=1; nl=clstart;
        while ~strcmp(string,'}')
            nl=nl+1;
            string=fgetl(fid);
            k=find(string=='%');
            if ~isempty(k)
                k=k(1); if k~=1, string(k:end)=[]; end
            end
            if ~isempty(string)
                if ~strcmp(string(1),'%')&&~strcmp(string(1),'}')&&gg
                    rec=str2num(string);
                    grav_err_ctrl(rec,nl,G)
                    G=[G; rec];
                    gg=0;
                end
            end
        end
    end
end
glob_err_ctrl

% Length and angles
status_info('[ReadStructure] Computing element length and orientation')
L=zeros(ne,1); ang=zeros(ne,2);
for i=1:size(index,1)
    rel_coord=xyztab(index(i,3),2:4)-xyztab(index(i,2),2:4);
    sph_coord=cart2sph(rel_coord).';
    L(i)=sph_coord(1);
    ang(i,:)=sph_coord(2:3);
end
ang=[ang index(:,end)*pi/180]; index(:,end)=[];

% Local to global matrices
status_info('[ReadStructure] Building local reference rotation matrices')
Li=zeros(12,12,ne);
Ri=zeros(3,3,ne);
for i=1:ne
    Ru=rotmat(-ang(i,3),1);
    Ry=rotmat(-ang(i,2)+pi/2,2);
    Rz=rotmat(-ang(i,1),3);
    R=Ru*Ry*Rz;
    Ri(:,:,i)=R;
    R=[R zeros(3,9); zeros(3) R zeros(3,6)
        zeros(3,6) R zeros(3);zeros(3,9) R];
    Li(:,:,i)=R;
end

% Distributed loads and gravity correction
d_sca=[max(xyztab(:,2))-min(xyztab(:,2))
    max(xyztab(:,3))-min(xyztab(:,3))
    max(xyztab(:,4))-min(xyztab(:,4))];
d_sca=max(d_sca);
if ~isempty(G)
    status_info('[ReadStructure] Gravity correction')
    gravity(G);
end
if ~isempty(Qtab)
    status_info('[ReadStructure] Distributed loads correction')
    distrol_corr;
end

% dtab construction
status_info('[ReadStructure] Building DoFs martrix')
ndof=sum(sum(dtab==0));
ndob=nn*6-ndof;
dtab=dtab.';
dtab((dtab==-1))=(ndof+1):(ndof+sum(sum(dtab==-1)));
dtab((dtab==0))=1:ndof;
dtab=dtab.';
if ~isempty(axx)
    status_info('[ReadStructure] Enslavements correction')
    for i=1:size(axx,1)
        for j=3:8
            if axx(i,j)==Inf
                dtab(axx(i,2),j-2)=dtab(axx(i,1),j-2);
            end
        end
    end
end

% Spring matrix construction
if ~isempty(springs)
    status_info('[ReadStructure] Springs matrix construction')
end
springs=[springs zeros(size(springs,1),2)];
for i=1:size(springs,1)
    rel_coord=xyztab(springs(i,3),2:4)-xyztab(springs(i,2),2:4);
    sph_coord=cart2sph(rel_coord).';
    springs(i,5:6)=sph_coord(2:3);
end
status_info('[ReadStructure] Stop reading')
end