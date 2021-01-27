function CTF = create_circular_CTF(sfIdx,sfCutoff,k,z)
% Takes in the spatial frequency grid coordinates sfX & sfY, along with the
% optical system's spatial frequency cutoff, wavenumber, k, and defocus
% ammount. Outputs the 3D circular coherent transfer function, CTF

sfLateralSquared = sfIdx.^2 + (sfIdx').^2;

% Compute diffraction-limited CTF
CTF = single(sfLateralSquared < sfCutoff.^2);

% Add defocus phase
CTF = CTF.*D(sfIdx,k,z);

