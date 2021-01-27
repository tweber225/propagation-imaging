function out = incoherent_PSF(sfIdx,sfCutoff,k,z)


CTF = create_circular_CTF(sfIdx,sfCutoff,k,z);
CSF = ifft2(ifftshift2(CTF));

out = fftshift2(abs(CSF).^2);