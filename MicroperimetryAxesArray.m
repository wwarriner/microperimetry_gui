classdef MicroperimetryAxesArray < handle
    properties
        axis_size (1,2) double = [320, 320]
        in_padding (1,2) double = [20, 20]
    end
    
    methods
        function obj = MicroperimetryAxesArray(parent, model)
            obj.parent = parent;
            obj.model = model;
        end
        
        function build(obj)
            obj.compute_padding(obj.parent);
            gs = cell(LayoutInfo.ROW_COUNT, LayoutInfo.COLUMN_COUNT);
            for row = 1 : LayoutInfo.ROW_COUNT
                for col = 1 : LayoutInfo.COLUMN_COUNT
                    % flip row, pos from bottom
                    position = obj.compute_position(col, LayoutInfo.ROW_COUNT - row + 1);
                    ax = Axes(obj.parent, position);
                    
                    ax.set_color_info(ax.SENSITIVITY_COLORBAR_SIDE, obj.SENSITIVITY_COLORMAP, Definitions.SENSITIVITY_DATA_RANGE);
                    ax.set_color_info(ax.Z_SCORES_COLORBAR_SIDE, obj.Z_SCORES_COLORMAP, Definitions.Z_SCORE_DATA_RANGE);
                    
                    obj.model.apply_style(ax, col);
                    
                    ax.location(Axes.TOP_LOCATION) = row == 1;
                    ax.location(Axes.BOTTOM_LOCATION) = row == LayoutInfo.COLUMN_COUNT;
                    ax.location(Axes.LEFT_LOCATION) = col == 1;
                    ax.location(Axes.RIGHT_LOCATION) = col == LayoutInfo.COLUMN_COUNT;
                    
                    ax.x_title_label = sprintf("r%dc%d", row, col);
                    ax.y_title_label = "placeholder";
                    
                    ax.build();
                    
                    g = EtdrsGrid();
                    g.chirality = obj.model.chirality_selection;
                    ax.apply_to_axes(ax.MM_AXES_UNITS, g);
                    gs{row, col} = g;
                    
                    obj.axes_handles{row, col} = ax;
                end
            end
            obj.grids = gs;
            
            c = CompassRose();
            c.chirality = obj.model.chirality_selection;
            c.position = [3.2, -3.2]; % mm
            c.label_nudge = 0.25;
            h = obj.axes_handles{LayoutInfo.ROW_COUNT, LayoutInfo.COLUMN_COUNT}; % bottom-right
            h.apply_to_axes(h.MM_AXES_UNITS, c)
            obj.compass = c;
            
            sensitivity_cbh = Colorbar();
            sensitivity_cbh.location = "west";
            sensitivity_cbh.cticks = Definitions.SENSITIVITY_TICKS;
            sensitivity_cbh.label = "mean log sensitivity, dB";
            sensitivity_cmap = obj.SENSITIVITY_COLORMAP;
            sensitivity_cbh.cmap = sensitivity_cmap();
            sensitivity_cbh.apply(obj.parent);
            obj.sensitivity_cbar = sensitivity_cbh;
            
            z_score_cbh = Colorbar();
            z_score_cbh.location = "east";
            z_score_cbh.cticks = Definitions.Z_SCORE_TICKS;
            z_score_cbh.label = "z-score";
            z_score_cmap = obj.Z_SCORES_COLORMAP;
            z_score_cbh.cmap = z_score_cmap();
            z_score_cbh.apply(obj.parent);
            obj.zscore_cbar = z_score_cbh;
        end
        
        function update(obj)
            % could be reduced to a single h.update()
            for row = 1 : LayoutInfo.ROW_COUNT
                for col = 1 : LayoutInfo.COLUMN_COUNT
                    h = obj.axes_handles{row, col};
                    h.x_title_label = sprintf("r%dc%d", row, col);
                    % TODO generic placeholder instead of above
                    obj.model.apply_style(h, col);
                    h.update();
                end
            end
            obj.update_label_visibility();
            obj.update_chirality();
            if ~obj.model.ready
                return;
            end
            for row = 1 : LayoutInfo.ROW_COUNT
                for col = 1 : LayoutInfo.COLUMN_COUNT
                    h = obj.axes_handles{row, col};
                    d = obj.model.get_data(row, col);
                    h.set_data(d, obj.point_size);
                    h.set_label_position(d.x, d.y);
                    h.update();
                end
            end
        end
        
        function update_label_visibility(obj)
            if ~obj.model.ready
                return;
            end
            for i = 1 : numel(obj.axes_handles)
                h = obj.axes_handles{i};
                h.set_label_visibility_state(obj.label_visibility_state);
            end
        end
        
        function update_chirality(obj)
            obj.compass.chirality = obj.model.chirality_selection;
            obj.compass.update();
            for row = 1 : LayoutInfo.ROW_COUNT
                for col = 1 : LayoutInfo.COLUMN_COUNT
                    obj.grids{row, col}.chirality = obj.model.chirality_selection;
                    obj.grids{row, col}.update();     
                end
            end
            if ~obj.model.ready
                return;
            end
            for row = 1 : LayoutInfo.ROW_COUNT
                for col = 1 : LayoutInfo.COLUMN_COUNT
                    h = obj.axes_handles{row, col};
                    h.set_label_position(obj.model.get_x(row), obj.model.get_y(row));
                end
            end
            
        end
    end
    
    properties (Access = private)
        parent
        model MicroperimetryModel
        
        axes_handles (:,:) cell
        grids cell
        compass CompassRose
        
        sensitivity_cbar Colorbar
        zscore_cbar Colorbar
        
        pre_pad (:,:)
        post_pad (:,:)
        
    end
    
    properties (Access = private, Constant)
        SENSITIVITY_COLORMAP (:,3) double = flipud(lajolla());
        Z_SCORES_COLORMAP (:,3) double = broc();
        COLORBAR_PADDING (1,2) double = [70 0]
    end
    
    methods (Access = private)
        function compute_padding(obj, parent)
            full = parent.Position(3:4);
            counts = [LayoutInfo.COLUMN_COUNT, LayoutInfo.ROW_COUNT];
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

