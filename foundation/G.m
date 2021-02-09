function out = G(sfIdx,k,z)

thisKz = k_z(k,sfIdx);

if size(z,2) ~= 1
    z3 = permute(z,[3 1 2]); % z axis should occupy 3rd dimension
else 
    z3 = z;
end
   

expArg = 2i*pi*z3.*thisKz;

denom = 4i*pi*thisKz;

out = exp(expArg)./denom;

% set anywhere where we divided by 0 to zero
out(out==Inf) = 0;