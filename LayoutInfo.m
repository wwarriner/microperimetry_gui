classdef LayoutInfo < handle
    properties
        row_vision_types (1,2) string
        column_styles (1,3) string
        column_keywords (1,3) string
        column_data_sources (1,3) string
        lookup_class (1,1) string
        lookup_title (1,1) string
        is_available_fn (1,1) function_handle = @(data)false
    end
    
    properties (Dependent, SetAccess = private)
        available (1,1) logical
    end
    
    properties (Constant)
        ROW_COUNT = 2
        COLUMN_COUNT = 3
    end
    
    methods
        function obj = LayoutInfo(data)
            obj.data = data;
        end
        
        function value = get.available(obj)
            value = obj.is_available_fn(obj.data);
        end
    end
    
    properties (SetAccess = private)
        data MicroperimetryData
    end
end

