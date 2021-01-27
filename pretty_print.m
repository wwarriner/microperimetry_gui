function s = pretty_print(s)

assert(isstring(s));

for i = 1 : numel(s)
    s(i) = pretty_print_scalar(s(i));
end

end


function s = pretty_print_scalar(s)
    w = replace(s, "_", " ");
    w = strsplit(w, " ");
    for i = 1 : numel(w)
        w(i) = init_cap(w(i));
    end
    s = strjoin(w, " ");
end