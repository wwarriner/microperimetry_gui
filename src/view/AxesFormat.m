classdef AxesFormat < handle & matlab.mixin.Copyable
    %{
    A class holding used to format axes-like objects. The class exists to
    simplify setting the same properties on multiple axes in an AxesArray
    object.

    Most properties are pass-through for built-in Axes properties. A colorbar
    must also be set, dictating which Colorbar object will be used with the
    affected axes-like object. Sets the clim and colormap properties.
    %}
    properties
        x_label (:,1) string = ""
        x_lim (2,1) double = [0 1]
        x_tick (:,1) double = 0:0.1:1
        x_tick_label (:,1) string = 0:0.1:1
        
        y_label (:,1) string = ""
        y_lim (2,1) double = [0 1]
        y_tick (:,1) double = 0:0.1:1
        y_tick_label (:,1) string = 0:0.1:1
        
        font_name (1,1) string = "arial"
        font_size (1,1) double = 12
        interpreter (1,1) string = "tex"
        
        colorbar Colorbar
    end
    
    methods
        function apply(obj, ax, ~, ~)
            ax.XLabel.String = obj.x_label;
            ax.XLabel.FontName = obj.font_name;
            ax.XLabel.FontSize = obj.font_size;
            ax.XLabel.Interpreter = obj.interpreter;
            ax.XLim = obj.x_lim;
            ax.XTick = obj.x_tick;
            ax.XTickLabel = obj.x_tick_label;
            
            ax.YLabel.String = obj.y_label;
            ax.YLabel.FontName = obj.font_name;
            ax.YLabel.FontSize = obj.font_size;
            ax.YLabel.Interpreter = obj.interpreter;
            ax.YLim = obj.y_lim;
            ax.YTick = obj.y_tick;
            ax.YTickLabel = obj.y_tick_label;
            
            ax.FontName = obj.font_name;
            ax.FontSize = obj.font_size;
            ax.TickLabelInterpreter = obj.interpreter;
            ax.Colormap = obj.colorbar.cmap;
            ax.CLim = obj.colorbar.c_lim;
        end
    end
end
