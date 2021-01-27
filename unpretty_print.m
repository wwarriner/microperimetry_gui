function s = unpretty_print(s)

assert(isstring(s));

s = lower(s);
for i = 1 : numel(s)
    s(i) = unpretty_print_scalar(s(i));
end

end


function s = unpretty_print_scalar(s)
    s = replace(s, " ", "_");
end

