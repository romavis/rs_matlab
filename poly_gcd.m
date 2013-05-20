function [ gcd ] = poly_gcd( poly_a, poly_b, powtable, fsize )
%POLY_GCD Computes greatest common divisor of two polynomials using the
%classical Euclid's algorithm

%Represent A = Q?*B + R, then B = Q?*R + R1, then R = Q?*R1 + R2.. and so
%on. Proceed until at some step remainder becomes zeros. For ex, Rk = 0,
%and Rk-1 ~= 0, i.e. Rk-2 = Q? * Rk-1 + Rk (0)
%That fact means that Rk-1 divides Rk-2, and taking into account that
%Rk-3 = Q? * Rk-2 + Rk-1, Rk-1 divides Rk-3. Going further, we can deduce
%that Rk-1 divides both A and B :)

%Represent every step of computation in the form X = Q? * Y + R;

    if length(poly_a) > length(poly_b)
        X = poly_a;
        Y = poly_b;
    else
        X = poly_b;
        Y = poly_a;
    end
    while true
        [R, ~] = poly_div(X, Y, powtable, fsize);
        R = poly_trim(R);
        if R(end) == 0
            break;
        end
        X = Y;
        Y = R;
        if length(R) == 1
            break;
        end
    end
    %GCD is stored in Y
    gcd = Y;
end

