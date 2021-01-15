function c = diverging_map(m, rgb_left, rgb_right, mid, rgb_mid)
% Based on the work of Kenneth Moreland
% Adapted for MATLAB by William Warriner 2020
% for more information see
% https://www.kennethmoreland.com/color-maps/
% https://www.kennethmoreland.com/color-maps/ColorMapsExpanded.pdf

if nargin < 1
    m = 256;
end

if nargin < 2
    rgb_left = [0.230 0.299 0.754]; % blue
end

if nargin < 2
    rgb_right = [0.706 0.016 0.150]; % red
end

if nargin < 4
    mid = 0.5;
end

if nargin < 5
    rgb_mid = [];
end

assert(isnumeric(m));
assert(isscalar(m));
assert(isreal(m));
assert(isfinite(m));
assert(mod(m, 1) == 0);
assert(1 <= m);

assert(isnumeric(rgb_left));
assert(isvector(rgb_left));
assert(size(rgb_left, 2) == 3);
assert(isreal(rgb_left));
assert(all(isfinite(rgb_left)));
assert(all(0 <= rgb_left));
assert(all(rgb_left <= 1));

assert(isnumeric(rgb_right));
assert(isvector(rgb_right));
assert(size(rgb_right, 2) == 3);
assert(isreal(rgb_right));
assert(all(isfinite(rgb_right)));
assert(all(0 <= rgb_right));
assert(all(rgb_right <= 1));

assert(isnumeric(mid));
assert(isscalar(mid));
assert(isreal(mid));
assert(isfinite(mid));
assert(0 <= mid);
assert(mid <= 1);

if ~isempty(rgb_mid)
    assert(isnumeric(rgb_left));
    assert(isvector(rgb_left));
    assert(size(rgb_left, 2) == 3);
    assert(isreal(rgb_left));
    assert(all(isfinite(rgb_left)));
    assert(all(0 <= rgb_left));
    assert(all(rgb_left <= 1));
end

msh_left = rgb2msh(rgb_left);
msh_right = rgb2msh(rgb_right);
M = 1;
S = 2;
H = 3;

use_white_mid_point = false;
if 0.05 < msh_left(S) ...
        && 0.05 < msh_right(S) ...
        && pi/3 < angdiff(msh_left(H), msh_right(H))
    use_white_mid_point = true;
end

force_mid = true;
if ~isempty(rgb_mid)
    msh_mid = rgb2msh(rgb_mid);
elseif use_white_mid_point
    msh_mid = [ ...
        max([msh_left(M) msh_right(M) 88]) ...
        0.0 ...
        0.0 ...
        ];
else
    force_mid = false;
end
    
t = linspace(0, 1, m);
if force_mid
    left_t = t < mid;
    [msh_left_adj, msh_mid_adj] = adjust(msh_left, msh_mid);
    msh_left_int = interp1(...
        [0; 1], ...
        [msh_left_adj; msh_mid_adj], ...
        linspace(0, 1, sum(left_t)) ...
        );
    
    right_t = mid <= t;
    [msh_mid_adj, msh_right_adj] = adjust(msh_mid, msh_right);
    msh_right_int = interp1(...
        [0; 1], ...
        [msh_mid_adj; msh_right_adj], ...
        linspace(0, 1, sum(right_t)) ...
        );
    
    msh = [msh_left_int; msh_right_int];
else
    [msh_left_adj, msh_right_adj] = adjust(msh_left, msh_right);
    msh = interp1([0; 1], [msh_left_adj; msh_right_adj], t);
end

c = msh2rgb(msh);

end


function [msh_left, msh_right] = adjust(msh_left, msh_right)
M = 1;
S = 2;
H = 3;

if msh_left(S) < 0.05 && 0.05 < msh_right(S)
    msh_left(H) = adjust_hue(msh_right, msh_left(M));
elseif 0.05 < msh_left(S) && msh_right(S) < 0.05
    msh_right(H) = adjust_hue(msh_left, msh_right(M));
