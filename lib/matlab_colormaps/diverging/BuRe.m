function c = BuRe(varargin)

parsed = mc_input_parse(varargin{:});
m = parsed.m;

b = [0.230 0.299 0.754];
r = [0.706 0.016 0.150];
w = [0.865 0.865 0.865];
c = diverging_map(m, b, r, 0.5, w);

end

