function out = H_asym(sfIdx,cutoff)

sfLateralSquared = sfIdx.^2 + (sfIdx').^2; % implicit expansion into 2 dims

% Compute diffraction-limited CTF and make asymmetric
out = single((sfLateralSquared < cutoff.^2) & (sfIdx >= 0));
out(find(abs(sfIdx)<cutoff),find(sfIdx == 0)) = 0.5;

