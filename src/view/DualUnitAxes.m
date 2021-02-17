classdef DualUnitAxes < handle
    %{
    DualUnitAxes
    
    Encapsulates behavior of dual unit axes. The bottom x- and left y-axes are
    one unit, while the top x- and right y-axes are another unit, set to the
    same scale. The scale is enforced by the API, based on the *_scale
    properties. Only one *_scale property need be set to set both.
    
    To use, create a DualUnitAxes and set one of *_scale properties. Set
    axes properties using apply_to_*_axes() by creating an axes-modifying
    function and passing it as an argument. The function must accept one
    argument, which is a matlab.graphics.axis.Axes object. The function
    apply_to_*_axes() returns all the arguments of the function passed to it. 
    The *Lim properties set the appropriate value for the other axes. The
    Position property may not be set this way. To change Position, use
    set_position(). 
 
    An example:
    
    ax = DualUnitAxes(figure());
    function success = format(ax)
        ax.XLabel = "hello";
        ax.YLabel = "world";
        success = true;
    end    
    success = ax.apply_to_primary_axes(@format);
    ax.set_position([50 50 500 500]);
    ax.set_parent(figure());
    %}
    properties
        primary_to_secondary_scale (1,1) double {mustBeReal,mustBeFinite,mustBePositive} = 1.0
    end
    
    properties (Dependent)
        secondary_to_primary_scale (1,1) double {mustBeReal,mustBeFinite,mustBePositive}
    end
    
    methods
        function obj = DualUnitAxes(parent)
            if nargin < 1
                parent = figure();
            end
            
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
            %{
            Allows setting underlying axes properties of the primary
            (bottom-left) axes. Any property of a matlab.graphics.axis.Axes may
            be set this way except Position and Parent. To set those, please use
            the set_* accessor functions provided.
            %}
            
            p = obj.primary_ax.Position;
            r = obj.primary_ax.Parent;
            [varargout{1:nargout}] = fn(obj.primary_ax);
            obj.primary_ax.Position = p;
            obj.primary_ax.Parent = r;
            
            obj.set_secondary_from_primary_lim(obj.primary_ax.XLim, "XLim");
            obj.set_secondary_from_primary_lim(obj.primary_ax.YLim, "YLim");
        end
        
        function varargout = apply_to_secondary_axes(obj, fn)
            %{
            Allows setting underlying axes properties of the secondary
            (top-right) axes. Any property of a matlab.graphics.axis.Axes may
            be set this way except Position and Parent. To set those, please use
            the set_* accessor functions provided.
            %}
            
            p = obj.primary_ax.Position;
            r = obj.primary_ax.Parent;
            [varargout{1:nargout}] = fn(obj.secondary_ax);
            obj.secondary_ax.Position = p;
            obj.secondary_ax.Parent = r;
            
            obj.set_primary_from_secondary_lim(obj.secondary_ax.XLim, "XLim");
            obj.set_primary_from_secondary_lim(obj.secondary_ax.YLim, "YLim");
        end

        function set_position(obj, position)
            %{
            position - Typical MATLAB position [x y w h];
            %}
            obj.secondary_ax.Position = position;
            obj.primary_ax.Position = position;
        end
        
        function set_parent(obj, new_parent)
            %{
            parent - MATLAB container, e.g. figure(), uifigure(), uipanel()
            %}
            obj.secondary_ax.Parent = new_parent;
            obj.primary_ax.Parent = new_parent;
            obj.parent = new_parent;
        end
    end
    
    methods % accessors
        function set.secondary_to_primary_scale(obj, value)
            obj.primary_to_secondary_scale = 1 ./ value;
        end
        
        function value = get.secondary_to_primary_scale(obj)
            value = 1 ./ obj.primary_to_secondary_scale;
        end
    end
    
    properties (Access = private)
        parent
        primary_ax matlab.graphics.axis.Axes
        secondary_ax matlab.graphics.axis.Axes
    end
    
    methods (Access = private)
        function set_secondary_from_primary_lim(obj, value, lim)
            secondary_lim = value .* obj.primary_to_secondary_scale;
            obj.secondary_ax.(lim) = secondary_lim;
        end
        
        function set_primary_from_secondary_lim(obj, value, lim)
            primary_lim = value .* obj.secondary_to_primary_scale;
            obj.primary_ax.(lim) = primary_lim;
        end
    end
end

