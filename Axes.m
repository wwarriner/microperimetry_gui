classdef Axes < handle
    properties
        location (1,4) logical = [true true true true] % [top, bot, left, right]
        
        x_title_label (1,1) string = "MISSING X TITLE"
        y_title_label (1,1) string = "MISSING Y TITLE"
    end
    
    properties (Constant)
        INDIVIDUAL_STYLE = "individiual"
        GROUP_MEANS_STYLE = "group_means"
        Z_SCORES_STYLE = "z_scores"
        
        TOP_LOCATION = 1
        BOTTOM_LOCATION = 2
        LEFT_LOCATION = 3
        RIGHT_LOCATION = 4
        
        DEGREES_AXES_UNITS = Definitions.DEGREES_UNITS
        MM_AXES_UNITS = Definitions.MM_UNITS
        
        SENSITIVITY_COLORBAR_SIDE = "left"
        Z_SCORES_COLORBAR_SIDE = "right"
    end
    
    methods
        function obj = Axes(parent, position)
            m = axes(parent);
            m.Units = "pixels";
            m.Position = position;
            m.XAxisLocation = "top";
            m.YAxisLocation = "right";
            m.TickLabelInterpreter = "latex";
            m.Color = "w";
            m.Toolbar.Visible = "off";
            m.Interactions = [];
            
            d = axes(parent);
            d.Units = "pixels";
            d.Position = position;
            d.XAxisLocation = "bottom";
            d.YAxisLocation = "left";
            
            s = scatter(d, 0, 0, 1, 0, "filled");
            s.XData = [];
            s.YData = [];
            s.CData = [];
            s.MarkerEdgeColor = [0 0 0];
            
            d.TickLabelInterpreter = "latex";
            d.Color = "none"; % scatter() changes background color
            d.Toolbar.Visible = "off";
            d.Interactions = [];
            
            obj.deg_ax = d;
            obj.mm_ax = m;
            obj.scatter_h = s;
        end
        
        function set_color_info(obj, side, cmap, range)
            %{
            Used to set coloraxis information for synchronization with other
            axes.
            %}
            assert(ismember(side, obj.sides));
            
            assert(isnumeric(cmap));
            assert(~isempty(cmap));
            assert(size(cmap, 2) == 3);
            assert(all(0 <= cmap, "all"));
            assert(all(cmap <= 1, "all"));
            
            assert(isnumeric(range));
            assert(isvector(range));
            assert(numel(range) == 2);
            assert(all(0 < diff(range), "all"));
            
            switch side
                case obj.SENSITIVITY_COLORBAR_SIDE
                    obj.left_cmap = cmap;
                    obj.left_crange = range;
                case obj.Z_SCORES_COLORBAR_SIDE
                    obj.right_cmap = cmap;
                    obj.right_crange = range;
                otherwise
                    assert(false);
            end
        end
        
        function set_style(obj, style)
            SENSITIVITY_STYLES = [obj.INDIVIDUAL_STYLE, obj.GROUP_MEANS_STYLE];
            Z_SCORES_STYLES = obj.Z_SCORES_STYLE;
            
            is_left = ismember(style, SENSITIVITY_STYLES);
            is_right = ismember(style, Z_SCORES_STYLES);
            if is_left
                s = obj.SENSITIVITY_COLORBAR_SIDE;
            elseif is_right
                s = obj.Z_SCORES_COLORBAR_SIDE;
            else
                assert(false);
            end
            assert(ismember(s, obj.sides));
            
            obj.style = style;
            obj.side = s;
        end
        
        function build(obj)
            obj.build_axes(obj.MM_AXES_UNITS);
            obj.build_axes(obj.DEGREES_AXES_UNITS);
        end
        
        function apply_to_axes(obj, axes_units, applicator)
            %{
            aplicator is object with apply() function accepting axes object
            %}
            switch axes_units
                case obj.DEGREES_AXES_UNITS
                    applicator.apply(obj.deg_ax);
                case obj.MM_AXES_UNITS
                    applicator.apply(obj.mm_ax);
                otherwise
                    assert(false);
            end
        end
        
        function set_data(obj, data, point_size)
            x = data.x;
            y = data.y;
            v = data.v;
            
            assert(isnumeric(x));
            assert(isvector(x));
            assert(isreal(x));
            assert(all(isfinite(x)));
            
            assert(isnumeric(y));
            assert(isvector(y));
            assert(numel(y) == numel(x));
            assert(isreal(y));
            assert(all(isfinite(y)));
            
            assert(isnumeric(v));
            assert(isvector(v));
            assert(numel(v) == numel(x));
            assert(isreal(v));
            assert(all(isfinite(v)));
            
            obj.scatter_h.XData = x;
            obj.scatter_h.YData = y;
            obj.scatter_h.CData = v;
            obj.scatter_h.SizeData = point_size;
            obj.build_data_labels(x, y, v);
        end
        
        function update(obj)
            obj.update_color_info();
            obj.set_axes_labels(obj.DEGREES_AXES_UNITS);
            obj.set_axes_labels(obj.MM_AXES_UNITS);
        end
        
        function update_color_info(obj)
            ax = obj.deg_ax;
            switch obj.side
                case obj.SENSITIVITY_COLORBAR_SIDE
                    ax.Colormap = obj.left_cmap;
                    ax.CLim = obj.left_crange;
                case obj.Z_SCORES_COLORBAR_SIDE
                    ax.Colormap = obj.right_cmap;
                    ax.CLim = obj.right_crange;
                otherwise
                    assert(false);
            end
        end
        
        function set_label_position(obj, x, y)
            % todo assert
            
            obj.scatter_h.XData = x;
            obj.scatter_h.YData = y;
            obj.update_data_labels();
            
            for i = 1 : numel(obj.scatter_h.CData)
                obj.text_h(i).Position(1:2) = [...
                    x(i) + tanh(x(i)) * 0.5 ... % spreads out points near middle
                    y(i) - 0.4 ... % moves text out of scatter circles
                    ];
            end
        end
        
        function set_label_visibility_state(obj, state)
            count = numel(obj.text_h);
            if count == 0
                return;
            end
            switch state
                case "On"
                    [obj.text_h.Visible] = deal("on");
                case "Off"
                    [obj.text_h.Visible] = deal("off");
                otherwise
                    assert(false);
            end
        end
    end
    
    properties (Access = private)
        deg_ax matlab.graphics.axis.Axes
        mm_ax matlab.graphics.axis.Axes
        scatter_h matlab.graphics.chart.primitive.Scatter
        text_h matlab.graphics.primitive.Text
        
        left_cmap (:,3) double {mustBeReal,mustBeFinite,mustBeNonnegative,mustBeLessThanOrEqual(left_cmap,1)}
        left_crange (1,2) double {mustBeReal,mustBeFinite}
        
        right_cmap (:,3) double {mustBeReal,mustBeFinite,mustBeNonnegative,mustBeLessThanOrEqual(right_cmap,1)}
        right_crange (1,2) double {mustBeReal,mustBeFinite}
        
        style (1,1) string = Axes.INDIVIDUAL_STYLE
        side (1,1) string = Axes.SENSITIVITY_COLORBAR_SIDE
    end
    
    properties (Dependent, Access = private)
        sides
        x_data (:,1) double {mustBeReal,mustBeFinite}
        y_data (:,1) double {mustBeReal,mustBeFinite}
        c_data (:,1) double {mustBeReal,mustBeFinite}
    end
    
    properties (Constant, Access = private)
        X = "X"
        Y = "Y"
        
        X_TITLE_INDIVIDUAL = "Patient %s"
        X_TITLE_GROUP_MEANS = "%s Means"
        X_TITLE_Z_SCORES = "%s Z-Scores"
    end
    
    methods (Access = private)
        function build_data_labels(obj, x, y, v)
            for h = obj.text_h(:)
                delete(h);
            end
            v_count = numel(v);
            obj.text_h = matlab.graphics.primitive.Text.empty(0, v_count);
            for i = 1 : v_count
                th = text(obj.deg_ax, x(i), y(i), obj.to_string(v(i)));
                th.VerticalAlignment = "top";
                th.HorizontalAlignment = "center";
                th.Interpreter = "latex";
                obj.text_h(i) = th;
            end
        end
        
        function update_data_labels(obj)
            v = obj.scatter_h.CData;
            for i = 1 : numel(v)
                obj.text_h(i).String = obj.to_string(v(i));
            end
        end
        
        function build_axes(obj, axes_units)
            ax = obj.get_axes(axes_units);
            
            lim = obj.build_lim(axes_units);
            ax.XLim = lim;
            ax.YLim = lim;
            
            tick = obj.build_tick(axes_units);
            ax.XTick = tick;
            ax.YTick = tick;
            
            ax.XTickLabel = [];
            ax.YTickLabel = [];
            
            obj.set_axes_labels(axes_units);
        end
        
        function value = build_lim(obj, axes_units)
            DEG = [-Definitions.DEGREES_LIM Definitions.DEGREES_LIM];
            switch axes_units
                case obj.DEGREES_AXES_UNITS
                    value = DEG;
                case obj.MM_AXES_UNITS
                    value = DEG .* Definitions.MM_PER_DEG;
                otherwise
                    assert(false);
            end
        end
        
        function value = build_tick(obj, axes_units)
            switch axes_units
                case obj.DEGREES_AXES_UNITS
                    value = -Definitions.DEGREES_LIM : Definitions.DEGREES_STEP : Definitions.DEGREES_LIM;
                case obj.MM_AXES_UNITS
                    value = -Definitions.MM_TICK_LIM : Definitions.MM_TICK_STEP : Definitions.MM_TICK_LIM;
                otherwise
                    assert(false);
            end
        end
        
        function set_axes_labels(obj, axes_units)
            ax = obj.get_axes(axes_units);
            is_top = obj.location(obj.TOP_LOCATION) && axes_units == obj.MM_AXES_UNITS;
            is_bottom = obj.location(obj.BOTTOM_LOCATION) && axes_units == obj.DEGREES_AXES_UNITS;
            if  is_top || is_bottom
                ax.XLabel.String = obj.build_axes_label(obj.X, axes_units, is_top);
                ax.XLabel.Interpreter = "latex";
                ax.XTickLabel = obj.build_tick_label(axes_units);
            end
            is_left = obj.location(obj.LEFT_LOCATION) && axes_units == obj.DEGREES_AXES_UNITS;
            is_right = obj.location(obj.RIGHT_LOCATION) && axes_units == obj.MM_AXES_UNITS;
            if  is_left || is_right
                ax.YLabel.String = obj.build_axes_label(obj.Y, axes_units, is_left);
                ax.YLabel.Interpreter = "latex";
                ax.YTickLabel = obj.build_tick_label(axes_units);
            end
        end
        
        function value = build_tick_label(obj, units)
            value = obj.to_tick_label(obj.build_tick(units));
        end
        
        function value = build_axes_label(obj, axis, axes_units, full_label)
            e_str = strjoin([init_cap(Definitions.ECCENTRICITY), "%s"], ", ");
            e_str = sprintf(e_str, axes_units);
            if full_label
                switch axis
                    case obj.X
                        title = obj.build_x_title();
                    case obj.Y
                        title = obj.build_y_title();
                    otherwise
                        assert(false);
                end
                value = [title, e_str];
            else
                value = e_str;
            end
        end
        
        function title = build_x_title(obj)
            title = obj.get_base_x_title();
            title = sprintf(title, obj.x_title_label);
            units = obj.get_x_units();
            title = strjoin([title, units], ", ");
        end
        
        function title = build_y_title(obj)
            title = obj.y_title_label;
        end
        
        function base = get_base_x_title(obj)
            switch obj.style
                case obj.INDIVIDUAL_STYLE
                    base = obj.X_TITLE_INDIVIDUAL;
                case obj.GROUP_MEANS_STYLE
                    base = obj.X_TITLE_GROUP_MEANS;
                case obj.Z_SCORES_STYLE
                    base = obj.X_TITLE_Z_SCORES;
                otherwise
                    assert(false);
            end
        end
        
        function units = get_x_units(obj)
            switch obj.style
                case obj.INDIVIDUAL_STYLE
                    units = Definitions.SENSITIVITY_UNITS;
                case obj.GROUP_MEANS_STYLE
                    units = Definitions.SENSITIVITY_UNITS;
                case obj.Z_SCORES_STYLE
                    units = [];
                otherwise
                    assert(false);
            end
        end
        
        function ax = get_axes(obj, units)
            switch units
                case obj.DEGREES_AXES_UNITS
                    ax = obj.deg_ax;
                case obj.MM_AXES_UNITS
                    ax = obj.mm_ax;
                otherwise
                    assert(false);
            end
        end
    end
    
    methods % private accessors
        function value = get.sides(obj)
            value = [obj.SENSITIVITY_COLORBAR_SIDE, obj.Z_SCORES_COLORBAR_SIDE];
        end
        
        function value = get.x_data(obj)
            value = obj.scatter_h.XData;
        end
        
        function value = get.y_data(obj)
            value = obj.scatter_h.XData;
        end
        
        function value = get.c_data(obj)
            value = obj.scatter_h.CData;
        end
    end
    
    methods (Access = private, Static)
        function v = to_string(d)
            v = sprintf("$%s$", num2str(d, "%.1f"));
        end
        
        function label = to_tick_label(tick)
            label = string(num2str(abs(tick.'))).';
        end
    end
end

