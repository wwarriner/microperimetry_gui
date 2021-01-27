classdef MicroperimetryData < handle
    properties
        chirality (1,1) string = Definitions.OD_CHIRALITY
    end
    
    properties (SetAccess = private)
        classes (:,1) string
        individuals (:,1) string
    end
    
    properties (SetAccess = private, Dependent)
        ready (1,1) logical
    end
    
    methods
        function obj = MicroperimetryData(coordinates)
            obj.coordinates = coordinates;
        end
        
        function load_csv(obj, csv_file_path)
            % assumes datafile of the form:
            % eye, ppt_id, <labels...>
            t = readtable(csv_file_path, "texttype", "string");
            
            keywords = unique(t.keyword);
            assert(all(intersect(keywords, Definitions.REQUIRED_KEYWORDS) == sort(Definitions.REQUIRED_KEYWORDS.')));
            
            v = t;
            v = v(v.keyword == Definitions.INDIVIDUAL, :);
            individual_names = sort(v.tag);
            
            classes_base = t(t.keyword == Definitions.Z_SCORES, :).class;
            z_score_classes = unique(classes_base);
            group_means_classes = unique(t(t.keyword == Definitions.GROUP_MEANS, :).class);
            assert(all(intersect(z_score_classes, group_means_classes) == z_score_classes));
            class_names = unique(classes_base, "stable");
            
            w = width(t);
            labels = {};
            for c = 1 : w
                var_name = t.Properties.VariableNames{c};
                if Label.is_label(var_name)
                    labels{end + 1} = Label(t.Properties.VariableNames{c}); %#ok<AGROW>
                end
            end
            
            meso = nan(height(t), 1);
            for c = 1 : numel(labels)
                label = labels{c};
                value = t{:, label.text};
                if label.vision_type == Definitions.MESOPIC
                        meso(:, label.index) = value;
                end
            end
            
            scoto = nan(height(t), 1);
            for c = 1 : numel(labels)
                label = labels{c};
                value = t{:, label.text};
                if label.vision_type == Definitions.SCOTOPIC
                    scoto(:, label.index) = value;
                end
            end
            
            obj.data = t;
            obj.individuals = individual_names;
            obj.classes = class_names;
            obj.mesopic = meso;
            obj.scotopic = scoto;
        end
        
        function value = has_individuals(obj)
            value = ~isempty(obj.individuals);
        end
        
        function values = get_class_values(obj, varargin)
            %{
            k-v pairs
            
            1) "keyword" - string
            2) "vision_type" - string
            3) "lookup_type" - string (individual, group_means)
            4) "lookup_value" - string
            
            NOTE: "class" and "individual" are mutually exclusive
            %}
            
            p = inputParser();
            p.addParameter(Definitions.KEYWORD, []);
            p.addParameter(Definitions.VISION_TYPE, []);
            p.addParameter(Definitions.LOOKUP_TYPE, []);
            p.addParameter(Definitions.LOOKUP_VALUE, []);
            p.parse(varargin{:});
            
            keyword = p.Results.(Definitions.KEYWORD);
            vision_type = p.Results.(Definitions.VISION_TYPE);
            lookup_type = p.Results.(Definitions.LOOKUP_TYPE);
            lookup_value = p.Results.(Definitions.LOOKUP_VALUE);
            
            assert(~isempty(keyword));
            assert(isstring(keyword));
            assert(isscalar(keyword));
            
            assert(~isempty(vision_type));
            assert(isstring(vision_type));
            assert(isscalar(vision_type));
            
            assert(~isempty(lookup_type));
            assert(isstring(lookup_type));
            assert(isscalar(lookup_type));
            
            assert(~isempty(lookup_value));
            assert(isstring(lookup_value));
            assert(isscalar(lookup_value));
            
            v = obj.data;
            indices = v.keyword == keyword;
            if lookup_type == Definitions.GROUP_MEANS
                indices = indices & v.class == lookup_value;
            elseif lookup_type == Definitions.INDIVIDUAL
                indices = indices & v.tag == lookup_value;
            else
                assert(false);
            end
            assert(sum(indices) == 1);
            index = find(indices);
            
            value = [];
            switch vision_type
                case Definitions.MESOPIC
                    value = obj.mesopic(index, :);
                case Definitions.SCOTOPIC
                    value = obj.scotopic(index, :);
                otherwise
                    assert(false);
            end
            assert(~isempty(value));
            values.x = obj.get_x(vision_type);
            values.y = obj.get_y(vision_type);
            values.v = obj.coordinates.limit_to_used(value.', vision_type);
        end
        
        function value = get_x(obj, vision_type)
            switch obj.chirality
                case Definitions.OD_CHIRALITY
                    value = obj.coordinates.get_x(vision_type);
                case Definitions.OS_CHIRALITY
                    value = -obj.coordinates.get_x(vision_type);
                otherwise
                    assert(false);
            end
        end
        
        function value = get_y(obj, vision_type)
            value = obj.coordinates.get_y(vision_type);
        end
    end
        
    methods % accessors
        function value = get.ready(obj)
            value = (~isempty(obj.classes) || ~isempty(obj.classes));
        end
    end
    
    properties (Access = private)
        data table
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
