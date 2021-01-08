classdef Label
    properties (SetAccess = private)
        vision_type (1,1) string
        index (1,1) uint64
        text (1,1) string
    end
    
    properties (Constant)
        MESOPIC = "mesopic";
        SCOTOPIC = "scotopic";
    end
    
    methods
        function obj = Label(text)
            [t, i] = obj.parse(text);
            obj.vision_type = t;
            obj.index = i;
            obj.text = text;
        end
    end
       
    methods (Static)
        function out = is_label(text)
            out = false;
            try
                Label.parse(text);
                out = true;
            catch e
                if ~strcmp(e.identifier, "microperimetry_gui:label:unknown_type")
                    rethrow(e);
                end
            end
        end
    end
    
    methods (Access = private, Static)
        function [t, i] = parse(text)
            % assumes text of the form <vision_type>_I<index>_
            raw = strsplit(text, "_");
            
            t = string(raw(1));
            t = Label.to_full_type(t);
            
            i = char(raw(2));
            i = i(2:end);
            i = str2double(i);
            i = uint64(i);
        end
        
        function t = to_full_type(text)
            if startsWith(Label.MESOPIC, text, "ignorecase", true)
                t = Label.MESOPIC;
            elseif startsWith(Label.SCOTOPIC, text, "ignorecase", true)
                t = Label.SCOTOPIC;
            else
                error("microperimetry_gui:label:unknown_type", "Unknown type %s", text);
            end
        end
    end
end

