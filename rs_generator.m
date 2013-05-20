function [ poly, n, k, r ] = rs_generator( prime, dmin, powtable, fsize )
%RS_GENERATOR Compute Reed-Solomon (N,K,R) generator polynomial in supplied
%   GF(2^m) using supplied prime element.
%   NOTE: "prime" need not to be actual GF prime element
%   NOTE: achieved dmin is >= 2
%   dmin is _maximal_ dmin value. Achieved dmin can be less than specified,
%   especially with bad(incorrect) prime value
%   Specifying prime, which order is < fsize-1, one can produce shortened
%   RS code with N < fsize-1. In fact, N is equal to specified prime order
    poly = [prime 1];   % G = x + prime
    cur_res = gf_mul(prime, prime, powtable, fsize);
    cur_pow = 2;
    r = 1;
    while cur_res ~= prime
        if cur_pow < dmin
            %If we've achieved specified dmin, stop to grow polynomial
            poly = poly_mul(poly, [cur_res 1], powtable, fsize);
            r = r + 1;
        end
        % anyway, we proceed to compute N
        cur_res = gf_mul(cur_res, prime, powtable, fsize);
        cur_pow = cur_pow + 1;
    end
    
    n = cur_pow - 1;    % N = q-1
    k = n - r;          
end

