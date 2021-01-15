function preview_cmap(c, axh)

if nargin < 2
    axh = [];
end

im = linspace(0, 1, size(c, 1));

if isempty(axh)
    fh = figure();
    fh.MenuBar = "none";
    fh.ToolBar = "none";
    fh.DockControls = "off";
    fh.Color = [1 1 1];

    fh.Position(3:4) = [720 120];

    axh = axes(fh);
    ti = axh.TightInset;
    axh.Position = [ti(1:2), 1 - ti(1) - ti(3), 1 - ti(2) - ti(4)];
end

imagesc(axh, im);
colormap(axh, c);

if isempty(axh)
    axh.XAxis.Visible = "off";
    axh.YAxis.Visible = "off";
end

end

