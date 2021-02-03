function data = median_table(coordinates_file_path, data_file_path)

data = readtable(data_file_path);
data.Properties.VariableNames = lower(data.Properties.VariableNames);
data = stack(data, 2:width(data));
data.Properties.VariableNames{1} = 'class';
data.Properties.VariableNames{2} = 'info';
data.Properties.VariableNames{3} = 'value';

v = cellfun(@(s)string(strsplit(s, "_")), cellstr(data{:, "info"}), "uniformoutput", false);
v = vertcat(v{:});
v = array2table(v, "variablenames", ["vision", "position", "data_type"]);
data = [data v];

data.vision(data.vision == "cm") = "Mesopic";
data.vision(data.vision == "cs") = "Scotopic";

data.index = str2double(strrep(data.position, "b", ""));

data.info = [];
data.position = [];

coords = readtable(coordinates_file_path);
coords.Properties.VariableNames = lower(coords.Properties.VariableNames);

data = join(data, coords, "keys", "index");

cols = find(varfun(@iscellstr, data, "output", "uniform"));
for c = cols(:).'
    v = data.Properties.VariableNames{c};
    data.(v) = string(data.(v));
end

end

