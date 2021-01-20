classdef CompassRose < handle
    properties
        chirality (1,1) string = Definitions.OD_CHIRALITY
        
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
            
            qh = obj.draw_arrows(axh);
            th = obj.add_labels(axh);
            
            if ~is_held
                hold(axh, "off");
            end
            
            obj.quiver_handle = qh;
            obj.label_handles = th;
        end
        
        function update(obj)
            xyuv = obj.compute_arrow_xyuv();
            qh = obj.quiver_handle;
            qh.XData = xyuv(:, 1);
            qh.YData = xyuv(:, 2);
            qh.UData = xyuv(:, 3);
            qh.VData = xyuv(:, 4);
            
            xy_ntsi = obj.compute_label_xy();
            th = obj.label_handles;
            for i = 1 : 4
                th{i}.Position([1 2]) = xy_ntsi(i, :);
            end
        end
    end
    
    properties (Access = private)
        quiver_handle
        label_handles
    end
    
    methods (Access = private)
        function qh = draw_arrows(obj, axh)
            xyuv = obj.compute_arrow_xyuv();
            qh = quiver( ...
                axh, ...
                xyuv(:, 1), ...
                xyuv(:, 2), ...
                xyuv(:, 3), ...
                xyuv(:, 4), ...
                0 ...
                );
            qh.LineWidth = obj.line_width;
            qh.Color = obj.color;
            qh.MaxHeadSize = 0.5;
        end
        
        function xyuv = compute_arrow_xyuv(obj)
            x = obj.position(1);
            y = obj.position(2);
            center = [x y 0 0];
            
            switch obj.chirality
                case Definitions.OD_CHIRALITY
                    nt_xyuv = [-0.5 0 1 0];
                case Definitions.OS_CHIRALITY
                    nt_xyuv = [0.5 0 -1 0];
                otherwise
                    assert(false);
            end
            
            nt = obj.arrow_length(1) .* nt_xyuv ...
                + center;
            si = obj.arrow_length(2) .* [0 -0.5 0 1] ...
                + center;
            
            xyuv = [nt; si];
        end
        
        function th = add_labels(obj, axh)
            xy_ntsi = obj.compute_label_xy();
            assert(all(size(xy_ntsi) == [4 2]));
            
            th = cell(4, 1);
            letters = ["N" "T" "S" "I"];
            for i = 1 : 4
                th{i} = text(axh, xy_ntsi(i, 1), xy_ntsi(i, 2), letters(i));
                obj.format_text(th{i});
            end
        end
        
        function xy_ntsi = compute_label_xy(obj)
            x = obj.position(1);
            y = obj.position(2);
            u = 0.5 .* obj.arrow_length(1);
            v = 0.5 .* obj.arrow_length(2);
            n = obj.label_nudge; % nudge
            
            x_pos = x + u + n;
            x_neg = x - u - n;
            switch obj.chirality
                case Definitions.OD_CHIRALITY
                    nx = x_neg;
                    tx = x_pos;
                case Definitions.OS_CHIRALITY
                    nx = x_pos;
                    tx = x_neg;
                otherwise
                    assert(false);
            end
            xy_ntsi = [ ...
                nx, y; ...
                tx, y; ...
                x, y + v + n; ...
                x, y - v - n; ...
                ];
        end
        
        function format_text(~, th)
            th.HorizontalAlignment = "center";
            th.VerticalAlignment = "middle";
            th.Interpreter = "latex";
        end
    end
end

