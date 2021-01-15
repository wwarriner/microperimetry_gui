function c = twilight_shifted(varargin)
% Idea sources from matplotlib, originally from Bastian Bechtold, see twilight.m
% Adapted for MATLAB by William Warriner 2020

parsed = mc_input_parse(varargin{:});
m = parsed.m;

rgb = twilight;
rgb = rgb(1 : end - 1, :);
rgb = circshift(rgb, -128, 1);
rgb(end + 1, :) = rgb(1, :);
rgb = flipud(rgb);

c = distill(rgb, m);

end
