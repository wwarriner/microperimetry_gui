%% DEFNS
OUT_NAME = "figure.pdf";

ROW_NAMES = [Definitions.SCOTOPIC, Definitions.MESOPIC];
COLUMN_NAMES = ["normal", "early", "intermediate"];
ECCENTRICITY_DEG = strjoin([init_cap(Definitions.ECCENTRICITY), Definitions.DEGREES_UNITS], ", ");
ECCENTRICITY_MM = strjoin([init_cap(Definitions.ECCENTRICITY), Definitions.MM_UNITS], ", ");

SENSITIVITY_COLORMAP = flipud(lajolla);
POINT_SIZE = 60;

%% DATA
coordinates_file = "Coordinates17.csv";
c = Coordinates(coordinates_file);

data_file = "medians.csv";
data = readtable(data_file);


%% FIGURE
fh = figure();
fh.Color = "w";
fh.Position = [50 50 1280 840];

%% COLORBAR
s_cb = Colorbar(fh);
s_cb.c_label = "mean log sensitivity, dB";
s_cb.c_lim = Definitions.SENSITIVITY_DATA_RANGE;
s_cb.c_tick = Definitions.SENSITIVITY_TICKS;
s_cb.c_tick_label = Definitions.SENSITIVITY_TICKS;
s_cb.cmap = SENSITIVITY_COLORMAP;
s_cb.update();

%% AXES ARRAY
ROW_COUNT = 2;
COLUMN_COUNT = 3;
ax_array = AxesArray(fh, 2, 3);
ax_array.set_right_colorbar(s_cb);

%% AXES FORMAT
AX_SIZE = [320 320];

deg_fmt = AxesFormat();
deg_fmt.x_lim = Definitions.DEGREES_LIM;
deg_fmt.x_tick = Definitions.DEGREES_TICK;
deg_fmt.x_tick_label = Definitions.DEGREES_TICK_LABEL;
deg_fmt.y_lim = Definitions.DEGREES_LIM;
deg_fmt.y_tick = Definitions.DEGREES_TICK;
deg_fmt.y_tick_label = Definitions.DEGREES_TICK_LABEL;
deg_fmt.colorbar = s_cb;

mm_fmt = AxesFormat();
mm_fmt.x_lim = Definitions.MM_LIM;
mm_fmt.x_tick = Definitions.MM_TICK;
mm_fmt.x_tick_label = Definitions.MM_TICK_LABEL;
mm_fmt.y_lim = Definitions.MM_LIM;
mm_fmt.y_tick = Definitions.MM_TICK;
mm_fmt.y_tick_label = Definitions.MM_TICK_LABEL;
mm_fmt.colorbar = s_cb;

%% BUILD AXES
for row = 1 : ROW_COUNT
    row_name = ROW_NAMES(row);
    row_name_title = init_cap(row_name);
    row_label = row_name_title;
    for column = 1 : COLUMN_COUNT
        column_name = COLUMN_NAMES(column);
        column_name_title = init_cap(column_name);
        column_label = strjoin(["Median Values", column_name_title], ", ");
        
        ax = Axes(fh);
        
        df = deg_fmt.copy();
        df.x_label = ECCENTRICITY_DEG;
        if row < ROW_COUNT; df.x_label = ""; df.x_tick = []; df.x_tick_label = []; end
        df.y_label = [row_label, ECCENTRICITY_DEG];
        if 1 < column; df.y_label = ""; df.y_tick = []; df.y_tick_label = []; end
        ax.apply_to_primary_axes(@df.apply);
        
        mf = mm_fmt.copy();
        mf.x_label = [column_label, ECCENTRICITY_MM];
        if 1 < row; mf.x_label = ""; mf.x_tick = []; mf.x_tick_label = []; end
        mf.y_label = ECCENTRICITY_MM;
        if column < COLUMN_COUNT; mf.y_label = ""; mf.y_tick = []; mf.y_tick_label = []; end
        ax.apply_to_secondary_axes(@mf.apply);
        
        ax.apply_to_secondary_axes(@EtdrsGrid);
        if row == ROW_COUNT && column == COLUMN_COUNT
            ax.apply_to_secondary_axes(@CompassRose);
        end
        
        scatter = ax.apply_to_primary_axes(@LabeledScatter);
        
        vision = ROW_NAMES(row);
        class = COLUMN_NAMES(column);
        indices = data.vision == vision & data.class == class;
        values = data(indices, :);
        scatter.v = c.filter(values.median, vision);
        scatter.x = c.get_x(vision);
        scatter.y = c.get_y(vision);
        scatter.size_data = POINT_SIZE;
        scatter.update();
        
        ax_array.set_axes(ax, row, column);
    end
end
ax_array.update();

%% Save
%export_fig(OUT_NAME, '-nofontswap', fh);

%% Turn this into generic controller class
