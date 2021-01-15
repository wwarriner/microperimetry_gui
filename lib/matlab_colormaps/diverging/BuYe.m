function c = BuYe(varargin)

parsed = mc_input_parse(varargin{:});
m = parsed.m;

b = [0.217 0.525 0.910];
y = [0.677 0.492 0.093];
w = [0.865 0.865 0.865];
c = diverging_map(m, b, y, 0.5, w);

end

