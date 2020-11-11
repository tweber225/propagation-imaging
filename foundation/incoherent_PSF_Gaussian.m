function out = incoherent_PSF_Gaussian(sfX,sfY,sfCutoff,beamFWHM,k,z)


CTF = create_gaussian_circular_CTF(sfX,sfY,sfCutoff,beamFWHM,k,z);
CSF = ifft2(ifftshift2(CTF));

out = fftshift2(abs(CSF).^2);