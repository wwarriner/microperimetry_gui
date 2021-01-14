classdef CompassRose < handle
    properties
        position (1,2) double {mustBeReal,mustBeFinite} = [0 0] % x, y of center
        arrow_length (1,2) double {mustBeReal,mustBeFinite} = [1 1] % NT, SI arrows
        label_nudge (1,1) double {mustBeReal,mustBeFinite,mustBeNonnegative} = 0.0
        
        line_width (1,1) double {mustBeReal,mustBeFinite,mustBePositive} = 1
        color (1,3) double = [0 0 0]
    end
    
    methods
        function apply(obj, axh)
            is_held = ishold(axh);
            hold(axh, "on");
            
            obj.draw_arrows(axh);
            obj.add_labels(axh);
            
            if ~is_held
                hold(axh, "off");
            end
        end
    end
    
    methods (Access = private)
        function ph = draw_arrows(obj, axh)
            x = obj.position(1);
            y = obj.position(2);
            center = [x y 0 0];
            
            nt = obj.arrow_length(1) .* [-0.5 0 1 0] ...
                + center;
            si = obj.arrow_length(2) .* [0 -0.5 0 1] ...
                + center;
            
            ph = quiver( ...
                axh, ...
                [nt(1) si(1)], ...
                [nt(2) si(2)], ...
                [nt(3) si(3)], ...
                [nt(4) si(4)], ...
                0 ...
                );
            ph.LineWidth = obj.line_width;
            ph.Color = obj.color;
            ph.MaxHeadSize = 0.5;
        end
        
        function th = add_labels(obj, axh)
            x = obj.position(1);
            y = obj.position(2);
            u = 0.5 .* obj.arrow_length(1);
            v = 0.5 .* obj.arrow_length(2);
            n = obj.label_nudge; % nudge
            
            th = cell(4, 1);
            th{1} = text(axh, x - u - n, y, "N");
            th{2} = text(axh, x + u + n, y, "T");
            th{3} = text(axh, x, y - v - n, "I");
            th{4} = text(axh, x, y + v + n, "S");
            for i = 1 : 4
                obj.format_text(th{i});
            end
        end
        
        function format_text(obj, th)
            th.HorizontalAlignment = "center";
            th.VerticalAlignment = "middle";
            th.Interpreter = "latex";
        end
    end
end

