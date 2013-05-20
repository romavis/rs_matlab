function [ multable ] = gf_calculate_mt( m, prime_poly )
%GF_CALCULATE_MT Computes multiplication table for GF(2^m) built over
%       prime polynomial "prime_poly"

    %GF(2) powers table
    bf_pt = [0 1 -1; 1 1 0];
    fsize = 2^m;
    multable = zeros(fsize, fsize);
    for i=0:(fsize-1)
        for j=0:(fsize-1)
            poly_a = de2bi(i, m);
            poly_b = de2bi(j, m);
            [rem, ~] = poly_div(poly_mul(poly_a, poly_b, bf_pt, 2),...
                prime_poly, bf_pt, 2);
            multable(i + 1, j + 1) = bi2de(rem);
        end
    end

end

