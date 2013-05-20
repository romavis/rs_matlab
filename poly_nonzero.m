function [ res ] = poly_nonzero( poly )
%POLY_IS_ZERO Test polynomial for zeroness

    res = false;
    for i=1:length(poly)
        if poly(i) ~= 0
            res = true;
            return;
        end
    end
end

