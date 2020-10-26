function OTF = create_OTF(CTF)
% Takes in the 3D circular coherent transfer function, CTF
% Outputs the autocorrelation of the CTF, the optical transfer function
% (OTF)

% Do this in the frequency domain
csf = ifft2(ifftshift(ifftshift(CTF,1),2));

psf = csf.*conj(csf);

OTF = fftshift(fftshift(fft2(psf),1),2);