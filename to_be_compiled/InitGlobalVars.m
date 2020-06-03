function InitGlobalVars

global Mesh
% General mesh info
Mesh.Numbers.Dofs = 0; %ndof
Mesh.Numbers.Dobs = 0; %ndob
Mesh.Numbers.Nodes = 0; %nn
Mesh.Numbers.Elements = 0; %ne
% Elements
Mesh.Element.Index = 0; % index
Mesh.Element.Length = 0; % L
Mesh.Element.SphAng = [0 0]; % ang
Mesh.Element.Loc2Glob = zeros(12); %Li
Mesh.Element.Rotated = zeros(3); %Li
% Nodes
Mesh.Nodes.Tab = [];  % xyztab
Mesh.Springs.Tab = []; % springs

global Properties
Properties.Materials=[]; %material
Properties.Sections=[]; %sections
Properties.Notches=[]; %notch

global Loads
Loads.Nodal = []; %Ftab
Loads.Elemental = []; %Qtab
Loads.Thermal = []; %Ttab

global Constraints
Constraints.Dtab = []; %dtab
Constraints.Bushing = []; %bush

global Solver
Solver.M = [];
Solver.Mi = zeros(12);
Solver.Mff = [];
Solver.Mfb = [];
Solver.Mbf = [];
Solver.Mbb = [];
Solver.C = [];
Solver.Ci = zeros(12);
Solver.Cff = [];
Solver.Cfb = [];
Solver.Cbf = [];
Solver.Cbb = [];
Solver.K = [];
Solver.Ki = zeros(12);
Solver.Kff = [];
Solver.Kfb = [];
Solver.Kbf = [];
Solver.Kbb = [];
Solver.F = [];
Solver.Ff = [];
Solver.Fb = [];
Solver.x =[];
Solver.xf =[];
Solver.xb =[];

global Output
Output.InternalForces = [];
Output.Stress.Nom = [];
Output.Stress.Max = [];
Output.Strain.Nom = [];
Output.Strain.Max = [];
Output.Deform.uvwtab = [];
Output.Deform.defmat = [];
Output.Deform.maxd = [];