function CTF = create_circular_CTF(sfX,sfY,sfCutoff,k,z)
% Takes in the spatial frequency grid coordinates sfX & sfY, along with the
% optical system's spatial frequency cutoff, wavenumber, k, and defocus
% ammount. Outputs the 3D circular coherent transfer function, CTF

sfLateralSquared = sfX.^2 + sfY.^2;

% Compute diffraction-limited CTF
CTF = single(sfLateralSquared < sfCutoff.^2);

% Add defocus phase
CTF = CTF.*D(sfX,sfY,k,z);

