function tests = testDesktop
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

function testDesktopLoadAndPreserveResult(testCase)
app = stanlyfea.App(); cleanup = onCleanup(@() delete(app)); %#ok<NASGU>
app.Figure.Visible = 'off';
app.loadFile(fullfile(testCase.TestData.Root,'examples','beam_without.stan'));
previous = app.Result;
verifyTrue(testCase,isgraphics(app.Figure));
verifyNotEmpty(testCase,findall(app.Figure,'Type','uitable'));
verifyError(testCase,@() app.loadFile('this-file-does-not-exist.stan'),'Stanly:FileOpen');
verifyEqual(testCase,app.Result.Displacements,previous.Displacements);
app.loadFile(fullfile(testCase.TestData.Root,'examples','bicycle.fstan'));
verifyTrue(testCase,isfield(app.Result,'Fatigue'));
app.loadFile(fullfile(testCase.TestData.Root,'examples','beam_without.stan'));
verifyFalse(testCase,isfield(app.Result,'Fatigue'));
end

function testEveryPlotAndImageExport(testCase)
result = stanlyfea.analyze(fullfile(testCase.TestData.Root,'examples','bicycle.fstan'));
figureHandle = uifigure('Visible','off');
cleanup = onCleanup(@() delete(figureHandle)); %#ok<NASGU>
axesHandle = uiaxes(figureHandle);
plots = {'Mesh','Deformed','Loads and supports','Von Mises','Normal stress', ...
    'Axial force','Shear force','Torque','Bending moment','Fatigue safety factor','Fatigue life'};
for i = 1:numel(plots)
    stanlyfea.plotResult(axesHandle,result,plots{i},1);
    verifyNotEmpty(testCase,axesHandle.Children,plots{i});
end
filename = [tempname '.png']; fileCleanup = onCleanup(@() delete(filename)); %#ok<NASGU>
exportgraphics(axesHandle,filename);
info = imfinfo(filename); verifyGreaterThan(testCase,info.Width,0);
end
