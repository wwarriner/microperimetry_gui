function convert_folder_to_m_files(folder, delimiter, comment)
%{
applies convert_to_m_code to each txt file in a folder
saves results to m files
%}

files = get_files_with_extension(get_contents(folder), ".txt");
out = fullfile(folder, "out");
mkdir(out);
for i = 1 : size(files, 1)
    f = files(i, :).name{1};
    [~, name, ~] = fileparts(f);
    txt = fileread(fullfile(folder, f));
    code = convert_to_m_code(txt, name, delimiter, comment);
    fid = fopen(fullfile(out, name + ".m"), "w");
    fc = create_file_closer(fid);
    fprintf(fid, code);
end

end

