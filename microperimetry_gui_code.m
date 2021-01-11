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
        SavefigureasButton        matlab.ui.control.Button
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
            ax.row_titles = ["Mesopic" "Scotopic"];
            ax.col_titles = ["Case" "Group Means" "Z-Scores"];
            ax.build();
            ax.label_visibility_state = string(app.DisplayValuesSwitch.Value);
            ax.update();
            
            app.ODButton.Tag = MicroperimetryData.OD_CHIRALITY;
            app.OSButton.Tag = MicroperimetryData.OS_CHIRALITY;
            
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
            [file, path] = uigetfile("*.csv", "Load CSV microperimetry data file");
            if file == 0
                return;
            end
            
            path = fullfile(path, file);
            try
                app.data.load_csv(path);
            catch e
                uialert(app.UIFigure, ["Error loading file", e.message]);
            end
            app.axes.update();
        end

        % Value changed function: DisplayValuesSwitch
        function DisplayValuesSwitchValueChanged(app, event)
            app.axes.label_visibility_state = string(app.DisplayValuesSwitch.Value);
            app.axes.update_label_visibility();
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.AutoResizeChildren = 'off';
            app.UIFigure.Position = [100 100 1280 840];
            app.UIFigure.Name = 'MATLAB App';
            app.UIFigure.Resize = 'off';

            % Create OptionsPanel
            app.OptionsPanel = uipanel(app.UIFigure);
            app.OptionsPanel.AutoResizeChildren = 'off';
            app.OptionsPanel.Title = 'Options';
            app.OptionsPanel.Position = [1 1 140 840];

            % Create EyeSideButtonGroup
            app.EyeSideButtonGroup = uibuttongroup(app.OptionsPanel);
            app.EyeSideButtonGroup.AutoResizeChildren = 'off';
            app.EyeSideButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @EyeSideButtonGroupSelectionChanged, true);
            app.EyeSideButtonGroup.Title = 'Eye Side';
            app.EyeSideButtonGroup.FontSize = 16;
            app.EyeSideButtonGroup.Position = [11 670 118 90];

            % Create ODButton
            app.ODButton = uitogglebutton(app.EyeSideButtonGroup);
            app.ODButton.Text = 'OD';
            app.ODButton.FontSize = 16;
            app.ODButton.Position = [11 9 49 49];
            app.ODButton.Value = true;

            % Create OSButton
            app.OSButton = uitogglebutton(app.EyeSideButtonGroup);
            app.OSButton.Text = 'OS';
            app.OSButton.FontSize = 16;
            app.OSButton.Position = [60 9 49 49];

            % Create LoadDataButton
            app.LoadDataButton = uibutton(app.OptionsPanel, 'push');
            app.LoadDataButton.ButtonPushedFcn = createCallbackFcn(app, @LoadDataButtonPushed, true);
            app.LoadDataButton.FontSize = 16;
            app.LoadDataButton.Position = [11 770 118 40];
            app.LoadDataButton.Text = 'Load data...';

            % Create DisplayValuesSwitchLabel
            app.DisplayValuesSwitchLabel = uilabel(app.OptionsPanel);
            app.DisplayValuesSwitchLabel.HorizontalAlignment = 'center';
            app.DisplayValuesSwitchLabel.FontSize = 16;
            app.DisplayValuesSwitchLabel.Position = [14 636 110 22];
            app.DisplayValuesSwitchLabel.Text = 'Display Values';

            % Create DisplayValuesSwitch
            app.DisplayValuesSwitch = uiswitch(app.OptionsPanel, 'slider');
            app.DisplayValuesSwitch.ValueChangedFcn = createCallbackFcn(app, @DisplayValuesSwitchValueChanged, true);
            app.DisplayValuesSwitch.FontSize = 16;
            app.DisplayValuesSwitch.Position = [38 601 62 27];
            app.DisplayValuesSwitch.Value = 'On';

            % Create SavefigureasButton
            app.SavefigureasButton = uibutton(app.OptionsPanel, 'push');
            app.SavefigureasButton.FontSize = 16;
            app.SavefigureasButton.Position = [5.5 10 131 40];
            app.SavefigureasButton.Text = 'Save figure as...';

            % Create DisplayPanel
            app.DisplayPanel = uipanel(app.UIFigure);
            app.DisplayPanel.AutoResizeChildren = 'off';
            app.DisplayPanel.Title = 'Display';
            app.DisplayPanel.Position = [141 1 1140 840];

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