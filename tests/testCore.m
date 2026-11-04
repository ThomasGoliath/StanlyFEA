function tests = testCore
tests = functiontests(localfunctions);
end

function setupOnce(testCase)
root = fileparts(fileparts(mfilename('fullpath')));
testCase.TestData.Root = root;
testCase.TestData.OldPath = path;
addpath(root,fullfile(root,'src'));
end

function teardownOnce(testCase)
path(testCase.TestData.OldPath);
end

function testArithmetic(testCase)
verifyEqual(testCase,stanlyfea.number('pi*(50^2-30^2)/4'),pi*400,'RelTol',1e-12);
verifyEqual(testCase,stanlyfea.number('-2^2'),-4);
verifyEqual(testCase,stanlyfea.number('2^3^2'),512);
verifyEqual(testCase,stanlyfea.number('2^-3'),1/8);
verifyEqual(testCase,stanlyfea.number('1000*(1/sqrt(2)-1)'),1000*(1/sqrt(2)-1));
verifyEqual(testCase,stanlyfea.number('log10(1000)'),3);
verifyError(testCase,@() stanlyfea.number('system(1)'),'Stanly:InvalidNumber');
verifyError(testCase,@() stanlyfea.number('1;exit'),'Stanly:InvalidNumber');
verifyError(testCase,@() stanlyfea.number('sqrt(-1)'),'Stanly:InvalidNumber');
verifyError(testCase,@() stanlyfea.number('2+'),'Stanly:InvalidNumber');
end

function testAxialCantilever(testCase)
m = beam(); m.Loads.Nodal = [20 100 0 0 0 0 0];
r = stanlyfea.solveStatic(m);
verifyEqual(testCase,r.Displacements(2,1),100*1000/(200000*100),'RelTol',1e-10);
verifyEqual(testCase,r.Reactions(1,1),-100,'AbsTol',1e-8);
verifyEqual(testCase,r.InternalForces(1,[1 7]),[100 100],'AbsTol',1e-8);
verifyEqual(testCase,r.Stress.Nom(1,[1 9]),[1 1],'AbsTol',1e-9);
end

function testBendingAboutBothAxes(testCase)
m = beam(); m.Loads.Nodal = [20 0 10 0 0 0 0];
r = stanlyfea.solveStatic(m); E = m.Properties.Materials(2); L = 1000;
verifyEqual(testCase,r.Displacements(2,2),10*L^3/(3*E*40000),'RelTol',1e-9);
verifyEqual(testCase,r.Displacements(2,6),10*L^2/(2*E*40000),'RelTol',1e-9);
verifyEqual(testCase,r.Reactions(1,6),-10*L,'AbsTol',1e-6);
m.Loads.Nodal = [20 0 0 10 0 0 0];
r = stanlyfea.solveStatic(m);
verifyEqual(testCase,r.Displacements(2,3),10*L^3/(3*E*20000),'RelTol',1e-9);
verifyEqual(testCase,r.Displacements(2,5),-10*L^2/(2*E*20000),'RelTol',1e-9);
end

function testTimoshenko(testCase)
m = beam(); m.Properties.Sections(7:8) = [1.2 1.4];
m.Loads.Nodal = [20 0 10 0 0 0 0];
r = stanlyfea.solveStatic(m); E = 200000; G = E/(2*1.3); L = 1000;
expected = 10*L^3/(3*E*40000)+10*L*1.2/(G*100);
verifyEqual(testCase,r.Displacements(2,2),expected,'RelTol',1e-9);
end

function testTorsion(testCase)
m = beam(); m.Loads.Nodal = [20 0 0 0 100 0 0];
r = stanlyfea.solveStatic(m); G = 200000/(2*1.3);
verifyEqual(testCase,r.Displacements(2,4),100*1000/(G*60000),'RelTol',1e-10);
end

function testDistributedLoad(testCase)
m = beam(); m.Loads.Distributed = [30 0 2 2 0 0 0 0];
r = stanlyfea.solveStatic(m); L = 1000; E = 200000; I = 40000;
verifyEqual(testCase,r.Displacements(2,2),2*L^4/(8*E*I),'RelTol',1e-9);
verifyEqual(testCase,r.Reactions(1,[2 6]),[-2*L -2*L^2/2],'AbsTol',1e-4);
verifyEqual(testCase,r.EndForces(1,7:12),zeros(1,6),'AbsTol',1e-4);
end

