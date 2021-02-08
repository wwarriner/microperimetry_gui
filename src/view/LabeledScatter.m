classdef LabeledScatter < handle
    properties
        x (:,1) double {mustBeReal,mustBeFinite}
        y (:,1) double {mustBeReal,mustBeFinite}
        v (:,1) double {mustBeReal}
        size_data (:,1) double {mustBeReal}
        labels_visible (1,1) logical
    end
    
    methods
        function obj = LabeledScatter(parent)
            s = scatter(parent, 0, 0, 1, 0, "filled");
            s.XData = [];
            s.YData = [];
            s.CData = [];
            s.MarkerEdgeColor = [0 0 0];
            
            obj.scatter_handle = s;
            obj.parent = parent;
        end
        
        function update(obj)
            req = obj.update_request;
            if obj.REBUILD_UPDATE <= req
                obj.rebuild_labels();
            end
            if obj.LABEL_POSITION_UPDATE <= req
                obj.update_label_positions();
            end
            if obj.LABEL_VALUE_UPDATE <= req
                obj.update_label_values();
                obj.update_scatter();
            end
            if obj.LABEL_VISIBILITY_UPDATE <= req
                obj.update_label_visibility();
            end
            obj.reset_request();
        end
    end
    
    methods % accessors
        function set.x(obj, value)
            if numel(value) == numel(obj.x)
                label_request = obj.LABEL_POSITION_UPDATE;
            else
                label_request = obj.REBUILD_UPDATE;
            end
            obj.make_request(label_request);
            obj.make_request(obj.SCATTER_UPDATE);
            obj.x = value;
        end
        
        function set.y(obj, value)
            if numel(value) == numel(obj.y)
                label_request = obj.LABEL_POSITION_UPDATE;
            else
                label_request = obj.REBUILD_UPDATE;
            end
            obj.make_request(label_request);
            obj.make_request(obj.SCATTER_UPDATE);
            obj.y = value;
        end
        
        function set.v(obj, value)
            if numel(value) == numel(obj.v)
                label_request = obj.LABEL_VALUE_UPDATE;
            else
                label_request = obj.REBUILD_UPDATE;
            end
            obj.make_request(label_request);
            obj.make_request(obj.SCATTER_UPDATE);
            obj.v = value;
        end
        
        function set.size_data(obj, value)
            obj.make_request(obj.SCATTER_UPDATE);
            obj.size_data = value;
        end
        
        function set.labels_visible(obj, value)
            obj.make_request(obj.LABEL_VISIBILITY_UPDATE);
            obj.labels_visible = value;
        end
    end
    
    properties (Access = private)
        parent
        scatter_handle matlab.graphics.chart.primitive.Scatter
        text_handles matlab.graphics.primitive.Text
        
        update_request (1,1) double = LabeledScatter.NO_UPDATE
    end
    
    properties (Access = private, Constant)
        NO_UPDATE = 0
        LABEL_VISIBILITY_UPDATE = 1
        LABEL_VALUE_UPDATE = 2
        SCATTER_UPDATE = 2
        LABEL_POSITION_UPDATE = 3
        REBUILD_UPDATE = 4
    end
    
    methods (Access = private)
        function make_request(obj, proposed_state)
            obj.update_request = max(obj.update_request, proposed_state);
        end
        
        function reset_request(obj)
            obj.update_request = obj.NO_UPDATE;
        end
        
        function rebuild_labels(obj)
            for h = obj.text_handles(:)
                delete(h);
            end
            
            v_count = numel(obj.v);
            obj.text_handles = matlab.graphics.primitive.Text.empty(0, v_count);
            for i = 1 : v_count
                th = text(obj.parent, obj.x(i), obj.y(i), obj.to_string(obj.v(i)));
                th.VerticalAlignment = "top";
                th.HorizontalAlignment = "center";
                th.Interpreter = "latex";
                obj.text_handles(i) = th;
            end
        end
        
        function update_label_values(obj)
            for i = 1 : numel(obj.v)
                th = obj.text_handles(i);
                th.String = obj.to_string(obj.v(i));
            end
        end
        
        function update_label_visibility(obj)
            for i = 1 : numel(obj.v)
                th = obj.text_handles(i);
                if obj.labels_visible
                    visible = "on";
                else
                    visible = "off";
                end
                th.Visible = visible;
            end
        end
        
        function update_label_positions(obj)
            for i = 1 : numel(obj.v)
                th = obj.text_handles(i);
                th.Position(1:2) = [...
                    obj.x(i) + tanh(obj.x(i)) * 0.5 ... % spreads out points near middle
                    obj.y(i) - 0.4 ... % moves text out of scatter circles
                    ];
            end
        end
        
        function update_scatter(obj)
            assert(numel(obj.y) == numel(obj.x));
            assert(numel(obj.v) == numel(obj.x));
            
            obj.scatter_handle.XData = obj.x;
            obj.scatter_handle.YData = obj.y;
            obj.scatter_handle.CData = obj.v;
            obj.scatter_handle.SizeData = obj.size_data;
        end
    end
    
    methods (Access = private, Static)
        function v = to_string(d)
            v = sprintf("$%s$", num2str(d, "%.1f"));
        end
    end
end

