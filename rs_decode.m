function [ data, correct, err_present, S, cw ] = rs_decode( cw, prime, rs_poly, rs_n, powtable, fsize)
%RS_DECODE Reed-Solomon decoder procedure
%   Detailed explanation goes here

    r = length(rs_poly) - 1;
    k = rs_n - r;
    data = zeros(1,k);

    %Evaluate syndroms. Syndrom count is 2t = dmin-1 = r
    S = zeros(1, r);
    cur_pv = prime;
    err_present = false;
    correct = true;
    for i=1:r
        S(i) = poly_eval(cw, cur_pv, powtable, fsize);
        cur_pv = gf_mul(cur_pv, prime, powtable, fsize);
        if S(i) ~= 0
            err_present = true;
        end
    end
    
    if err_present
        %We must try to correct received codeword
        %Use Berlekamp-Massey algorithm to obtain error locator polynomial
        %coefficients L1...Lv (s is error count, which is smaller than r/2)
        Sx = S;
        while Sx(1) == 0
            Sx = Sx(2:end);
        end
        [V, Lb] = berlekamp(Sx, powtable, fsize);
        L = [1 Lb];
        fprintf('Berlekamp gives us locator polynomial of power %d\n', V);
        fprintf('L(x):\n');
        disp(L);
        %Initialize error locator vector
        iloc_vec = zeros(1, floor(r/2));
        iloc_idx = 1;
        %Find roots of L(x) using Chien search..
        for i=1:(fsize-1)
            lev = poly_eval(L, i, powtable, fsize);
            if lev == 0
                iloc_vec(iloc_idx) = i;
                iloc_idx = iloc_idx + 1;
            end
        end
        loc_cnt = iloc_idx - 1;
        if loc_cnt < V
            fprintf('deg L(x) < V. Unable to correct errors\n');
            correct = false;
            return;
        end
        %Forney algorithm
        %Compute error values polynomial
        Ev = poly_mul(S, L, powtable, fsize);
        Ev = Ev(1:r);   %Remainder from division by x^2t = x^r
        fprintf('Omega(x):\n');
        disp(Ev);
        %Compute error values..
        %Formal derivative
        L_d = poly_diff(L);
        
        for i=1:loc_cnt
            nom = poly_eval(Ev, iloc_vec(i), powtable, fsize);
            denom = poly_eval(L_d, iloc_vec(i), powtable, fsize);
            err_pos = fsize - 1 - powtable(iloc_vec(i)+1, 3);
            if nom == 0 || denom == 0 || err_pos > (rs_n-1)
                fprintf('Incorrect error value. Unable to correct errors\n');
                correct = false;
                return;
            end
            err_val = gf_div(nom, denom, powtable,fsize);
            fprintf('ILocator %d has error value %d and pos %d\n', iloc_vec(i),...
                err_val, err_pos);
            %Correct error
            cw(err_pos+1) = bitxor(cw(err_pos+1), err_val);
        end
    end
    
    data = cw(end:-1:(r+1));
end

