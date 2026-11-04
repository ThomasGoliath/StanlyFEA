classdef App < handle
    %APP Desktop controller. All callbacks share explicit object state.
    properties (SetAccess = private)
        Figure
        Result = []
    end
    properties (Access = private)
        Axes
        Data
        PlotChoice
        TableChoice
        Scale
        Status
        Actions = {}
    end
    methods
        function app = App()
            app.Figure = uifigure('Name','STANLY FEA','Position',[100 100 1200 800]);
            app.Figure.CloseRequestFcn = @(~,~) delete(app);
            layout = uigridlayout(app.Figure,[4 1]);
            layout.RowHeight = {38,'1x','1x',25};
            controls = uigridlayout(layout,[1 7]);
            controls.ColumnWidth = {120,'1x',80,100,'1x',100,100};
            uibutton(controls,'Text','Load and solve','ButtonPushedFcn',@(~,~) app.loadModel());
            app.PlotChoice = uidropdown(controls,'Items',{'Mesh','Deformed','Loads and supports', ...
                'Von Mises','Normal stress','Axial force','Shear force','Torque','Bending moment'}, ...
                'ValueChangedFcn',@(~,~) app.draw());
            uilabel(controls,'Text','Deform scale');
            app.Scale = uieditfield(controls,'numeric','Value',1,'Limits',[0 Inf], ...
                'ValueChangedFcn',@(~,~) app.draw());
            app.TableChoice = uidropdown(controls,'Items',{'Nodes','Elements','Displacements', ...
                'Reactions','Applied loads','Internal forces','Stress','Nominal stress','Strain','Safety factors'}, ...
                'ValueChangedFcn',@(~,~) app.showTable());
            csvButton = uibutton(controls,'Text','Export CSV','Enable','off', ...
                'ButtonPushedFcn',@(~,~) app.export('csv'));
            matButton = uibutton(controls,'Text','Export MAT','Enable','off', ...
                'ButtonPushedFcn',@(~,~) app.export('mat'));
            app.Axes = uiaxes(layout); view(app.Axes,3); grid(app.Axes,'on');
            title(app.Axes,'Load a .stan or .fstan model');
            app.Data = uitable(layout,'Data',[],'ColumnName',{});
            app.Status = uilabel(layout,'Text','Ready');
            file = uimenu(app.Figure,'Text','File');
            uimenu(file,'Text','Load and solve...','MenuSelectedFcn',@(~,~) app.loadModel());
            report = uimenu(file,'Text','Export HTML report...','Enable','off', ...
                'MenuSelectedFcn',@(~,~) app.export('html'));
            image = uimenu(file,'Text','Export plot...','Enable','off', ...
                'MenuSelectedFcn',@(~,~) app.export('png'));
            uimenu(file,'Text','Close model','MenuSelectedFcn',@(~,~) app.closeModel());
            uimenu(file,'Text','Quit','MenuSelectedFcn',@(~,~) delete(app));
            help = uimenu(app.Figure,'Text','Help');
            uimenu(help,'Text','Input manual','MenuSelectedFcn',@(~,~) app.manual());
            app.Actions = {csvButton,matButton,report,image};
        end
        function loadFile(app,filename)
            % Solve before replacing state, so a failed model leaves the old result intact.
            nextResult = stanlyfea.analyze(filename);
            app.Result = nextResult;
            tables = {'Nodes','Elements','Displacements','Reactions','Applied loads', ...
                'Internal forces','Stress','Nominal stress','Strain','Safety factors'};
            plots = {'Mesh','Deformed','Loads and supports','Von Mises', ...
                'Normal stress','Axial force','Shear force','Torque','Bending moment'};
            if isfield(nextResult,'Fatigue')
                tables{end+1} = 'Fatigue';
                plots = [plots, {'Fatigue safety factor','Fatigue life'}];
            end
            app.TableChoice.Value = 'Nodes'; app.TableChoice.Items = tables;
            app.PlotChoice.Value = 'Mesh'; app.PlotChoice.Items = plots;
            span = max(max(nextResult.Model.Mesh.Nodes(:,2:4))-min(nextResult.Model.Mesh.Nodes(:,2:4)));
            maximum = max(vecnorm(nextResult.Displacements(:,1:3),2,2));
            if maximum > 0, app.Scale.Value = span/(10*maximum); else, app.Scale.Value = 1; end
            [~,name,extension] = fileparts(filename); name = [name extension];
            app.Figure.Name = ['STANLY FEA - ' name];
            app.draw(); app.showTable(); app.setEnabled('on');
            app.Status.Text = sprintf('%s | %d nodes, %d elements | solved', ...
                name,size(nextResult.Model.Mesh.Nodes,1),size(nextResult.Model.Mesh.Elements,1));
        end
        function delete(app)
            if ~isempty(app.Figure) && isgraphics(app.Figure), delete(app.Figure); end
        end
    end
    methods (Access = private)
        function loadModel(app)
            [name,folder] = uigetfile({'*.stan;*.fstan','STANLY models (*.stan, *.fstan)'}, ...
                'Load model',stanlyfea.resourcePath('examples'));
            if isequal(name,0), return; end
            app.Status.Text = 'Solving...'; drawnow;
            try
                app.loadFile(fullfile(folder,name));
            catch exception
                app.Status.Text = 'Load failed';
                uialert(app.Figure,exception.message,'Cannot solve model');
            end
        end
        function draw(app)
            if isempty(app.Result), return; end
            stanlyfea.plotResult(app.Axes,app.Result,app.PlotChoice.Value,app.Scale.Value);
        end
        function showTable(app)
            if isempty(app.Result), return; end
            data = stanlyfea.resultTable(app.Result,app.TableChoice.Value);
            app.Data.ColumnName = data.Properties.VariableNames;
            app.Data.Data = table2array(data);
        end
        function export(app,kind)
            if isempty(app.Result), return; end
            if strcmp(kind,'png')
                filter = {'*.png','PNG image';'*.pdf','PDF plot'};
            else
                filter = {['*.' kind],upper(kind)};
            end
            [name,folder] = uiputfile(filter,'Export result');
            if isequal(name,0), return; end
            filename = fullfile(folder,name);
            try
                switch kind
                    case 'mat'
                        result = app.Result; save(filename,'result');
                    case 'csv'
                        writetable(stanlyfea.resultTable(app.Result,app.TableChoice.Value),filename);
                    case 'html'
                        stanlyfea.writeReport(app.Result,filename);
                    case 'png'
                        exportgraphics(app.Axes,filename,'Resolution',180);
                end
                app.Status.Text = ['Exported ' filename];
            catch exception
                uialert(app.Figure,exception.message,'Export failed');
            end
        end
        function closeModel(app)
            app.Result = []; cla(app.Axes); colorbar(app.Axes,'off');
            app.Data.Data = []; app.Data.ColumnName = {};
            app.Figure.Name = 'STANLY FEA'; app.Status.Text = 'Ready'; app.setEnabled('off');
        end
        function setEnabled(app,value)
            for i = 1:numel(app.Actions), app.Actions{i}.Enable = value; end
        end
        function manual(app)
            filename = fullfile(stanlyfea.resourcePath('install_path'),'inp_manual.pdf');
            try
                if ispc, winopen(filename); else, open(filename); end
            catch exception
                uialert(app.Figure,exception.message,'Cannot open manual');
            end
        end
    end
end
