classdef MicroperimetryAxesArray < handle
    properties
        patient_class (1,1) string = ""
        lookup_item (1,1) string = ""
        
        layout (1,1) string = MicroperimetryAxesArray.INDIVIDUAL_LAYOUT
        
        row_titles (1,2) string = [init_cap(Definitions.MESOPIC) init_cap(Definitions.SCOTOPIC)]
        axis_size (1,2) double = [320, 320]
        in_padding (1,2) double = [20, 20]
        point_size (1,1) double = 60
        
        label_visibility_state (1,1) string
    end
    
    properties (Dependent, SetAccess = private)
        allowed_layouts (:,1) string
        lookup_title (:,1) string
        lookup_items (:,1) string % left axes, source depends on layout
        classes (:,1) string % middle and right axes
    end
    
    properties (Constant)
        INDIVIDUAL_LAYOUT = Definitions.INDIVIDUAL
        GROUP_MEANS_LAYOUT = Definitions.GROUP_MEANS
    end
    
    methods
        function obj = MicroperimetryAxesArray(parent, data, layout_infos)
            obj.data = data;
            obj.parent = parent;
            obj.layout_infos = layout_infos;
        end
        
        function build(obj)
            obj.compute_padding(obj.parent);
            gs = cell(obj.row_count, obj.col_count);
            for row = 1 : obj.row_count
                for col = 1 : obj.col_count
                    % flip row, pos from bottom
                    position = obj.compute_position(col, obj.row_count - row + 1);
                    ax = Axes(obj.parent, position);
                    
                    ax.set_color_info(ax.SENSITIVITY_COLORBAR_SIDE, obj.SENSITIVITY_COLORMAP, Definitions.SENSITIVITY_DATA_RANGE);
                    ax.set_color_info(ax.Z_SCORES_COLORBAR_SIDE, obj.Z_SCORES_COLORMAP, Definitions.Z_SCORE_DATA_RANGE);
                    
                    ax.set_style(obj.layout_info.column_styles(col));
                    
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
            for row = 1 : obj.row_count
                for col = 1 : obj.col_count
                    h = obj.axes_handles{row, col};
                    h.x_title_label = sprintf("r%dc%d", row, col);
                    % TODO generic placeholder instead of above
                    h.set_style(obj.layout_info.column_styles(col));
                    % TODO after ready check below, assign actual value
                    h.update();
                end
            end
            obj.update_label_visibility();
            obj.update_chirality();
            if ~obj.data.ready
                return;
            end
            for row = 1 : obj.row_count
                vision_type = obj.VISION_TYPE(row);
                for col = 1 : obj.col_count
                    h = obj.axes_handles{row, col};
                    keyword = obj.layout_info.column_keywords(col);
                    % the usage of obj.lookup_item should vary by column
                    % 1 is lookup_item, 2/3 is patient_class
                    % make more general
                    data_source = obj.layout_info.column_data_sources(col);
                    switch data_source
                        case Definitions.LOOKUP_DATA_SOURCE
                            class = obj.layout_info.lookup_class;
                            value = obj.lookup_item;
                        case Definitions.CLASS_DATA_SOURCE
                            class = Definitions.GROUP_MEANS;
                            value = obj.patient_class;
                        otherwise
                            assert(false);
                    end
                    d = obj.data.get_class_values(...
                        Definitions.KEYWORD, keyword, ...
                        Definitions.VISION_TYPE, vision_type, ...
                        Definitions.LOOKUP_TYPE, class, ...
                        Definitions.LOOKUP_VALUE, value ...
                        );
                    h.set_data(d, obj.point_size);
                    h.set_label_position(d.x, d.y);
                    h.update();
                end
            end
        end
        
        function update_label_visibility(obj)
            if ~obj.data.ready
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
            if ~obj.data.ready
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
        
        function value = get.allowed_layouts(obj)
            value = [obj.GROUP_MEANS_LAYOUT];
            if obj.data.has_individuals()
                value = [value obj.INDIVIDUAL_LAYOUT];
            end
        end
        
        function value = get.lookup_title(obj)
            value = obj.layout_info.lookup_title;
        end
        
        function value = get.lookup_items(obj)
            value = obj.layout_info.lookup_items;
        end
        
        function value = get.classes(obj)
            value = obj.data.classes;
            if obj.layout_info.lookup_class == Definitions.GROUP_MEANS
                value = setdiff(value, obj.lookup_item, "stable");
            end
        end
        
        function set.layout(obj, value)
            obj.layout = unpretty_print(value);
        end
    end
    
    properties (Access = private)
        parent
        layout_infos containers.Map
        
        data MicroperimetryData
        axes_handles (:,:) cell
        
        grids cell
        compass CompassRose
        
        sensitivity_cbar Colorbar
        zscore_cbar Colorbar
        
        pre_pad (:,:)
        post_pad (:,:)
        
    end
    
    properties (Dependent, Access = private)
        row_count
        col_count
        layout_info
    end
    
    properties (Access = private, Constant)
        VISION_TYPE (1,2) string = [Definitions.MESOPIC, Definitions.SCOTOPIC]
        SENSITIVITY_COLORMAP (:,3) double = flipud(lajolla());
        Z_SCORES_COLORMAP (:,3) double = broc();
        COLORBAR_PADDING (1,2) double = [70 0]
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
    
    methods % private accessors
        function value = get.row_count(obj)
            value = numel(obj.row_titles);
        end
        
        function value = get.col_count(obj)
            value = numel(obj.layout_info.column_styles);
        end
        
        function value = get.layout_info(obj)
            value = obj.layout_infos(char(obj.layout));
        end
    end
end

