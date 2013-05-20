function [ res ] = poly_eval( poly, x, powtable, fsize )
%POLY_EVAL Evaluate polynomial "poly" at point "x" in GF
%Procedure uses Horner's rule..
    res = poly(end);    
    for i=(length(poly)-1):-1:1
        res = gf_mul(res, x, powtable, fsize);
        res = bitxor(res, poly(i));
    end
end

