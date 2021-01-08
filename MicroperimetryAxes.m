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
            d = axes(parent);
            d.Units = "pixels";
            d.Position = position;
            d.XAxisLocation = "bottom";
            d.YAxisLocation = "left";
            d.TickLabelInterpreter = "latex";
            d.Color = "w";
            
            m = axes(parent);
            m.Units = "pixels";
            m.Position = position;
            m.XAxisLocation = "top";
            m.YAxisLocation = "right";
            m.TickLabelInterpreter = "latex";
            m.Color = "none";
            
            obj.deg_ax = d;
            obj.mm_ax = m;
        end
        
        function build(obj)
            obj.build_axes(obj.DEG_UNITS);
            obj.build_axes(obj.MM_UNITS);
        end
        
        function set_data(obj, data, point_size)
            x = data(:, 1);
            y = data(:, 2);
            v = data(:, 3);
            scatter(obj.deg_ax, x, y, point_size, v, "filled");
            % generate labels from v
            % text(x, y, labels)
        end
    end
    
    properties (Access = private)
        deg_ax matlab.graphics.axis.Axes
        mm_ax matlab.graphics.axis.Axes
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
    end
end

