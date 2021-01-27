classdef LayoutInfo < handle
    properties % TODO make private
        column_styles (1,3) string
        column_keywords (1,3) string
        column_data_sources (1,3) string
        lookup_class (1,1) string
        lookup_title (1,1) string
    end
    
    properties (Dependent, SetAccess = private)
        lookup_items (1,1) string
    end
    
    methods
        function obj = LayoutInfo(data)
            obj.data = data;
        end
    end
    
    methods % accessors
        function value = get.lookup_items(obj)
            switch obj.lookup_class
                case Definitions.INDIVIDUAL
                    value = obj.data.individuals;
                case Definitions.GROUP_MEANS
                    value = obj.data.classes;
                otherwise
                    assert(false);
            end
        end
    end
    
    properties (SetAccess = private)
        data MicroperimetryData
    end
end

