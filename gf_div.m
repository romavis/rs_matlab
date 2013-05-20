function [ res ] = gf_div( dd, dr, powtable, fsize )
%GF_DIV Calculate division in GF using prime el. power table
%       order is prime order, i.e. Num_of_elements - 1;
    if dd == 0
        res = 0;
        return;
    end
    if dr == 0
        error('GF division by zero');
    end
    
    dd_pow = powtable(dd + 1, 3);
    dr_pow = powtable(dr + 1, 3);
    res_pow = 1 + mod(dd_pow - dr_pow - 1, fsize - 1);

    res = powtable(res_pow + 1, 2);
end

