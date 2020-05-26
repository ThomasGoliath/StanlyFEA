function InitMenu
%% InitMenu()
% Build the Menu Bar for the Graphic User Interface
%

% Richiamo le variabili globali
global GphUsrInterface
global FileManager

% Seleziono le opzioni di cui abilitare il caricamento
% estensioni
extEnabled={'off';'off';'off'};
extEnabled(FileManager.FileTypes.Enabled)={'on'};

% -------------------------------------------------------------------------
% File menu
% -------------------------------------------------------------------------
GphUsrInterface.Menu.File.root = uimenu(GphUsrInterface.Figure,'Label','File','Separator','on');
GphUsrInterface.Menu.File.BlankModel.root = uimenu(GphUsrInterface.Menu.File.root,'Label','Blank model');
GphUsrInterface.Menu.File.BlankModel.StaticAnalysis = uimenu(GphUsrInterface.Menu.File.BlankModel.root,'Label','Static analysis','Callback','BlankModel(1)','Enable',char(extEnabled(1)));
GphUsrInterface.Menu.File.BlankModel.FatigueAnalysis = uimenu(GphUsrInterface.Menu.File.BlankModel.root,'Label','Fatigue analysis','Callback','BlankModel(2)','Enable',char(extEnabled(2)));
GphUsrInterface.Menu.File.BlankModel.DynamicAnalysis = uimenu(GphUsrInterface.Menu.File.BlankModel.root,'Label','Dynamic analysis','Callback','BlankModel(3)','Enable',char(extEnabled(3)));
GphUsrInterface.Menu.File.OpenStan = uimenu(GphUsrInterface.Menu.File.root,'Label','Open STAN','Callback','open_stan');
GphUsrInterface.Menu.File.LoadStan = uimenu(GphUsrInterface.Menu.File.root,'Label','Load STAN','Callback','loader','Separator','on');
GphUsrInterface.Menu.File.Export.root = uimenu(GphUsrInterface.Menu.File.root,'Label','Export','Enable','off');
GphUsrInterface.Menu.File.Export.Report = uimenu(GphUsrInterface.Menu.File.Export.root,'Label','Report','Callback','pub_rep','Enable','off');
GphUsrInterface.Menu.File.Export.Workspace = uimenu(GphUsrInterface.Menu.File.Export.root,'Label','Workspace','Callback','export_mat','Enable','off');
GphUsrInterface.Menu.File.CloseStan = uimenu(GphUsrInterface.Menu.File.root,'Label','Close STAN','Callback','close_stan','Enable','off','Separator','on');
GphUsrInterface.Menu.File.Quit = uimenu(GphUsrInterface.Menu.File.root,'Label','Quit','Callback','close all');


% -------------------------------------------------------------------------
% Model menu
% -------------------------------------------------------------------------
GphUsrInterface.Menu.Model.root = uimenu(GphUsrInterface.Figure,'Label','Model','Separator','on','Enable','off');
GphUsrInterface.Menu.Model.Mesh = uimenu(GphUsrInterface.Menu.Model.root,'Label','Mesh','Enable','off','Callback','AXLIM=axis; cla(UIax), meshstr, axis(AXLIM)');
GphUsrInterface.Menu.Model.Materials = uimenu(GphUsrInterface.Menu.Model.root,'Label','Materials','Callback','AXLIM=axis; cla(UIax), materials_mesh, axis(AXLIM)','Separator','on','Enable','off');
GphUsrInterface.Menu.Model.Sections = uimenu(GphUsrInterface.Menu.Model.root,'Label','Section properties','Callback','AXLIM=axis; cla(UIax), csection_mesh, axis(AXLIM)','Enable','off');
GphUsrInterface.Menu.Model.Orientation = uimenu(GphUsrInterface.Menu.Model.root,'Label','Beams orientation','Callback','AXLIM=axis; cla(UIax), orient, axis(AXLIM)','Separator','on','Enable','off');
GphUsrInterface.Menu.Model.Loads = uimenu(GphUsrInterface.Menu.Model.root,'Label','Loads and boundaries','Callback','AXLIM=axis; cla(UIax), boundaries(ext_f,int_f), axis(AXLIM)','Separator','on','Enable','off');


