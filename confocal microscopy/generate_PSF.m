function PSF = generate_PSF(p,d)

% If an upstream pinhole is present
if p.upPin 
    % Propagate flat spectrum (ie point) to obstructing pinhole
    CTFd_3D = exp((2i*pi*p.upPinOffset/1000).*sqrt(p.kd^2 - d.sfLatSqr));
    
    % FT the obstruction pinhole
    FTobstruction = fftshift(fft2(ifftshift(d.pinObstruction)));
    
    % Convolve
    thing = conv2(CTFd_3D,FTobstruction,'same');
end

% Add defocus phase to detection and illumination CTFs
CTFd_3D = d.CTFd.*exp((2i*pi*(p.z-p.zOffsetd)/1000).*sqrt(p.kd^2 - d.sfLatSqr));
CTFi_3D = d.CTFi.*exp((2i*pi*(p.z-p.zOffseti)/1000).*sqrt(p.kd^2 - d.sfLatSqr));

% Additionally apply Gaussian envelop to illumination CTF
CTFi_3D = CTFi_3D.*exp(-4*log(2)*d.sfLatSqr/(p.waistiFWHM^2));

% Fourier Transform CTF to CSF
CTFi_3D = ifftshift(ifftshift(CTFi_3D,1),2);
CSFi = fftshift(fftshift(ifft2(CTFi_3D),1),2);
CTFd_3D = ifftshift(ifftshift(CTFd_3D,1),2);
CSFd = fftshift(fftshift(ifft2(CTFd_3D),1),2);

% Compute diffraction-limited detection PSF, convolve with pinhole
diffLimPSFd = CSFd.*conj(CSFd);
pinholeImg = convn(diffLimPSFd,d.pinhole,'same');

% Compute point spread function (PSF)
PSFi = CSFi.*conj(CSFi);
PSFd = pinholeImg;
PSF = PSFi.*PSFd;