classdef TestDualUnitAxes < matlab.unittest.TestCase
    properties
        figure_handle
    end
    
    methods (TestMethodSetup)
        function create_figure(testCase)
            fh = figure();
            fh.Visible = "off";
            testCase.figure_handle = fh;
        end
    end
    
    methods (Test)
        function test_scaling(testCase)
            ax = DualUnitAxes(testCase.figure_handle);
            SCALE = 0.5;
            SET_X = [0 1];
            SET_Y = [2 4];
            
            % DOES PRIMARY SET SECONDARY?
            ax.primary_to_secondary_scale = SCALE;
            ax.apply_to_primary_axes(@(ax)testCase.set(ax, SET_X, SET_Y));
            [actual_x, actual_y] = ax.apply_to_secondary_axes(@testCase.get);
            expected_x = SET_X .* SCALE;
            testCase.verifyEqual(actual_x, expected_x);
            expected_y = SET_Y .* SCALE;
            testCase.verifyEqual(actual_y, expected_y);
            
            % DOES SECONDARY SET PRIMARY?
            ax.secondary_to_primary_scale = SCALE;
            ax.apply_to_secondary_axes(@(ax)testCase.set(ax, SET_X, SET_Y));
            [actual_x, actual_y] = ax.apply_to_primary_axes(@testCase.get);
            expected_x = SET_X .* SCALE;
            testCase.verifyEqual(actual_x, expected_x);
            expected_y = SET_Y .* SCALE;
            testCase.verifyEqual(actual_y, expected_y);
        end
        
        function test_position(testCase)
            ax = DualUnitAxes(testCase.figure_handle);
            expected = [0 0 50 100];
            
            % ARE BOTH POSITIONS SET?
            ax.set_position(expected);
            actual_primary = ax.apply_to_primary_axes(@testCase.get_position);
            actual_secondary = ax.apply_to_secondary_axes(@testCase.get_position);
            testCase.verifyEqual(actual_primary, expected);
            testCase.verifyEqual(actual_secondary, expected);
            testCase.verifyEqual(actual_primary, actual_secondary);
            
            unexpected = [1 2 3 4];
            testCase.fatalAssertNotEqual(expected, unexpected);
            
            % DOES PRIMARY FAIL TO APPLY POSITION?
            ax.apply_to_primary_axes(@(ax)testCase.set_position(ax, unexpected));
            actual_primary = ax.apply_to_primary_axes(@testCase.get_position);
            testCase.verifyEqual(actual_primary, expected);
            testCase.verifyNotEqual(actual_primary, unexpected);
            
            % DOES SECONDARY FAIL TO APPLY POSITION?
            ax.apply_to_secondary_axes(@(ax)testCase.set_position(ax, unexpected));
            actual_secondary = ax.apply_to_secondary_axes(@testCase.get_position);
            testCase.verifyEqual(actual_secondary, expected);
            testCase.verifyNotEqual(actual_secondary, unexpected);
        end
    end
    
    methods (Static)
        function set(ax, xlim, ylim)
            ax.XLim = xlim;
            ax.YLim = ylim;
        end
        
        function [xlim, ylim] = get(ax)
            xlim = ax.XLim;
            ylim = ax.YLim;
        end
        
        function set_position(ax, pos)
            ax.Position = pos;
        end
        
        function pos = get_position(ax)
            pos = ax.Position;
        end
    end
end