function testTriangularLoadRefinement(testCase)
m = beam(); m.Loads.Distributed = [30 0 0 3 0 0 0 0];
a = stanlyfea.solveStatic(m);
m.Mesh.Refinement = [30 3]; b = stanlyfea.solveStatic(m);
verifyEqual(testCase,b.Displacements(2,:),a.Displacements(2,:),'AbsTol',1e-8);
verifyEqual(testCase,b.Reactions(1,:),a.Reactions(1,:),'AbsTol',1e-4);
verifyEqual(testCase,size(b.Model.Mesh.Elements,1),4);
verifyEqual(testCase,b.Model.Mesh.ParentElementIDs,30*ones(4,1));
end

function testGravityIncludesArea(testCase)
m = beam(); m.Properties.Materials(5) = 7.8e-9;
m.Loads.Gravity = [0 -9810 0]; r = stanlyfea.solveStatic(m);
weight = 7.8e-9*9810*100*1000;
verifyEqual(testCase,r.Reactions(1,2),weight,'RelTol',1e-9);
end

function testThermalExpansion(testCase)
m = beam(); m.Loads.Thermal = [30 20 20 0 0];
r = stanlyfea.solveStatic(m);
verifyEqual(testCase,r.Displacements(2,1),1.2e-5*20*1000,'RelTol',1e-9);
verifyEqual(testCase,r.EndForces,zeros(1,12),'AbsTol',1e-6);
end

function testRestrainedThermalExpansion(testCase)
m = beam(); m.Constraints.Ground(end+1,:) = [20 Inf 0 0 0 0 0 0 0];
m.Loads.Thermal = [30 20 20 0 0]; r = stanlyfea.solveStatic(m);
expected = 200000*100*1.2e-5*20;
verifyEqual(testCase,r.Reactions(:,1),[expected;-expected],'AbsTol',1e-6);
end

function testPrescribedDisplacement(testCase)
m = beam(); m.Constraints.Prescribed = [20 .1 0 0 0 0 0];
r = stanlyfea.solveStatic(m);
verifyEqual(testCase,r.Displacements(2,1),.1,'AbsTol',1e-10);
verifyEqual(testCase,r.Reactions(:,1),[-2000;2000],'AbsTol',1e-7);
end

function testGroundSpring(testCase)
m = beam(); m.Constraints.Ground(end+1,:) = [20 1000 0 0 0 0 0 0 0];
m.Loads.Nodal = [20 100 0 0 0 0 0]; r = stanlyfea.solveStatic(m);
verifyEqual(testCase,r.Displacements(2,1),100/(20000+1000),'RelTol',1e-10);
verifyEqual(testCase,r.Reactions(2,1),-1000*r.Displacements(2,1),'AbsTol',1e-8);
verifyEqual(testCase,sum(r.Reactions(:,1)),-100,'AbsTol',1e-8);
end

function testAxialSpring(testCase)
m = beam(); m.Mesh.Springs = [1 10 20 1000];
m.Loads.Nodal = [20 100 0 0 0 0 0]; r = stanlyfea.solveStatic(m);
verifyEqual(testCase,r.Displacements(2,1),100/(20000+1000),'RelTol',1e-10);
end

function testInclinedSupport(testCase)
m = beam(); m.Constraints.Ground(end+1,:) = [20 Inf 0 0 0 0 0 45 0];
m.Loads.Nodal = [20 0 10 0 0 0 0]; r = stanlyfea.solveStatic(m);
verifyEqual(testCase,r.Displacements(2,1),r.Displacements(2,2),'AbsTol',1e-9);
verifyLessThan(testCase,r.Diagnostics.ConstraintResidual,1e-9);
end

function testElasticInternalConstraint(testCase)
m = beam(); m.Constraints.Internal = [10 20 1000 0 0 0 0 0];
m.Loads.Nodal = [20 100 0 0 0 0 0]; r = stanlyfea.solveStatic(m);
verifyEqual(testCase,r.Displacements(2,1),100/(20000+1000),'RelTol',1e-10);
end

function testSectionAndMaterialIDsAreIndependent(testCase)
m = beam(); m.Properties.Sections = [m.Properties.Sections; 77 200 30000 50000 3000 5000 0 0 1];
m.Properties.Materials = [m.Properties.Materials; 99 100000 .25 0 0 100 200 1];
m.Mesh.Elements(4:5) = [77 99]; m.Loads.Nodal = [20 100 0 0 0 0 0];
r = stanlyfea.solveStatic(m);
verifyEqual(testCase,r.Displacements(2,1),100*1000/(100000*200),'RelTol',1e-10);
end

