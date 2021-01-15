function c = PuOr(varargin)

parsed = mc_input_parse(varargin{:});
m = parsed.m;

v = [0.436 0.308 0.631];
o = [0.759 0.334 0.046];
w = [0.865 0.865 0.865];
c = diverging_map(m, v, o, 0.5, w);

end

