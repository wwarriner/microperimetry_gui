classdef CompassRose < handle
    %{
    Units are in MM, apply to MM axes.
    %}
    
    properties
        laterality (1,1) string = Definitions.DEFAULT_LATERALITY_VALUE
        
        font_name (1,1) string = "arial"
        font_size (1,1) double = 10
        interpreter (1,1) string = "tex"
    end
    
    methods
        function obj = CompassRose(parent)
            is_held = ishold(parent);
            hold(parent, "on");
            
            qh = obj.draw_arrows(parent);
            th = obj.add_labels(parent);
            
            if ~is_held
                hold(parent, "off");
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
    
    properties (Access = private, Constant)
        POSITION (1,2) double {mustBeReal,mustBeFinite} = [3.2 -3.2] % x, y of center
        ARROW_LENGTH (1,2) double {mustBeReal,mustBeFinite} = [1 1] % NT, SI arrows
        LABEL_NUDGE (1,1) double {mustBeReal,mustBeFinite,mustBeNonnegative} = 0.25
        
        LINE_WIDTH (1,1) double {mustBeReal,mustBeFinite,mustBePositive} = 1
        COLOR (1,3) double = [0 0 0]
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
            qh.LineWidth = obj.LINE_WIDTH;
            qh.Color = obj.COLOR;
            qh.MaxHeadSize = 0.5;
        end
        
        function xyuv = compute_arrow_xyuv(obj)
            x = obj.POSITION(1);
            y = obj.POSITION(2);
            center = [x y 0 0];
            
            switch obj.laterality
                case Definitions.OD_LATERALITY_VALUE
                    nt_xyuv = [0.5 0 -1 0];
                case Definitions.OS_LATERALITY_VALUE
                    nt_xyuv = [-0.5 0 1 0];
                otherwise
                    assert(false);
            end
            
            nt = obj.ARROW_LENGTH(1) .* nt_xyuv ...
                + center;
            si = obj.ARROW_LENGTH(2) .* [0 -0.5 0 1] ...
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
            x = obj.POSITION(1);
            y = obj.POSITION(2);
            u = 0.5 .* obj.ARROW_LENGTH(1);
            v = 0.5 .* obj.ARROW_LENGTH(2);
            n = obj.LABEL_NUDGE; % nudge
            
            x_pos = x + u + n;
            x_neg = x - u - n;
            switch obj.laterality
                case Definitions.OD_LATERALITY_VALUE
                    nx = x_pos;
                    tx = x_neg;
                case Definitions.OS_LATERALITY_VALUE
                    nx = x_neg;
                    tx = x_pos;
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
        
        function format_text(obj, th)
            th.FontName = obj.font_name;
            th.FontSize = obj.font_size;
            th.Interpreter = obj.interpreter;
            th.HorizontalAlignment = "center";
            th.VerticalAlignment = "middle";
        end
    end
end

