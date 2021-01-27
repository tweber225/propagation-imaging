function out = D(sfIdx,k,z)
% z should be vector along third dimension

thisKz = k_z(k,sfIdx);

z3 = permute(z,[3 1 2]);
expArg = 2i*pi*z3.*thisKz; % implicitly expand into 3rd dimension

out = exp(expArg);