function c = sinebow(varargin)
% Credit to Charlie Loyd
% Adapted for MATLAB by William Warriner 2020
% pulled from
% https://basecase.org/env/on-rainbows

parsed = mc_input_parse(varargin{:});
m = parsed.m;

h = linspace(0, 1, m);
c = hue_to_rgb(h);
    
end


function rgb = hue_to_rgb(h)

assert(isnumeric(h));
assert(isvector(h));

h = h(:);

h = h + 1/2;
h = -h;
r = sin(pi * h);
g = sin(pi * (h + 1/3));
b = sin(pi * (h + 2/3));
rgb = [r g b] .^ 2;

end
