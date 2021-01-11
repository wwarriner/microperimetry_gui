classdef EtdrsGrid < handle
    properties
        step_size (1,1) uint64 {mustBePositive} = 1000
        center (1,2) double {mustBeReal,mustBeFinite} = [0 0]
        scale (1,1) double {mustBeReal,mustBeFinite,mustBePositive} = 1.0
        
        edge_color (1,3) double {mustBeReal,mustBeFinite,mustBeNonnegative,mustBeLessThanOrEqual(edge_color, 1.0)} = EtdrsGrid.EDGE_GRAY
        face_color (1,3) double {mustBeReal,mustBeFinite,mustBeNonnegative,mustBeLessThanOrEqual(face_color, 1.0)} = EtdrsGrid.FACE_GRAY
    end
    
    methods
        function apply(obj, axh)
            is_held = ishold(axh);
            hold(axh, "on");
            
            obj.draw_circle(axh, obj.center, obj.OUTER_RADIUS, true);
            obj.draw_circle(axh, obj.center, obj.MIDDLE_RADIUS);
            obj.draw_circle(axh, obj.center, obj.INNER_RADIUS);
            
            radii = [obj.INNER_RADIUS obj.OUTER_RADIUS];
            for angle = obj.LINE_ANGLES
                obj.draw_radial_line(axh, angle, radii);
            end
            
            % TODO blind spot
            
            if ~is_held
                hold(axh, "off");
            end
        end
    end
    
    properties (Access = private, Constant)
        INNER_RADIUS = 0.5
        MIDDLE_RADIUS = 1.5
        OUTER_RADIUS = 3.0
        LINE_ANGLES = [-3 -1 1 3] .* (pi / 4)
        
        EDGE_GRAY = [0.5 0.5 0.5];
        FACE_GRAY = [0.95 0.95 0.95];
    end
    
    methods (Access = private)
        function ph = draw_circle(obj, axh, center, radius, filled)
            if nargin < 5
                filled = false;
            end
            
            t = linspace(-pi, pi, obj.step_size);
            x = obj.scale_radius(radius .* cos(t)) + center(1);
            y = obj.scale_radius(radius .* sin(t)) + center(2);
            ph = patch(axh, x, y, obj.face_color);
            ph.EdgeColor = obj.edge_color;
            ph.FaceColor = obj.face_color;
            if ~filled
                ph.FaceAlpha = 0.0;
            end
        end
        
        function ph = draw_radial_line(obj, axh, angle, radii)
            x = obj.scale_radius(radii .* cos(angle));
            y = obj.scale_radius(radii .* sin(angle));
            ph = plot(axh, x, y);
            ph.Color = obj.edge_color;
        end
        
        function scaled = scale_radius(obj, radius)
            scaled = obj.scale .* radius;
        end
    end
end

