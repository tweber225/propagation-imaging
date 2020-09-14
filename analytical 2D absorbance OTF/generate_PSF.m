function PSF = generate_PSF(p,d)


CTF_3D = d.CTF.*exp((2i*pi*p.z/1000).*sqrt(p.k^2 - d.spatLatSqr.*d.CTF));

% Fourier Transform CTF to CSF
CTF_3D = ifftshift(ifftshift(CTF_3D,1),2);
CSF = fftshift(fftshift(ifft2(CTF_3D),1),2);

% Compute point spread function (PSF)
PSF = CSF.*conj(CSF);