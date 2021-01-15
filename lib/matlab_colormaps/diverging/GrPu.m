function c = GrPu(varargin)

parsed = mc_input_parse(varargin{:});
m = parsed.m;

g = [0.085 0.532 0.201];
v = [0.436 0.308 0.631];
w = [0.865 0.865 0.865];
c = diverging_map(m, g, v, 0.5, w);

end

