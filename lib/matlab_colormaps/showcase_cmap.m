function showcase_cmap(c)

if nargin < 1
    c = viridis;
end

% setup
fh = figure();
fh.MenuBar = "none";
fh.ToolBar = "none";
fh.DockControls = "off";
fh.Color = [0.9 0.9 0.9];
fh.Position(1:2) = [50 50];
fh.Position(3:4) = [1600 960];

% hi-res peaks
[X, Y, Z] = peaks(200);

axh = subplot(2, 4, 1);
sh = surfc(axh, X, Y, Z);
sh(1).EdgeColor = "none";
sh(1).FaceColor = "interp";
light(axh, "position", [0 0 5], "style", "local");
view(axh, 3);
colormap(axh, c);
axis(axh, "square", "vis3d");
axh.Title.String = "surfc(peaks(200)), view(1)";
axh.Toolbar.Visible = "on";
axtoolbar(axh, "rotate");

axh = subplot(2, 4, 2);
imagesc(axh, Z);
axh.YDir = "normal";
view(axh, 2);
colormap(axh, c);
axis(axh, "square");
axh.Title.String = "surfc(peaks(200)), view(2)";
axh.Toolbar.Visible = "off";

% lo-res peaks
[X, Y, Z] = peaks(10);

axh = subplot(2, 4, 5);
sh = surfc(axh, X, Y, Z);
sh(1).EdgeColor = "none";
sh(1).FaceColor = "interp";
light(axh, "position", [0 0 5], "style", "local");
view(axh, 3);
colormap(axh, c);
axis(axh, "square", "vis3d");
axh.Title.String = "surfc(peaks(20)), view(1)";
axh.Toolbar.Visible = "on";
axtoolbar(axh, "rotate");

axh = subplot(2, 4, 6);
imagesc(axh, Z);
axh.YDir = "normal";
view(axh, 2);
colormap(axh, c);
axis(axh, "square");
axh.Title.String = "surfc(peaks(20)), view(2)";
axh.Toolbar.Visible = "off";

% test image
im = imread("rice.png");
im = imadjust(im);

axh = subplot(2, 4, 3);
imshow(im);
axis(axh, "square");
axh.Title.String = "rice.png, grayscale";
axh.Toolbar.Visible = "off";

axh = subplot(2, 4, 4);
imagesc(axh, im);
colormap(axh, c);
axis(axh, "square");
axh.Box = "off";
axh.Title.String = "rice.png, color";
axh.Toolbar.Visible = "off";

% sine ramp
axh = subplot(2, 4, [7 8]);
im = ramp_sine_test();
ih = imagesc(axh, im);
colormap(axh, c);
axis(axh, "equal");
axh.Box = "off";
axh.XAxis.Visible = "off";
axh.YAxis.Visible = "off";
axh.Color = [0.9 0.9 0.9];
axh.Title.String = "Sinusoidal Ramp";

end

