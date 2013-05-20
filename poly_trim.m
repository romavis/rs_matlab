function [ ret ] = poly_trim( poly )
%POLY_TRIM Trim highest zero coefficients of poly
    ret = poly;
    real_pow = 0;
    for i=1:length(poly)
        if poly(i) ~= 0
            real_pow = i - 1;
        end
    end
    
    ret = ret(1:(real_pow+1));
end

