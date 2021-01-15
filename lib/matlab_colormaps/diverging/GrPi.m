function c = GrPi(varargin)

parsed = mc_input_parse(varargin{:});
m = parsed.m;

g = [0.085 0.532 0.201];
r = [0.758 0.214 0.233];
w = [0.865 0.865 0.865];
c = diverging_map(m, g, r, 0.5, w);

end

