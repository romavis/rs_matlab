function [ ret ] = gf_el_order( prime, powtable, fsize )
%GF_EL_ORDER Compute order of supplied element in GF

    cur_pow = 2;
    cur_num = gf_mul(prime, prime, powtable, fsize);
    while (cur_num ~= prime)
        cur_num = gf_mul(prime, cur_num, powtable, fsize);
        cur_pow = cur_pow + 1;
    end
    ret = cur_pow - 1;
end

