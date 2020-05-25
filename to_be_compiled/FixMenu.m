function FixMenu(open)
%% FixMenu(open)
% Re-build Menu Bar for the Graphic User Interface after structure has been
% loaded. If open = TRUE enables all active voices in Menu, otherwise, it
% disables them.
%

% Richiamo le variabili globali
global GphUsrInterface
global FileManager
global axx

% Valuto se aprire o chiudere
if nargin == 0, open = true; end
if open
    enableStatus = 'on';
else
    enableStatus = 'off';
end

% Seleziono le opzioni di cui abilitare il caricamento
% tabella di asservimenti
if ~isempty(axx) && open
    ensEnabled='on';
else
    ensEnabled='off';
end
% fatigue and dynamics menu
if open
    switch FileManager.CurrentFile.FileType
        case 1
            fatEnabled='off';
            dynEnabled='off';
        case 2
            fatEnabled='on';
            dynEnabled='off';
        case 3
            fatEnabled='off';
            dynEnabled='on';
        otherwise        
                fatEnabled='off';
                dynEnabled='off';
    end
else
    fatEnabled='off';
    dynEnabled='off';
end


% -------------------------------------------------------------------------
% File menu
% -------------------------------------------------------------------------
set(GphUsrInterface.Menu.File.Export.root,'Enable',enableStatus);
set(GphUsrInterface.Menu.File.Export.Report,'Enable',enableStatus);
set(GphUsrInterface.Menu.File.Export.Workspace,'Enable',enableStatus);
set(GphUsrInterface.Menu.File.CloseStan,'Enable',enableStatus);


% -------------------------------------------------------------------------
% Model menu
% -------------------------------------------------------------------------
set(GphUsrInterface.Menu.Model.root,'Enable',enableStatus)
set(GphUsrInterface.Menu.Model.Mesh,'Enable',enableStatus)
set(GphUsrInterface.Menu.Model.Materials,'Enable',enableStatus)
set(GphUsrInterface.Menu.Model.Sections,'Enable',enableStatus)
set(GphUsrInterface.Menu.Model.Orientation,'Enable',enableStatus)
set(GphUsrInterface.Menu.Model.Loads,'Enable',enableStatus)


% -------------------------------------------------------------------------
% Internal Forces menu
% -------------------------------------------------------------------------
set(GphUsrInterface.Menu.IntForces.root,'Enable',enableStatus)
set(GphUsrInterface.Menu.IntForces.Axial,'Enable',enableStatus)
set(GphUsrInterface.Menu.IntForces.Shear,'Enable',enableStatus)
set(GphUsrInterface.Menu.IntForces.Bending,'Enable',enableStatus)
set(GphUsrInterface.Menu.IntForces.Torque,'Enable',enableStatus)


% -------------------------------------------------------------------------
% Stress menu
% -------------------------------------------------------------------------
set(GphUsrInterface.Menu.Stress.root,'Enable',enableStatus)
set(GphUsrInterface.Menu.Stress.SecDet,'Enable',enableStatus)
set(GphUsrInterface.Menu.Stress.Su,'Enable',enableStatus)
set(GphUsrInterface.Menu.Stress.Suv,'Enable',enableStatus)
set(GphUsrInterface.Menu.Stress.MaxPrin,'Enable',enableStatus)
set(GphUsrInterface.Menu.Stress.MinPrin,'Enable',enableStatus)
set(GphUsrInterface.Menu.Stress.VM,'Enable',enableStatus)
set(GphUsrInterface.Menu.Stress.GT,'Enable',enableStatus)
set(GphUsrInterface.Menu.Stress.FirstInv,'Enable',enableStatus)
set(GphUsrInterface.Menu.Stress.ThirdInv,'Enable',enableStatus)