% -------------------------------------------------------------------------
% Internal Forces menu
% -------------------------------------------------------------------------
GphUsrInterface.Menu.IntForces.root = uimenu(GphUsrInterface.Figure,'Label','Internal Forces','Separator','on','Enable','off');
GphUsrInterface.Menu.IntForces.Axial = uimenu(GphUsrInterface.Menu.IntForces.root,'Label','Axial load','Callback','AXLIM=axis; cla(UIax), axial(int_act,iasca), axis(AXLIM)','Enable','off');
GphUsrInterface.Menu.IntForces.Shear = uimenu(GphUsrInterface.Menu.IntForces.root,'Label','Shear load','Callback','AXLIM=axis; cla(UIax), shear(int_act,iasca), axis(AXLIM)','Enable','off');
GphUsrInterface.Menu.IntForces.Bending = uimenu(GphUsrInterface.Menu.IntForces.root,'Label','Bending moment','Callback','AXLIM=axis; cla(UIax), bending(int_act,iasca), axis(AXLIM)','Separator','on','Enable','off');
GphUsrInterface.Menu.IntForces.Torque = uimenu(GphUsrInterface.Menu.IntForces.root,'Label','Torque','Callback','AXLIM=axis; cla(UIax), torque(int_act,iasca), axis(AXLIM)','Enable','off');


% -------------------------------------------------------------------------
% Stress menu
% -------------------------------------------------------------------------
GphUsrInterface.Menu.Stress.root=uimenu(GphUsrInterface.Figure,'Label','Stress','Separator','on','Enable','off');
GphUsrInterface.Menu.Stress.SecDet = uimenu(GphUsrInterface.Menu.Stress.root,'Label','Section details','Callback','secdetail(int_act)','Enable','off');
GphUsrInterface.Menu.Stress.Su = uimenu(GphUsrInterface.Menu.Stress.root,'Label','Su','Callback','AXLIM=axis; cla(UIax), sigmass(1,SS,SSnom), axis(AXLIM)','Separator','on','Enable','off');
GphUsrInterface.Menu.Stress.Suv = uimenu(GphUsrInterface.Menu.Stress.root,'Label','Suv','Callback','AXLIM=axis; cla(UIax), sigmass(2,SS,SSnom), axis(AXLIM)','Enable','off');
GphUsrInterface.Menu.Stress.MaxPrin = uimenu(GphUsrInterface.Menu.Stress.root,'Label','Maximum principal','Callback','AXLIM=axis; cla(UIax), sigmass(3,SS,SSnom), axis(AXLIM)','Separator','on','Enable','off');
GphUsrInterface.Menu.Stress.MinPrin = uimenu(GphUsrInterface.Menu.Stress.root,'Label','Minimum principal','Callback','AXLIM=axis; cla(UIax), sigmass(4,SS,SSnom), axis(AXLIM)','Enable','off');
GphUsrInterface.Menu.Stress.VM = uimenu(GphUsrInterface.Menu.Stress.root,'Label','Von Mises','Callback','AXLIM=axis; cla(UIax), sigmass(5,SS,SSnom), axis(AXLIM)','Separator','on','Enable','off');
GphUsrInterface.Menu.Stress.GT = uimenu(GphUsrInterface.Menu.Stress.root,'Label','Guest-Tresca','Callback','AXLIM=axis; cla(UIax), sigmass(6,SS,SSnom), axis(AXLIM)','Enable','off');
GphUsrInterface.Menu.Stress.FirstInv = uimenu(GphUsrInterface.Menu.Stress.root,'Label','First invariant','Callback','AXLIM=axis; cla(UIax), sigmass(7,SS,SSnom), axis(AXLIM)','Separator','on','Enable','off');
GphUsrInterface.Menu.Stress.ThirdInv = uimenu(GphUsrInterface.Menu.Stress.root,'Label','Third invariant','Callback','AXLIM=axis; cla(UIax), sigmass(8,SS,SSnom), axis(AXLIM)','Enable','off');


