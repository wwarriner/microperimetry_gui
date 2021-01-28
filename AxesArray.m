classdef AxesArray < handle
    properties
        axis_size (1,2) double = [320, 320]
        in_padding (1,2) double = [20, 20]
        point_size (1,1) double = 60
        
        left_colormap_fn
        left_colorbar_visible (1,1) logical = true
        right_colormap_fn
        right_colorbar_visible (1,1) logical = true
    end
    
    methods
        function obj = AxesArray(parent, row_count, column_count)
            obj.parent = parent;
            obj.row_count = row_count;
            obj.column_count = column_count;
        end
        
        function add_axes(obj, ax, row, col)
            assert(0 <= row && row <= obj.row_count);
            assert(0 <= row && row <= obj.row_count);
            obj.axes_handles{row, col} = ax;
                    
            ax.location(Axes.TOP_LOCATION) = row == 1;
            ax.location(Axes.BOTTOM_LOCATION) = row == obj.row_count;
            ax.location(Axes.LEFT_LOCATION) = col == 1;
            ax.location(Axes.RIGHT_LOCATION) = col == obj.column_count;
        end
        
        function build(obj)
            obj.compute_padding();
            for row = 1 : obj.row_count
                for col = 1 : obj.column_count
                    ax = obj.axes_handles{row, col};
                    
                    % flip row, pos from bottom
                    position = obj.compute_position(col, obj.row_count - row + 1);
                    ax.set_position(position);
                end
            end
            
            if obj.left_colorbar_visible
                left_colorbar_handle = Colorbar();
                left_colorbar_handle.location = "west";
                left_colorbar_handle.cticks = Definitions.SENSITIVITY_TICKS;
                left_colorbar_handle.label = "mean log sensitivity, dB";
                left_colorbar_handle.cmap = obj.left_colormap_fn();
                left_colorbar_handle.apply(obj.parent);
                obj.left_colorbar = left_colorbar_handle;
            end
            
            if obj.right_colorbar_visible
                right_colorbar_handle = Colorbar();
                right_colorbar_handle.location = "east";
                right_colorbar_handle.cticks = Definitions.Z_SCORE_TICKS;
                right_colorbar_handle.label = "z-score";
                right_colorbar_handle.cmap = obj.right_colormap_fn();
                right_colorbar_handle.apply(obj.parent);
                obj.right_colorbar = right_colorbar_handle;
            end
        end
    end
    
    properties (Access = private)
        parent
        axes_handles (:,:) cell
        
        left_colorbar Colorbar
        right_colorbar Colorbar
        
        row_count (1,1)
        column_count (1,1)
        
        pre_pad (:,:)
        post_pad (:,:)
    end
    
    properties (Access = private, Constant)
        COLORBAR_PADDING (1,2) double = [70 0]
    end
    
    methods (Access = private)
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

