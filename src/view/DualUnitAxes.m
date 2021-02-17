classdef Axes < handle
    methods
        function obj = Axes(parent)
            s = axes(parent);
            s.Units = "pixels";
            s.XAxisLocation = "top";
            s.YAxisLocation = "right";
            s.Color = "w";
            s.Toolbar.Visible = "off";
            s.Interactions = [];
            hold(s, "on");
            
            p = axes(parent);
            p.Units = "pixels";
            p.XAxisLocation = "bottom";
            p.YAxisLocation = "left";
            p.Color = "none";
            p.Toolbar.Visible = "off";
            p.Interactions = [];
            hold(p, "on");
            
            obj.primary_ax = p;
            obj.secondary_ax = s;
            obj.parent = parent;
        end
        
        function varargout = apply_to_primary_axes(obj, fn)
            [varargout{1:nargout}] = fn(obj.primary_ax);
        end
        
        function varargout = apply_to_secondary_axes(obj, fn)
            [varargout{1:nargout}] = fn(obj.secondary_ax);
        end

        function set_position(obj, position)
            obj.secondary_ax.Position = position;
            obj.primary_ax.Position = position;
        end
        
        function transplant(obj, new_parent)
            obj.secondary_ax.Parent = new_parent;
            obj.primary_ax.Parent = new_parent;
            obj.parent = new_parent;
        end
    end
    
    properties (Access = private)
        parent
        primary_ax matlab.graphics.axis.Axes
        secondary_ax matlab.graphics.axis.Axes
    end
end

