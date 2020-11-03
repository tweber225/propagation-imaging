function out = D(k,sfX,sfY,z)
% z should be vector along third dimension

thisKz = k_z(k,sfX,sfY);

expArg = 2i*pi*z.*thisKz;

out = exp(expArg);