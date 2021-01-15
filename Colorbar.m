classdef Colorbar < handle
    properties
        cticks (:,1) double {mustBeReal,mustBeFinite} = [0 1]
        label (1,1) string = ""
        vertical_pad_fraction (1,1) double {mustBeReal,mustBeFinite} = 0.4
        location (1,1) string = "east"
        cmap (:,3) double {mustBeReal,mustBeFinite} = parula
    end
    
    methods
        function apply(obj, parent)
            axh = axes(parent);
            axh.Units = "pixels";
            axh.Position(1:2) = 0;
            axh.Position(3) = parent.Position(3);
            pad_height = 1.0 - obj.vertical_pad_fraction;
            axh.Position(4) = pad_height .* parent.Position(4);
            pad = 0.5 .* obj.vertical_pad_fraction;
            axh.Position(2) = pad .* parent.Position(4);
            axh.Color = "none";
            axh.Box = "off";
            axh.XAxis.Visible = "off";
            axh.YAxis.Visible = "off";
            colormap(axh, obj.cmap);
            
            limits = [obj.cticks(1) obj.cticks(end)];
            caxis(axh, limits);
            
            cbh = colorbar(axh);
            cbh.Limits = limits;
            cbh.Ticks = obj.cticks;
            cbh.TickLabelInterpreter = "latex";
            cbh.FontSize = 12;
            cbh.Label.FontSize = 12;
            cbh.Label.String = obj.label;
            cbh.Label.Interpreter = "latex";
            cbh.Location = obj.location;
            
            obj.ax = axh;
            obj.ch = cbh;
        end
    end
    
    properties
        ax matlab.graphics.axis.Axes
        ch matlab.graphics.illustration.ColorBar
    end
end

