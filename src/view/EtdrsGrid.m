classdef EtdrsGrid < handle
    %{
    Units are in MM, apply to MM axes.
    %}
    
    properties
        laterality (1,1) string = Definitions.OD_LATERALITY
    end
    
    methods
        function obj = EtdrsGrid(parent)
            is_held = ishold(parent);
            hold(parent, "on");
            
            obj.draw_circle(parent, obj.CENTER, obj.OUTER_RADIUS, true);
            obj.draw_circle(parent, obj.CENTER, obj.MIDDLE_RADIUS);
            obj.draw_circle(parent, obj.CENTER, obj.INNER_RADIUS);
            
            radii = [obj.INNER_RADIUS obj.OUTER_RADIUS];
            for angle = obj.LINE_ANGLES
                obj.draw_radial_line(parent, angle, radii);
            end
            
            optic_disk_center = obj.compute_optic_disk_center();
            ph = obj.draw_circle(parent, optic_disk_center, obj.OPTIC_DISK_RADIUS, true);
            ph.EdgeColor = obj.OPTIC_DISK_EDGE_GRAY;
            ph.FaceColor = obj.OPTIC_DISK_FACE_GRAY;
            
            if ~is_held
                hold(parent, "off");
            end
            
            obj.optic_disk = ph;
            obj.parent = parent;
        end
        
        function update(obj)
            c = obj.compute_optic_disk_center();
            xy = obj.compute_circle_points(c, obj.OPTIC_DISK_RADIUS);
            obj.optic_disk.XData = xy(:, 1);
            obj.optic_disk.YData = xy(:, 2);
        end
    end
    
    properties (Access = private)
        parent
        optic_disk
    end
    
    properties (Access = private, Constant)
        STEP_SIZE (1,1) uint64 {mustBePositive} = 1000
        CENTER (1,2) double {mustBeReal,mustBeFinite} = [0 0]
        SCALE (1,1) double {mustBeReal,mustBeFinite,mustBePositive} = 1.0
        
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
            ph = patch(axh, xy(:, 1), xy(:, 2), obj.FACE_GRAY);
            ph.EdgeColor = obj.EDGE_GRAY;
            ph.FaceColor = obj.FACE_GRAY;
            if ~filled
                ph.FaceAlpha = 0.0;
            end
        end
        
        function xy = compute_circle_points(obj, center, radius)
            t = linspace(-pi, pi, obj.STEP_SIZE).';
            x = obj.scale_radius(radius .* cos(t)) + center(1);
            y = obj.scale_radius(radius .* sin(t)) + center(2);
            xy = [x y];
        end
        
        function xy = compute_optic_disk_center(obj)
            c = obj.OPTIC_DISK_CENTER_OFFSET;
            switch obj.laterality
                case Definitions.OD_LATERALITY
                    c(1) = -c(1);
                case Definitions.OS_LATERALITY
                    % noop
                otherwise
                    assert(false)
            end
            xy = obj.CENTER + c;
        end
        
        function ph = draw_radial_line(obj, axh, angle, radii)
            x = obj.scale_radius(radii .* cos(angle));
            y = obj.scale_radius(radii .* sin(angle));
            ph = plot(axh, x, y);
            ph.Color = obj.EDGE_GRAY;
        end
        
        function scaled = scale_radius(obj, radius)
            scaled = obj.SCALE .* radius;
        end
    end
end
