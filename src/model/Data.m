classdef Data < handle
    %{
    Table with the following columns
    - vision (string)
        - Vision type
        - Must be in {"scotopic", "mesopic"}
    - class (string)
        - Denotes patient class for the given experiment
    - data_type (string)
        - Name of the type of data
        - May contain patient identifier
    - value (double)
        - Numeric value of interest to visualize
    - x (double)
        - X coordinate position on the retina in degrees
    - y (double)
        - Y coordinate position on the retina in degrees
    - laterality
        - eye laterality
        - must be one of "os" or "od"
    %}
    
    properties (SetAccess = private)
        t table
    end
    
    properties (SetAccess = private, Dependent)
        empty (1,1) logical
    end
    
    methods
        function load_csv(obj, file_path)
            in_t = readtable(file_path);
            
            vars = string(in_t.Properties.VariableNames);
            included = intersect(vars, obj.COLUMNS);
            expected = sort(obj.COLUMNS);
            assert(numel(included) == numel(expected) && all(included == expected));
            
            % stringify
            cols = find(varfun(@iscellstr, in_t, "output", "uniform"));
            for c = cols(:).'
                v = in_t.Properties.VariableNames{c};
                in_t.(v) = string(in_t.(v));
            end
            
            assert(isstring(in_t.class));
            assert(isstring(in_t.vision));
            assert(isstring(in_t.data_type));
            assert(isa(in_t.value, "double"));
            assert(isa(in_t.x, "double"));
            assert(isa(in_t.y, "double"));
            assert(isstring(in_t.laterality));
            
            included = lower(unique(in_t.vision));
            expected = [Definitions.MESOPIC, Definitions.SCOTOPIC];
            assert(isempty(setdiff(included, expected)));
            assert(isempty(setdiff(expected, included)));
            
            in_t.laterality = lower(in_t.laterality);
            included = lower(unique(in_t.laterality));
            expected = [Definitions.OD_LATERALITY_VALUE, Definitions.OS_LATERALITY_VALUE];
            assert(all(ismember(included, expected)));
            
            obj.t = in_t;
        end
        
        function value = get_classes(obj)
            value = unique(obj.t.class, "stable");
        end
        
        function value = get_data_types(obj, class)
            indices = lower(obj.t.class) == lower(class);
            value = unique(obj.t(indices, :).data_type, "stable");
        end
        
        function value = get_values(obj, vision, class, data_type)
            indices = lower(obj.t.vision) == lower(vision) ...
                & lower(obj.t.class) == lower(class) ...
                & lower(obj.t.data_type) == lower(data_type);
            value = obj.t(indices, :);
        end
    end
    
    methods % accessors
        function value = get.empty(obj)
            value = isempty(obj.t);
        end
    end
    
    properties (Access = private, Constant)
        COLUMNS = ["vision", "class", "data_type", "value", "x", "y", "laterality"]
    end
end

