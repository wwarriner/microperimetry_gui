classdef Definitions
    properties (Constant)
        OD_CHIRALITY = "od";
        OS_CHIRALITY = "os";
        
        VISION_TYPE = "vision_type"
        MESOPIC = "mesopic"
        SCOTOPIC = "scotopic"
        
        SENSITIVITY_UNITS = "dB";
        SENSITIVITY_TICKS = 0 : 4 : 28
        SENSITIVITY_DATA_RANGE = [Definitions.SENSITIVITY_TICKS(1) Definitions.SENSITIVITY_TICKS(end)]
        
        Z_SCORE_TICKS = -3 : 1 : 3
        Z_SCORE_DATA_RANGE = [Definitions.Z_SCORE_TICKS(1) Definitions.Z_SCORE_TICKS(end)]
        
        DEGREES_UNITS = "degrees";
        DEGREES_LIM = 15;
        DEGREES_STEP = 5;
        
        MM_UNITS = "mm";
        MM_PER_DEG = 0.288;
        MM_TICK_LIM = 4;
        MM_TICK_STEP = 1;
        
        ECCENTRICITY = "eccentricity"
        SENSITIVITY = "sensitivity"
        
        KEYWORD = "keyword"
        INDIVIDUAL = "individual"
        GROUP_MEANS = "group_means"
        Z_SCORES = "z_scores"
        KEYWORDS = [Definitions.INDIVIDUAL, Definitions.GROUP_MEANS, Definitions.Z_SCORES]
        REQUIRED_KEYWORDS = [Definitions.GROUP_MEANS, Definitions.Z_SCORES]
        
        CLASS = "class"
        LOOKUP_TYPE = "lookup_type";
        LOOKUP_VALUE = "lookup_value";
        
        PATIENT = "patient";
        CONTROL_CLASS = "control_class";
        
        CLASS_DATA_SOURCE = "class";
        LOOKUP_DATA_SOURCE = "lookup";
    end
end

