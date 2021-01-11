classdef MicroperimetryAxes < handle
    %MICROPERIMETRYAXES Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        x_title (1,1) string = ""
        y_title (1,1) string = ""
        top (1,1) logical = false
        bottom (1,1) logical = false
        left (1,1) logical = false
        right (1,1) logical = false
    end
    
    methods
        function obj = MicroperimetryAxes(parent, position)
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
            d.TickLabelInterpreter = "latex";
            d.Color = "none";
            m.Toolbar.Visible = "off";
            m.Interactions = [];
            
            s = scatter(d, 0, 0, 1, 0, "filled");
            s.XData = [];
            s.YData = [];
            s.CData = [];
            s.MarkerEdgeColor = [0 0 0];
            d.Color = "none"; % scatter() changes background color
            
            obj.deg_ax = d;
            obj.mm_ax = m;
            obj.scatter_h = s;
        end
        
        function build(obj)
            obj.build_axes(obj.MM_UNITS);
            grid = EtdrsGrid();
            grid.apply(obj.mm_ax);
            obj.build_axes(obj.DEG_UNITS);
        end
        
        function set_data(obj, x, y, v, point_size)
            % todo assert
            
            obj.scatter_h.XData = x;
            obj.scatter_h.YData = y;
            obj.scatter_h.CData = v;
            obj.scatter_h.SizeData = point_size;
            obj.build_labels(x, y, v);
        end
        
        function set_label_position(obj, x, y)
            % todo assert
            
            obj.scatter_h.XData = x;
            obj.scatter_h.YData = y;
            obj.update_labels();
            
            for i = 1 : numel(obj.scatter_h.CData)
                obj.text_h(i).Position(1:2) = [x(i) y(i)];
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
    end
    
    properties (Access = private, Constant)
        X = "X"
        Y = "Y"
        
        DEG_UNITS = "degrees"
        MM_UNITS = "mm"
        
        DEG_LIM = 15;
        DEG_STEP = 5;
        MM_PER_DEG = 0.288;
        MM_TICK_LIM = 4;
        MM_TICK_STEP = 1;
    end
    
    methods (Access = private)
        function build_labels(obj, x, y, v)
            v_count = numel(v);
            if v_count ~= numel(obj.text_h)
                obj.text_h = matlab.graphics.primitive.Text.empty(0, v_count);
                for i = 1 : v_count
                     th = text(obj.deg_ax, x(i), y(i), obj.to_string(v(i)));
                     th.VerticalAlignment = "top";
                     th.HorizontalAlignment = "left";
                     th.Interpreter = "latex";
                     obj.text_h(i) = th;
                end
            else
                obj.update_labels();
            end
        end
        
        function update_labels(obj)
            v = obj.scatter_h.CData;
            for i = 1 : numel(v)
                obj.text_h(i).String = obj.to_string(v(i));
            end
        end
        
        function reposition_labels(obj, x, y)
        end
        
        function build_axes(obj, units)
            ax = obj.get_axes(units);
            
            lim = obj.build_lim(units);
            ax.XLim = lim;
            ax.YLim = lim;
            
            tick = obj.build_tick(units);
            ax.XTick = tick;
            ax.YTick = tick;
            
            ax.XTickLabel = [];
            ax.YTickLabel = [];
            is_top = obj.top && units == obj.MM_UNITS;
            if  is_top || (obj.bottom && units == obj.DEG_UNITS)
                ax.XLabel.String = obj.build_label(obj.X, units, is_top);
                ax.XTickLabel = obj.build_tick_label(units);
            end
            is_left = obj.left && units == obj.DEG_UNITS;
            if  is_left || (obj.right && units == obj.MM_UNITS)
                ax.YLabel.String = obj.build_label(obj.Y, units, is_left);
                ax.YTickLabel = obj.build_tick_label(units);
            end
        end
        
        function ax = get_axes(obj, units)
            switch units
                case obj.DEG_UNITS
                    ax = obj.deg_ax;
                case obj.MM_UNITS
                    ax = obj.mm_ax;
                otherwise
                    assert(false);
            end
        end
        
        function value = build_lim(obj, units)
            DEG = [-obj.DEG_LIM obj.DEG_LIM];
            switch units
                case obj.DEG_UNITS
                    value = DEG;
                case obj.MM_UNITS
                    value = DEG .* obj.MM_PER_DEG;
                otherwise
                    assert(false);
            end
        end
        
        function value = build_label(obj, axis, units, full_label)
            e_str = obj.build_e_str(units);
            if full_label
                switch axis
                    case obj.X
                        title = obj.x_title;
                    case obj.Y
                        title = obj.y_title;
                    otherwise
                        assert(false);
                end
                value = [title, e_str];
            else
                value = e_str;
            end
        end
        
        function value = build_tick(obj, units)
            switch units
                case obj.DEG_UNITS
                    value = -obj.DEG_LIM : obj.DEG_STEP : obj.DEG_LIM;
                case obj.MM_UNITS
                    value = -obj.MM_TICK_LIM : obj.MM_TICK_STEP : obj.MM_TICK_LIM;
                otherwise
                    assert(false);
            end
        end
        
        function value = build_tick_label(obj, units)
            value = obj.to_tick_label(obj.build_tick(units));
        end
    end
    
    methods (Access = private, Static)
        function value = build_e_str(units)
            value = sprintf("Eccentricity, %s", units);
        end
        
        function label = to_tick_label(tick)
            label = string(num2str(abs(tick.'))).';
        end
        
        function v = to_string(d)
            v = sprintf("$%s$", num2str(d, "%.1f"));
        end
    end
end

