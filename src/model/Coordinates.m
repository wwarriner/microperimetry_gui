classdef Coordinates < handle
    methods
        function obj = Coordinates(coordinates_table)
            %{
            expects columns X and Y
            each row is one point
            %}
        end
        
        function x = get_x(obj, vision_type)
            x = obj.filter(obj.t.x, vision_type);
        end
        
        function y = get_y(obj, vision_type)
            y = obj.filter(obj.t.y, vision_type);
        end
        
        function v = filter(obj, v, vision_type)
            used = logical(obj.t{:, vision_type});
            v = v(used);
        end
    end
    
    properties (Access = private)
        t (:,:) table
    end
end