% -------------------------------------------------------------------------
% Strain menu
% -------------------------------------------------------------------------
GphUsrInterface.Menu.Strain.root = uimenu(GphUsrInterface.Figure,'Label','Strain','Separator','on','Enable','off');
GphUsrInterface.Menu.Strain.Displ.root = uimenu(GphUsrInterface.Menu.Strain.root,'Label','Displacements','Enable','off');
GphUsrInterface.Menu.Strain.Displ.Global.root = uimenu(GphUsrInterface.Menu.Strain.Displ.root,'Label','Global','Enable','off');
GphUsrInterface.Menu.Strain.Displ.Local.root = uimenu(GphUsrInterface.Menu.Strain.Displ.root,'Label','Local','Enable','off');
GphUsrInterface.Menu.Strain.Displ.Global.Sx = uimenu(GphUsrInterface.Menu.Strain.Displ.Global.root,'Label','sx','Callback','AXLIM=axis; cla(UIax), deform(defmat,maxd,2), axis(AXLIM)','Enable','off');
GphUsrInterface.Menu.Strain.Displ.Global.Sy = uimenu(GphUsrInterface.Menu.Strain.Displ.Global.root,'Label','sy','Callback','AXLIM=axis; cla(UIax), deform(defmat,maxd,3), axis(AXLIM)','Enable','off');
GphUsrInterface.Menu.Strain.Displ.Global.Sz = uimenu(GphUsrInterface.Menu.Strain.Displ.Global.root,'Label','sz','Callback','AXLIM=axis; cla(UIax), deform(defmat,maxd,4), axis(AXLIM)','Enable','off');
GphUsrInterface.Menu.Strain.Displ.Global.Rx = uimenu(GphUsrInterface.Menu.Strain.Displ.Global.root,'Label','rx','Callback','AXLIM=axis; cla(UIax), deform(defmat,maxd,8), axis(AXLIM)','Separator','on','Enable','off');
GphUsrInterface.Menu.Strain.Displ.Global.Ry = uimenu(GphUsrInterface.Menu.Strain.Displ.Global.root,'Label','ry','Callback','AXLIM=axis; cla(UIax), deform(defmat,maxd,9), axis(AXLIM)','Enable','off');
GphUsrInterface.Menu.Strain.Displ.Global.Rz = uimenu(GphUsrInterface.Menu.Strain.Displ.Global.root,'Label','rz','Callback','AXLIM=axis; cla(UIax), deform(defmat,maxd,10), axis(AXLIM)','Enable','off');
GphUsrInterface.Menu.Strain.Displ.Local.U = uimenu(GphUsrInterface.Menu.Strain.Displ.Local.root,'Label','u','Callback','AXLIM=axis; cla(UIax), deform(defmat,maxd,5), axis(AXLIM)','Enable','off');
GphUsrInterface.Menu.Strain.Displ.Local.V = uimenu(GphUsrInterface.Menu.Strain.Displ.Local.root,'Label','v','Callback','AXLIM=axis; cla(UIax), deform(defmat,maxd,6), axis(AXLIM)','Enable','off');
GphUsrInterface.Menu.Strain.Displ.Local.W = uimenu(GphUsrInterface.Menu.Strain.Displ.Local.root,'Label','w','Callback','AXLIM=axis; cla(UIax), deform(defmat,maxd,7), axis(AXLIM)','Enable','off');
GphUsrInterface.Menu.Strain.Displ.Local.Ru = uimenu(GphUsrInterface.Menu.Strain.Displ.Local.root,'Label','ru','Callback','AXLIM=axis; cla(UIax), deform(defmat,maxd,11), axis(AXLIM)','Separator','on','Enable','off');
GphUsrInterface.Menu.Strain.Displ.Local.Rv = uimenu(GphUsrInterface.Menu.Strain.Displ.Local.root,'Label','rv','Callback','AXLIM=axis; cla(UIax), deform(defmat,maxd,12), axis(AXLIM)','Enable','off');
GphUsrInterface.Menu.Strain.Displ.Local.Rw = uimenu(GphUsrInterface.Menu.Strain.Displ.Local.root,'Label','rw','Callback','AXLIM=axis; cla(UIax), deform(defmat,maxd,13), axis(AXLIM)','Enable','off');
GphUsrInterface.Menu.Strain.Displ.Total = uimenu(GphUsrInterface.Menu.Strain.Displ.root,'Label','Total','Callback','AXLIM=axis; cla(UIax), deform(defmat,maxd,1), axis(AXLIM)','Separator','on','Enable','off');
GphUsrInterface.Menu.Strain.Eu = uimenu(GphUsrInterface.Menu.Strain.root,'Label','Eu','Callback','AXLIM=axis; cla(UIax), epsilon(1,EE,EEnom), axis(AXLIM)','Separator','on','Enable','off');
GphUsrInterface.Menu.Strain.Euv = uimenu(GphUsrInterface.Menu.Strain.root,'Label','Euv','Callback','AXLIM=axis; cla(UIax), epsilon(2,EE,EEnom), axis(AXLIM)','Enable','off');
GphUsrInterface.Menu.Strain.MaxPrin = uimenu(GphUsrInterface.Menu.Strain.root,'Label','Maximum principal','Callback','AXLIM=axis; cla(UIax), epsilon(3,EE,EEnom), axis(AXLIM)','Separator','on','Enable','off');
GphUsrInterface.Menu.Strain.MinPrin = uimenu(GphUsrInterface.Menu.Strain.root,'Label','Minimum principal','Callback','AXLIM=axis; cla(UIax), epsilon(4,EE,EEnom), axis(AXLIM)','Enable','off');
GphUsrInterface.Menu.Strain.FirstInv = uimenu(GphUsrInterface.Menu.Strain.root,'Label','First invariant','Callback','AXLIM=axis; cla(UIax), epsilon(5,EE,EEnom), axis(AXLIM)','Separator','on','Enable','off');
GphUsrInterface.Menu.Strain.ThirdInv = uimenu(GphUsrInterface.Menu.Strain.root,'Label','Third invariant','Callback','AXLIM=axis; cla(UIax), epsilon(6,EE,EEnom), axis(AXLIM)','Enable','off');


