classdef Colorbar < handle
    properties
        cticks (:,1) double {mustBeReal,mustBeFinite} = [0 1]
        label (1,1) string = ""
    end
    
    methods
        function apply(obj, parent)
            axh = axes(parent);
            axh.Units = "pixels";
            axh.Position(1:2) = 0;
            axh.Position(3) = parent.Position(3);
            axh.Position(4) = 0.6 .* parent.Position(4);
            axh.Position(2) = 0.2 .* parent.Position(4);
            axh.Color = "none";
            axh.Box = "off";
            axh.XAxis.Visible = "off";
            axh.YAxis.Visible = "off";
            
            limits = [obj.cticks(1) obj.cticks(end)]
            caxis(axh, limits);
            
            cbh = colorbar(axh);
            cbh.Limits = limits;
            cbh.Ticks = obj.cticks;
            cbh.TickLabelInterpreter = "latex";
            cbh.Label.FontSize = 12;
            cbh.Label.String = obj.label;
            cbh.Label.Interpreter = "latex";
            cbh.Location = "east";
            
            obj.ax = axh;
            obj.ch = cbh;
        end
    end
    
    properties
        ax matlab.graphics.axis.Axes
        ch matlab.graphics.illustration.ColorBar
    end
end

