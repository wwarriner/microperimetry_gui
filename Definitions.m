classdef Definitions
    properties (Constant)
        OD_CHIRALITY = "od";
        OS_CHIRALITY = "os";
        
        MESOPIC = "mesopic"
        SCOTOPIC = "scotopic"
        
        COLOR_TICKS = 0 : 4 : 28
        COLOR_DATA_RANGE = [Definitions.COLOR_TICKS(1) Definitions.COLOR_TICKS(end)]
        
        Z_SCORE_TICKS = -3 : 1 : 3
        Z_SCORE_DATA_RANGE = [Definitions.Z_SCORE_TICKS(1) Definitions.Z_SCORE_TICKS(end)]
        
        SENSITIVITY = "sensitivity"
        
        MEANS = "means"
        Z_SCORE = "z_score"
        
        NORMAL = "normal"
        EARLY = "early"
        INTERMEDIATE = "intermediate"
    end
end

