classdef TestInitCap < matlab.unittest.TestCase
    properties
        LOWER_LETTERS = 'a':'z';
        UPPER_LETTERS = 'A':'Z';
    end
    
    methods (Test)
        function test_empty(testCase)
            expected = "";
            actual = init_cap("");
            testCase.assertEqual(actual, expected);
        end
        
        function test_single(testCase)
            for i = 1 : numel(testCase.LOWER_LETTERS)
                expected = testCase.UPPER_LETTERS(i);
                letter = string(testCase.LOWER_LETTERS(i));
                letter = init_cap(letter);
                actual = char(letter);
                testCase.assertEqual(actual, expected);
            end
        end
        
        function test_multiple(testCase)
            for i = 1 : numel(testCase.LOWER_LETTERS)
                expected = [testCase.UPPER_LETTERS(i) testCase.LOWER_LETTERS(i+1 : end)];
                letters = string(testCase.LOWER_LETTERS(i : end));
                letters = init_cap(letters);
                actual = char(letters);
                testCase.assertEqual(actual, expected);
            end
        end
    end
end

