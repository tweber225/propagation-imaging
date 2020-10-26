% Add the support code
addpath ../foundation/

% Parameters
p.realPixSize = 0.25;    % microns
p.numLatPix = 256;       % number pixels per lateral dimension
p.n = 1;                % refractive index of object medium
p.NA = 0.4;            % dimensionless
p.wl = 0.850;          % microns
p.focalPlanes = -40:5:40;

% Calculated
p.k = single(p.n/p.wl);  
p.sfCutoff = single(p.NA/p.wl); 


% Set up domains
d = set_up_domains(p);
zIdx = permute(d.positionIdx,[3 1 2]); % make z index along 3rd dimension

% Create objects
[x,y,z] = meshgrid(d.positionIdx);
r = 2.5;
x2 = 7.2;
y2 = 1;
z2 = 21.5;
object1 = single(x.^2 + y.^2 + z.^2 < r^2);
object2 = single((x-x2).^2 + (y-y2).^2 + (z-z2).^2 < r^2);
objectSpectrum1 = fftshift(fftshift(fft2(object1),1),2);
objectSpectrum2 = fftshift(fftshift(fft2(object2),1),2);

% Allocate some space
imgIntensity1 = zeros(p.numLatPix,p.numLatPix,numel(p.focalPlanes),'single');
imgIntensity2 = imgIntensity1;

% Create focal plane intensity images
for focalPlaneNumber = 1:numel(p.focalPlanes)
    focalPlaneOffset = p.focalPlanes(focalPlaneNumber);
    
    CTF = create_circular_CTF(d.sfX,d.sfY,p.sfCutoff,p.k,zIdx - focalPlaneOffset);
    OTF = create_OTF(CTF);
    
    imgIntensity1(:,:,focalPlaneNumber) = ifft2(ifftshift(ifftshift(sum(OTF.*objectSpectrum1,3),1),2));
    imgIntensity2(:,:,focalPlaneNumber) = ifft2(ifftshift(ifftshift(sum(OTF.*objectSpectrum2,3),1),2));
end

% Try to cross correlate image stacks in 3D
F1 = fftn(imgIntensity1);
F2 = fftn(imgIntensity2);

XPowSpectrum = F1.*conj(F2);
XPowSpectrumNormalized = XPowSpectrum./abs(XPowSpectrum+eps);

volumeViewer(fftshift(angle(XPowSpectrum)))


