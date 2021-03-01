function s = init_cap(s)
%{
capitalizes the first letter of the input string
%}

assert(isstring(s));
assert(isscalar(s));

if s == ""
    return
end

s = char(s);
s(1) = upper(s(1));
s(2:end) = lower(s(2:end));
s = string(s);

end

