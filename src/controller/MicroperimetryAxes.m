classdef MicroperimetryAxes < Axes
    properties
        chirality (1,1) string % update_coordinates(), update_chirality()
        vision (1,1) string % update_coordinates(), update_values()
        class (1,1) string % update_values()
        data_type (1,1) string % update_values()
        labels_visible (1,1) string % {"off", "on"}, update_label_visibility()
        point_size (1,1) double = 60 % update_appearance()
    end
    
    properties (Constant)
        TOP = 1
        BOTTOM = 2
        LEFT = 3
        RIGHT = 4
    end
    
    methods
        function obj = MicroperimetryAxes(parent, data, location)
            obj = obj@Axes(parent);
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
            obj.degrees_format = format;
        end
        
        function set_mm_format(obj, format)
            assert(isa(format, "AxesFormat"));
            obj.mm_format = format;
        end
        
        function register_feature(obj, tag, feature)
            %{
            Must have @apply method which accepts a built-in axes object
            %}
            obj.features(char(tag)) = feature;
        end
        
        function update(obj)
            obj.update_coordinates();
            obj.update_values();
            obj.update_features();
            obj.update_label_visibility();
            obj.update_appearance();
        end
        
        function update_values(obj)
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
            
            if obj.data.empty
                return;
            end
            
            values = obj.get_values();
            obj.scatter.v = values.value;
            
            obj.update_coordinates();
            obj.scatter.update();
        end
        
        function update_chirality(obj)
            for key = obj.features.keys()
                feature = obj.features(char(key));
                feature.chirality = obj.chirality;
                feature.update();
            end
            if obj.data.empty
                return;
            end
            obj.update_coordinates();
            obj.scatter.update();
        end
        
        function update_label_visibility(obj)
            switch lower(obj.labels_visible)
                case "off"
                    v = false;
                case "on"
                    v = true;
                otherwise
                    assert(false);
            end
            obj.scatter.labels_visible = v;
            obj.scatter.update();
        end
        
        function update_appearance(obj)
            obj.scatter.size_data = obj.point_size;
            obj.scatter.update();
        end
    end
    
    properties
        data Data
        scatter LabeledScatter
        degrees_format AxesFormat
        mm_format AxesFormat
        location (1,4) logical % top, bottom, left, right
        features containers.Map
    end
    
    properties (Access = private, Constant)
        ECCENTRICITY_DEG = strjoin([init_cap(Definitions.ECCENTRICITY), Definitions.DEGREES_UNITS], ", ");
        ECCENTRICITY_MM = strjoin([init_cap(Definitions.ECCENTRICITY), Definitions.MM_UNITS], ", ");
    end
    
    methods (Access = private)
        function update_coordinates(obj)
            values = obj.get_values();
            obj.scatter.x = values.x;
            obj.scatter.y = values.y;
        end
        
        function values = get_values(obj)
            values = obj.data.get_values(obj.vision, obj.class, obj.data_type);
        end
    end
end

