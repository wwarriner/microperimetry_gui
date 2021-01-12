classdef MicroperimetryAxesArray < handle
    properties
        row_titles (1,2) string = [init_cap(Definitions.MESOPIC) init_cap(Definitions.SCOTOPIC)]
        col_titles (1,3) string = ["Case" "Group Means" "Z-Scores"]
        axis_size (1,2) double = [320, 320]
        in_padding (1,2) double = [20, 20]
        point_size (1,1) double = 60
        
        label_visibility_state (1,1) string
    end
    
    properties (Dependent)
        row_count
        col_count
    end
    
    methods
        function obj = MicroperimetryAxesArray(parent, data)
            obj.data = data;
            obj.parent = parent;
        end
        
        function build(obj)
            obj.compute_padding(obj.parent);
            for row = 1 : obj.row_count
                for col = 1 : obj.col_count
                    % flip row, pos from bottom
                    position = obj.get_position(col, obj.row_count - row + 1);
                    ax = MicroperimetryAxes(obj.parent, position);
                    ax.x_title = obj.col_titles(col);
                    ax.y_title = obj.row_titles(row);
                    if row == 1; ax.top = true; end
                    if row == obj.row_count; ax.bottom = true; end
                    if col == 1; ax.left = true; end
                    if col == obj.col_count; ax.right = true; end
                    ax.build();
                    obj.handles{row, col} = ax;
                end
            end
        end
        
        function update(obj)
            if obj.data.count == 0
                return;
            end
            for row = 1 : obj.row_count
                for col = 1 : obj.col_count
                    value_name = obj.data.value_names(1); % TODO
                    values = obj.data.get_values(obj.VISION_TYPE{row}, value_name);
                    h = obj.handles{row, col};
                    h.set_data(values.x, values.y, values.v, obj.point_size);
                end
            end
            obj.update_label_visibility();
            obj.update_chirality();
        end
        
        function update_label_visibility(obj)
            if obj.data.count == 0
                return;
            end
            for i = 1 : numel(obj.handles)
                h = obj.handles{i};
                h.set_label_visibility_state(obj.label_visibility_state);
            end
        end
        
        function update_chirality(obj)
            if obj.data.count == 0
                return;
            end
            for row = 1 : obj.row_count
                for col = 1 : obj.col_count
                    h = obj.handles{row, col};
                    type = obj.VISION_TYPE{row};
                    h.set_label_position(obj.data.get_x(type), obj.data.get_y(type));
                end
            end
        end
        
        function value = get.row_count(obj)
            value = numel(obj.row_titles);
        end
        
        function value = get.col_count(obj)
            value = numel(obj.col_titles);
        end
    end
    
    properties (Access = private)
        data MicroperimetryData
        parent
        row_labels (:,1)
        col_labels (:,1)
        handles (:,:) cell
        pre_pad (:,:)
        post_pad (:,:)
    end
    
    properties (Access = private, Constant)
        VISION_TYPE (1,2) string = [Definitions.MESOPIC, Definitions.SCOTOPIC]
    end
    
    methods (Access = private)
        function compute_padding(obj, parent)
            full = parent.Position(3:4);
            counts = [obj.col_count, obj.row_count];
            pad = full - (counts - 1) .* obj.in_padding;
            pad = pad - counts .* obj.axis_size;
            assert(all(0 < pad));
            obj.pre_pad = round(0.5 * pad);
            obj.post_pad = pad - obj.pre_pad;
        end
        
        function pos = get_position(obj, col, row)
            x = obj.pre_pad(1) + (col - 1) * (obj.axis_size(1) + obj.in_padding(1));
            y = obj.post_pad(2) + (row - 1) * (obj.axis_size(2) + obj.in_padding(2));
            w = obj.axis_size(1);
            h = obj.axis_size(2);
            pos = [x y w h];
        end
    end
end

