function ReadStructure(fid)

global Mesh
global Constraints
global Loads
global Properties
global FileManager

global d_sca
G=[]; clstart=0;
string=fgetl(fid);
while ~strcmp(string,'*start')
    string=fgetl(fid);
end
ctrl=1;
while ~strcmp(string,'*end')
    if Mesh.Numbers.Nodes>0&&ctrl
        Constraints.Dtab=zeros(Mesh.Numbers.Nodes,6); ctrl=0;
    end
    string=fgetl(fid);
    %% MESH
    % Nodes global coordinates matrix
    if strcmp(string,'nodes {')
        LogMsg('[ReadStructure] Reading "nodes" block')
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
                    Mesh.Nodes.Tab = [Mesh.Nodes.Tab; rec];
                end
            end
        end
        Mesh.Numbers.Nodes=size(Mesh.Nodes.Tab,1);
        % Init roperties notches tab
        Properties.Notches=[(1:Mesh.Numbers.Nodes).' ones(Mesh.Numbers.Nodes,3)];
    end
    
    % Element index matrix
    if strcmp(string,'elements {')
        LogMsg('[ReadStructure] Reading "index" block')
        nl=clstart;
        elem_counter = 0;
        while ~strcmp(string,'}')
		nl=nl+1;
            string=fgetl(fid);
            k=find(string=='%');
            if ~isempty(k)
                k=k(1); if k~=1, string(k:end)=[]; end
            end
            if ~isempty(string)
                if ~strcmp(string(1),'%')&&~strcmp(string(1),'}')
                    elem_counter = elem_counter + 1;
					rec=str2num(string);
					elem_err_ctrl(rec,nl)
                    Mesh.Element(elem_counter).Index = rec;
                end
            end
        end
        Mesh.Numbers.Elements=elem_counter;
    end

    
    % Spring index matrix
    if strcmp(string,'springs {')
        LogMsg('[ReadStructure] Reading "springs" block')
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
                    Mesh.Springs.Tab=[Mesh.Springs.Tab; rec];
                end
            end
        end
    end
    
    % Notch matrix
    if strcmp(string,'notches {')
        LogMsg('[ReadStructure] Reading "notches" block')
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
                    Properties.Notches(rec(1),:)=rec;
                end
            end
        end
    end
    
    % Table of sections properties
    if strcmp(string,'sections {')
        LogMsg('[ReadStructure] Reading "sections" block')
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
                    Properties.Sections=[Properties.Sections; rec];
                end
            end
        end
    end
    
    % Table of material properties
    if strcmp(string,'materials {')
        LogMsg('[ReadStructure] Reading "materials" block')
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
                    Properties.Materials=[Properties.Materials; rec];
                end
            end
        end
    end
    
    %% CONSTRAINTS
    % DOF matrix
    if strcmp(string,'ground constraints {')
        LogMsg('[ReadStructure] Reading "ground constraints" block')
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
                            Constraints.Dtab(rec(1),i)=-1;
                        elseif rec(i+1)~=0
                            Constraints.Kcorr=[Constraints.Kcorr; rec(1) i rec(i+1)];
                        end
                    end
                    if length(rec)>7
                        if sum(rec(8:9)~=0)
                            Constraints.Incl=[Constraints.Incl; rec([1 8 9])];
                        end
                    end
                end
            end
        end
    end
    if strcmp(string,'internal constraints {')
        LogMsg('[ReadStructure] Reading "internal constraints" block')
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
                    Constraints.Ensl=[Constraints.Ensl; rec];
                    rec([false false rec(3:8)<Inf])=0; rec(rec==Inf)=1;
                    Constraints.Dtab(rec(2),:)=rec(3:8)*rec(1);
                end
            end
        end
    end
    
    % Yielded constraints matrix
    if strcmp(string,'yielded constraints {')
        LogMsg('[ReadStructure] Reading "yielded constraints" block')
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
                    Constraints.Bushing=[Constraints.Bushing; rec];
                end
            end
        end
    end
    
    %% LOADS
    % Loads matrix
    if strcmp(string,'nodal loads {')
        LogMsg('[ReadStructure] Reading "nodal loads" block')
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
                    Loads.Nodal=[Loads.Nodal; rec];
                end
            end
        end
    end
    
    % Thermal variations matrix
    if strcmp(string,'thermal variations {')
        LogMsg('[ReadStructure] Reading "thermal variations" block')
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
                    Loads.Thermal=[Loads.Thermal; rec];
                end
            end
        end
    end
    
    % Distributed loads matrix
    if strcmp(string,'distributed loads {')
        LogMsg('[ReadStructure] Reading "distributed loads" block')
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
                    Loads.Elemental=[Loads.Elemental; rec];
                end
            end
        end
    end	
    
    % Mesh control
    if strcmp(string,'mesh control {')
        LogMsg('[ReadStructure] Reading "mesh control" block')
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
					if ~isempty(Loads.Elemental), old_q=Loads.Elemental(:,1); else, old_q=[]; end
                    if ~sum(old_q==rec(1))
                        Loads.Elemental=[Loads.Elemental; rec(1) zeros(1,6) rec(end)];
                    end
                end
            end
        end
    end
    
    % Gravity
    if strcmp(string,'gravity {')
        LogMsg('[ReadStructure] Reading "gravity" block')
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
LogMsg('[ReadStructure] Computing element length and orientation')
for i=1:Mesh.Numbers.Elements
    rel_coord=Mesh.Nodes.Tab(Mesh.Element(i).Index(3),2:4)-Mesh.Nodes.Tab(Mesh.Element(i).Index(2),2:4);
    sph_coord=cart2sph(rel_coord).';
    Mesh.Element(i).Length=sph_coord(1);
    Mesh.Element(i).SphAng=[sph_coord(2:3) Mesh.Element(i).Index(end)*pi/180];
    Mesh.Element(i).Index(end)=[];
end

% Local to global matrices
LogMsg('[ReadStructure] Building local reference rotation matrices')
for i=1:Mesh.Numbers.Elements
    Ru=rotmat(-Mesh.Element(i).SphAng(3),1);
    Ry=rotmat(-Mesh.Element(i).SphAng(2)+pi/2,2);
    Rz=rotmat(-Mesh.Element(i).SphAng(1),3);
    R=Ru*Ry*Rz;
    Mesh.Element(i).Rotated=R;
    Mesh.Element(i).Loc2Glob=[R zeros(3,9); zeros(3) R zeros(3,6)
        zeros(3,6) R zeros(3);zeros(3,9) R];
end

% Distributed loads and gravity correction
d_sca=[max(Mesh.Nodes.Tab(:,2))-min(Mesh.Nodes.Tab(:,2))
    max(Mesh.Nodes.Tab(:,3))-min(Mesh.Nodes.Tab(:,3))
    max(Mesh.Nodes.Tab(:,4))-min(Mesh.Nodes.Tab(:,4))];
d_sca=max(d_sca);
if ~isempty(G)
    LogMsg('[ReadStructure] Gravity correction')
    gravity(G);
end
if ~isempty(Loads.Elemental)
    LogMsg('[ReadStructure] Distributed loads correction')
    distrol_corr;
end

% Constraints.Dtab construction
LogMsg('[ReadStructure] Building DoFs martrix')
Mesh.Numbers.Dofs=sum(sum(Constraints.Dtab==0));
Mesh.Numbers.Dobs=Mesh.Numbers.Nodes*6-Mesh.Numbers.Dofs;
Constraints.Dtab=Constraints.Dtab.';
Constraints.Dtab((Constraints.Dtab==-1))=(Mesh.Numbers.Dofs+1):(Mesh.Numbers.Dofs+sum(sum(Constraints.Dtab==-1)));
Constraints.Dtab((Constraints.Dtab==0))=1:Mesh.Numbers.Dofs;
Constraints.Dtab=Constraints.Dtab.';
if ~isempty(Constraints.Ensl)
    LogMsg('[ReadStructure] Enslavements correction')
    for i=1:size(Constraints.Ensl,1)
        for j=3:8
            if Constraints.Ensl(i,j)==Inf
                Constraints.Dtab(Constraints.Ensl(i,2),j-2)=Constraints.Dtab(Constraints.Ensl(i,1),j-2);
            end
        end
    end
end

% Spring matrix construction
if ~isempty(Mesh.Springs.Tab)
    LogMsg('[ReadStructure] Springs matrix construction')
end
Mesh.Springs.Tab=[Mesh.Springs.Tab zeros(size(Mesh.Springs.Tab,1),2)];
for i=1:size(Mesh.Springs.Tab,1)
    rel_coord=Mesh.Nodes.Tab(Mesh.Springs.Tab(i,3),2:4)-Mesh.Nodes.Tab(Mesh.Springs.Tab(i,2),2:4);
    sph_coord=cart2sph(rel_coord).';
    Mesh.Springs.Tab(i,5:6)=sph_coord(2:3);
end
LogMsg('[ReadStructure] Stop reading')
end