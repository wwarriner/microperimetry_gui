function parsed = mc_input_parse(varargin)

if nargin < 1
    m = 256;
else
    m = varargin{1};
end

assert(isnumeric(m));
assert(isscalar(m));
assert(isreal(m));
assert(isfinite(m));
assert(mod(m, 1) == 0);
assert(1 <= m);

parsed.m = m;

end

