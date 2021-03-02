classdef AxesArray < handle
    %{
    AxesArray encapsulates a specific arrangement of axes objects in a
    container. The container and rows by columns are passed in as arguments to
    the constructor. Allows two colorbar objects to be used, one on either side.
    This object should have the same parent as the two colorbar objects.
    %}
    properties (SetAccess = private)
        left_colorbar Colorbar
        right_colorbar Colorbar
    end
    
    methods
        function obj = AxesArray(parent, row_count, column_count)
            %{
            Inputs:
            parent - container object (e.g. figure, uipanel)
            row_count - number of rows of axes
            column_count - number of columns of axes
            %}
            obj.parent = parent;
            obj.row_count = row_count;
            obj.column_count = column_count;
        end
        
        function set_left_colorbar(obj, cb)
            %{
            Sets a Colorbar object as the left colorbar. Matched with
            appropriate axes.
            %}
            cb.location = "west";
            cb.update();
            obj.left_colorbar = cb;
        end
        
        function set_right_colorbar(obj, cb)
            %{
            Sets a Colorbar object as the right colorbar. Matched with
            appropriate axes.
            %}
            cb.location = "east";
            cb.update();
            obj.right_colorbar = cb;
        end
        
        function set_axes(obj, ax, row, col)
            %{
            Add an axes-like object to one of this object's slots at the supplied row
            and column position.
            %}
            assert(0 <= row && row <= obj.row_count);
            assert(0 <= row && row <= obj.row_count);
            obj.axes_handles{row, col} = ax;
        end
        
        function apply(obj, fn)
            %{
            Applies a function to all axes. Function must accept an axes-like
            object (set with set_axes) as well as a row and column.
            %}
            for row = 1 : obj.row_count
                for col = 1 : obj.column_count
                    ax = obj.axes_handles{row, col};
                    fn(ax, row, col);
                end
            end
        end
        
        function update_layout(obj)
            %{
            Updates the layout of the axes in the array.
            %}
            [obj.pre_pad, obj.post_pad] = obj.update_padding();
            obj.apply(@(ax,row,col)obj.update_position(ax, row, col));
        end

        function set_parent(obj, new_parent)
            %{
            Sets the parent of this object and all its children.
            %}
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
    
    properties (Access = protected)
        row_count (1,1)
        column_count (1,1)
    end
    
    properties (Access = private)
        parent
        axes_handles (:,:) cell
        
        pre_pad (:,:)
        post_pad (:,:)
    end
    
    properties (Access = private, Constant)
        AXIS_SIZE (1,2) double = [320, 320]
        IN_PADDING (1,2) double = [20, 20]
    end
    
    methods (Access = private)
        function update_position(obj, ax, row, col)
            position = obj.compute_position(col, obj.row_count - row + 1);
            ax.set_position(position);
        end
        
        function [pre, post] = update_padding(obj)
            available = obj.parent.Position(3:4);
            counts = [obj.column_count, obj.row_count];
            inner_pad = (counts - 1) .* obj.IN_PADDING;
            colorbar_pad = 2 .* [Colorbar.WIDTH, 0];
            axis_use = counts .* obj.AXIS_SIZE;
            pad = available - inner_pad - colorbar_pad - axis_use;
            assert(all(0 < pad));
            pre = round(0.5 * pad);
            post = pad - pre;
        end
        
        function pos = compute_position(obj, col, row)
            x = obj.pre_pad(1) ...
                + (col - 1) * (obj.AXIS_SIZE(1) + obj.IN_PADDING(1)) ...
                + Colorbar.WIDTH;
            y = obj.post_pad(2) ...
                + (row - 1) * (obj.AXIS_SIZE(2) + obj.IN_PADDING(2));
            w = obj.AXIS_SIZE(1);
            h = obj.AXIS_SIZE(2);
            pos = [x y w h];
        end
    end
end

