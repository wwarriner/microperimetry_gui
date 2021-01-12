classdef MicroperimetryData < handle
    properties
        chirality (1,1) string = MicroperimetryData.OD_CHIRALITY
    end
    
    properties (SetAccess = private)
        value_names (:,1) string
        eye (1,1) double
        id (1,1) double
    end
    
    properties (SetAccess = private, Dependent)
        count (1,1) double
    end
    
    properties (Constant)
        OD_CHIRALITY = "od";
        OS_CHIRALITY = "os";
    end
    
    methods
        function obj = MicroperimetryData(coordinates)
            obj.coordinates = coordinates;
        end
        
        function load_csv(obj, csv_file_path)
            % assumes datafile of the form:
            % eye, ppt_id, <labels...>
            t = readtable(csv_file_path);
            
            w = width(t);
            labels = {};
            for c = 1 : w
                var_name = t.Properties.VariableNames{c};
                if Label.is_label(var_name)
                    labels{end + 1} = Label(t.Properties.VariableNames{c}); %#ok<AGROW>
                end
            end
            
            names = string(t.index);
            name_count = numel(names);
            meso = nan(name_count, obj.count);
            scoto = nan(name_count, obj.count);
            for c = 1 : numel(labels)
                label = labels{c};
                value = t{:, label.text};
                switch label.vision_type
                    case Definitions.MESOPIC
                        meso(:, label.index) = value;
                    case Definitions.SCOTOPIC
                        scoto(:, label.index) = value;
                    otherwise
                        assert(false)
                end
            end
            
            obj.value_names = names;
            obj.eye = t{1, "eye"};
            obj.id = t{1, "ppt_id"};
            obj.mesopic = meso;
            obj.scotopic = scoto;
        end
        
        function values = get_values(obj, vision_type, value_name)
            value = [];
            value_index = obj.to_index(value_name);
            switch vision_type
                case Definitions.MESOPIC
                    value = obj.mesopic(value_index, :);
                case Definitions.SCOTOPIC
                    value = obj.scotopic(value_index, :);
                otherwise
                    assert(false);
            end
            assert(~isempty(value));
            values.x = obj.get_x();
            values.y = obj.get_y();
            values.v = value.';
        end
        
        function value = get_x(obj)
            switch obj.chirality
                case obj.OD_CHIRALITY
                    value = obj.coordinates.x;
                case obj.OS_CHIRALITY
                    value = -obj.coordinates.x;
                otherwise
                    assert(false);
            end
        end
        
        function value = get_y(obj)
            value = obj.coordinates.y;
        end
        
        function value = get.count(obj)
            value = size(obj.mesopic, 2);
        end
    end
    
    properties (Access = private)
        coordinates Coordinates
        mesopic (:,:) double
        scotopic (:,:) double
    end
    
    methods (Access = private)
        function index = to_index(obj, name)
            index = find(obj.value_names == name);
        end
    end
end