function testRigidInternalConstraint(testCase)
m = beam(); m.Mesh.Nodes(end+1,:) = [40 2000 0 0];
m.Mesh.Elements(end+1,:) = [50 20 40 7 9 0];
m.Constraints.Internal = [20 40 Inf 0 0 0 0 0];
m.Loads.Nodal = [40 100 0 0 0 0 0]; r = stanlyfea.solveStatic(m);
verifyEqual(testCase,r.Displacements(3,1),r.Displacements(2,1),'AbsTol',1e-10);
verifyEqual(testCase,r.Displacements(2,1),.005,'RelTol',1e-9);
end

function testIncompatibleConstraints(testCase)
m = beam(); m.Constraints.Internal = [10 20 Inf 0 0 0 0 0];
m.Constraints.Prescribed = [20 .1 0 0 0 0 0];
verifyError(testCase,@() stanlyfea.solveStatic(m),'Stanly:Constraints');
end

function testUnstableFrame(testCase)
m = beam(); m.Constraints.Ground = zeros(0,9);
m.Loads.Nodal = [20 100 0 0 0 0 0];
verifyError(testCase,@() stanlyfea.solveStatic(m),'Stanly:UnstableModel');
end

function testCompressionEnvelopeAndNominalStrain(testCase)
m = beam(); m.Loads.Nodal = [20 -100 10 0 0 0 0];
m.Properties.Notches = [10 2 3 4]; r = stanlyfea.solveStatic(m);
verifyLessThan(testCase,r.Stress.Max(1,1),0);
verifyEqual(testCase,abs(r.Stress.Nom(1,1)),1+10000/4000,'RelTol',1e-9);
verifyGreaterThan(testCase,abs(r.Strain.Max(1,1)),abs(r.Strain.Nom(1,1)));
end

function testZeroLoad(testCase)
r = stanlyfea.solveStatic(beam());
verifyEqual(testCase,r.Displacements,zeros(2,6));
verifyEqual(testCase,r.Stress.Nom,zeros(1,16));
verifyTrue(testCase,all(isinf(r.SafetyFactors(:))));
end

function testDeformedEndpoints(testCase)
m = beam(); m.Loads.Nodal = [20 0 10 0 0 0 0];
r = stanlyfea.solveStatic(m); paths = stanlyfea.deformedCoordinates(r,2);
verifyEqual(testCase,paths{1}(1,:),m.Mesh.Nodes(1,2:4),'AbsTol',1e-8);
verifyEqual(testCase,paths{1}(end,:),m.Mesh.Nodes(2,2:4)+2*r.Displacements(2,1:3),'AbsTol',1e-8);
end

function testReadEveryHistoricalExample(testCase)
files = [dir(fullfile(testCase.TestData.Root,'examples','*.stan')); ...
    dir(fullfile(testCase.TestData.Root,'examples','*.fstan'))];
verifyGreaterThanOrEqual(testCase,numel(files),10);
for i = 1:numel(files)
    model = stanlyfea.readModel(fullfile(files(i).folder,files(i).name));
    verifyNotEmpty(testCase,model.Mesh.Elements);
end
end

function testSolveEveryHistoricalExample(testCase)
files = [dir(fullfile(testCase.TestData.Root,'examples','*.stan')); ...
    dir(fullfile(testCase.TestData.Root,'examples','*.fstan'))];
for i = 1:numel(files)
    filename = fullfile(files(i).folder,files(i).name);
    if strcmp(files(i).name,'bridge3D_gravity.stan')
        % Vertical member 6 can spin freely: its end Rz rotations are untied.
        verifyError(testCase,@() stanlyfea.analyze(filename),'Stanly:UnstableModel');
        continue
    end
    try
        r = stanlyfea.analyze(filename);
        verifyTrue(testCase,all(isfinite(r.Displacements(:))),files(i).name);
        verifyLessThan(testCase,r.Diagnostics.ConstraintResidual,1e-7,files(i).name);
    catch exception
        verifyFail(testCase,sprintf('%s: %s',files(i).name,exception.message));
    end
end
end

