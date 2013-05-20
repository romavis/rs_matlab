function [ res ] = poly_sum( poly_a, poly_b )
%POLY_SUM Calculate sum of polynomials over GF(2^m)
    
    deg_a = length(poly_a) - 1;
    deg_b = length(poly_b) - 1;
    if deg_a >= deg_b
        deg_min = deg_b;
        res = poly_a;
    else
        deg_min = deg_a;
        res = poly_b;
    end
    for i=0:deg_min
        res(i+1) = bitxor(poly_a(i+1), poly_b(i+1));
    end
end

