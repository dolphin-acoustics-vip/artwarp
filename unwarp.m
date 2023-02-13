function unwarpfun = unwarp(warpfun)

for i = 1:warpfun(end)
    n = find(warpfun ==i);
    if isempty(n)
        unwarpfun(i) = unwarpfun(i-1);
    else
        unwarpfun(i) = n(1);
    end
end