classdef MicroperimetryModel < handle
    properties
        layout_selection (1,1) string = ""
        lookup_selection (1,1) string = ""
        class_selection (1,1) string = ""
        chirality_selection (1,1) string = ""
    end
    
    properties (Dependent, SetAccess = private)
        layouts_available (:,1) string
        lookups_available (:,1) string
        classes_available (:,1) string
        
        ready (1,1) logical
        lookup_title (1,1) string
    end
    
    methods
        function obj = MicroperimetryModel(data, coordinates)
            obj.coordinates = coordinates;
            obj.data = data;
        end
        
        function add_layout(obj, layout, tag)
            obj.layouts(tag) = layout;
        end
        
        function apply_style(obj, ax, col)
            ax.set_style(obj.current_layout.column_styles(col));
        end
    end
    
    methods % accessors
        function value = get.layouts_available(obj)
            keys = obj.layouts.keys();
            count = obj.layouts.Count();
            value = strings(0, 1);
            for i = 1 : count
                key = keys{i};
                layout = obj.layouts(key);
                if layout.available
                    value(end + 1) = string(key); %#ok<AGROW>
                end
            end
            value = sort(value);
        end
        
        function value = get.lookups_available(obj)
            value = obj.data.get_lookup_items(obj.current_layout.lookup_class);
        end
        
        function value = get.classes_available(obj)
            value = obj.data.get_lookup_items(MicroperimetryData.CLASSES_LOOKUP);
            if obj.current_layout.lookup_class == MicroperimetryData.CLASSES_LOOKUP
                value = setdiff(value, obj.lookup_selection, "stable");
            end
        end
        
        function out = get_data(obj, row, col)
            layout = obj.current_layout;
            vision_type = layout.row_vision_types(row);
            keyword = layout.column_keywords(col);
            switch layout.column_data_sources(col)
                case Definitions.LOOKUP_DATA_SOURCE
                    class = layout.lookup_class;
                    value = obj.lookup_selection;
                case Definitions.CLASS_DATA_SOURCE
                    class = Definitions.GROUP_MEANS;
                    value = obj.class_selection;
                otherwise
                    assert(false);
            end
            out = obj.data.get_class_values(...
                Definitions.KEYWORD, keyword, ...
                Definitions.VISION_TYPE, vision_type, ...
                Definitions.LOOKUP_TYPE, class, ...
                Definitions.LOOKUP_VALUE, value, ...
                Definitions.CHIRALITY, obj.chirality_selection ...
                );
        end
        
        function x = get_x(obj, row)
            % TODO if chirality is present in table, use that
            % TODO otherwise resort to flopping the data
            vision_type = obj.current_layout.row_vision_types(row);
            x = obj.coordinates.get_x(vision_type);
            switch obj.chirality_selection
                case Definitions.OD_CHIRALITY
                    % noop
                case Definitions.OS_CHIRALITY
                    x = -x;
                otherwise
                    assert(false);
            end
        end
        
        function y = get_y(obj, row)
            vision_type = obj.current_layout.row_vision_types(row);
            y = obj.coordinates.get_y(vision_type);
        end
        
        function value = get.ready(obj)
            value = obj.data.ready;
        end
        
        function value = get.lookup_title(obj)
            value = obj.current_layout.lookup_title;
        end
    end
    
    properties (Access = private)
        coordinates Coordinates
        data MicroperimetryData
        layouts containers.Map
    end
    
    properties (Dependent, Access = private)
        current_layout
    end
    
    methods % private accessors
        function value = get.current_layout(obj)
            value = obj.layouts(obj.layout_selection);
        end
    end
end

