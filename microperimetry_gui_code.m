classdef microperimetry_gui < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                  matlab.ui.Figure
        OptionsPanel              matlab.ui.container.Panel
        EyeSideButtonGroup        matlab.ui.container.ButtonGroup
        ODButton                  matlab.ui.control.ToggleButton
        OSButton                  matlab.ui.control.ToggleButton
        LoadDataButton            matlab.ui.control.Button
        DisplayValuesSwitchLabel  matlab.ui.control.Label
        DisplayValuesSwitch       matlab.ui.control.Switch
        SaveFigureAsButton        matlab.ui.control.Button
        PatientClassButtonGroup   matlab.ui.container.ButtonGroup
        NormalButton              matlab.ui.control.ToggleButton
        EarlyButton               matlab.ui.control.ToggleButton
        IntermediateButton        matlab.ui.control.ToggleButton
        DisplayPanel              matlab.ui.container.Panel
    end

    
    properties (Access = private)
        axes
        data
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            c = Coordinates("coordinates17.csv");
            d = MicroperimetryData(c);
            
            ax = MicroperimetryAxesArray(app.DisplayPanel, d);
            ax.build();
            ax.label_visibility_state = string(app.DisplayValuesSwitch.Value);
            ax.update();
            
            app.ODButton.Tag = Definitions.OD_CHIRALITY;
            app.OSButton.Tag = Definitions.OS_CHIRALITY;
            
            app.NormalButton.Tag = Definitions.NORMAL;
            app.EarlyButton.Tag = Definitions.EARLY;
            app.IntermediateButton.Tag = Definitions.INTERMEDIATE;
            
            app.data = d;
            app.axes = ax;
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
            app.axes.update();
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
            ax.col_titles = app.axes.col_titles;
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

        % Selection changed function: PatientClassButtonGroup
        function PatientClassButtonGroupSelectionChanged(app, event)
            selectedButton = app.PatientClassButtonGroup.SelectedObject;
            app.axes.patient_class = selectedButton.Tag;
            app.axes.update();
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.AutoResizeChildren = 'off';
            app.UIFigure.Position = [100 100 1420 840];
            app.UIFigure.Name = 'MATLAB App';
            app.UIFigure.Resize = 'off';

            % Create OptionsPanel
            app.OptionsPanel = uipanel(app.UIFigure);
            app.OptionsPanel.AutoResizeChildren = 'off';
            app.OptionsPanel.Title = 'Options';
            app.OptionsPanel.FontSize = 14;
            app.OptionsPanel.Position = [1 1 140 840];

            % Create EyeSideButtonGroup
            app.EyeSideButtonGroup = uibuttongroup(app.OptionsPanel);
            app.EyeSideButtonGroup.AutoResizeChildren = 'off';
            app.EyeSideButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @EyeSideButtonGroupSelectionChanged, true);
            app.EyeSideButtonGroup.Title = 'Eye Side';
            app.EyeSideButtonGroup.FontSize = 14;
            app.EyeSideButtonGroup.Position = [11 678 118 80];

            % Create ODButton
            app.ODButton = uitogglebutton(app.EyeSideButtonGroup);
            app.ODButton.Text = 'OD';
            app.ODButton.FontSize = 14;
            app.ODButton.Position = [11 8 49 40];
            app.ODButton.Value = true;

            % Create OSButton
            app.OSButton = uitogglebutton(app.EyeSideButtonGroup);
            app.OSButton.Text = 'OS';
            app.OSButton.FontSize = 14;
            app.OSButton.Position = [60 8 49 40];

            % Create LoadDataButton
            app.LoadDataButton = uibutton(app.OptionsPanel, 'push');
            app.LoadDataButton.ButtonPushedFcn = createCallbackFcn(app, @LoadDataButtonPushed, true);
            app.LoadDataButton.FontSize = 14;
            app.LoadDataButton.Position = [11 768 118 40];
            app.LoadDataButton.Text = 'Load data...';

            % Create DisplayValuesSwitchLabel
            app.DisplayValuesSwitchLabel = uilabel(app.OptionsPanel);
            app.DisplayValuesSwitchLabel.HorizontalAlignment = 'center';
            app.DisplayValuesSwitchLabel.FontSize = 14;
            app.DisplayValuesSwitchLabel.Position = [18 466 97 22];
            app.DisplayValuesSwitchLabel.Text = 'Display Values';

            % Create DisplayValuesSwitch
            app.DisplayValuesSwitch = uiswitch(app.OptionsPanel, 'slider');
            app.DisplayValuesSwitch.ValueChangedFcn = createCallbackFcn(app, @DisplayValuesSwitchValueChanged, true);
            app.DisplayValuesSwitch.FontSize = 14;
            app.DisplayValuesSwitch.Position = [35 430 64 28];
            app.DisplayValuesSwitch.Value = 'On';

            % Create SaveFigureAsButton
            app.SaveFigureAsButton = uibutton(app.OptionsPanel, 'push');
            app.SaveFigureAsButton.ButtonPushedFcn = createCallbackFcn(app, @SaveFigureAsButtonPushed, true);
            app.SaveFigureAsButton.FontSize = 14;
            app.SaveFigureAsButton.Position = [11 8 118 40];
            app.SaveFigureAsButton.Text = 'Save figure...';

            % Create PatientClassButtonGroup
            app.PatientClassButtonGroup = uibuttongroup(app.OptionsPanel);
            app.PatientClassButtonGroup.AutoResizeChildren = 'off';
            app.PatientClassButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @PatientClassButtonGroupSelectionChanged, true);
            app.PatientClassButtonGroup.Title = 'Patient Class';
            app.PatientClassButtonGroup.FontSize = 14;
            app.PatientClassButtonGroup.Position = [11 498 118 170];

            % Create NormalButton
            app.NormalButton = uitogglebutton(app.PatientClassButtonGroup);
            app.NormalButton.Text = 'Normal';
            app.NormalButton.FontSize = 14;
            app.NormalButton.Position = [11 98 100 40];
            app.NormalButton.Value = true;

            % Create EarlyButton
            app.EarlyButton = uitogglebutton(app.PatientClassButtonGroup);
            app.EarlyButton.Text = 'Early';
            app.EarlyButton.FontSize = 14;
            app.EarlyButton.Position = [11 58 100 40];

            % Create IntermediateButton
            app.IntermediateButton = uitogglebutton(app.PatientClassButtonGroup);
            app.IntermediateButton.Text = 'Intermediate';
            app.IntermediateButton.FontSize = 14;
            app.IntermediateButton.Position = [11 18 100 40];

            % Create DisplayPanel
            app.DisplayPanel = uipanel(app.UIFigure);
            app.DisplayPanel.AutoResizeChildren = 'off';
            app.DisplayPanel.Title = 'Display';
            app.DisplayPanel.FontSize = 14;
            app.DisplayPanel.Position = [141 1 1280 840];

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