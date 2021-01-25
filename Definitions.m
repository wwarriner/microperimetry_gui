classdef Definitions
    properties (Constant)
        OD_CHIRALITY = "od";
        OS_CHIRALITY = "os";
        
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
        
        INDIVIDUAL = "patient"
        GROUP_MEANS = "group_means"
        Z_SCORES = "z_scores"
        
        NORMAL = "normal"
        EARLY = "early"
        INTERMEDIATE = "intermediate"
    end
end

