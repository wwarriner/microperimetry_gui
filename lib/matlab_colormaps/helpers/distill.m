function c = distill(rgb, m)
%{
Distills n by 3 rgb data into m evenly spaced values using linear interpolation.

INPUTS:
1) rgb | numeric array, n by 3, [0, 1]
2) m | integer scalar, [1, intmax]
%}

assert(isnumeric(rgb));
assert(ismatrix(rgb));
assert(size(rgb, 2) == 3);

assert(isnumeric(m));
assert(isscalar(m));
assert(1 <= m);

if size(rgb, 1) == m
    c = rgb;
    return;
end

x = linspace(0, 1, size(rgb, 1));
xq = linspace(0, 1, m);
c = interp1(x, rgb, xq);

end

