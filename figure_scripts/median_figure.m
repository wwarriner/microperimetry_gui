coordinates_file = "Coordinates17.csv";
c = Coordinates(coordinates_file);

data_file = "medians.csv";
data = readtable(data_file);


fh = figure();
fh.Color = "w";
%             closer = onCleanup(@()close(fh));
%             fh.Visible = "off";
fh.Position = [50 50 1280 840];

SENSITIVITY_COLORMAP_FN = @()flipud(lajolla);

ROW_COUNT = 2;
COLUMN_COUNT = 3;
ax_array = AxesArray(fh, 2, 3);
ax_array.right_colorbar_visible = false;
ax_array.left_colormap_fn = SENSITIVITY_COLORMAP_FN;
for row = 1 : ROW_COUNT
    for col = 1 : COLUMN_COUNT
        ax = Axes(fh);
        ax.set_color_info(ax.SENSITIVITY_COLORBAR_SIDE, SENSITIVITY_COLORMAP_FN(), Definitions.SENSITIVITY_DATA_RANGE);
        ax_array.add_axes(ax, row, col);
        ax.set_style(ax.GROUP_MEANS_STYLE);
        ax.build();
        g = EtdrsGrid();
        ax.apply_to_axes(ax.MM_AXES_UNITS, g);
        if row == ROW_COUNT && col == COLUMN_COUNT
            cr = CompassRose();
            cr.chirality = Definitions.OD_CHIRALITY;
            cr.position = [3.2, -3.2]; % mm
            cr.label_nudge = 0.25;
            ax.apply_to_axes(ax.MM_AXES_UNITS, cr);
        end
        % TODO ax.set_data() based on lookup in data var
    end
end
ax_array.build();
