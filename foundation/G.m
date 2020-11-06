function out = G(sfX,sfY,k,z)
% z should be vector along third dimension

thisKz = k_z(k,sfX,sfY);

expArg = 2i*pi*z.*thisKz;

denom = 4i*pi*thisKz;

out = exp(expArg)./denom;

% set anywhere where we divided by 0 to zero
out(out==Inf) = 0;