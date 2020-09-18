function [PSFi,PSFd,PSF] = generate_PSF(p,d)

%% ILLUMINATION
% Laser beam on objective back aperture -> sample

% Model beam with Gaussian envelop & apply aperture hard cutoff
CTFi_3D = exp(-4*log(2)*d.sfLatSqr/(p.waistiFWHM^2)).*d.CTFi;

% Propagate to desired plane
CTFi_3D = CTFi_3D.*propagator(p.z-p.zOffseti,p.ki,d.sfLatSqr);

% Fourier Transform CTFs to CSFs & compute illumination PSF
CTFi_3D = ifftshift(ifftshift(CTFi_3D,1),2);
CSFi = fftshift(fftshift(ifft2(CTFi_3D),1),2);
PSFi = CSFi.*conj(CSFi);



%% DETECTION
% Points on detection pinhole -> sample

% If an upstream pinhole is present
if p.upPin
    % Expand 4th dim for index of positions inside the pinhole
    [pinY,pinX] = find(d.pinhole); 
    pinY = single(pinY) - p.numPoints/2 - 1;
    pinX = single(pinX) - p.numPoints/2 - 1;
    pinY = permute(pinY,[4 3 2 1]);
    pinX = permute(pinX,[4 3 2 1]);
    
    % To start, compute Fourier Transform of those positions (ie phase ramps)
    [x,y] = meshgrid(single((-p.numPoints/2):(p.numPoints/2-1)));
    CTFd_3D = exp(2i*pi*(pinX.*x + pinY.*y)/p.numPoints);
    
    % Propagate spectra of points to obstructing pinhole
    CTFd_3D = CTFd_3D.*propagator(-p.upPinOffset,p.kd,d.sfLatSqr);
    
    % Fourier Transform the obstructing pinhole
    FTobstruction = fftshift(fft2(ifftshift(single(d.pinObstruction))));
    
    % Convolve with transform of obstruction and reverse propagate back to focal plane
    CTFd_3D = convn(CTFd_3D,FTobstruction,'same');
    CTFd_3D = CTFd_3D.*propagator(+p.upPinOffset,p.kd,d.sfLatSqr);
else
    CTFd_3D = single(1);
end

% Apply hard aperture cutoff to simulating imaging backwards through system
CTFd_3D = CTFd_3D.*d.CTFd;

% Propagate in-focus spectra to desired focal planes
CTFd_3D = CTFd_3D.*propagator(p.z-p.zOffsetd,p.kd,d.sfLatSqr);

% Fourier Transform CTFs to CSFs
CTFd_3D = ifftshift(ifftshift(CTFd_3D,1),2);
CSFd = fftshift(fftshift(ifft2(CTFd_3D),1),2);

% Compute diffraction-limited detection PSFs 
% (as function of pinhole position, if applicable)
diffLimPSFd = CSFd.*conj(CSFd);

% Sum all the PSFs for each position inside the pinhole, or simply convolve
if p.upPin
    PSFd = sum(diffLimPSFd,4);
else
    PSFd = convn(diffLimPSFd,d.pinhole,'same');
end

%% Compute joint point spread function (PSF)
PSF = PSFi.*PSFd;

