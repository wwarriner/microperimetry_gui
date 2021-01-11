classdef Coordinates < handle
    properties (SetAccess = private)
        x (:,1) double {mustBeReal,mustBeFinite}
        y (:,1) double {mustBeReal,mustBeFinite}
    end
    
    methods
        function obj = Coordinates(csv_file_path)
            %{
            expects columns X and Y
            each row is one point
            %}
            if nargin == 0
                obj.x = [];
                obj.y = [];
            end
            
            t = readtable(csv_file_path);
            assert(0 < height(t));
            assert(2 <= width(t));
            
            t.Properties.VariableNames = lower(t.Properties.VariableNames);
            assert(ismember("x", t.Properties.VariableNames));
            assert(ismember("y", t.Properties.VariableNames));
            
            obj.x = t.x;
            obj.y = t.y;
        end
    end
end

