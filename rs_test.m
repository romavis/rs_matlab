function [ ] = rs_test( )
%RS_TEST Test RS encoder/decoder

    %Construct GF
    gf_power = 4;
    gf_poly = [1 1 0 0 1]; %2^4
    %%gf_poly = [1 0 1 1 1 0 0 0 1]; %2^8
    gf_prime = 2;
    fprintf('Constructing GF(2^%d) powers table..\n', gf_power);
    fprintf('Prime polynomial:\n');
    disp(gf_poly);
    fprintf('Prime element: %d\n', gf_prime);
    [gf_pt, gf_size] = gf_calculate_pt(gf_power, gf_poly, gf_prime);
    
    fprintf('GF constructed\n');
    rs_prime = 2;
    rs_dmin = 5;
    fprintf('Calculating RS generator polynomial\n');
    fprintf('Prime used to construct G: %d, Dmin: %d\n', rs_prime, rs_dmin);
    [rs_poly, n, k, r] = rs_generator(rs_prime, rs_dmin, gf_pt, gf_size);
    fprintf('Constructed code N=%d K=%d R=%d over GF(%d)\n', n, k ,r, gf_size);
    fprintf('G(x): ');
    disp(rs_poly);
    
    fprintf('**************\n****ENCODE****\n**************\n');
    data = randi(gf_size, 1, k) - 1;
    fprintf('Random data to encode(%d symbols): ', k);
    disp(data);
    
    cw = rs_encode(data, rs_poly, n, gf_pt, gf_size);
    fprintf('Encoded codeword (%d symbols):\n', n);
    disp(cw);
    errcnt = floor((rs_dmin - 1)/2);
    
    fprintf('**************\n****CORRUPT***\n**************\n');
    fprintf('Randomized error vector (max %d errors):\n', errcnt);
    errv = zeros(1,n);
    for i=1:errcnt
        errv(randi(n, 1)) = randi(gf_size - 1, 1);
    end
    disp(errv);
    real_errcnt = 0;
    for i=1:length(errv)
        if errv(i) ~= 0
            real_errcnt = real_errcnt + 1;
            fprintf('Error %d at position %d\n', errv(i), i - 1);
        end
    end
    fprintf('Real error count: %d\n', real_errcnt);
    cw_t = cw;
    cw_t = bitxor(cw, errv);
    fprintf('Corrupted codeword:\n');
    disp(cw_t);
    fprintf('**************\n****DECODE****\n**************\n');
    tic;
    [rdata, rcorrect, err_present, S, ccw] = rs_decode(cw_t, rs_prime, rs_poly, n, gf_pt, gf_size);
    etime = toc;
    fprintf('Syndrome vector:');
    disp(S);
    if err_present
        fprintf('Decoder detected error presence\n');
    else
        fprintf('Decoder hasnt detected any errors\n');
    end
    if rcorrect
        fprintf('Decoder thinks that we have correct data..\n');
        fprintf('Recovered data:\n');
        disp(rdata);
        rec_errv = bitxor(rdata, data);
        fprintf('Errors in recovered data:\n');
        disp(rec_errv);
        if nnz(rec_errv) == 0
            fprintf('**************\n**DECODED OK**\n**************\n');
        else
            fprintf('**************\n****OOPS..****\n**************\n');
            [rem, ~] = poly_div(ccw, rs_poly, gf_pt, gf_size);
            if rem == 0
                fprintf('..But decoder has given us another code word!\n');
            else
                fprintf('..And decoder produced some weird thing..\n');
            end
        end
    else
        fprintf('Decoder cannot recover data\n');
    end
    fprintf('DECODE spent %d seconds\n', etime);
end

