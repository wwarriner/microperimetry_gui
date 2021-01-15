classdef TestColormaps < matlab.unittest.TestCase
    properties
        folders = ["circular" "diverging" "sequential"];
        functions = [];
    end
    
    methods (TestMethodSetup)
        function find_colormap_functions(testCase)
            files = table();
            for f = testCase.folders
                c = get_contents(f);
                files = [files; get_files_with_extension(c, ".m")]; %#ok<AGROW>
            end
            
            names = string(files.name);
            [~, fns, ~] = arrayfun(@fileparts, names);
            testCase.functions = fns;
        end
    end
    
    methods (Test)
        function sanity_check(testCase)
            for fn = testCase.functions.'
                rgb = feval(fn);
                testCase.verifyTrue(isa(rgb, "double"));
                testCase.verifyEqual(size(rgb), [256 3]);
                testCase.verifyGreaterThanOrEqual(rgb, 0.0);
                testCase.verifyLessThanOrEqual(rgb, 1.0);
                for i = 2 .^ (1:10)
                    rgb = feval(fn, i);
                    testCase.verifyTrue(isa(rgb, "double"));
                    testCase.verifyEqual(size(rgb), [i 3]);
                    testCase.verifyGreaterThanOrEqual(rgb, 0.0);
                    testCase.verifyLessThanOrEqual(rgb, 1.0);
                end
            end
        end
    end
end

