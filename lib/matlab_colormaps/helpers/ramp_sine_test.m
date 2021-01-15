function im = ramp_sine_test()

CYCLES = 64.5;
PX_PER_CYCLE = 8;
A = 0.05;

% horizontal linear ramp
width = PX_PER_CYCLE * CYCLES + 1;
height = round((width - 1) / 4);
linear_ramp = linspace(A, 1 - A, width);

% vertical sinusoid ramp
k = 0 : (width - 1);
x = -A * cos((2*pi / PX_PER_CYCLE) * k);
q = 0 : (height - 1);
y = ((height - q) / (height - 1)) .^ 2;
sine_ramp = (y') .* x;

% superimpose and extend
im = sine_ramp + linear_ramp;
im = [im; repmat(linspace(0, 1, width), round(height / 4), 1)];

end

