function [ res ] = gf_mul( a, b, powtable, fsize )
%GF_MUL Multiplication in GF using prime el. powers table

    if a == 0 || b == 0
        res = 0;
        return;
    end
    
    a_pow = powtable(a + 1, 3);
    b_pow = powtable(b + 1, 3);
    res_pow = 1 + mod(a_pow + b_pow - 1, fsize - 1);

    res = powtable(res_pow + 1, 2);
end

