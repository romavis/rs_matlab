function [ res ] = poly_mul( poly_a, poly_b, powtable, fsize )
%POLY_MUL Calculate multiplication of polynomials over GF(p)
    
    deg_a = length(poly_a) - 1;
    deg_b = length(poly_b) - 1;
    deg_res = deg_a + deg_b;
    
    res = zeros(1, deg_res + 1);
    %Calculate coefficients "convolution" :)
    for i=0:deg_res
        for j=max([0 (i-deg_b)]):min([i deg_a])
            % res_i += Pj * Qi-j
            res(i+1) = bitxor(res(i+1), gf_mul(poly_a(j+1), poly_b(i-j+1), powtable, fsize));
        end
    end
end

