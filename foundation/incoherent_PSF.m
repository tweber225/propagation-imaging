function out = incoherent_PSF(sfX,sfY,sfCutoff,k,z)


CTF = create_circular_CTF(sfX,sfY,sfCutoff,k,z);
CSF = ifft2(ifftshift2(CTF));

out = fftshift2(abs(CSF).^2);