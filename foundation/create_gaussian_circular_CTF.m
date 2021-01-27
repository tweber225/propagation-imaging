function CTF = create_gaussian_circular_CTF(sfIdx,sfCutoff,beamFWHM,k,z)
% Takes in the spatial frequency grid coordinates sfX & sfY, along with the
% optical system's spatial frequency cutoff, wavenumber, k, and defocus
% ammount. Outputs the 3D circular coherent transfer function, CTF

sfLateralSquared = sfIdx.^2 + (sfIdx').^2; % implicit expansion

% Compute diffraction-limited CTF
CTF = single(sfLateralSquared < sfCutoff.^2);

% Multiply by Gaussian envelope 
CTF = CTF.*exp(-0.5*sfLateralSquared/(beamFWHM*sqrt(2)*sfCutoff)^2);

% Add defocus phase
CTF = CTF.*D(sfIdx,k,z);

