classdef MicroperimetryAxesArray < handle
    properties
        patient_class (1,1) string = Definitions.NORMAL
        
        layout (1,1) string = MicroperimetryAxesArray.INDIVIDUAL_LAYOUT
        
        row_titles (1,2) string = [init_cap(Definitions.MESOPIC) init_cap(Definitions.SCOTOPIC)]
        axis_size (1,2) double = [320, 320]
        in_padding (1,2) double = [20, 20]
        point_size (1,1) double = 60
        
        label_visibility_state (1,1) string
    end
    
    properties (Dependent, SetAccess = private)
        row_count
        col_count
    end
    
    properties (Constant)
        INDIVIDUAL_LAYOUT = "individual"
        GROUP_MEANS_LAYOUT = "group_means"
    end
    
    methods
        function obj = MicroperimetryAxesArray(parent, data)
            obj.data = data;
            obj.parent = parent;
        end
        
        function build(obj)
            obj.compute_padding(obj.parent);
            gs = cell(obj.row_count, obj.col_count);
            for row = 1 : obj.row_count
                for col = 1 : obj.col_count
                    % flip row, pos from bottom
                    position = obj.compute_position(col, obj.row_count - row + 1);
                    ax = Axes(obj.parent, position);
                    ax.set_style(obj.col_styles(col));
                    ax.location(Axes.TOP_LOCATION) = row == 1;
                    ax.location(Axes.BOTTOM_LOCATION) = row == obj.row_count;
                    ax.location(Axes.LEFT_LOCATION) = col == 1;
                    ax.location(Axes.RIGHT_LOCATION) = col == obj.col_count;
                    ax.x_title_label = sprintf("r%dc%d", row, col);
                    ax.y_title_label = obj.row_titles(row);
                    ax.build();
                    
                    g = EtdrsGrid();
                    g.chirality = obj.data.chirality;
                    ax.apply_to_axes(ax.MM_AXES_UNITS, g);
                    gs{row, col} = g;
                    
                    obj.axes_handles{row, col} = ax;
                end
            end
            obj.grids = gs;
            
            c = CompassRose();
            c.chirality = obj.data.chirality;
            c.position = [3.2, -3.2]; % mm
            c.label_nudge = 0.25;
            h = obj.axes_handles{obj.row_count, obj.col_count}; % bottom-right
            h.apply_to_axes(h.MM_AXES_UNITS, c)
            obj.compass = c;
            
            sensitivity_cbh = Colorbar();
            sensitivity_cbh.location = "west";
            sensitivity_cbh.cticks = Definitions.SENSITIVITY_TICKS;
            sensitivity_cbh.label = "mean log sensitivity, dB";
            sensitivity_cmap = obj.COLORMAP_FNS{1};
            sensitivity_cbh.cmap = sensitivity_cmap();
            sensitivity_cbh.apply(obj.parent);
            obj.sensitivity_cbar = sensitivity_cbh;
            
            z_score_cbh = Colorbar();
            z_score_cbh.location = "east";
            z_score_cbh.cticks = Definitions.Z_SCORE_TICKS;
            z_score_cbh.label = "z-score";
            z_score_cmap = obj.COLORMAP_FNS{obj.col_count};
            z_score_cbh.cmap = z_score_cmap();
            z_score_cbh.apply(obj.parent);
            obj.zscore_cbar = z_score_cbh;
        end
        
        function update(obj)
            for row = 1 : obj.row_count
                for col = 1 : obj.col_count
                    h = obj.axes_handles{row, col};
                    h.x_title_label = sprintf("r%dc%d", row, col);
                    h.update();
                end
            end
            if obj.data.count == 0
                return;
            end
            for row = 1 : obj.row_count
                for col = 1 : obj.col_count
                    value_name = obj.DATA_TYPE(col);
                    if obj.DATA_TYPE_APPEND(col)
                        value_name = strjoin([value_name, obj.patient_class], "_");
                    end
                    values = obj.data.get_values(obj.VISION_TYPE(row), value_name);
                    h = obj.axes_handles{row, col};
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
            for i = 1 : numel(obj.axes_handles)
                h = obj.axes_handles{i};
                h.set_label_visibility_state(obj.label_visibility_state);
            end
        end
        
        function update_chirality(obj)
            obj.compass.chirality = obj.data.chirality;
            obj.compass.update();
            for row = 1 : obj.row_count
                for col = 1 : obj.col_count
                    obj.grids{row, col}.chirality = obj.data.chirality;
                    obj.grids{row, col}.update();     
                end
            end
            if obj.data.count == 0
                return;
            end
            for row = 1 : obj.row_count
                for col = 1 : obj.col_count
                    h = obj.axes_handles{row, col};
                    type = obj.VISION_TYPE{row};
                    h.set_label_position(obj.data.get_x(type), obj.data.get_y(type));
                end
            end
            
        end
        
        function value = get.row_count(obj)
            value = numel(obj.row_titles);
        end
        
        function value = get.col_count(obj)
            value = numel(obj.col_styles);
        end
    end
    
    properties (Access = private)
        parent
        
        data MicroperimetryData
        axes_handles (:,:) cell
        
        grids cell
        compass CompassRose
        
        sensitivity_cbar Colorbar
        zscore_cbar Colorbar
        
        pre_pad (:,:)
        post_pad (:,:)
        
        col_styles (1,3) string = MicroperimetryAxesArray.INDIVIDUAL_LAYOUT_COL_STYLES
    end
    
    properties (Access = private, Constant)
        VISION_TYPE (1,2) string = [Definitions.MESOPIC, Definitions.SCOTOPIC]
        DATA_TYPE (1,3) string = [Definitions.SENSITIVITY, Definitions.MEANS, Definitions.Z_SCORE]
        DATA_TYPE_APPEND (1,3) logical = [false true true]
        DATA_RANGES (1,3) cell = {Definitions.SENSITIVITY_DATA_RANGE, Definitions.SENSITIVITY_DATA_RANGE, Definitions.Z_SCORE_DATA_RANGE}
        COLORMAP_FNS (1,3) cell = {flipud(lajolla), flipud(lajolla), broc}
        COLORBAR_PADDING (1,2) double = [70 0]
        
        INDIVIDUAL_LAYOUT_COL_STYLES = [Axes.INDIVIDUAL_STYLE, Axes.GROUP_MEANS_STYLE, Axes.Z_SCORES_STYLE]
        GROUP_MEANS_LAYOUT_COL_STYLES = [Axes.GROUP_MEANS_STYLE, Axes.GROUP_MEANS_STYLE, Axes.ZSCORES_STYLE]
        
        INDIVIDUAL_LAYOUT_KEYWORDS = [Definitions.INDIVIDUAL, Definitions.GROUP_MEANS, Definitions.Z_SCORES]
        GROUP_MEANS_LAYOUT_KEYWORDS = [Definitions.GROUP_MEANS, Definitions.GROUP_MEANS, Definitions.Z_SCORES]
        % filter data on keyword
        % build combo box for left col
        % build combo box for mid/right cols
        % if gm_layout, left col data record index is forbidden in mid/right
    end
    
    methods (Access = private)
        function compute_padding(obj, parent)
            full = parent.Position(3:4);
            counts = [obj.col_count, obj.row_count];
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