% -------------------------------------------------------------------------
% Fatigue menu
% -------------------------------------------------------------------------
GphUsrInterface.Menu.Fatigue.root = uimenu(GphUsrInterface.Figure,'Label','Fatigue','Separator','on','Enable','off');
GphUsrInterface.Menu.Fatigue.GP = uimenu(GphUsrInterface.Menu.Fatigue.root,'Label','Gough-Pollard','Callback','AXLIM=axis; cla(UIax), fatigue_plot(1,FF,FFnom), axis(AXLIM)','Enable','off');
GphUsrInterface.Menu.Fatigue.S = uimenu(GphUsrInterface.Menu.Fatigue.root,'Label','Sines','Callback','AXLIM=axis; cla(UIax), fatigue_plot(2,FF,FFnom), axis(AXLIM)','Enable','off');
GphUsrInterface.Menu.Fatigue.Endurance = uimenu(GphUsrInterface.Menu.Fatigue.root,'Label','Endurance limit','Callback','AXLIM=axis; cla(UIax), fatigue_plot(3,FF,FFnom), axis(AXLIM)','Separator','on','Enable','off');
GphUsrInterface.Menu.Fatigue.Life = uimenu(GphUsrInterface.Menu.Fatigue.root,'Label','Fatigue life','Callback','AXLIM=axis; cla(UIax), fatigue_plot(4,FF,FFnom), axis(AXLIM)','Enable','off');


% -------------------------------------------------------------------------
% Dynamics menu
% -------------------------------------------------------------------------
GphUsrInterface.Menu.Dynamics.root = uimenu(GphUsrInterface.Figure,'Label','Dynamics','Separator','on','Enable','off');