function testHistoricalBridgeFreeSpinIsARealMechanism(testCase)
model = stanlyfea.readModel(fullfile(testCase.TestData.Root,'examples','bridge3D_gravity.stan'));
e = model.Mesh.Elements(6,:);
verifyEqual(testCase,e(2:3),[11 12]);
% Both nodes occur only in this beam and have no fixed/rigid Rz constraint.
verifyEqual(testCase,sum(ismember(model.Mesh.Elements(:,2:3),[11 12]),'all'),2);
verifyFalse(testCase,any(ismember(model.Constraints.Ground(:,1),[11 12])));
rows = any(ismember(model.Constraints.Internal(:,1:2),[11 12]),2);
verifyEqual(testCase,model.Constraints.Internal(rows,8),zeros(sum(rows),1));
R = stanlyfea.rotation(model.Mesh.Nodes(12,2:4)-model.Mesh.Nodes(11,2:4),e(6));
T = blkdiag(R,R,R,R); spin = zeros(12,1); spin([6 12]) = 1;
k = stanlyfea.beamStiffness(model.Properties.Materials(1,:), ...
    model.Properties.Sections(1,:),.75);
verifyEqual(testCase,k*T*spin,zeros(12,1),'AbsTol',1e-9);
end

function testMalformedModelTerminates(testCase)
filename = [tempname '.stan']; cleanup = onCleanup(@() delete(filename)); %#ok<NASGU>
fid = fopen(filename,'wt'); fprintf(fid,'Title\n*start\nnodes {\n1 0 0 0\n'); fclose(fid);
verifyError(testCase,@() stanlyfea.readModel(filename),'Stanly:Parse');
end

function testFatigueZeroAndMeanFailure(testCase)
m = beam(); m.IsFatigue = true;
f = stanlyfea.fatigue(m,zeros(1,16),zeros(1,16));
verifyEqual(testCase,f.Values([4 8]),[1e7 1e7]);
verifyTrue(testCase,all(isinf(f.SafetyFactors)));
meanStress = zeros(1,16); meanStress([7 15]) = 1000;
f = stanlyfea.fatigue(m,ones(1,16),meanStress);
verifyTrue(testCase,all(isinf(f.Values([2 6]))));
verifyEqual(testCase,f.Values([4 8]),[0 0]);
end

function testExportAndEntryFromAnotherDirectory(testCase)
folder = tempname; mkdir(folder);
previous = pwd; cleanup = onCleanup(@() restoreFolder(previous,folder)); %#ok<NASGU>
cd(folder);
filename = fullfile(testCase.TestData.Root,'examples','beam_without.stan');
r = stanly(filename,fullfile(folder,'result.mat'));
saved = load(fullfile(folder,'result.mat'));
verifyEqual(testCase,saved.result.Displacements,r.Displacements);
stanlyfea.writeReport(r,fullfile(folder,'report.html'));
html = fileread(fullfile(folder,'report.html'));
verifyTrue(testCase,contains(html,'VonMises1'));
writetable(stanlyfea.resultTable(r,'Displacements'),fullfile(folder,'result.csv'));
verifyTrue(testCase,isfile(fullfile(folder,'result.csv')));
verifyTrue(testCase,isfolder(stanlyfea.resourcePath('examples')));
end

function restoreFolder(previous,temporary)
cd(previous);
rmdir(temporary,'s');
end

function model = beam()
% Nonsequential IDs and unequal inertias catch row/ID and bending-axis mixups.
model.SchemaVersion = 1; model.Title = 'Analytic cantilever';
model.Filename = 'analytic.stan'; model.IsFatigue = false;
model.Mesh.Nodes = [10 0 0 0;20 1000 0 0];
model.Mesh.Elements = [30 10 20 7 9 0];
model.Mesh.Springs = zeros(0,4); model.Mesh.Refinement = zeros(0,2);
model.Properties.Sections = [7 100 20000 40000 2000 4000 0 0 .9];
model.Properties.Materials = [9 200000 .3 1.2e-5 0 250 400 .9];
model.Properties.Notches = zeros(0,4);
model.Constraints.Ground = [10 Inf Inf Inf Inf Inf Inf 0 0];
model.Constraints.Internal = zeros(0,8); model.Constraints.Prescribed = zeros(0,7);
model.Loads.Nodal = zeros(0,7); model.Loads.Distributed = zeros(0,8);
model.Loads.Thermal = zeros(0,5); model.Loads.Gravity = zeros(0,3);
end
