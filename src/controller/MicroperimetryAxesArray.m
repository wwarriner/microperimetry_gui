classdef MicroperimetryAxesArray < AxesArray
    %{
    Microperimetry-specific subclass of AxesArray
    
    Knows how to respond to and coordinates changes in laterality, label
    visibility among multiple MicroperimetryAxes. Has 3 class along columns, and
    2 rows featuring Mesopic and Scotopic vision to facilitate comparison.
    %}
    properties
        laterality (1,1) string
        left_class (1,1) string
        left_data_type (1,1) string
        center_class (1,1) string
        center_data_type (1,1) string
        right_class (1,1) string
        right_data_type (1,1) string
        labels_visible (1,1) string % {"off", "on"}
    end
    
    properties (Constant)
        ROW_COUNT = 2;
        COLUMN_COUNT = 3;
    end
    
    methods
        function obj = MicroperimetryAxesArray(parent)
            %{
            Inputs:
            parent - container object such as figure or uipanel
            %}
            obj = obj@AxesArray(...
                parent, ...
                MicroperimetryAxesArray.ROW_COUNT, ...
                MicroperimetryAxesArray.COLUMN_COUNT ...
                );
        end
        
        function update(obj)
            %{
            Updates visual representation of object
            %}
            obj.update_laterality();
            obj.update_values();
            obj.update_label_visibility();
        end
    end
    
    methods (Access = private)
        function update_axes_laterality(obj, ax, ~, ~)
            ax.laterality = obj.laterality;
            ax.update();
        end
        
        function update_axes_values(obj, ax, row, col)
            switch row
                case 1
                    v = init_cap(Definitions.MESOPIC);
                case 2
                    v = init_cap(Definitions.SCOTOPIC);
                otherwise
                    assert(false);
            end
            
            switch col
                case 1
                    c = obj.left_class;
                    d = obj.left_data_type;
                case 2
                    c = obj.center_class;
                    d = obj.center_data_type;
                case 3
                    c = obj.right_class;
                    d = obj.right_data_type;
                otherwise
                    assert(false);
            end
            
            ax.vision = v;
            ax.class = c;
            ax.data_type = d;
            ax.update();
        end
        
        function update_axes_label_visibility(obj, ax, ~, ~)
            ax.labels_visible = obj.labels_visible;
            ax.update();
        end
        
        function update_laterality(obj)
            obj.apply(@(ax,r,c)obj.update_axes_laterality(ax, r, c));
        end
        
        function update_values(obj)
            obj.apply(@(ax,r,c)obj.update_axes_values(ax, r, c));
        end
        
        function update_label_visibility(obj)
            obj.apply(@(ax,r,c)obj.update_axes_label_visibility(ax, r, c));
        end
    end
end

