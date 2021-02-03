classdef Colorbar < handle
    properties
        c_label (:,1) string = ""
        c_lim (2,1) double = [0 1]
        c_tick (:,1) double = 0:0.1:1
        c_tick_label (:,1) string = 0:0.1:1
        
        location (1,1) string = "east"
        cmap (:,3) double {mustBeReal,mustBeFinite} = parula
        
        font_name (1,1) string = "arial"
        font_size (1,1) double = 12
        interpreter (1,1) string = "tex"
        
        visible (1,1) string = "on"
    end
    
    methods
        function obj = Colorbar(parent)
            ax = axes(parent);
            ax.Units = "pixels";
            
            ax.Position(1:2) = 0;
            ax.Position(3) = parent.Position(3);
            pad_height = 1.0 - obj.VERTICAL_PAD_FRACTION;
            ax.Position(4) = pad_height .* parent.Position(4);
            pad = 0.5 .* obj.VERTICAL_PAD_FRACTION;
            ax.Position(2) = pad .* parent.Position(4);
            
            ax.Color = "none";
            ax.Box = "off";
            ax.XAxis.Visible = "off";
            ax.YAxis.Visible = "off";
            
            hold(ax, "on");
            
            cb = colorbar(ax);
            
            obj.parent = parent;
            obj.axes_handle = ax;
            obj.colorbar_handle = cb;
        end
        
        function update(obj)
            ax = obj.axes_handle;
            colormap(ax, obj.cmap);
            caxis(ax, obj.c_lim);
            
            cb = obj.colorbar_handle;
            cb.FontName = obj.font_name;
            cb.FontSize = obj.font_size;
            cb.Label.String = obj.c_label;
            cb.Label.FontName = obj.font_name;
            cb.Label.FontSize = obj.font_size;
            cb.Label.Interpreter = obj.interpreter;
            cb.Limits = obj.c_lim;
            cb.Ticks = obj.c_tick;
            cb.TickLabels = obj.c_tick_label;
            cb.TickLabelInterpreter = obj.interpreter;
            cb.Location = obj.location;
            cb.Visible = obj.visible;
        end
        
        function transplant(obj, new_parent)
            obj.axes_handle.Parent = new_parent;
            obj.parent = new_parent;
        end
    end
    
    properties (Access = private)
        parent
        axes_handle matlab.graphics.axis.Axes
        colorbar_handle matlab.graphics.illustration.ColorBar
    end
    
    properties (Access = private, Constant)
        VERTICAL_PAD_FRACTION (1,1) double {mustBeReal,mustBeFinite} = 0.4
    end
end