% -------------------------------------------------------------------------
% Strain menu
% -------------------------------------------------------------------------
set(GphUsrInterface.Menu.Strain.root,'Enable',enableStatus)
set(GphUsrInterface.Menu.Strain.Displ.root,'Enable',enableStatus)
set(GphUsrInterface.Menu.Strain.Displ.Global.root,'Enable',enableStatus)
set(GphUsrInterface.Menu.Strain.Displ.Local.root,'Enable',enableStatus)
set(GphUsrInterface.Menu.Strain.Displ.Global.Sx,'Enable',enableStatus)
set(GphUsrInterface.Menu.Strain.Displ.Global.Sy,'Enable',enableStatus)
set(GphUsrInterface.Menu.Strain.Displ.Global.Sz,'Enable',enableStatus)
set(GphUsrInterface.Menu.Strain.Displ.Global.Rx,'Enable',enableStatus)
set(GphUsrInterface.Menu.Strain.Displ.Global.Ry,'Enable',enableStatus)
set(GphUsrInterface.Menu.Strain.Displ.Global.Rz,'Enable',enableStatus)
set(GphUsrInterface.Menu.Strain.Displ.Local.U,'Enable',enableStatus)
set(GphUsrInterface.Menu.Strain.Displ.Local.V,'Enable',enableStatus)
set(GphUsrInterface.Menu.Strain.Displ.Local.W,'Enable',enableStatus)
set(GphUsrInterface.Menu.Strain.Displ.Local.Ru,'Enable',enableStatus)
set(GphUsrInterface.Menu.Strain.Displ.Local.Rv,'Enable',enableStatus)
set(GphUsrInterface.Menu.Strain.Displ.Local.Rw,'Enable',enableStatus)
set(GphUsrInterface.Menu.Strain.Displ.Total,'Enable',enableStatus)
set(GphUsrInterface.Menu.Strain.Eu,'Enable',enableStatus)
set(GphUsrInterface.Menu.Strain.Euv,'Enable',enableStatus)
set(GphUsrInterface.Menu.Strain.MaxPrin,'Enable',enableStatus)
set(GphUsrInterface.Menu.Strain.MinPrin,'Enable',enableStatus)
set(GphUsrInterface.Menu.Strain.FirstInv,'Enable',enableStatus)
set(GphUsrInterface.Menu.Strain.ThirdInv,'Enable',enableStatus)


% -------------------------------------------------------------------------
% Fatigue menu
% -------------------------------------------------------------------------
set(GphUsrInterface.Menu.Fatigue.root,'Enable',fatEnabled)
set(GphUsrInterface.Menu.Fatigue.GP,'Enable',fatEnabled)
set(GphUsrInterface.Menu.Fatigue.S,'Enable',fatEnabled)
set(GphUsrInterface.Menu.Fatigue.Endurance,'Enable',fatEnabled)
set(GphUsrInterface.Menu.Fatigue.Life,'Enable',fatEnabled)


% -------------------------------------------------------------------------
% Dynamics menu
% -------------------------------------------------------------------------
set(GphUsrInterface.Menu.Dynamics.root,'Enable',dynEnabled)


% -------------------------------------------------------------------------
% Tables menu
% -------------------------------------------------------------------------
set(GphUsrInterface.Menu.Tables.root,'Enable',enableStatus)
set(GphUsrInterface.Menu.Tables.Nodes,'Enable',enableStatus)
set(GphUsrInterface.Menu.Tables.Elements,'Enable',enableStatus)
set(GphUsrInterface.Menu.Tables.Enslavements,'Enable',ensEnabled)
set(GphUsrInterface.Menu.Tables.Materials,'Enable',enableStatus)
set(GphUsrInterface.Menu.Tables.Sections,'Enable',enableStatus)
set(GphUsrInterface.Menu.Tables.Notches,'Enable',enableStatus)
set(GphUsrInterface.Menu.Tables.Orient,'Enable',enableStatus)
set(GphUsrInterface.Menu.Tables.ExtLoads,'Enable',enableStatus)
set(GphUsrInterface.Menu.Tables.ReactLoads,'Enable',enableStatus)
set(GphUsrInterface.Menu.Tables.IntForces,'Enable',enableStatus)
set(GphUsrInterface.Menu.Tables.Displ,'Enable',enableStatus)
set(GphUsrInterface.Menu.Tables.MaxStress,'Enable',enableStatus)
set(GphUsrInterface.Menu.Tables.NomStress,'Enable',enableStatus)
set(GphUsrInterface.Menu.Tables.MaxStrains,'Enable',enableStatus)
set(GphUsrInterface.Menu.Tables.NomStrains,'Enable',enableStatus)
set(GphUsrInterface.Menu.Tables.Safety,'Enable',enableStatus)
set(GphUsrInterface.Menu.Tables.Fatigue,'Enable',fatEnabled)


end