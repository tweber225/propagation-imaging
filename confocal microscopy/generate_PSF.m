function PSF = generate_PSF(p,d)

% Add defocus phase to CTFs
CTFi_3D = d.CTFi.*exp((2i*pi*p.z/1000).*sqrt(p.ki^2 - d.sfLatSqr.*d.CTFi));
CTFd_3D = d.CTFd.*exp((2i*pi*(p.z)/1000).*sqrt(p.kd^2 - d.sfLatSqr.*d.CTFd));


% Fourier Transform CTF to CSF
CTFi_3D = ifftshift(ifftshift(CTFi_3D,1),2);
CSFi = fftshift(fftshift(ifft2(CTFi_3D),1),2);
CTFd_3D = ifftshift(ifftshift(CTFd_3D,1),2);
CSFd = fftshift(fftshift(ifft2(CTFd_3D),1),2);

% Compute diffraction-limited detection PSF, convolve with pinhole
diffLimPSFd = CSFd.*conj(CSFd);
pinholeImg = convn(diffLimPSFd,d.pinhole,'same');

% Compute point spread function (PSF)
PSF = (CSFi.*conj(CSFi)).*pinholeImg;