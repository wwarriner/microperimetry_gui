classdef microperimetry_gui < matlab.apps.AppBase
    
    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                 matlab.ui.Figure
        OptionsPanel             matlab.ui.container.Panel
        EyeSideButtonGroup       matlab.ui.container.ButtonGroup
        ODButton                 matlab.ui.control.ToggleButton
        OSButton                 matlab.ui.control.ToggleButton
        LoadDataButton           matlab.ui.control.Button
        ValueDisplaySwitchLabel  matlab.ui.control.Label
        ValueDisplaySwitch       matlab.ui.control.Switch
        SaveFigureAsButton       matlab.ui.control.Button
        LeftColumnSourceLabel    matlab.ui.control.Label
        LeftColumnTree           matlab.ui.container.Tree
        NodeLeft                 matlab.ui.container.TreeNode
        NodeLeft1                matlab.ui.container.TreeNode
        NodeLeft2                matlab.ui.container.TreeNode
        NodeLeft3                matlab.ui.container.TreeNode
        NodeLeft4                matlab.ui.container.TreeNode
        CenterColumnSourceLabel  matlab.ui.control.Label
        CenterColumnTree         matlab.ui.container.Tree
        NodeCenter               matlab.ui.container.TreeNode
        NodeCenter1              matlab.ui.container.TreeNode
        NodeCenter2              matlab.ui.container.TreeNode
        NodeCenter3              matlab.ui.container.TreeNode
        NodeCenter4              matlab.ui.container.TreeNode
        RightColumnSourceLabel   matlab.ui.control.Label
        RightColumnTree          matlab.ui.container.Tree
        NodeRight                matlab.ui.container.TreeNode
        NodeRight1               matlab.ui.container.TreeNode
        NodeRight2               matlab.ui.container.TreeNode
        NodeRight3               matlab.ui.container.TreeNode
        NodeRight4               matlab.ui.container.TreeNode
        DisplayPanel             matlab.ui.container.Panel
    end
    
    properties (Access = private)
        axes
        coordinates
        data
        
        left_selection
        center_selection
        right_selection
    end
    
    methods (Access = private)
        % TODO tree class
        % TODO units in data and colorbar selection depending on that?
        
        function update_trees(app)
            app.update_tree(app.LeftColumnTree);
            app.left_selection = app.LeftColumnTree.SelectedNodes;
            app.update_tree(app.CenterColumnTree);
            app.center_selection = app.CenterColumnTree.SelectedNodes;
            app.update_tree(app.RightColumnTree);
            app.right_selection = app.RightColumnTree.SelectedNodes;
        end
        
        function update_tree(app, tree)
            % get old selection
            [old_class, old_data_type] = app.get_old_selection(tree);
            has_old_selection = ~isempty(old_class) && ~isempty(old_data_type);
            
            % remove old nodes
            tree.Children.delete();
            
            % build new nodes
            if app.data.empty
                tree.SelectedNodes = [];
                return;
            end
            classes = app.data.get_classes();
            for i = 1 : numel(classes)
                class = classes(i);
                node = uitreenode(tree, "text", class);
                data_types = app.data.get_data_types(class);
                for j = 1 : numel(data_types)
                    uitreenode(node, "text", data_types(j));
                end
            end
            expand(tree, "all");
            
            if has_old_selection
                tree.SelectedNodes = app.determine_old_selection(tree, old_class, old_data_type);
            else
                tree.SelectedNodes = [];
            end
        end
        
        function [old_class, old_data_type] = get_old_selection(~, tree)
            old_selection = tree.SelectedNodes;
            count = numel(old_selection);
            if count == 0
                old_class = [];
                old_data_type = [];
            elseif count == 1
                old_class = old_selection.Parent.Text;
                old_data_type = old_selection.Text;
            else
                assert(false);
            end
        end
        
        function node = determine_old_selection(~, tree, old_class, old_data_type)
            select_none = false;
            
            selected_class_node = [];
            for class_node = tree.Children(:).'
                if string(class_node.Text) == string(old_class)
                    selected_class_node = class_node;
                    break;
                end
            end
            if isempty(selected_class_node)
                select_none = true;
            end
            
            selected_data_type_node = [];
            if ~select_none
                for data_type_node = selected_class_node.Children(:).'
                    if string(data_type_node.Text) == string(old_data_type)
                        selected_data_type_node = data_type_node;
                        break;
                    end
                end
                if isempty(selected_data_type_node)
                    select_none = true;
                end
            end
            
            if select_none
                node = [];
            else
                node = selected_data_type_node;
            end
        end
    end
    
    % Callbacks that handle component events
    methods (Access = private)
        
        % Code that executes after component creation
        function startupFcn(app)
            addpath(genpath("lib"));
            addpath(genpath("src"));
            
            d = Data();
            sensitivity_colormap = flipud(lajolla());
            z_scores_colormap = broc();
            
            sensitivity_colorbar = Colorbar(app.DisplayPanel);
            sensitivity_colorbar.c_label = sprintf("mean log sensitivity, %s", Definitions.SENSITIVITY_UNITS);
            sensitivity_colorbar.c_lim = Definitions.SENSITIVITY_DATA_RANGE;
            sensitivity_colorbar.c_tick = Definitions.SENSITIVITY_TICKS;
            sensitivity_colorbar.c_tick_label = Definitions.SENSITIVITY_TICKS;
            sensitivity_colorbar.cmap = sensitivity_colormap;
            
            z_scores_colorbar = Colorbar(app.DisplayPanel);
            z_scores_colorbar.c_label = "Z-score";
            z_scores_colorbar.c_lim = Definitions.Z_SCORE_DATA_RANGE;
            z_scores_colorbar.c_tick = Definitions.Z_SCORE_TICKS;
            z_scores_colorbar.c_tick_label = Definitions.Z_SCORE_TICKS;
            z_scores_colorbar.cmap = z_scores_colormap;
            
            degrees_format = AxesFormat();
            degrees_format.x_lim = Definitions.DEGREES_LIM;
            degrees_format.x_tick = Definitions.DEGREES_TICK;
            degrees_format.x_tick_label = Definitions.DEGREES_TICK_LABEL;
            degrees_format.y_lim = Definitions.DEGREES_LIM;
            degrees_format.y_tick = Definitions.DEGREES_TICK;
            degrees_format.y_tick_label = Definitions.DEGREES_TICK_LABEL;
            degrees_format.colorbar = sensitivity_colorbar; % todo
            
            mm_format = AxesFormat();
            mm_format.x_lim = Definitions.MM_LIM;
            mm_format.x_tick = Definitions.MM_TICK;
            mm_format.x_tick_label = Definitions.MM_TICK_LABEL;
            mm_format.y_lim = Definitions.MM_LIM;
            mm_format.y_tick = Definitions.MM_TICK;
            mm_format.y_tick_label = Definitions.MM_TICK_LABEL;
            mm_format.colorbar = sensitivity_colorbar;
            
            row_count = MicroperimetryAxesArray.ROW_COUNT;
            column_count = MicroperimetryAxesArray.COLUMN_COUNT;
            ax_array = MicroperimetryAxesArray(app.DisplayPanel);
            ax_array.set_left_colorbar(sensitivity_colorbar);
            ax_array.set_right_colorbar(z_scores_colorbar);
            for row = 1 : row_count
                for col = 1 : column_count
                    location = false(1, 4);
                    if row == 1; location(MicroperimetryAxes.TOP) = true; end
                    if row == row_count; location(MicroperimetryAxes.BOTTOM) = true; end
                    if col == 1; location(MicroperimetryAxes.LEFT) = true; end
                    if col == column_count; location(MicroperimetryAxes.RIGHT) = true; end
                    ax = MicroperimetryAxes(app.DisplayPanel, d, location);
                    ax.set_degrees_format(degrees_format.copy());
                    ax.set_mm_format(mm_format.copy());
                    grid = ax.apply_to_mm_axes(@EtdrsGrid);
                    ax.register_feature("grid", grid);
                    if row == row_count && col == column_count
                        rose = ax.apply_to_mm_axes(@CompassRose);
                        ax.register_feature("rose", rose);
                    end
                    ax.update_appearance();
                    ax_array.set_axes(ax, row, col);
                end
            end
            
            app.ODButton.Tag = Definitions.OD_CHIRALITY;
            app.OSButton.Tag = Definitions.OS_CHIRALITY;
            
            app.data = d;
            app.axes = ax_array;
            
            ax_array.chirality = string(app.EyeSideButtonGroup.SelectedObject.Tag);
            ax_array.labels_visible = lower(string(app.ValueDisplaySwitch.Value));
            
            app.update_trees();
            app.axes.update_layout();
            app.axes.update_chirality();
            app.axes.update_values();
            app.axes.update_label_visibility();
        end
        
        % Selection changed function: EyeSideButtonGroup
        function EyeSideButtonGroupSelectionChanged(app, event)
            selectedButton = app.EyeSideButtonGroup.SelectedObject;
            app.axes.chirality = selectedButton.Tag;
            app.axes.update_chirality();
        end
        
        % Button pushed function: LoadDataButton
        function LoadDataButtonPushed(app, event)
            [file, path] = uigetfile("*.csv", "Load CSV microperimetry data file...");
            if file == 0
                return;
            end
            
            path = fullfile(path, file);
            try
                app.data.load_csv(path);
            catch e
                uialert(app.UIFigure, e.message, "Error loading file");
            end
            
            app.update_trees();
            app.axes.update_values();
        end
        
        % Value changed function: ValueDisplaySwitch
        function ValueDisplaySwitchValueChanged(app, event)
            app.axes.labels_visible = lower(string(app.ValueDisplaySwitch.Value));
            app.axes.update_label_visibility();
        end
        
        % Button pushed function: SaveFigureAsButton
        function SaveFigureAsButtonPushed(app, event)
            PNG_FILTER = "*.png";
            PDF_FILTER = "*.pdf";
            EPS_FILTER = "*.eps";
            TEX_FILTER = "*.tex";
            filters = [PNG_FILTER; PDF_FILTER; EPS_FILTER; TEX_FILTER];
            default_name = sprintf("microperimetry_figure_pt%d_eye%d", app.data.id, app.data.eye);
            [file, path, index] = uiputfile(filters, "Save figure as...", default_name);
            if file == 0
                return;
            end
            path = fullfile(path, file);
            
            fh = figure();
            fh.Color = "w";
            closer = onCleanup(@()close(fh));
            fh.Visible = "off";
            fh.Position = app.DisplayPanel.Position();
            ax = MicroperimetryAxesArray(fh, app.data);
            ax.row_titles = app.axes.row_titles;
            ax.layout = app.axes.layout;
            ax.build();
            ax.label_visibility_state = string(app.ValueDisplaySwitch.Value);
            ax.update();
            handle = fh;
            
            try
                switch filters(index)
                    case PNG_FILTER
                        export_fig(path, handle);
                    case PDF_FILTER
                        export_fig(path, '-nofontswap', handle);
                    case EPS_FILTER
                        export_fig(path, handle);
                    case TEX_FILTER
                        matlab2tikz(char(path), char("figurehandle"), handle)
                    otherwise
                        assert(false);
                end
            catch e
                uialert(app.UIFigure, e.message, "Error saving figure");
            end
        end
        
        % Selection changed function: LeftColumnTree
        function LeftColumnTreeSelectionChanged(app, event)
            selectedNodes = app.LeftColumnTree.SelectedNodes;
            assert(numel(selectedNodes) == 1);
            
            if selectedNodes.Parent == app.LeftColumnTree
                app.LeftColumnTree.SelectedNodes = app.left_selection;
                return;
            end
            app.left_selection = selectedNodes;
            
            app.axes.left_class = selectedNodes.Parent.Text;
            app.axes.left_data_type = selectedNodes.Text;
            app.axes.update_values();
        end
        
        % Selection changed function: CenterColumnTree
        function CenterColumnTreeSelectionChanged(app, event)
            selectedNodes = app.CenterColumnTree.SelectedNodes;
            assert(numel(selectedNodes) == 1);
            
            if selectedNodes.Parent == app.CenterColumnTree
                app.CenterColumnTree.SelectedNodes = app.center_selection;
                return;
            end
            app.center_selection = selectedNodes;
            
            app.axes.center_class = selectedNodes.Parent.Text;
            app.axes.center_data_type = selectedNodes.Text;
            app.axes.update_values();
        end
        
        % Selection changed function: RightColumnTree
        function RightColumnTreeSelectionChanged(app, event)
            selectedNodes = app.RightColumnTree.SelectedNodes;
            assert(numel(selectedNodes) == 1);
            
            if selectedNodes.Parent == app.RightColumnTree
                app.RightColumnTree.SelectedNodes = app.right_selection;
                return;
            end
            app.right_selection = selectedNodes;
            
            app.axes.right_class = selectedNodes.Parent.Text;
            app.axes.right_data_type = selectedNodes.Text;
            app.axes.update_values();
        end
    end
    
    % Component initialization
    methods (Access = private)
        
        % Create UIFigure and components
        function createComponents(app)
            
            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.AutoResizeChildren = 'off';
            app.UIFigure.Position = [100 100 1460 840];
            app.UIFigure.Name = 'MATLAB App';
            app.UIFigure.Resize = 'off';
            
            % Create OptionsPanel
            app.OptionsPanel = uipanel(app.UIFigure);
            app.OptionsPanel.AutoResizeChildren = 'off';
            app.OptionsPanel.Title = 'Options';
            app.OptionsPanel.FontSize = 14;
            app.OptionsPanel.Position = [1 1 180 840];
            
            % Create EyeSideButtonGroup
            app.EyeSideButtonGroup = uibuttongroup(app.OptionsPanel);
            app.EyeSideButtonGroup.AutoResizeChildren = 'off';
            app.EyeSideButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @EyeSideButtonGroupSelectionChanged, true);
            app.EyeSideButtonGroup.Title = 'Eye Side';
            app.EyeSideButtonGroup.FontSize = 14;
            app.EyeSideButtonGroup.Position = [11 258 158 80];
            
            % Create ODButton
            app.ODButton = uitogglebutton(app.EyeSideButtonGroup);
            app.ODButton.Text = 'OD';
            app.ODButton.FontSize = 14;
            app.ODButton.Position = [11 8 69 40];
            app.ODButton.Value = true;
            
            % Create OSButton
            app.OSButton = uitogglebutton(app.EyeSideButtonGroup);
            app.OSButton.Text = 'OS';
            app.OSButton.FontSize = 14;
            app.OSButton.Position = [80 8 69 40];
            
            % Create LoadDataButton
            app.LoadDataButton = uibutton(app.OptionsPanel, 'push');
            app.LoadDataButton.ButtonPushedFcn = createCallbackFcn(app, @LoadDataButtonPushed, true);
            app.LoadDataButton.FontSize = 14;
            app.LoadDataButton.Position = [11 768 158 40];
            app.LoadDataButton.Text = 'Load data...';
            
            % Create ValueDisplaySwitchLabel
            app.ValueDisplaySwitchLabel = uilabel(app.OptionsPanel);
            app.ValueDisplaySwitchLabel.HorizontalAlignment = 'center';
            app.ValueDisplaySwitchLabel.FontSize = 14;
            app.ValueDisplaySwitchLabel.Position = [42 226 90 22];
            app.ValueDisplaySwitchLabel.Text = 'Value Display';
            
            % Create ValueDisplaySwitch
            app.ValueDisplaySwitch = uiswitch(app.OptionsPanel, 'slider');
            app.ValueDisplaySwitch.ValueChangedFcn = createCallbackFcn(app, @ValueDisplaySwitchValueChanged, true);
            app.ValueDisplaySwitch.FontSize = 14;
            app.ValueDisplaySwitch.Position = [55 189 64 28];
            
            % Create SaveFigureAsButton
            app.SaveFigureAsButton = uibutton(app.OptionsPanel, 'push');
            app.SaveFigureAsButton.ButtonPushedFcn = createCallbackFcn(app, @SaveFigureAsButtonPushed, true);
            app.SaveFigureAsButton.FontSize = 14;
            app.SaveFigureAsButton.Position = [11 8 158 40];
            app.SaveFigureAsButton.Text = 'Save figure...';
            
            % Create LeftColumnSourceLabel
            app.LeftColumnSourceLabel = uilabel(app.OptionsPanel);
            app.LeftColumnSourceLabel.FontSize = 14;
            app.LeftColumnSourceLabel.Position = [11 736 158 22];
            app.LeftColumnSourceLabel.Text = 'Left Column Source';
            
            % Create LeftColumnTree
            app.LeftColumnTree = uitree(app.OptionsPanel);
            app.LeftColumnTree.SelectionChangedFcn = createCallbackFcn(app, @LeftColumnTreeSelectionChanged, true);
            app.LeftColumnTree.Position = [11 631 158 106];
            
            % Create NodeLeft
            app.NodeLeft = uitreenode(app.LeftColumnTree);
            app.NodeLeft.Text = 'NodeLeft';
            
            % Create NodeLeft1
            app.NodeLeft1 = uitreenode(app.NodeLeft);
            app.NodeLeft1.Text = 'NodeLeft1';
            
            % Create NodeLeft2
            app.NodeLeft2 = uitreenode(app.NodeLeft);
            app.NodeLeft2.Text = 'NodeLeft2';
            
            % Create NodeLeft3
            app.NodeLeft3 = uitreenode(app.NodeLeft);
            app.NodeLeft3.Text = 'NodeLeft3';
            
            % Create NodeLeft4
            app.NodeLeft4 = uitreenode(app.NodeLeft);
            app.NodeLeft4.Text = 'NodeLeft4';
            
            % Create CenterColumnSourceLabel
            app.CenterColumnSourceLabel = uilabel(app.OptionsPanel);
            app.CenterColumnSourceLabel.FontSize = 14;
            app.CenterColumnSourceLabel.Position = [11 597 158 22];
            app.CenterColumnSourceLabel.Text = 'Center Column Source';
            
            % Create CenterColumnTree
            app.CenterColumnTree = uitree(app.OptionsPanel);
            app.CenterColumnTree.SelectionChangedFcn = createCallbackFcn(app, @CenterColumnTreeSelectionChanged, true);
            app.CenterColumnTree.Position = [11 492 158 106];
            
            % Create NodeCenter
            app.NodeCenter = uitreenode(app.CenterColumnTree);
            app.NodeCenter.Text = 'NodeCenter';
            
            % Create NodeCenter1
            app.NodeCenter1 = uitreenode(app.NodeCenter);
            app.NodeCenter1.Text = 'NodeCenter1';
            
            % Create NodeCenter2
            app.NodeCenter2 = uitreenode(app.NodeCenter);
            app.NodeCenter2.Text = 'NodeCenter2';
            
            % Create NodeCenter3
            app.NodeCenter3 = uitreenode(app.NodeCenter);
            app.NodeCenter3.Text = 'NodeCenter3';
            
            % Create NodeCenter4
            app.NodeCenter4 = uitreenode(app.NodeCenter);
            app.NodeCenter4.Text = 'NodeCenter4';
            
            % Create RightColumnSourceLabel
            app.RightColumnSourceLabel = uilabel(app.OptionsPanel);
            app.RightColumnSourceLabel.FontSize = 14;
            app.RightColumnSourceLabel.Position = [11 457 158 22];
            app.RightColumnSourceLabel.Text = 'Right Column Source';
            
            % Create RightColumnTree
            app.RightColumnTree = uitree(app.OptionsPanel);
            app.RightColumnTree.SelectionChangedFcn = createCallbackFcn(app, @RightColumnTreeSelectionChanged, true);
            app.RightColumnTree.Position = [11 352 158 106];
            
            % Create NodeRight
            app.NodeRight = uitreenode(app.RightColumnTree);
            app.NodeRight.Text = 'NodeRight';
            
            % Create NodeRight1
            app.NodeRight1 = uitreenode(app.NodeRight);
            app.NodeRight1.Text = 'NodeRight1';
            
            % Create NodeRight2
            app.NodeRight2 = uitreenode(app.NodeRight);
            app.NodeRight2.Text = 'NodeRight2';
            
            % Create NodeRight3
            app.NodeRight3 = uitreenode(app.NodeRight);
            app.NodeRight3.Text = 'NodeRight3';
            
            % Create NodeRight4
            app.NodeRight4 = uitreenode(app.NodeRight);
            app.NodeRight4.Text = 'NodeRight4';
            
            % Create DisplayPanel
            app.DisplayPanel = uipanel(app.UIFigure);
            app.DisplayPanel.AutoResizeChildren = 'off';
            app.DisplayPanel.Title = 'Display';
            app.DisplayPanel.FontSize = 14;
            app.DisplayPanel.Position = [180 1 1280 840];
            
            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end
    
    % App creation and deletion
    methods (Access = public)
        
        % Construct app
        function app = microperimetry_gui
            
            % Create UIFigure and components
            createComponents(app)
            
            % Register the app with App Designer
            registerApp(app, app.UIFigure)
            
            % Execute the startup function
            runStartupFcn(app, @startupFcn)
            
            if nargout == 0
                clear app
            end
        end
        
        % Code that executes before app deletion
        function delete(app)
            
            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end