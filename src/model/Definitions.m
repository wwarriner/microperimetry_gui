classdef Definitions
    properties (Constant)
        CHIRALITY = "chirality"
        OD_CHIRALITY = "od"
        OS_CHIRALITY = "os"
        
        VISION_TYPE = "vision_type"
        MESOPIC = "mesopic"
        SCOTOPIC = "scotopic"
        
        SENSITIVITY_UNITS = "dB"
        SENSITIVITY_TICKS = 0 : 5 : 30
        SENSITIVITY_DATA_RANGE = [Definitions.SENSITIVITY_TICKS(1) Definitions.SENSITIVITY_TICKS(end)]
        
        Z_SCORE_TICKS = -3 : 1 : 3
        Z_SCORE_DATA_RANGE = [Definitions.Z_SCORE_TICKS(1) Definitions.Z_SCORE_TICKS(end)]
        
        DEGREES_UNITS = "degrees"
        DEGREES_LIM = [-15 15]
        DEGREES_STEP = 5
        DEGREES_TICK = Definitions.DEGREES_LIM(1) : Definitions.DEGREES_STEP : Definitions.DEGREES_LIM(2)
        DEGREES_TICK_LABEL = abs(Definitions.DEGREES_TICK)
        
        MM_UNITS = "mm"
        MM_PER_DEG = 0.288
        MM_LIM = Definitions.MM_PER_DEG .* Definitions.DEGREES_LIM
        MM_TICK_LIM = [-4 4]
        MM_TICK_STEP = 1
        MM_TICK = Definitions.MM_TICK_LIM(1) : Definitions.MM_TICK_STEP : Definitions.MM_TICK_LIM(2)
        MM_TICK_LABEL = abs(Definitions.MM_TICK)
        
        ECCENTRICITY = "eccentricity"
        SENSITIVITY = "sensitivity"
        
        KEYWORD = "keyword"
        INDIVIDUAL = "individual"
        GROUP_MEANS = "group_means"
        Z_SCORES = "z_scores"
        KEYWORDS = [Definitions.INDIVIDUAL, Definitions.GROUP_MEANS, Definitions.Z_SCORES]
        REQUIRED_KEYWORDS = [Definitions.GROUP_MEANS, Definitions.Z_SCORES]
        
        CLASS = "class"
        LOOKUP_TYPE = "lookup_type"
        LOOKUP_VALUE = "lookup_value"
        
        PATIENT = "patient"
        CONTROL_CLASS = "control_class"
        
        CLASS_DATA_SOURCE = "class"
        LOOKUP_DATA_SOURCE = "lookup"
    end
end

