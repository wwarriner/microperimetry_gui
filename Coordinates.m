classdef Coordinates < handle
    methods
        function obj = Coordinates(csv_file_path)
            %{
            expects columns X and Y
            each row is one point
            %}
            if nargin == 0
                obj.t = table();
            end
            
            t = readtable(csv_file_path);
            assert(0 < height(t));
            assert(2 <= width(t));
            
            t.Properties.VariableNames = lower(t.Properties.VariableNames);
            assert(ismember("x", t.Properties.VariableNames));
            assert(ismember("y", t.Properties.VariableNames));
            assert(ismember(lower(Definitions.MESOPIC), t.Properties.VariableNames));
            assert(ismember(lower(Definitions.SCOTOPIC), t.Properties.VariableNames));
            
            obj.t = t;
        end
        
        function x = get_x(obj, vision_type)
            x = obj.limit_to_used(obj.t.x, vision_type);
        end
        
        function y = get_y(obj, vision_type)
            y = obj.limit_to_used(obj.t.y, vision_type);
        end
        
        function v = limit_to_used(obj, v, vision_type)
            used = logical(obj.t{:, vision_type});
            v = v(used);
        end
    end
    
    properties (Access = private)
        t (:,:) table
    end
end

