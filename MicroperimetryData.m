classdef MicroperimetryData < handle
    properties (SetAccess = private)
        coordinates (:,2) double {mustBeReal,mustBeFinite}
        value_names (:,1) string
        eye (1,1) double
        id (1,1) double
    end
    
    properties (SetAccess = private, Dependent)
        count (1,1) double
    end
    
    methods
        function obj = MicroperimetryData(coordinates)
            obj.coordinates = coordinates;
        end
        
        function load_csv(obj, csv_file_path)
            % assumes datafile of the form:
            % eye, ppt_id, <labels...>
            data = readtable(csv_file_path);
            
            w = width(data);
            labels = {};
            for c = 1 : w
                var_name = data.Properties.VariableNames{c};
                if Label.is_label(var_name)
                    labels{end + 1} = Label(data.Properties.VariableNames{c}); %#ok<AGROW>
                end
            end
            
            names = string(data.index);
            name_count = numel(names);
            meso = nan(name_count, obj.count);
            scoto = nan(name_count, obj.count);
            for c = 1 : numel(labels)
                label = labels{c};
                value = data{:, label.text};
                switch label.vision_type
                    case Label.MESOPIC
                        meso(:, label.index) = value;
                    case Label.SCOTOPIC
                        scoto(:, label.index) = value;
                    otherwise
                        assert(false)
                end
            end
            
            obj.value_names = names;
            obj.eye = data{1, "eye"};
            obj.id = data{1, "ppt_id"};
            obj.mesopic = meso;
            obj.scotopic = scoto;
        end
        
        function value = get.count(obj)
            value = size(obj.coordinates, 2);
        end
        
        function value = get(obj, vision_type, value_name)
            value = [];
            value_index = obj.to_index(value_name);
            switch vision_type
                case Label.MESOPIC
                    value = obj.mesopic(value_index, :);
                case Label.SCOTOPIC
                    value = obj.scotopic(value_index, :);
                otherwise
                    assert(false);
            end
            assert(~isempty(value));
            value = value.';
        end
    end
    
    properties (Access = private)
        mesopic (:,:) double
        scotopic (:,:) double
    end
    
    methods (Access = private)
        function index = to_index(obj, name)
            index = find(obj.value_names == name);
        end
    end
end

