function code = convert_to_m_code(txt, name, delimiter, comment)
%{
Reads a delimited text file and converts to an m_files
%}
if nargin < 3
    delimiter = " ";
end

if nargin < 4
    comment = "";
end

data = string(txt);
data = string(split(data));
data = string(split(data, delimiter));
data(data == "") = [];
data = reshape(data, 3, []);
data = permute(data, [2 1]);

rgb = strings([size(data, 1) 1]);
fmt = "    [%s];...";
last_fmt = "    [%s]...";
for i = 1 : size(data, 1)
    row = data(i, :);
    row = strjoin(row, ", ");
    if i == size(data, 1)
        row = sprintf(last_fmt, row);
    else
        row = sprintf(fmt, row);
    end
    rgb(i) = row;
end

if comment ~= ""
    comment = [ ...
        comment; ...
        "" ...
        ];
end

code = [...
    sprintf("function c = %s(varargin)", name); ...
    comment; ...
    "parsed = mc_input_parse(varargin{:});"; ...
    "m = parsed.m;"; ...
    ""; ...
    "rgb = [..."; ...
    rgb; ...
    "    ];"; ...
    ""; ...
    "c = distill(rgb, m);"; ...
    ""; ...
    "end" ...
    ];
code = strjoin(code, newline);

end

