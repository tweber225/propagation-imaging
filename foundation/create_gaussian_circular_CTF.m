function CTF = create_gaussian_circular_CTF(sfX,sfY,sfCutoff,beamFWHM,k,z)
% Takes in the spatial frequency grid coordinates sfX & sfY, along with the
% optical system's spatial frequency cutoff, wavenumber, k, and defocus
% ammount. Outputs the 3D circular coherent transfer function, CTF

sfLateralSquared = sfX.^2 + sfY.^2;

% Compute diffraction-limited CTF
CTF = single(sfLateralSquared < sfCutoff.^2);

% Multiply by Gaussian avalanche
CTF = CTF.*exp(-0.5*sfLateralSquared/(beamFWHM*sqrt(2)*sfCutoff)^2);

% Add defocus phase
CTF = CTF.*D(sfX,sfY,k,z);

