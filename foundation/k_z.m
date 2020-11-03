function out = k_z(k,sfX,sfY)

sqrtArg = k^2 - sfX.^2 - sfY.^2;

% disallow imaginary kz
sqrtArg(sqrtArg<0) = 0;

out = sqrt(sqrtArg);