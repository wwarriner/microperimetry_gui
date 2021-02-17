classdef AxesArray < handle
    properties
        axis_size (1,2) double = [320, 320]
        in_padding (1,2) double = [20, 20]
    end
    
    properties (SetAccess = private)
        left_colorbar Colorbar
        right_colorbar Colorbar
    end
    
    methods
        function obj = AxesArray(parent, row_count, column_count)
            obj.parent = parent;
            obj.row_count = row_count;
            obj.column_count = column_count;
        end
        
        function set_left_colorbar(obj, cb)
            cb.location = "west";
            cb.update();
            obj.left_colorbar = cb;
        end
        
        function set_right_colorbar(obj, cb)
            cb.location = "east";
            cb.update();
            obj.right_colorbar = cb;
        end
        
        function set_axes(obj, ax, row, col)
            assert(0 <= row && row <= obj.row_count);
            assert(0 <= row && row <= obj.row_count);
            obj.axes_handles{row, col} = ax;
        end
        
        function apply(obj, fn)
            for row = 1 : obj.row_count
                for col = 1 : obj.column_count
                    ax = obj.axes_handles{row, col};
                    fn(ax, row, col);
                end
            end
        end
        
        function update_layout(obj)
            obj.compute_padding();
            obj.apply(@(ax,row,col)obj.update_position(ax, row, col));
        end

        function set_parent(obj, new_parent)
            if ~isempty(obj.axes_handles)
                obj.apply(@(ax,row,col)ax.set_parent(new_parent));
            end
            if ~isempty(obj.left_colorbar)
                obj.left_colorbar.set_parent(new_parent);
            end
            if ~isempty(obj.right_colorbar)
                obj.right_colorbar.set_parent(new_parent);
            end
            obj.parent = new_parent;
        end
    end
    
    properties (Access = private)
        parent
        axes_handles (:,:) cell
        
        row_count (1,1)
        column_count (1,1)
        
        pre_pad (:,:)
        post_pad (:,:)
    end
    
    properties (Access = private, Constant)
        COLORBAR_PADDING (1,2) double = [70 0] % HACK, colorbar should know its size
    end
    
    methods (Access = private)
        function update_position(obj, ax, row, col)
            position = obj.compute_position(col, obj.row_count - row + 1);
            ax.set_position(position);
        end
        
        function compute_padding(obj)
            full = obj.parent.Position(3:4);
            counts = [obj.column_count, obj.row_count];
            pad = full - (counts - 1) .* obj.in_padding - 2 .* obj.COLORBAR_PADDING;
            pad = pad - counts .* obj.axis_size;
            assert(all(0 < pad));
            obj.pre_pad = round(0.5 * pad);
            obj.post_pad = pad - obj.pre_pad;
        end
        
        function pos = compute_position(obj, col, row)
            x = obj.pre_pad(1) + (col - 1) * (obj.axis_size(1) + obj.in_padding(1)) ...
                + obj.COLORBAR_PADDING(1);
            y = obj.post_pad(2) + (row - 1) * (obj.axis_size(2) + obj.in_padding(2));
            w = obj.axis_size(1);
            h = obj.axis_size(2);
            pos = [x y w h];
        end
    end
end