% -------------------------------------------------------------------------
% Tables menu
% -------------------------------------------------------------------------
GphUsrInterface.Menu.Tables.root = uimenu(GphUsrInterface.Figure,'Label','Tables','Separator','on','Enable','off');
GphUsrInterface.Menu.Tables.Nodes = uimenu(GphUsrInterface.Menu.Tables.root,'Label','Nodal coordinates','Callback','ktab=1; tabDisplay','Enable','off');
GphUsrInterface.Menu.Tables.Elements = uimenu(GphUsrInterface.Menu.Tables.root,'Label','Index matrix','Callback','ktab=2; tabDisplay','Enable','off');
GphUsrInterface.Menu.Tables.Enslavements = uimenu(GphUsrInterface.Menu.Tables.root,'Label','Enslavements matrix','Callback','ktab=3; tabDisplay','Enable','off');
GphUsrInterface.Menu.Tables.Materials = uimenu(GphUsrInterface.Menu.Tables.root,'Label','Materials','Callback','ktab=4; tabDisplay','Separator','on','Enable','off');
GphUsrInterface.Menu.Tables.Sections = uimenu(GphUsrInterface.Menu.Tables.root,'Label','Section properties','Callback','ktab=5; tabDisplay','Enable','off');
GphUsrInterface.Menu.Tables.Notches = uimenu(GphUsrInterface.Menu.Tables.root,'Label','Notches','Callback','ktab=6; tabDisplay','Enable','off');
GphUsrInterface.Menu.Tables.Orient = uimenu(GphUsrInterface.Menu.Tables.root,'Label','Element orientation','Callback','ktab=7; tabDisplay','Enable','off');
GphUsrInterface.Menu.Tables.ExtLoads = uimenu(GphUsrInterface.Menu.Tables.root,'Label','External loads','Callback','ktab=8; tabDisplay','Separator','on','Enable','off');
GphUsrInterface.Menu.Tables.ReactLoads = uimenu(GphUsrInterface.Menu.Tables.root,'Label','Reaction loads','Callback','ktab=9; tabDisplay','Enable','off');
GphUsrInterface.Menu.Tables.IntForces = uimenu(GphUsrInterface.Menu.Tables.root,'Label','Internal forces','Callback','ktab=10; tabDisplay','Enable','off');
GphUsrInterface.Menu.Tables.Displ = uimenu(GphUsrInterface.Menu.Tables.root,'Label','Nodal displacements','Callback','ktab=11; tabDisplay','Separator','on','Enable','off');
GphUsrInterface.Menu.Tables.MaxStress = uimenu(GphUsrInterface.Menu.Tables.root,'Label','Maximum stresses','Callback','ktab=12; tabDisplay','Separator','on','Enable','off');
GphUsrInterface.Menu.Tables.NomStress = uimenu(GphUsrInterface.Menu.Tables.root,'Label','Nominal stresses','Callback','ktab=13; tabDisplay','Enable','off');
GphUsrInterface.Menu.Tables.MaxStrains = uimenu(GphUsrInterface.Menu.Tables.root,'Label','Maximum strains','Callback','ktab=14; tabDisplay','Separator','on','Enable','off');
GphUsrInterface.Menu.Tables.NomStrains = uimenu(GphUsrInterface.Menu.Tables.root,'Label','Nominal strains','Callback','ktab=15; tabDisplay','Enable','off');
GphUsrInterface.Menu.Tables.Safety = uimenu(GphUsrInterface.Menu.Tables.root,'Label','Safety factors','Callback','ktab=16; tabDisplay','Separator','on','Enable','off');
GphUsrInterface.Menu.Tables.Fatigue = uimenu(GphUsrInterface.Menu.Tables.root,'Label','Fatigue','Callback','ktab=17; tabDisplay','Separator','on','Enable','off');


% -------------------------------------------------------------------------
% Documentation menu
% -------------------------------------------------------------------------
GphUsrInterface.Menu.Documentation.root = uimenu(GphUsrInterface.Figure,'Label','Documentation','Separator','on');
GphUsrInterface.Menu.Documentation.Input = uimenu(GphUsrInterface.Menu.Documentation.root,'Label','Input manual','Callback','winopen inp_manual.pdf','Enable','on');
GphUsrInterface.Menu.Documentation.Output = uimenu(GphUsrInterface.Menu.Documentation.root,'Label','Output manual','Callback','winopen out_manual.pdf','Enable','off');
GphUsrInterface.Menu.Documentation.License = uimenu(GphUsrInterface.Menu.Documentation.root,'Label','License','Callback','open_lic','Separator','on');