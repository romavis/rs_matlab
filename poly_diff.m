function [ res ] = poly_diff( poly )
%POLY_DIFF Find formal polynomial derivative over GF(2^m)

    if mod(length(poly), 2) ~= 0
        res = zeros(1, length(poly) - 2);
    else
        res = zeros(1, length(poly) - 1);
    end
    for i=1:length(res)
        if mod(i,2) ~= 0
            res(i) = poly(i+1);
        end
    end

end

