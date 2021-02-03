classdef MicroperimetryAxesArray < AxesArray
    properties
        chirality (1,1) string % update_chirality()
        left_class (1,1) string % update_values()
        left_data_type (1,1) string % update_values()
        center_class (1,1) string % update_values()
        center_data_type (1,1) string % update_values()
        right_class (1,1) string % update_values()
        right_data_type (1,1) string % update_values()
        labels_visible (1,1) string % {"off", "on"}, update_label_visiblity()
    end
    
    properties (Constant)
        ROW_COUNT = 2;
        COLUMN_COUNT = 3;
    end
    
    methods
        function obj = MicroperimetryAxesArray(parent)
            obj = obj@AxesArray(...
                parent, ...
                MicroperimetryAxesArray.ROW_COUNT, ...
                MicroperimetryAxesArray.COLUMN_COUNT ...
                );
        end
        
        function update_chirality(obj)
            obj.apply(@(ax,r,c)obj.update_axes_chirality(ax, r, c));
        end
        
        function update_values(obj)
            obj.apply(@(ax,r,c)obj.update_axes_values(ax, r, c));
        end
        
        function update_label_visibility(obj)
            obj.apply(@(ax,r,c)obj.update_axes_label_visibility(ax, r, c));
        end
    end
    
    methods (Access = private)
        function update_axes_chirality(obj, ax, ~, ~)
            ax.chirality = obj.chirality;
            ax.update_chirality();
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
            ax.update_values();
        end
        
        function update_axes_label_visibility(obj, ax, ~, ~)
            ax.labels_visible = obj.labels_visible;
            ax.update_label_visibility();
        end
    end
end

