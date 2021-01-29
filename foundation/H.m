function out = H(sfIdx,cutoff)

sfLateralSquared = sfIdx.^2 + (sfIdx').^2; % implicit expansion into 2 dims

% Compute diffraction-limited CTF
out = single(sfLateralSquared < cutoff.^2);