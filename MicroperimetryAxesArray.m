classdef MicroperimetryAxesArray < handle
    properties
        patient_class (1,1) string = Definitions.NORMAL
        
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
            grid = EtdrsGrid();
            for row = 1 : obj.row_count
                for col = 1 : obj.col_count
                    % flip row, pos from bottom
                    position = obj.compute_position(col, obj.row_count - row + 1);
                    ax = MicroperimetryAxes(obj.parent, position);
                    ax.x_title = obj.build_x_title(col);
                    ax.y_title = obj.row_titles(row);
                    if row == 1; ax.top = true; end
                    if row == obj.row_count; ax.bottom = true; end
                    if col == 1; ax.left = true; end
                    if col == obj.col_count; ax.right = true; end
                    ax.data_range = obj.DATA_RANGES{col};
                    cmap_fn = obj.COLORMAP_FNS{col};
                    ax.cmap = cmap_fn();
                    ax.build();
                    ax.apply_to_axes(ax.MM_UNITS, grid);
                    obj.handles{row, col} = ax;
                end
            end
            
            compass = CompassRose();
            compass.position = [3.2, -3.2]; % mm
            compass.label_nudge = 0.25;
            h = obj.handles{obj.row_count, obj.col_count}; % bottom-right
            h.apply_to_axes(h.MM_UNITS, compass)
            
            sensitivity_cbh = Colorbar();
            sensitivity_cbh.location = "west";
            sensitivity_cbh.cticks = Definitions.COLOR_TICKS;
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
                    h = obj.handles{row, col};
                    h.x_title = obj.build_x_title(col);
                    h.update_axes_titles();
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
        sensitivity_cbar Colorbar
        zscore_cbar Colorbar
        row_labels (:,1)
        col_labels (:,1)
        handles (:,:) cell
        pre_pad (:,:)
        post_pad (:,:)
    end
    
    properties (Access = private, Constant)
        VISION_TYPE (1,2) string = [Definitions.MESOPIC, Definitions.SCOTOPIC]
        DATA_TYPE (1,3) string = [Definitions.SENSITIVITY, Definitions.MEANS, Definitions.Z_SCORE]
        DATA_TYPE_APPEND (1,3) logical = [false true true]
        DATA_RANGES (1,3) cell = {Definitions.COLOR_DATA_RANGE, Definitions.COLOR_DATA_RANGE, Definitions.Z_SCORE_DATA_RANGE}
        COLORMAP_FNS (1,3) cell = {flipud(lajolla), flipud(lajolla), broc}
        COLORBAR_PADDING (1,2) double = [70 0]
    end
    
    methods (Access = private)
        function title = build_x_title(obj, col)
            title = obj.col_titles(col);
            if obj.DATA_TYPE_APPEND(col)
                title = strjoin([title, init_cap(obj.patient_class)], ", ");
            end
        end
        
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