end

end


function h = adjust_hue(msh_sat, msh_unsat)
M = 1;
S = 2;
H = 3;
    
if msh_unsat(M) <= msh_sat(M)
    h = msh_sat(H);
else
    h_spin = msh_sat(S) ...
        * sqrt(msh_unsat(M).^2 - msh_sat(M).^2) ...
        / (msh_sat(M) * sin(msh_sat(S)));
    if -pi/3 < msh_sat(H) % away from purple
        h = msh_sat(H) + h_spin;
    else
        h = msh_sat(H) - h_spin;
    end
end

end


function rgb = msh2rgb(msh)

lab = msh2lab(msh);
xyz = lab2xyz(lab);
rgb = xyz2rgb(xyz);

end


function msh = rgb2msh(rgb)

xyz = rgb2xyz(rgb);
lab = xyz2lab(xyz);
msh = lab2msh(lab);

end


function lab = msh2lab(msh)

M = msh(:, 1);
s = msh(:, 2);
h = msh(:, 3);

lab = [...
    M .* cos(s) ...
    M .* sin(s) .* cos(h) ...
    M .* sin(s) .* sin(h) ...
    ];

end


function msh = lab2msh(lab)

L = lab(:, 1);
a = lab(:, 2);
b = lab(:, 3);

M = sqrt(L .* L + a .* a + b .* b);
s = (M > 0.001) .* acos(L ./ M);
h = (s > 0.001) .* atan2(b, a);
msh = [M s h];

end


function xyz = lab2xyz(lab)

var_y = (lab(:, 1) + 16.0) / 116.0;
var = [...
    (lab(:, 2) / 500.0) + var_y ...
    var_y ...
    var_y - (lab(:, 3) / 200.0) ...
    ];

t = 0.008856 .^ (1 / 3);
xyz = var;
xyz(t < var) = xyz(t < var) .^ 3;
xyz(var <= t) = (xyz(var <= t) - (16.0 / 116.0)) / 7.787;

% Observer -> 2 deg
% Illuminant -> D65
ref = [0.9505 1.0000 1.0890];

xyz = ref .* xyz;

end


function lab = xyz2lab(xyz)

% Observer -> 2 deg
% Illuminant -> D65
ref = [0.9505 1.0000 1.0890];
var = xyz ./ ref;

t = 0.008856;
lab = var;
lab(var < t) = (7.787 * lab(var < t)) + (16.0 / 116.0);
lab(t <= var) = lab(t <= var) .^ (1.0 / 3.0);

lab = [...
    (116.0 * lab(:, 2)) - 16.0 ...
    500.0 * (lab(:, 1) - lab(:, 2)) ...
    200.0 * (lab(:, 2) - lab(:, 3)) ...
    ];

end


function rgb = xyz2rgb(xyz)

m = [ ...
     3.2406 -0.9689  0.0557; ...
    -1.5372  1.8758 -0.2040; ...
    -0.4986  0.0415  1.0570 ...
    ];
var = xyz * m;

t = 0.0031308;
rgb = var;
rgb(var <= t) = rgb(var <= t) * 12.92;
rgb(t < var) = (1.055 * (rgb(t < var) .^ (1 / 2.4))) - 0.055;

rgb(rgb < 0) = 0;
maxval = max(rgb, [], "all");
if 1.0 < maxval
    rgb = rgb / maxval;
end

end


function xyz = rgb2xyz(rgb)

t = 0.04045;
var = rgb;
var(rgb <= t) = var(rgb <= t) / 12.92;
var(t < rgb) = ((var(t < rgb) + 0.055) / 1.055) .^ 2.4;

% Observer -> 2 deg
% Illuminant -> D65
m = [ ...
    0.4124 0.2126 0.0193; ...
    0.3576 0.7152 0.1192; ...
    0.1805 0.0722 0.9505 ...
    ];
xyz = var * m;

end

