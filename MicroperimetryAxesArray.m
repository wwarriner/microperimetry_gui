classdef MicroperimetryAxesArray < handle
    properties
        row_titles (1,:) string
        col_titles (1,:) string
        axis_size (1,2) double = [320, 320];
        in_padding (1,2) double = [20, 20];
    end
    
    methods
        function obj = MicroperimetryAxesArray(parent, data)
            obj.data = data;
            obj.parent = parent;
        end
        
        function build(obj)
            row_count = numel(obj.row_titles);
            col_count = numel(obj.col_titles);
            obj.compute_padding(obj.parent, row_count, col_count);
            for row = 1 : row_count
                for col = 1 : col_count
                    % flip row, pos from bottom
                    position = obj.get_position(col, row_count - row + 1);
                    ax = MicroperimetryAxes(obj.parent, position);
                    ax.x_title = obj.col_titles(col);
                    ax.y_title = obj.row_titles(row);
                    if row == 1; ax.top = true; end
                    if row == row_count; ax.bottom = true; end
                    if col == 1; ax.left = true; end
                    if col == col_count; ax.right = true; end
                    ax.build();
                    obj.handles{row, col} = ax;
                end
            end
        end
        
        function update(obj)
            for i = 1 : numel(obj.handles)
                vision_type = Label.MESOPIC;
                value_name = obj.data.value_names(1);
                values = obj.data.get(vision_type, value_name);
                h = obj.handles{i};
                h.set_data([obj.data.coordinates values], 45);
            end
        end
    end
    
    properties (Access = private)
        data MicroperimetryData
        parent
        row_labels (:, 1)
        col_labels (:, 1)
        handles (:, :) cell
        pre_pad (:, :)
        post_pad (:, :)
    end
    
    methods (Access = private)
        function compute_padding(obj, parent, row_count, col_count)
            full = parent.Position(3:4);
            counts = [col_count, row_count];
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

