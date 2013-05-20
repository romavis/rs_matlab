function [ powtable, fsize ] = gf_calculate_pt( m, prime_poly, prime )
%GF_CALCULATE_PT Computes powers table for GF(2^m) built over
%       prime polynomial "prime_poly" and for specified prime element

    %GF(2) powers table
    bf_pt = [0 1 -1; 1 1 0];
    fsize = 2^m;
    
    powtable = zeros(fsize, 3);
    powtable(1,:) = [0 1 -1];
    powtable(:,3) = -1;
    poly_pe = de2bi(prime, m);  %Polynomial representation of "prime"
    cur_res = poly_pe;
    for i=1:(fsize-1)
        dec_cur_res = bi2de(cur_res);   %Decimal representation of prime^i
        powtable(i+1, 1) = i;
        powtable(i+1, 2) = dec_cur_res;
        powtable(dec_cur_res+1, 3) = i;
        %Calculate prime^(i+1) modulo "prime_poly"
        [cur_res, ~] = poly_div(poly_mul(cur_res, poly_pe, bf_pt, 2), prime_poly, bf_pt, 2);
    end
end

