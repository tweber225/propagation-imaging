function out = D(sfIdx,k,z)
% z should be matrix with
%   dim 3 = z position, (optional: adjusted for detection pinhole offset)
%   dim 4 = pinhole channel idx (optional)

thisKz = k_z(k,sfIdx);

z3 = permute(z,[3 4 2 1]);
expArg = 2i*pi*z3.*thisKz; % implicitly expand into 3rd dimension

out = exp(expArg);