function out = H(sfX,sfY,cutoff)
% z should be vector along third dimension

sfLateralSquared = sfX.^2 + sfY.^2;

% Compute diffraction-limited CTF
out = single(sfLateralSquared < cutoff.^2);