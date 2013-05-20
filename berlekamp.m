function [ L, K ] = berlekamp( S, powtable, fsize )
%BERLEKAMP Constructs LFSR with minimal length that generates specified
%vector S in order S1, S2, ... Sn
%LFSR must be initialized with values S1..SL
%Returns length L and feedback coefficients Ki (i=1..L)
    
    L = 0;
    K = zeros(1,0);
    if length(S) < 1
        return;
    end
    if length(S) < 2
        L = 1;
        K = [K 0];
        return;
    end
    
    L = 1;
    K = 1;
    %m = 1 - some iteration (LFSR state), at which we had nonzero
    %discrepancy
    %Before iter. 1 register produced nothing (zeroes) and had zero length
    %Therefore, discrepancy was equal to S(1)
    m = 1;
    dis_m = S(1);
    L_m = 0;
    K_m = zeros(1,0);
    %Iterative LFSR construction..
    %Iteration number. Register at iteration "it" should be able to
    %generate correct Sit. Register at previous iteration "it-1" WAS able
    %to generate correct Sit-1
    for it=2:length(S)
        %Compute next generated symbol
        Sit = 0;
        for j=1:L
            Sit = bitxor(Sit, gf_mul(K(j), S(it - j), powtable, fsize));
        end
        %Discrepancy
        dis = bitxor(Sit, S(it));
        if dis == 0
            %Skip if register is already able to generate correct Sit
            continue;
        end
        %Else, correct register in some way...
        %Calculate scaling coefficient A, so that dis_m * A = dis
        A = gf_div(dis, dis_m, powtable, fsize);
        %Build up register that extracts dis_m...
        L_ext = L_m + it - m;
        K_ext = [zeros(1, it - m - 1) 1 K_m];
        if L_ext > L
            %Remember current register...
            L_m = L;
            K_m = K;
            m = it;
            dis_m = dis;
            K = [K zeros(1, L_ext - L)];
            L = L_ext;
        end
        if L_ext < L
            %Auxiliary register's length can be smaller than L...
            K_ext = [K_ext zeros(1, L - L_ext)];
        end
        %Add two registers o_O, Resulting register should have zero
        %discrepancy(compensated), and therefore should produce correct Sit
        for j=1:L
            K(j) = bitxor(K(j), gf_mul(K_ext(j), A, powtable, fsize));
        end
    end
    
    %Calculate discrepancy at last stage
    %Sit = 0;
    %for j=1:L
    %    Sit = bitxor(Sit, gf_mul(K(j), S(it - j), powtable, fsize));
    %end
    %dis = bitxor(Sit, S(it))
end

