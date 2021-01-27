function out = k_z(k,sfIdx)

sqrtArg = k^2 - sfIdx.^2 - (sfIdx').^2; % implicitly expand

% disallow imaginary kz
sqrtArg(sqrtArg<0) = 0;

out = sqrt(sqrtArg);