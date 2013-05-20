function [ rem, quot ] = poly_div( poly_dd, poly_dr, powtable, fsize )
%POLY_DIV Divide poly_dd by poly_dr (over GF) and calculate quotient and
%      remainder
%       NOTE: this is typical "corner" division
%       multiplication/division is done by using prime el. powers table

    %rem = zeros(1, length(poly_dr) - 1);
    %if length(poly_dd) < length(poly_dr) 
    %    quot = 0;
    %    rem(1:length(poly_dd)) = poly_dd;
    %    return;
    %end
    quot = zeros(1, length(poly_dd) - length(poly_dr) + 1);

    dd_deg = length(poly_dd) - 1;
    dr_deg = length(poly_dr) - 1;
    quot_idx = length(quot);
    poly_dr_shifted = [zeros(1, dd_deg - dr_deg) poly_dr];
    while dd_deg >= dr_deg
        quot_part = gf_div(poly_dd(dd_deg + 1), poly_dr(dr_deg + 1), powtable, fsize);
        quot(quot_idx) = quot_part;
        poly_dd = poly_sum(poly_dd, poly_mul(poly_dr_shifted, quot_part, powtable, fsize));
        dd_deg = dd_deg - 1;
        quot_idx = quot_idx - 1;
        poly_dr_shifted = poly_dr_shifted(2:end);
    end
    rem = poly_dd(1:(dd_deg+1));
end

