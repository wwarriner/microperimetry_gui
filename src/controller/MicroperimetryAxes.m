classdef MicroperimetryAxes < DualUnitAxes
    properties
        laterality (1,1) string
        vision (1,1) string
        class (1,1) string
        data_type (1,1) string
        labels_visible (1,1) string % {"off", "on"}
        point_size (1,1) double = 60
    end
    
    properties (Constant)
        TOP = 1
        BOTTOM = 2
        LEFT = 3
        RIGHT = 4
    end
    
    methods
        function obj = MicroperimetryAxes(parent, data, location)
            obj = obj@DualUnitAxes(parent);
            obj.primary_to_secondary_scale = Definitions.MM_PER_DEG;
            scatter = obj.apply_to_degrees_axes(@LabeledScatter);
            obj.scatter = scatter;
            obj.data = data;
            obj.location = location;
            obj.features = containers.Map("keytype", "char", "valuetype", "any");
        end
        
        function varargout = apply_to_degrees_axes(obj, fn)
            [varargout{1:nargout}] = obj.apply_to_primary_axes(fn);
        end
        
        function varargout = apply_to_mm_axes(obj, fn)
            [varargout{1:nargout}] = obj.apply_to_secondary_axes(fn);
        end
        
        function set_degrees_format(obj, format)
            assert(isa(format, "AxesFormat"));
            obj.make_request(obj.FORMAT_UPDATE);
            obj.degrees_format = format;
        end
        
        function set_mm_format(obj, format)
            assert(isa(format, "AxesFormat"));
            obj.make_request(obj.FORMAT_UPDATE);
            obj.mm_format = format;
        end
        
        function register_feature(obj, tag, feature)
            %{
            Must have @apply method which accepts a built-in axes object
            %}
            obj.features(char(tag)) = feature;
        end
        
        function update(obj)
            req = obj.update_request;
            req = unique(req);
            if isempty(req)
                return;
            end
            
            if ismember(obj.APPEARANCE_UPDATE, req)
                obj.update_appearance();
            end
            if ismember(obj.FORMAT_UPDATE, req)
                obj.update_format();
            end
            
            if obj.data.empty
                return;
            end
            
            if ismember(obj.LATERALITY_UPDATE, req)
                obj.update_feature_laterality();
            end
            
            refresh_values = [...
                obj.LATERALITY_UPDATE ...
                obj.VALUE_UPDATE ...
                ];
            if any(ismember(refresh_values, req))
                v = obj.get_values();
                selected_laterality_value = obj.select_laterality_value();
                v = obj.adjust_laterality_of_values(v, selected_laterality_value);
                obj.values = v;
                obj.update_values();
            end
            
            obj.reset_request();
        end
    end
    
    methods % accessors
        function set.laterality(obj, value)
            if value ~= obj.laterality
                obj.make_request(obj.LATERALITY_UPDATE);
            end
            obj.laterality = value;
        end
        
        function set.vision(obj, value)
            if value ~= obj.vision
                obj.make_request(obj.VALUE_UPDATE);
                obj.make_request(obj.FORMAT_UPDATE);
            end
            obj.vision = value;
        end
        
        function set.class(obj, value)
            if value ~= obj.class
                obj.make_request(obj.VALUE_UPDATE);
                obj.make_request(obj.FORMAT_UPDATE);
            end
            obj.class = value;
        end
        
        function set.data_type(obj, value)
            if value ~= obj.data_type
                obj.make_request(obj.VALUE_UPDATE);
                obj.make_request(obj.FORMAT_UPDATE);
            end
            obj.data_type = value;
        end
        
        function set.labels_visible(obj, value)
            if value ~= obj.labels_visible
                obj.make_request(obj.APPEARANCE_UPDATE);
            end
            obj.labels_visible = value;
        end
        
        function set.point_size(obj, value)
            if value ~= obj.point_size
                obj.make_request(obj.APPEARANCE_UPDATE);
            end
            obj.point_size = value;
        end
    end
    
    properties
        data Data
        scatter LabeledScatter
        degrees_format AxesFormat
        mm_format AxesFormat
        location (1,4) logical % top, bottom, left, right
        features containers.Map
        
        values table
        update_request (:,1) double
    end
    
    properties (Access = private, Constant)
        APPEARANCE_UPDATE = 1
        FORMAT_UPDATE = 2
        LATERALITY_UPDATE = 3
        VALUE_UPDATE = 4
    end
    
    properties (Access = private, Constant)
        ECCENTRICITY_DEG = strjoin([init_cap(Definitions.ECCENTRICITY), Definitions.DEGREES_UNITS], ", ");
        ECCENTRICITY_MM = strjoin([init_cap(Definitions.ECCENTRICITY), Definitions.MM_UNITS], ", ");
    end
    
    methods (Access = private)
        function make_request(obj, proposed_request)
            obj.update_request = [obj.update_request; proposed_request];
        end
        
        function reset_request(obj)
            obj.update_request = [];
        end
        
        function update_values(obj)
            obj.scatter.v = obj.values.value;
            obj.scatter.x = obj.values.x;
            obj.scatter.y = obj.values.y;
            obj.scatter.update();
        end
        
        function update_appearance(obj)
            switch lower(obj.labels_visible)
                case "off"
                    v = false;
                case "on"
                    v = true;
                otherwise
                    assert(false);
            end
            obj.scatter.labels_visible = v;
            obj.scatter.size_data = obj.point_size;
            obj.scatter.update();
        end
        
        function update_format(obj)
            assert(~isempty(obj.degrees_format));
            assert(~isempty(obj.mm_format));
            
            d = obj.degrees_format;
            m = obj.mm_format;
            
            d.x_label = obj.ECCENTRICITY_DEG;
            d.y_label = [obj.vision, obj.ECCENTRICITY_DEG];
            
            if obj.class == "" && obj.data_type == ""
                x_label = "";
            elseif obj.class == ""
                x_label = obj.data_type;
            elseif obj.data_type == ""
                x_label = obj.class;
            else
                x_label = strjoin([obj.class, obj.data_type], ", ");
            end
            m.x_label = [x_label, obj.ECCENTRICITY_MM];
            m.y_label = obj.ECCENTRICITY_MM;
            
            if ~obj.location(obj.TOP); m.x_label = ""; m.x_tick = []; m.x_tick_label = []; end
            if ~obj.location(obj.BOTTOM); d.x_label = ""; d.x_tick = []; d.x_tick_label = []; end
            if ~obj.location(obj.LEFT); d.y_label = ""; d.y_tick = []; d.y_tick_label = []; end
            if ~obj.location(obj.RIGHT); m.y_label = ""; m.y_tick = []; m.y_tick_label = []; end
            
            obj.apply_to_degrees_axes(@d.apply);
            obj.apply_to_mm_axes(@m.apply);
        end
        
        function update_feature_laterality(obj)
            selected_laterality_value = obj.select_laterality_value();
            for key = obj.features.keys()
                feature = obj.features(char(key));
                feature.laterality = selected_laterality_value;
                feature.update();
            end
        end
        
        function laterality_value = select_laterality_value(obj)
            if isempty(obj.values)
                laterality_value = Definitions.DEFAULT_LATERALITY_VALUE;
                return;
            end
            switch obj.laterality
                case Definitions.FROM_DATA_LATERALITY
                    % HACK, collapses multiple values to one
                    laterality_value = unique(obj.values.laterality);
                    assert(numel(laterality_value) == 1);
                case Definitions.IMPOSE_OD_LATERALITY
                    laterality_value = Definitions.OD_LATERALITY_VALUE;
                case Definitions.IMPOSE_OS_LATERALITY
                    laterality_value = Definitions.OS_LATERALITY_VALUE;
                otherwise
                    assert(false);
            end
        end
        
        function values = adjust_laterality_of_values(~, values, selected_laterality_value)
            if values.laterality ~= selected_laterality_value
                values.x = -values.x;
            end
        end
        
        function values = get_values(obj)
            values = obj.data.get_values(obj.vision, obj.class, obj.data_type);
        end
    end
end

