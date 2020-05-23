function [F,T,yp]=pub_sel
global filetype axx
F=zeros(40,1);
T=zeros(17,1);

%% lists
f0={'Mesh','Materials','Section properties','Beams orientation',...
    'Loads and boundaries','Axial load','Shear load','Torque',...
    'Bending moment','Total displacements','Global displacements',...
    'Local displacements','Static stresses','Static strains',...
    'Gough-Pollard','Sines','Endurance limit','Fatigue life'};
t0={'Nodal coordinates','Index matrix','Enslavements matrix',...
    'Materials','Section properties','Notches','Element orientation',...
    'External loads','Reaction loads','Internal actions',...
    'Nodal displacements','Maximum stresses','Nominal stresses',....
    'Maximum strains','Nominal strains','Safety factors','Fatigue'};
fdg={'Displacement along X','Displacement along Y','Displacement along Z',...
    'Rotation around X','Rotation around Y','Rotation around Z'};
fdl={'Displacement along U','Displacement along V','Displacement along W',...
    'Rotation around U','Rotation around V','Rotation around W'};
fs={'Normal stress Su','Shear stress Suv','Maximum principal',...
    'Minimum principal','Von Mises','Guest-Tresca','First invariant'...
    'Third invariant'};
fe={'Normal strain Eu','Shear strain Euv','Maximum principal',...
    'Minimum principal','First invariant','Third invariant'};

if filetype==1
    f0(15:18)=[]; t0(end)=[];
else
    f0(13:14)={'Alternate stresses','Alternate strain'};
end
if isempty(axx)
    t0(3)=[];
end

% tables
[select,yp]=listdlg('PromptString','Tables',...
    'InitialValue',[],'ListString',t0);
if yp
    if isempty(axx), select(select>=3)=select(select>=3)+1; end
    T(select)=ones(length(select),1);
else
    return
end

% diagrams
[select,yp]=listdlg('PromptString','Diagrams','ListString',f0);
if yp
    s0=select(select<=10);
    F(s0)=ones(length(s0),1);
    if filetype==2
        s00=select(select>=15)+22;
        F(s00)=ones(length(s00),1);
    end
else
    return
end

% global displacements
if sum(select==11)
    [sdg,yp]=listdlg('PromptString','Diagrams (Global displacements)',...
        'ListString',fdg);
    if yp
        F(sdg+10)=ones(length(sdg),1);
    else
        return
    end
end

% local displacements
if sum(select==12)
    [sdl,yp]=listdlg('PromptString','Diagrams (Local displacements)',...
        'ListString',fdl);
    if yp
        F(sdl+16)=ones(length(sdl),1);
    else
        return
    end
end
                    
% stresses
if sum(select==13)
    [ss,yp]=listdlg('PromptString','Diagrams (Stresses)',...
        'ListString',fs);
    if yp
        F(ss+22)=ones(length(ss),1);
    else
        return
    end
end

% strains
if sum(select==14)
    [se,yp]=listdlg('PromptString','Diagrams (Strains)',...
        'ListString',fe);
    if yp
        F(se+30)=ones(length(se),1);
    end
end

end