function [ codeword ] = rs_encode( data, rs_poly, rs_n, powtable, fsize)
%RS_ENCODE Systematic RS encoder
    
    k = rs_n - length(rs_poly) + 1;
    if length(data) ~= k
        error('Data block length must be equal to %d', k);
    end
    codeword = [zeros(1, length(rs_poly) - 1) data(end:-1:1)];
    [rem, ~] = poly_div(codeword, rs_poly, powtable, fsize);
    codeword(1:length(rem)) = rem;
end

