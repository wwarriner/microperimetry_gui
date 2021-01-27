classdef microperimetry_gui < matlab.apps.AppBase
    
    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                    matlab.ui.Figure
        OptionsPanel                matlab.ui.container.Panel
        EyeSideButtonGroup          matlab.ui.container.ButtonGroup
        ODButton                    matlab.ui.control.ToggleButton
        OSButton                    matlab.ui.control.ToggleButton
        LoadDataButton              matlab.ui.control.Button
        DisplayValuesSwitchLabel    matlab.ui.control.Label
        DisplayValuesSwitch         matlab.ui.control.Switch
        SaveFigureAsButton          matlab.ui.control.Button
        LookupLabel                 matlab.ui.control.Label
        LookupListBox               matlab.ui.control.ListBox
        PatientClassListBox_2Label  matlab.ui.control.Label
        PatientClassListBox         matlab.ui.control.ListBox
        FigureLayoutLabel           matlab.ui.control.Label
        FigureLayoutListBox         matlab.ui.control.ListBox
        DisplayPanel                matlab.ui.container.Panel
    end
    
    properties (Access = private)
        axes
        data
    end
    
    methods (Access = private)
        function update(app)
            app.axes.update();
            app.update_lookup_list_box();
            app.update_patient_class_list_box();
            app.update_figure_layout_list_box();
        end
        
        function update_axes(app)
            app.axes.update();
        end
        
        function update_lookup_list_box(app)
            app.LookupLabel.Text = app.axes.lookup_title;
            
            old_value = app.LookupListBox.Value;
            app.LookupListBox.Items = app.axes.lookup_items;
            new_items = app.LookupListBox.Items;
            if ismember(old_value, new_items)
                app.LookupListBox.Value = old_value;
            elseif 0 < numel(new_items)
                app.LookupListBox.Value = new_items(1);
            else
                app.LookupListBox.Enable = "off";
                return;
            end
            app.axes.lookup_item = app.LookupListBox.Value;
            
            if isempty(app.axes.lookup_items)
                app.LookupListBox.Enable = "off";
            else
                app.LookupListBox.Enable = "on";
            end
        end
        
        function update_patient_class_list_box(app)
            old_value = app.PatientClassListBox.Value;
            app.PatientClassListBox.Items = app.axes.classes;
            new_items = app.PatientClassListBox.Items;
            if ismember(old_value, new_items)
                app.PatientClassListBox.Value = old_value;
            elseif 0 < numel(new_items)
                app.PatientClassListBox.Value = new_items(1);
            else
                app.PatientClassListBox.Enable = "off";
                return;
            end
            app.axes.patient_class = app.PatientClassListBox.Value;
            
            if isempty(app.axes.classes)
                app.PatientClassListBox.Enable = "off";
            else
                app.PatientClassListBox.Enable = "on";
            end
        end
        
        function update_figure_layout_list_box(app)
            app.FigureLayoutListBox.Items = pretty_print(app.axes.allowed_layouts);
        end
    end
    
    % Callbacks that handle component events
    methods (Access = private)
        
        % Code that executes after component creation
        function startupFcn(app)
            addpath(genpath("lib"));
            
            c = Coordinates("coordinates17.csv");
            d = MicroperimetryData(c);
            
            i_info = LayoutInfo(d);
            i_info.column_styles = [Axes.INDIVIDUAL_STYLE, Axes.GROUP_MEANS_STYLE, Axes.Z_SCORES_STYLE];
            i_info.column_keywords = [Definitions.INDIVIDUAL, Definitions.GROUP_MEANS, Definitions.Z_SCORES];
            i_info.column_data_sources = [Definitions.LOOKUP_DATA_SOURCE, Definitions.CLASS_DATA_SOURCE, Definitions.CLASS_DATA_SOURCE];
            i_info.lookup_class = Definitions.INDIVIDUAL;
            i_info.lookup_title = pretty_print(Definitions.PATIENT);
            gm_info = LayoutInfo(d);
            gm_info.column_styles = [Axes.GROUP_MEANS_STYLE, Axes.GROUP_MEANS_STYLE, Axes.Z_SCORES_STYLE];
            gm_info.column_keywords = [Definitions.GROUP_MEANS, Definitions.GROUP_MEANS, Definitions.Z_SCORES];
            gm_info.column_data_sources = [Definitions.LOOKUP_DATA_SOURCE, Definitions.CLASS_DATA_SOURCE, Definitions.CLASS_DATA_SOURCE];
            gm_info.lookup_class = Definitions.GROUP_MEANS;
            gm_info.lookup_title = pretty_print(Definitions.PATIENT);
            keys = { ...
                char(Definitions.INDIVIDUAL), ...
                char(Definitions.GROUP_MEANS) ...
                };
            values = { ...
                i_info, ...
                gm_info ...
                };
            layouts = containers.Map(keys, values);
            
            ax = MicroperimetryAxesArray(app.DisplayPanel, d, layouts);
            ax.build();
            ax.label_visibility_state = string(app.DisplayValuesSwitch.Value);
            
            app.ODButton.Tag = Definitions.OD_CHIRALITY;
            app.OSButton.Tag = Definitions.OS_CHIRALITY;
            
            app.data = d;
            app.axes = ax;
            
            app.update_lookup_list_box();
            app.update_patient_class_list_box();
            app.update_figure_layout_list_box();
            app.axes.layout = app.FigureLayoutListBox.Value;
            app.axes.update();
        end
        
        % Selection changed function: EyeSideButtonGroup
        function EyeSideButtonGroupSelectionChanged(app, event)
            selectedButton = app.EyeSideButtonGroup.SelectedObject;
            app.data.chirality = selectedButton.Tag;
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
            app.update_lookup_list_box();
            app.update_patient_class_list_box();
            app.update_figure_layout_list_box();
            app.update_axes();
        end
        
        % Value changed function: DisplayValuesSwitch
        function DisplayValuesSwitchValueChanged(app, event)
            app.axes.label_visibility_state = string(app.DisplayValuesSwitch.Value);
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
            ax.label_visibility_state = string(app.DisplayValuesSwitch.Value);
            ax.update();
            handle = fh;
            
            try
                switch filters(index)
                    case PNG_FILTER
                        export_fig(path, handle);
                    case PDF_FILTER
                        export_fig(path, handle);
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
        
        % Value changed function: LookupListBox
        function LookupListBoxValueChanged(app, event)
            value = app.LookupListBox.Value;
            app.axes.lookup_item = value;
            app.update_patient_class_list_box();
            app.update_axes();
        end
        
        % Value changed function: PatientClassListBox
        function PatientClassListBoxValueChanged(app, event)
            value = app.PatientClassListBox.Value;
            app.axes.patient_class = value;
            app.update_axes();
        end
        
        % Value changed function: FigureLayoutListBox
        function FigureLayoutListBoxValueChanged(app, event)
            value = app.FigureLayoutListBox.Value;
            app.axes.layout = value;
            %             if app.data.has_individuals()
            %                 app.axes.layout = app.axes.INDIVIDUAL_LAYOUT;
            %             else
            %                 app.axes.layout = app.axes.GROUP_MEANS_LAYOUT;
            %             end
            app.update_lookup_list_box();
            app.update_patient_class_list_box();
            app.update_axes();
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
            app.EyeSideButtonGroup.Position = [11 288 158 80];
            
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
            
            % Create DisplayValuesSwitchLabel
            app.DisplayValuesSwitchLabel = uilabel(app.OptionsPanel);
            app.DisplayValuesSwitchLabel.HorizontalAlignment = 'center';
            app.DisplayValuesSwitchLabel.FontSize = 14;
            app.DisplayValuesSwitchLabel.Position = [40 255 97 22];
            app.DisplayValuesSwitchLabel.Text = 'Display Values';
            
            % Create DisplayValuesSwitch
            app.DisplayValuesSwitch = uiswitch(app.OptionsPanel, 'slider');
            app.DisplayValuesSwitch.ValueChangedFcn = createCallbackFcn(app, @DisplayValuesSwitchValueChanged, true);
            app.DisplayValuesSwitch.FontSize = 14;
            app.DisplayValuesSwitch.Position = [57 219 64 28];
            app.DisplayValuesSwitch.Value = 'On';
            
            % Create SaveFigureAsButton
            app.SaveFigureAsButton = uibutton(app.OptionsPanel, 'push');
            app.SaveFigureAsButton.ButtonPushedFcn = createCallbackFcn(app, @SaveFigureAsButtonPushed, true);
            app.SaveFigureAsButton.FontSize = 14;
            app.SaveFigureAsButton.Position = [11 8 118 40];
            app.SaveFigureAsButton.Text = 'Save figure...';
            
            % Create LookupLabel
            app.LookupLabel = uilabel(app.OptionsPanel);
            app.LookupLabel.VerticalAlignment = 'top';
            app.LookupLabel.FontSize = 14;
            app.LookupLabel.Position = [11 666 158 22];
            app.LookupLabel.Text = '<Lookup>';
            
            % Create LookupListBox
            app.LookupListBox = uilistbox(app.OptionsPanel);
            app.LookupListBox.Items = {'Item 1', 'Item 2', 'Item 3', 'Item 4', 'Item 5', 'Item 6', 'Item 7', 'Item 8', 'Item 9', 'Item 10', 'Item 11', 'Item 12'};
            app.LookupListBox.ValueChangedFcn = createCallbackFcn(app, @LookupListBoxValueChanged, true);
            app.LookupListBox.FontSize = 14;
            app.LookupListBox.Position = [11 468 158 199];
            
            % Create PatientClassListBox_2Label
            app.PatientClassListBox_2Label = uilabel(app.OptionsPanel);
            app.PatientClassListBox_2Label.VerticalAlignment = 'top';
            app.PatientClassListBox_2Label.FontSize = 14;
            app.PatientClassListBox_2Label.Position = [11 436 158 22];
            app.PatientClassListBox_2Label.Text = 'Patient Class';
            
            % Create PatientClassListBox
            app.PatientClassListBox = uilistbox(app.OptionsPanel);
            app.PatientClassListBox.Items = {'Item 1', 'Item 2', 'Item 3'};
            app.PatientClassListBox.ValueChangedFcn = createCallbackFcn(app, @PatientClassListBoxValueChanged, true);
            app.PatientClassListBox.FontSize = 14;
            app.PatientClassListBox.Position = [11 375 158 62];
            
            % Create FigureLayoutLabel
            app.FigureLayoutLabel = uilabel(app.OptionsPanel);
            app.FigureLayoutLabel.VerticalAlignment = 'top';
            app.FigureLayoutLabel.FontSize = 14;
            app.FigureLayoutLabel.Position = [11 736 158 22];
            app.FigureLayoutLabel.Text = 'Figure Layout';
            
            % Create FigureLayoutListBox
            app.FigureLayoutListBox = uilistbox(app.OptionsPanel);
            app.FigureLayoutListBox.Items = {'Item 1', 'Item 2'};
            app.FigureLayoutListBox.ValueChangedFcn = createCallbackFcn(app, @FigureLayoutListBoxValueChanged, true);
            app.FigureLayoutListBox.FontSize = 14;
            app.FigureLayoutListBox.Position = [11 695 158 42];
            
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