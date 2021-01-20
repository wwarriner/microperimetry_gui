classdef EtdrsGrid < handle
    properties
        chirality (1,1) string = Definitions.OD_CHIRALITY
        
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
            
            % todo should shift by obj.center
            optic_disk_center = obj.compute_optic_disk_center();
            ph = obj.draw_circle(axh, optic_disk_center, obj.OPTIC_DISK_RADIUS, true);
            ph.EdgeColor = obj.OPTIC_DISK_EDGE_GRAY;
            ph.FaceColor = obj.OPTIC_DISK_FACE_GRAY;
            
            if ~is_held
                hold(axh, "off");
            end
            
            obj.optic_disk = ph;
            obj.update();
        end
        
        function update(obj)
            c = obj.compute_optic_disk_center();
            xy = obj.compute_circle_points(c, obj.OPTIC_DISK_RADIUS);
            obj.optic_disk.XData = xy(:, 1);
            obj.optic_disk.YData = xy(:, 2);
        end
    end
    
    properties (Access = private)
        optic_disk
    end
    
    properties (Access = private, Constant)
        INNER_RADIUS = 0.5
        MIDDLE_RADIUS = 1.5
        OUTER_RADIUS = 3.0
        LINE_ANGLES = [-3 -1 1 3] .* (pi / 4)
        
        EDGE_GRAY = [0.5 0.5 0.5];
        FACE_GRAY = [0.95 0.95 0.95];
        
        OPTIC_DISK_CENTER_OFFSET = [-4.32 0.66];
        OPTIC_DISK_RADIUS = 0.92;
        
        OPTIC_DISK_EDGE_GRAY = [0.25 0.25 0.25];
        OPTIC_DISK_FACE_GRAY = [0.5 0.5 0.5];
    end
    
    methods (Access = private)
        function ph = draw_circle(obj, axh, center, radius, filled)
            if nargin < 5
                filled = false;
            end
            
            xy = obj.compute_circle_points(center, radius);
            ph = patch(axh, xy(:, 1), xy(:, 2), obj.face_color);
            ph.EdgeColor = obj.edge_color;
            ph.FaceColor = obj.face_color;
            if ~filled
                ph.FaceAlpha = 0.0;
            end
        end
        
        function xy = compute_circle_points(obj, center, radius)
            t = linspace(-pi, pi, obj.step_size).';
            x = obj.scale_radius(radius .* cos(t)) + center(1);
            y = obj.scale_radius(radius .* sin(t)) + center(2);
            xy = [x y];
        end
        
        function xy = compute_optic_disk_center(obj)
            c = obj.OPTIC_DISK_CENTER_OFFSET;
            switch obj.chirality
                case Definitions.OD_CHIRALITY
                    % noop
                case Definitions.OS_CHIRALITY
                    c(1) = -c(1);
                otherwise
                    assert(false)
            end
            xy = obj.center + c;
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

